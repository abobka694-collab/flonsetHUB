--[[
    Fatality-like UI  •  single-file
    API:
        local lib = loadstring(...)()
        lib:settheme({...})
        lib:notify({title=, text=, icon=, life=})
        lib:popup({title=, items={{icon=,name=,on=,callback=}}})
        local win = lib:window({bind="Insert"})
        local tab = win:tab({name=, icon=, tip=})
        local sec = tab:section({name=, side="left"|"right"|"full"})
        sec:toggle({name=, default=, flag=, options=, callback=})
        sec:slider({name=, min=, max=, default=, step=, suffix=, flag=, callback=})
        sec:combo({name=, list={}, default=, multi=, flag=, callback=})
        sec:color({name=, default=, flag=, callback=})
        sec:keybind({name=, default=, flag=, callback=})
        sec:button({name=, icon=, callback=})
        sec:label({name=, wrap=})
        tab:sub({name=, icon=, tip=})
        tab:configs({name=, side=})
]]

local Lib = {}

--============================================================
-- SERVICES
--============================================================
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInput      = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local CoreGui        = game:GetService("CoreGui")
local Lighting       = game:GetService("Lighting")
local HttpService    = game:GetService("HttpService")

local LP = Players.LocalPlayer

local function new(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function tween(inst, time, props, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

--============================================================
-- THEME
--============================================================
local Theme = {
    accent     = Color3.fromRGB(133, 220, 255),
    text       = Color3.fromRGB(236, 236, 236),
    panel      = Color3.fromRGB(22, 22, 26),
    header     = Color3.fromRGB(16, 16, 20),
    sidebar    = Color3.fromRGB(14, 14, 18),
    outline    = Color3.fromRGB(40, 40, 48),
    muted      = Color3.fromRGB(120, 120, 130),
    background = Color3.fromRGB(10, 10, 14),
    glow       = Color3.fromRGB(133, 220, 255),
    font       = Enum.Font.Gotham,
    fontBold   = Enum.Font.GothamBold,
    radius     = 8,
}

function Lib:settheme(t)
    for k, v in pairs(t or {}) do Theme[k] = v end
    Lib:_refresh()
end

function Lib:setaccent(c) Theme.accent = c; Lib:_refresh() end
function Lib:setbind(k)   Lib._bind = k end
function Lib:setsound(v)  Lib._sounds = v end
function Lib:settone(v)   Lib._tone = v end
function Lib:sethotkeys(v)Lib._hotkeys = v end
function Lib:setwatermark(v) Lib:_watermark(v) end
function Lib:setcursor(v) end
function Lib:setstyle(v)  end
Lib.cursorlist = {}
Lib.tonelist   = { "Click", "Pop", "Soft" }

--============================================================
-- ROOT GUI
--============================================================
local function gethui()
    return (gethui and gethui()) or CoreGui
end

local Root = new("ScreenGui", {
    Name = "FatalityUI_" .. tostring(math.random(1e5, 9e5)),
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, gethui())

local Watermark = new("TextLabel", {
    Parent = Root,
    BackgroundColor3 = Theme.header,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 220, 0, 26),
    Position = UDim2.new(0, 12, 0, 12),
    Font = Theme.fontBold,
    TextSize = 13,
    TextColor3 = Theme.text,
    Text = "  fatality  •  beta",
    TextXAlignment = Enum.TextXAlignment.Left,
    Visible = false,
}, Root)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, Watermark)
new("UIStroke", { Color = Theme.outline, Thickness = 1 }, Watermark)

function Lib:_watermark(v) Watermark.Visible = v and true or false end

--============================================================
-- NOTIFICATIONS
--============================================================
local NotifyHolder = new("Frame", {
    Parent = Root,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, -312, 0, 0),
}, Root)

local function iconAsset(icon)
    if type(icon) == "number" then return "rbxassetid://" .. icon end
    if type(icon) == "string" and icon:match("^%d+$") then return "rbxassetid://" .. icon end
    return "rbxassetid://6031075931"
