--[[
    SHITARO GUI SYSTEM - Extracted & Cleaned
    Совместимо с UI библиотекой shitaroebet.lua
    Использование: require этот модуль после загрузки UI либы
]]

local GUI = {}

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА ИКОНОК
-- ═══════════════════════════════════════════════════════════════
local ICONMAP = {
    ["circle-x"] = "x",
    ["circle-check"] = "shield-check",
    ["clipboard"] = "file-text",
    ["cube-vertexes"] = "box",
    ["mouse-scrollwheel"] = "mouse-pointer",
    ["person"] = "user",
    ["crosshairs"] = "crosshair",
    ["chart-four-vertical-bars"] = "activity",
    ["memory-card"] = "database",
    ["gamepad"] = "gamepad-2",
    ["heart"] = "heart",
    ["users"] = "users",
    ["map"] = "map",
    ["eye"] = "eye",
    ["palette"] = "palette",
    ["save"] = "save",
    ["send"] = "send",
    ["log-out"] = "log-out",
    ["rotate-ccw"] = "rotate-ccw",
    ["plus"] = "plus",
    ["copy"] = "copy",
    ["trash-2"] = "trash-2",
    ["check"] = "check",
    ["ellipsis"] = "ellipsis",
    ["map-pin"] = "map-pin",
    ["video"] = "video",
    ["person-standing"] = "person-standing",
    ["move"] = "move",
    ["layers"] = "layers",
    ["circle-dot"] = "circle-dot",
    ["footprints"] = "footprints",
    ["sliders-horizontal"] = "sliders-horizontal",
    ["shirt"] = "shirt",
    ["globe"] = "globe",
}

local function art(v, fallback)
    if type(v) == "number" then return v end
    if type(v) ~= "string" or v == "" then return fallback end
    return ICONMAP[string.lower(v)] or v
end

GUI.art = art

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА УВЕДОМЛЕНИЙ
-- ═══════════════════════════════════════════════════════════════
local lib = nil -- Будет установлена при инициализации

local __Notification = {
    new = function(c)
        c = c or {}
        if lib and lib.notify then
            lib:notify({
                title = c.Title or "SCRIPT",
                text = c.Content or "",
                icon = art(c.Icon, "info"),
                life = c.Duration or 5,
            })
        end
    end,
}

local __Logging = {
    new = function(ic, txt, dur, col)
        if lib and lib.notify then
            lib:notify({
                title = tostring(txt or ""),
                icon = art(ic, "file-text"),
                life = dur or 4,
                tone = (typeof(col) == "Color3") and col or nil,
            })
        end
    end,
}

GUI.notification = __Notification
GUI.event_notify = __Logging

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА СИНХРОНИЗАЦИИ UI
-- ═══════════════════════════════════════════════════════════════
getgenv().UI_SYNC = { stamp = 0, count = 0, start = os.clock() }

local function wrapCallback(fn)
    if type(fn) ~= "function" then return nil end
    return function(...)
        local sync = getgenv().UI_SYNC
        if sync then
            local now = os.clock()
            if now - sync.stamp > 0.4 then sync.count = 0 end
            sync.stamp = now
            sync.count = sync.count + 1
        end
        return fn(...)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- WRAP CONTAINER (обёртка над секциями UI либы)