end

local Notify = {}
function Lib:notify(cfg)
    cfg = cfg or {}
    local card = new("Frame", {
        Parent = NotifyHolder,
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, card)
    local stroke = new("UIStroke", { Color = Theme.outline, Thickness = 1 }, card)

    local bar = new("Frame", {
        Parent = card,
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

    local title = new("TextLabel", {
        Parent = card,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 8),
        Size = UDim2.new(1, -28, 0, 16),
        Font = Theme.fontBold,
        TextSize = 13,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(cfg.title or "notification"),
    })

    local body = new("TextLabel", {
        Parent = card,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 26),
        Size = UDim2.new(1, -28, 0, 22),
        Font = Theme.font,
        TextSize = 12,
        TextColor3 = Theme.muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Text = tostring(cfg.text or cfg.content or ""),
    })

    if cfg.tone then bar.BackgroundColor3 = cfg.tone end

    table.insert(Notify, card)
    local targetY = 12
    for i, c in ipairs(Notify) do
        c.Position = UDim2.new(0, 0, 0, targetY - 12)
        targetY = targetY + c.AbsoluteSize.Y + 10
        c.Size = UDim2.new(1, 0, 0, 56)
        tween(c, 0.25, { Position = UDim2.new(0, 0, 0, targetY - 56 - 10) })
    end

    tween(card, 0.25, { BackgroundTransparency = 0 })
    tween(stroke, 0.25, { Color = Theme.accent })

    local life = cfg.life or cfg.duration or 4
    task.delay(life, function()
        tween(card, 0.2, { BackgroundTransparency = 1 })
        tween(stroke, 0.2, { Color = Theme.outline })
        task.wait(0.22)
        for i, c in ipairs(Notify) do
            if c == card then table.remove(Notify, i) break end
        end
        card:Destroy()
    end)
end

--============================================================
-- POPUP
--============================================================
function Lib:popup(cfg)
    cfg = cfg or {}
    local x = cfg.x or UserInput:GetMouseLocation().X
    local y = cfg.y or UserInput:GetMouseLocation().Y

    local holder = new("TextButton", {
        Parent = Root,
        BackgroundTransparency = 1,
        Text = "",
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 500,
    })
    local menu = new("Frame", {
        Parent = holder,
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 0),
        Position = UDim2.new(0, x, 0, y),
        ZIndex = 501,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, menu)
    new("UIStroke", { Color = Theme.outline, Thickness = 1 }, menu)

    local title = new("TextLabel", {
        Parent = menu,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 0, 26),
        Position = UDim2.new(0, 12, 0, 6),
        Font = Theme.fontBold,
        TextSize = 13,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(cfg.title or "menu"),
        ZIndex = 502,
    })

    local yOff = 36
    local totalH = 36
    for _, item in ipairs(cfg.items or {}) do
        local row = new("TextButton", {
            Parent = menu,
            BackgroundColor3 = Theme.panel,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -12, 0, 28),
            Position = UDim2.new(0, 6, 0, yOff),
            Text = "",
            ZIndex = 502,
        })
        new("UICorner", { CornerRadius = UDim.new(0, 6) }, row)

        local label = new("TextLabel", {
            Parent = row,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Theme.font,
            TextSize = 12,
            TextColor3 = Theme.text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = tostring(item.name or ""),
            ZIndex = 503,
        })

        local dot = new("Frame", {
            Parent = row,
            BackgroundColor3 = item.on and Theme.accent or Theme.outline,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, 16, 0.5, -3),
            ZIndex = 503,
        })
        new("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)

        row.MouseEnter:Connect(function()
            tween(row, 0.15, { BackgroundTransparency = 0.7 })
        end)
        row.MouseLeave:Connect(function()
            tween(row, 0.15, { BackgroundTransparency = 1 })
        end)
        row.MouseButton1Click:Connect(function()
            if item.callback then
                local ok, res = pcall(item.callback)
                if ok and res ~= nil then
                    item.on = res and true or false
                    dot.BackgroundColor3 = item.on and Theme.accent or Theme.outline
                end
            end
        end)

        yOff = yOff + 30
        totalH = totalH + 30
    end

    menu.Size = UDim2.new(0, 200, 0, totalH + 6)
    tween(menu, 0.18, { Position = UDim2.new(0, x, 0, y) })

    holder.MouseButton1Click:Connect(function() holder:Destroy() end)
end

--============================================================
-- ASK (input prompt)
--============================================================
function Lib:ask(cfg)
    cfg = cfg or {}
    local holder = new("TextButton", {
        Parent = Root,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 600,
    })
    local box = new("Frame", {
        Parent = holder,
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 320, 0, 120),
        Position = UDim2.new(0.5, -160, 0.5, -60),
        ZIndex = 601,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 10) }, box)
    new("UIStroke", { Color = Theme.outline, Thickness = 1 }, box)

    new("TextLabel", {
        Parent = box,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 12),
        Size = UDim2.new(1, -32, 0, 20),
        Font = Theme.fontBold,
        TextSize = 14,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(cfg.title or "input"),
    })

    local input = new("TextBox", {
        Parent = box,
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 16, 0, 40),
        Size = UDim2.new(1, -32, 0, 32),
        Font = Theme.font,
        TextSize = 13,
        TextColor3 = Theme.text,
        PlaceholderText = tostring(cfg.hint or ""),
        PlaceholderColor3 = Theme.muted,
        Text = "",
        ClearTextOnFocus = false,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, input)
    new("UIStroke", { Color = Theme.outline, Thickness = 1 }, input)

    local accept = new("TextButton", {
        Parent = box,
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 16, 0, 80),
        Size = UDim2.new(0.5, -20, 0, 28),
        Font = Theme.fontBold,
        TextSize = 13,
        TextColor3 = Theme.background,
        Text = tostring(cfg.accept or "ok"),
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, accept)

    local deny = new("TextButton", {
        Parent = box,
        BackgroundColor3 = Theme.outline,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 4, 0, 80),
        Size = UDim2.new(0.5, -20, 0, 28),
        Font = Theme.fontBold,
        TextSize = 13,
        TextColor3 = Theme.text,
        Text = tostring(cfg.deny or "cancel"),
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, deny)

    accept.MouseButton1Click:Connect(function()
        local val = input.Text
        holder:Destroy()
        if cfg.callback then pcall(cfg.callback, val) end
    end)
    deny.MouseButton1Click:Connect(function()
        holder:Destroy()
    end)
end

--============================================================
-- WINDOW
--============================================================
function Lib:window(cfg)
    cfg = cfg or {}
    local bind = cfg.bind or "Insert"
    Lib._bind = bind

    local win = new("Frame", {
        Parent = Root,
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 620, 0, 420),
        Position = UDim2.new(0.5, -310, 0.5, -210),
        Visible = false,
        ClipsDescendants = true,
        Active = true,
    })
    new("UICorner", { CornerRadius = UDim.new(0, Theme.radius) }, win)
    new("UIStroke", { Color = Theme.outline, Thickness = 1 }, win)

    local header = new("Frame", {
        Parent = win,
        BackgroundColor3 = Theme.header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
    })
    new("UICorner", { CornerRadius = UDim.new(0, Theme.radius) }, header)
    local headerFix = new("Frame", {
        Parent = header,
        BackgroundColor3 = Theme.header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -Theme.radius),
        Size = UDim2.new(1, 0, 0, Theme.radius),
    })

    new("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -120, 1, 0),
        Font = Theme.fontBold,
        TextSize = 14,
        TextColor3 = Theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(cfg.name or "fatality"),
    })

    local sidebar = new("Frame", {
        Parent = win,
        BackgroundColor3 = Theme.sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(0, 150, 1, -36),
    })

    local content = new("Frame", {
        Parent = win,
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 36),
        Size = UDim2.new(1, -150, 1, -36),
        ClipsDescendants = true,
    })

    local tabHolder = new("ScrollingFrame", {
        Parent = sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 6, 0, 6),
        Size = UDim2.new(1, -12, 1, -12),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })

    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = win.Position
        end
    end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInput.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local tabs, activeTab = {}, nil
    local object = {}
    object.__win = win

    local function showTab(t)
        for _, x in ipairs(tabs) do
            x.page.Visible = (x == t)
            x.btn.BackgroundColor3 = (x == t) and Theme.panel or Theme.sidebar
            x.label.TextColor3 = (x == t) and Theme.accent or Theme.muted
        end
        activeTab = t
    end

    function object:tab(cfg2)
        cfg2 = cfg2 or {}
        local btn = new("TextButton", {
            Parent = tabHolder,
            BackgroundColor3 = Theme.sidebar,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Text = "",
        })
        new("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)

        local icon = new("ImageLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = iconAsset(cfg2.icon),
            ImageColor3 = Theme.muted,
        })

        local label = new("TextLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 34, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Theme.font,
            TextSize = 13,
            TextColor3 = Theme.muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = tostring(cfg2.name or "tab"),
        })

        local page = new("Frame", {
            Parent = content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
        })

        btn.MouseEnter:Connect(function()
            if activeTab ~= { btn = btn, page = page, label = label } then
                tween(btn, 0.15, { BackgroundColor3 = Theme.panel })
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= { btn = btn, page = page, label = label } then
                tween(btn, 0.15, { BackgroundColor3 = Theme.sidebar })
            end
        end)

        local ref = { btn = btn, page = page, label = label, icon = icon, name = cfg2.name }
        table.insert(tabs, ref)
        btn.MouseButton1Click:Connect(function() showTab(ref) end)

        if #tabs == 1 then showTab(ref) end

        local tabObj = {}
        tabObj.__page = page
        tabObj.__name = cfg2.name
        tabObj.page = page

        local subHolder = nil

        function tabObj:section(scfg)
            scfg = scfg or {}
            local side = scfg.side or "left"
            local holder
            if side == "full" then
                holder = new("Frame", {
                    Parent = page,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
            else
                local x = (side == "right") and 0.5 or 0
                local w = 1
                holder = new("Frame", {
                    Parent = page,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(x, 10, 0, 10),
                    Size = UDim2.new(0.5, -15, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
            end
            local canvas = new("ScrollingFrame", {
                Parent = holder,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),

                    --[[
    Chams  •  single-file  •  MM2
    Всё в одном: роли + подсветка + автообновление.

    Использование:
        local Chams = loadstring(game:HttpGet("URL"))()

        Chams.mode         = "highlight"     -- "highlight" | "material" | "both"
        Chams.visible_only = false           -- true → не видно сквозь стены
        Chams.colors.murder   = { fill = Color3.fromRGB(255,60,60),  outline = Color3.fromRGB(255,0,0) }
        Chams.colors.sheriff  = { fill = Color3.fromRGB(60,180,255), outline = Color3.fromRGB(0,150,255) }
        Chams.colors.innocent = { fill = Color3.fromRGB(255,255,255),outline = Color3.fromRGB(200,200,200) }

        Chams:start()
        Chams:stop()
        Chams:destroy()

    API:
        Chams:get(player)        -- "Murderer"|"Sheriff"|"Hero"|"Innocent"|nil
        Chams:me()               -- роль локального игрока
        Chams:murderer()         -- Player|nil
        Chams:sheriff()          -- Player|nil
        Chams:innocents()        -- {Player}
        Chams:isMurderer(player) -- bool
        Chams:isSheriff(player)  -- bool
        Chams:isInnocent(player) -- bool
        Chams:setmode(m)         -- "highlight"|"material"|"both"
        Chams:setcolor(role, fill, outline)
        Chams.onUpdate           -- function(player, role, oldRole)
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

local Chams = {}

--============================================================
-- CONFIG
--============================================================
Chams.enabled            = false
Chams.mode               = "highlight"   -- "highlight" | "material" | "both"
Chams.visible_only       = false         -- true → HighlightDepthMode.Occluded
Chams.fill_transparency  = 0.5
Chams.outline_transparency = 0
Chams.useGunFallback     = true
Chams.useKnifeFallback   = true
Chams.onUpdate           = nil           -- function(player, role, oldRole)

Chams.colors = {
    murder   = { fill = Color3.fromRGB(255, 60, 60),  outline = Color3.fromRGB(255, 0, 0) },
    sheriff  = { fill = Color3.fromRGB(60, 180, 255), outline = Color3.fromRGB(0, 150, 255) },
    innocent = { fill = Color3.fromRGB(255, 255, 255),outline = Color3.fromRGB(200, 200, 200) },
}

--============================================================
-- STATE
--============================================================
local highlights     = {}     -- [Player] = Highlight
local materialCache  = {}     -- [BasePart] = { mat, col }
local roleByName     = {}     -- [string] = role
local roleByPlayer   = {}     -- [Player] = role
local watchedPlayers = {}     -- [Player] = true
local connections    = {}
local roleModule     = nil
local roleEventConn  = nil
local loopConn       = nil
local rolePollThread = nil
local lastRefresh    = 0

--============================================================
-- ROLE RESOLUTION
--============================================================
local function getModule()
    if roleModule and roleModule.PlayerData then return roleModule end
    local ok, m = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient", 5))
    end)
    if ok and type(m) == "table" then roleModule = m end
    return roleModule
end

local function hasTool(player, name)
    local char = player.Character
    if char and char:FindFirstChild(name) then return true end
    local bp = player:FindFirstChildOfClass("Backpack")
    if bp and bp:FindFirstChild(name) then return true end
    return false
end

local function fallbackRole(player)
    if Chams.useGunFallback and hasTool(player, "Gun") then
        return "Sheriff"
    end
    if Chams.useKnifeFallback and hasTool(player, "Knife") then
        return "Murderer"
    end
    return nil
end

local function setRole(player, role)
    local old = roleByPlayer[player]
    if old == role then return end
    roleByPlayer[player] = role
    roleByName[player.Name] = role
    if Chams.onUpdate then
        pcall(Chams.onUpdate, player, role, old)
    end
end

local function refreshRoles()
    local m = getModule()
    local data = m and m.PlayerData

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local role
            if type(data) == "table" then
                local info = data[p.Name]
                if type(info) == "table" then
                    if info.Dead then
                        role = nil
                    else
                        role = info.Role or fallbackRole(p) or "Innocent"
                    end
                end
            end
            if not role then
                role = fallbackRole(p) or "Innocent"
            end
            setRole(p, role)
        end
    end
end

local function colorFor(player)
    local role = roleByPlayer[player]
    if role == "Murderer" then
        return Chams.colors.murder
    elseif role == "Sheriff" or role == "Hero" then
        return Chams.colors.sheriff
    end
    return Chams.colors.innocent
end

--============================================================
-- HIGHLIGHT MODE
--============================================================
local function ensureHighlight(player)
    local char = player.Character
    if not char then return end

    local hl = highlights[player]
    if not hl or not hl.Parent then
        hl = Instance.new("Highlight")
        hl.Name = "\0"
        hl.Adornee = char
        hl.Parent = char
        highlights[player] = hl
    end

    local col = colorFor(player)
    hl.FillColor = col.fill
    hl.OutlineColor = col.outline
    hl.FillTransparency = Chams.fill_transparency
    hl.OutlineTransparency = Chams.outline_transparency
    hl.DepthMode = Chams.visible_only
        and Enum.HighlightDepthMode.Occluded
        or  Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = char
end

local function removeHighlight(player)
    local hl = highlights[player]
    if hl then
        pcall(function() hl:Destroy() end)
        highlights[player] = nil
    end
end

--============================================================
-- MATERIAL MODE
--============================================================
local function applyMaterialToChar(char, player)
    if not char then return end
    local col = colorFor(player)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not materialCache[part] then
                materialCache[part] = { mat = part.Material, col = part.Color }
            end
            part.Material = Enum.Material.ForceField
            part.Color = col.fill
        end
    end
end

local function restoreMaterialFromChar(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local cache = materialCache[part]
            if cache then
                pcall(function()
                    part.Material = cache.mat
                    part.Color = cache.col
                end)
                materialCache[part] = nil
            end
        end
    end
end

--============================================================
-- ATTACH / DETACH
--============================================================
local function attachCharacter(player)
    local char = player.Character
    if not char or player == LP then return end

    if Chams.mode == "highlight" or Chams.mode == "both" then
        ensureHighlight(player)
    end
    if Chams.mode == "material" or Chams.mode == "both" then
        applyMaterialToChar(char, player)
    end
end

local function detachCharacter(player)
    removeHighlight(player)
    local char = player.Character
    if char then restoreMaterialFromChar(char) end
end

local function refreshAll()
    refreshRoles()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if Chams.mode == "highlight" or Chams.mode == "both" then
                ensureHighlight(p)
            end
            if Chams.mode == "material" or Chams.mode == "both" then
                applyMaterialToChar(p.Character, p)
            end
        end
    end
end

--============================================================
-- WATCHERS
--============================================================
local function watchPlayer(player)
    if player == LP or watchedPlayers[player] then return end
    watchedPlayers[player] = true

    connections[#connections + 1] = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Chams.enabled then attachCharacter(player) end
    end)
    connections[#connections + 1] = player.CharacterRemoving:Connect(function()
        detachCharacter(player)
    end)

    local function hookBackpack(bp)
        if not bp then return end
        connections[#connections + 1] = bp.ChildAdded:Connect(function()
            task.defer(function() if Chams.enabled then refreshAll() end end)
        end)
        connections[#connections + 1] = bp.ChildRemoved:Connect(function()
            task.defer(function() if Chams.enabled then refreshAll() end end)
        end)
    end
    hookBackpack(player:FindFirstChildOfClass("Backpack"))
    connections[#connections + 1] = player.ChildAdded:Connect(function(c)
        if c:IsA("Backpack") then hookBackpack(c) end
    end)

    local char = player.Character
    if char then
        connections[#connections + 1] = char.ChildAdded:Connect(function()
            task.defer(function() if Chams.enabled then refreshAll() end end)
        end)
    end

    if player.Character then
        task.defer(function() if Chams.enabled then attachCharacter(player) end end)
    end
end

local function watchAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then watchPlayer(p) end
    end

    connections[#connections + 1] = Players.PlayerAdded:Connect(function(p)
        if Chams.enabled and p ~= LP then watchPlayer(p) end
    end)

    connections[#connections + 1] = Players.PlayerRemoving:Connect(function(p)
        detachCharacter(p)
        highlights[p] = nil
        roleByPlayer[p] = nil
        roleByName[p.Name] = nil
        watchedPlayers[p] = nil
    end)

    connections[#connections + 1] = LP.CharacterAdded:Connect(function()
        if not Chams.enabled then return end
        task.wait(0.5)
        refreshAll()
    end)
end

--============================================================
-- ROLE EVENT HOOK
--============================================================
local function hookRoleEvent()
    if roleEventConn then return end
    local m = getModule()
    if not m then return end
    if m.PlayerDataChanged and m.PlayerDataChanged.Event then
        roleEventConn = m.PlayerDataChanged.Event:Connect(function()
            if not Chams.enabled then return end
            refreshAll()
        end)
    end
end

--============================================================
-- LOOPS
--============================================================
local function startLoop()
    if loopConn then return end
    loopConn = RunService.Heartbeat:Connect(function()
        if not Chams.enabled then return end

        local now = os.clock()
        if now - lastRefresh > 0.35 then
            lastRefresh = now
            refreshAll()
        end

        for _, hl in pairs(highlights) do
            if hl and hl.Parent then
                local want = Chams.visible_only
                    and Enum.HighlightDepthMode.Occluded
                    or  Enum.HighlightDepthMode.AlwaysOnTop
                if hl.DepthMode ~= want then hl.DepthMode = want end
                if hl.FillTransparency ~= Chams.fill_transparency then
                    hl.FillTransparency = Chams.fill_transparency
                end
                if hl.OutlineTransparency ~= Chams.outline_transparency then
                    hl.OutlineTransparency = Chams.outline_transparency
                end
            end
        end
    end)
end

local function startRolePoll()
    if rolePollThread then return end
    rolePollThread = task.spawn(function()
        while Chams.enabled do
            pcall(refreshRoles)
            task.wait(0.5)
        end
        rolePollThread = nil
    end)
end

local function stopRolePoll()
    if rolePollThread then
        pcall(task.cancel, rolePollThread)
        rolePollThread = nil
    end
end

--============================================================
-- PUBLIC API
--============================================================
function Chams:start()
    if self.enabled then return end
    self.enabled = true

    hookRoleEvent()
    refreshRoles()
    watchAll()
    startLoop()
    startRolePoll()

    task.defer(function()
        refreshAll()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then attachCharacter(p) end
        end
    end)
end

function Chams:stop()
    self.enabled = false

    for player in pairs(highlights) do
        removeHighlight(player)
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then restoreMaterialFromChar(p.Character) end
    end

    stopRolePoll()
end

function Chams:destroy()
    self:stop()

    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)

    if loopConn then pcall(function() loopConn:Disconnect() end) loopConn = nil end
    if roleEventConn then pcall(function() roleEventConn:Disconnect() end) roleEventConn = nil end

    table.clear(highlights)
    table.clear(materialCache)
    table.clear(roleByName)
    table.clear(roleByPlayer)
    table.clear(watchedPlayers)
end

function Chams:setmode(m)
    if m ~= "highlight" and m ~= "material" and m ~= "both" then return end
    self.mode = m
    if self.enabled then
        for player in pairs(highlights) do removeHighlight(player) end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then restoreMaterialFromChar(p.Character) end
        end
        task.defer(refreshAll)
    end
end

function Chams:setcolor(role, fill, outline)
    if not self.colors[role] then return end
    if fill then self.colors[role].fill = fill end
    if outline then self.colors[role].outline = outline end
    if self.enabled then task.defer(refreshAll) end
end

--============================================================
-- GETTERS
--============================================================
function Chams:get(player)
    if typeof(player) == "string" then
        return roleByName[player]
    end
    if typeof(player) == "Instance" and player:IsA("Player") then
        return roleByPlayer[player]
    end
    return nil
end

function Chams:me()
    return roleByPlayer[LP]
end

function Chams:murderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if roleByPlayer[p] == "Murderer" then return p end
    end
    return nil
end

function Chams:sheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        local r = roleByPlayer[p]
        if r == "Sheriff" or r == "Hero" then return p end
    end
    return nil
end

function Chams:innocents()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if roleByPlayer[p] == "Innocent" then
            list[#list + 1] = p
        end
    end
    return list
end

function Chams:isMurderer(player)
    return roleByPlayer[player] == "Murderer"
end

function Chams:isSheriff(player)
    local r = roleByPlayer[player]
    return r == "Sheriff" or r == "Hero"
end

function Chams:isInnocent(player)
    return roleByPlayer[player] == "Innocent"
end

function Chams:colorFor(player)
    return colorFor(player)
end

function Chams:all()
    local out = {}
    for _, p in ipairs(Players:GetPlayers()) do
        out[p] = roleByPlayer[p]
    end
    return out
end

return Chams