-- ═══════════════════════════════════════════════════════════════
local function wrapContainer(sec)
    local w = { __sec = sec }
    
    function w:AddToggle(cfg)
        cfg = cfg or {}
        local el = sec:toggle({
            name = cfg.Name or "toggle",
            default = cfg.Default and true or false,
            options = cfg.Option and true or false,
            flag = cfg.Flag,
            callback = wrapCallback(cfg.Callback),
        })
        local o = { __el = el }
        if cfg.Option and el.options then
            o.Option = wrapContainer(el.options)
        end
        function o:GetValue() return el:get() end
        function o:SetValue(v) el:set(v) end
        return o
    end
    
    function w:AddSlider(cfg)
        cfg = cfg or {}
        local dec = tonumber(cfg.Round or cfg.Rounding) or 0
        local step = (dec > 0) and (1 / (10 ^ dec)) or 1
        local el = sec:slider({
            name = cfg.Name or "slider",
            min = tonumber(cfg.Min) or 0,
            max = tonumber(cfg.Max) or 100,
            default = cfg.Default,
            step = step,
            suffix = (type(cfg.Type) == "string" and cfg.Type ~= "") and cfg.Type or "",
            flag = cfg.Flag,
            callback = wrapCallback(cfg.Callback),
        })
        local o = { __el = el }
        function o:GetValue() return el:get() end
        function o:SetValue(v) el:set(v) end
        return o
    end
    
    function w:AddDropdown(cfg)
        cfg = cfg or {}
        local el = sec:combo({
            name = cfg.Name or "dropdown",
            list = cfg.Values or {},
            default = cfg.Default,
            multi = cfg.Multi and true or false,
            flag = cfg.Flag,
            callback = wrapCallback(cfg.Callback),
        })
        local o = { __el = el }
        function o:GetValue() return el:get() end
        function o:SetValue(v) el:set(v) end
        function o:SetValues(v) el:setlist(v) end
        function o:Generate() end
        return o
    end
    
    function w:AddColorPicker(cfg)
        cfg = cfg or {}
        local hook = cfg.Callback
        local el = sec:color({
            name = cfg.Name or "color",
            default = cfg.Default,
            flag = cfg.Flag,
            callback = hook and wrapCallback(function(c)
                hook(c, cfg.Transparency)
            end) or nil,
        })
        local o = { __el = el }
        function o:GetValue() return el:get() end
        function o:SetValue(v) el:set(v) end
        return o
    end
    
    function w:AddKeybind(cfg)
        cfg = cfg or {}
        local el = sec:keybind({
            name = cfg.Name or "keybind",
            default = cfg.Default,
            flag = cfg.Flag,
            callback = wrapCallback(cfg.Callback),
        })
        local o = { __el = el }
        function o:GetValue() return el:get() end
        function o:SetValue(v) el:set(v) end
        return o
    end
    
    function w:AddButton(cfg)
        cfg = cfg or {}
        local el = sec:button({
            name = cfg.Name or "Button",
            icon = art(cfg.Icon),
            callback = cfg.Callback,
        })
        return { __el = el }
    end
    
    function w:AddLabel(name, wrapText)
        local el = sec:label({
            name = tostring(name or ""),
            wrap = wrapText and true or false,
        })
        local o = { __el = el }
        function o:SetValue(v) el:set(v) end
        function o:GetValue() return el:get() end
        return o
    end
    
    return w
end

-- ═══════════════════════════════════════════════════════════════
-- WRAP PAGE (обёртка над табами)
-- ═══════════════════════════════════════════════════════════════
local function side_of(pos)
    if pos == "full" or pos == 3 then return "full" end
    return (pos == "right" or pos == 2) and "right" or "left"
end

local function wrapPage(tab, name)
    local menu = { Name = name, __tab = tab }
    menu.Root = setmetatable({}, {
        __index = function(_, key)
            if key == "Visible" then
                local ok, v = pcall(function() return tab.page.Visible end)
                return ok and v or false
            end
        end,
    })
    
    function menu:AddSection(scfg)
        scfg = scfg or {}
        return wrapContainer(tab:section({
            name = scfg.Name or "SECTION",
            side = side_of(scfg.Position),
        }))
    end
    
    function menu:AddClone(ccfg)
        ccfg = ccfg or {}
        return tab:clone({
            name = ccfg.Name or "Character",
            side = side_of(ccfg.Position),
            height = tonumber(ccfg.Height) or 250,
            zoom = tonumber(ccfg.Zoom),
            fov = tonumber(ccfg.Fov),
            callback = ccfg.Callback,
        })
    end
    
    function menu:AddImageList(icfg)
        icfg = icfg or {}
        local g = tab:gallery({
            name = icfg.Name or "LIST",
            icon = art(icfg.Icon, "list"),
            side = side_of(icfg.Position),
            height = tonumber(icfg.Height) or 250,
            multi = icfg.Multi and true or false,
            thumb = icfg.Thumb or "Asset",
            cell = tonumber(icfg.Cell),
            gap = tonumber(icfg.Gap),
            search = icfg.Search ~= false,
            tools = icfg.Tools ~= false,
            reset = icfg.Reset and true or false,
            blank = icfg.Blank,
            empty = icfg.Empty,
            buttons = icfg.Buttons,
            action = icfg.Action,
            context = icfg.Context,
            list = icfg.Values or {},
            default = icfg.Default,
            flag = icfg.Flag,
            callback = wrapCallback(icfg.Callback),
        })
        local o = { __el = g }
        function o:SetData(v) g:setdata(v) end
        function o:SetValues(v) g:setdata(v) end
        function o:SetDefault(v) g:setdefault(v) end
        function o:SetValue(v) g:set(v) end
        function o:GetValue() return g:get() end
        function o:Refresh() g:refresh() end
        function o:Clear() g:clear() end
        function o:All() g:all() end
        function o:Search(q) g:search(q) end
        function o:Generate() end
        return o
    end
    
    if type(tab.sub) == "function" then
        function menu:AddSub(bcfg)
            bcfg = bcfg or {}
            local branch = tab:sub({
                name = bcfg.Name or "SUB",
                icon = art(bcfg.Icon, "circle-dot"),
                tip = bcfg.Tip or "",
            })
            if type(tab.setopen) == "function" then
                pcall(tab.setopen, tab, true)
            end
            return wrapPage(branch, bcfg.Name)
        end
    end
    
    return menu
end

-- ═══════════════════════════════════════════════════════════════
-- POPUP & ASK SYSTEM
-- ═══════════════════════════════════════════════════════════════
local function popmenu(cfg)
    if lib and type(lib.popup) == "function" then
        lib:popup(cfg)
    end
end

local function askinput(cfg)
    if lib and type(lib.ask) == "function" then
        return lib:ask(cfg)
    end
end

GUI.popmenu = popmenu
GUI.askinput = askinput

-- ═══════════════════════════════════════════════════════════════
-- FATILITY-СОВМЕСТИМЫЙ API
-- ═══════════════════════════════════════════════════════════════
local fatality = {}
fatality.Colors = { Black = Color3.fromRGB(16, 16, 16) }

function fatality:CreateNotifier()
    return {
        Notify = function(_, c)
            c = c or {}
            __Notification.new(c)
        end,
    }
end

function fatality:CreateEventNotifier()
    return {
        Notify = function(_, c)
            c = c or {}
            __Logging.new(c.Icon or "clipboard", c.Title or c.Content or "", c.Duration or 4, c.Color)
        end,
    }
end

function fatality:Loader() end
function fatality:RegisterColorElement() end
function fatality:UpdateColors() end

local root = nil

function fatality.new(cfg)
    cfg = cfg or {}
    root = lib:window({ bind = "Insert" })
    
    local win = {}
    win.Menus = {}
    win.ClickSoundId = ""
    win.__win = root
    
    function win:SetSize() end
    function win:Set3DRender() end
    
    function win:Toggle()
        root:toggle()
    end
    
    function win:AddMenu(mcfg)
        mcfg = mcfg or {}
        local tab = root:tab({
            name = mcfg.Name or "TAB",
            icon = art(mcfg.Icon, "circle-dot"),
            tip = mcfg.Tip or "",
        })
        local menu = wrapPage(tab, mcfg.Name)
        table.insert(win.Menus, menu)
        return menu
    end
    
    function win:AddColors()
        local ct = root:tab({ name = "colors", icon = "palette", tip = "menu colors" })
        ct:color({ name = "accent", key = "accent", side = "left" })
        ct:color({ name = "text", key = "text", side = "right" })
        ct:color({ name = "panel", key = "panel", side = "left" })
        ct:color({ name = "header", key = "head", side = "right" })
        ct:color({ name = "sidebar", key = "side", side = "left" })
        ct:color({ name = "outline", key = "line", side = "right" })
        ct:color({ name = "muted", key = "dim", side = "left" })
        ct:color({ name = "network", key = "glow", side = "right" })
        ct:color({ name = "background", key = "bg", side = "left" })
        return ct
    end
    
    function win:AddConfig()
        local ct = root:tab({ name = "config", icon = "save", tip = "menu settings" })
        ct:configs({ name = "Configs", side = "left" })
        return ct, ct:section({ name = "Menu", side = "right" })
    end
    
    function win:SetBind(v)
        root:setbind(v)
    end
    
    return win
end

GUI.fatality = fatality

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА ОЧЕРЕДЕЙ (для отложенного добавления элементов)
-- ═══════════════════════════════════════════════════════════════
getgenv().__PLR_Q = {}

getgenv().__PLR_QUEUE = function(key, name, fn)
    local q = getgenv().__PLR_Q[key]
    if not q then
        q = {}
        getgenv().__PLR_Q[key] = q
    end
    q[#q + 1] = { name = name, fn = fn, order = #q + 1 }
end

getgenv().__PLR_FLUSH = function(key, sec)
    local q = getgenv().__PLR_Q[key]
    if not q or not sec then return end
    table.sort(q, function(a, b)
        local la, lb = #a.name, #b.name
        if la ~= lb then return la < lb end
        if a.name ~= b.name then return a.name < b.name end
        return a.order < b.order
    end)
    for _, entry in ipairs(q) do
        pcall(entry.fn, sec)
    end
    getgenv().__PLR_Q[key] = nil
end

-- ═══════════════════════════════════════════════════════════════
-- INDICATOR (для индикаторов типа FAKE, SURF и т.д.)
-- ═══════════════════════════════════════════════════════════════
local function CreateIndicator()
    local ind = {}
    function ind:Set() end
    function ind:SetRender() end
    function ind:SetText() end
    function ind:Remove() end
    return ind
end

GUI.CreateIndicator = CreateIndicator

-- ═══════════════════════════════════════════════════════════════
-- ГЛАВНЫЙ ИНИЦИАЛИЗАТОР
-- ═══════════════════════════════════════════════════════════════
function GUI.init(ui_lib)
    lib = ui_lib
    
    -- Создаём базовые нотификаторы
    local notification = fatality:CreateNotifier()
    local event_notify = fatality:CreateEventNotifier()
    
    -- Создаём главное окно
    local window = fatality.new({
        Name = "YOUR_SCRIPT",
        Expire = "Never",
    })
    
    -- Приветственное уведомление
    notification:Notify({
        Title = "YOUR_SCRIPT",
        Content = "Welcome, " .. game.Players.LocalPlayer.DisplayName,
        Icon = "clipboard"
    })
    
    return {
        window = window,
        notification = notification,
        event_notify = event_notify,
        lib = lib,
    }
end

-- ═══════════════════════════════════════════════════════════════
-- UNLOAD SYSTEM
-- ═══════════════════════════════════════════════════════════════
local unload_callbacks = {}

function GUI.registerUnload(name, fn)
    unload_callbacks[name] = fn
end

function GUI.unload()
    for name, fn in pairs(unload_callbacks) do
        pcall(fn)
    end
    
    -- Очищаем очереди
    for key in pairs(getgenv().__PLR_Q) do
        getgenv().__PLR_Q[key] = nil
    end
    
    -- Очищаем UI_SYNC
    getgenv().UI_SYNC = nil
    
    -- Выгружаем UI библиотеку
    if lib and lib.unload then
        pcall(function() lib:unload() end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ЭКСПОРТ
-- ═══════════════════════════════════════════════════════════════
GUI.wrapContainer = wrapContainer
GUI.wrapPage = wrapPage
GUI.wrapCallback = wrapCallback

return GUI
