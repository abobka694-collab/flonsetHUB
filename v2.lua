--[[
    MM2 GUI  •  только интерфейс
    Без функционала — только каркас
    RightShift — открыть/закрыть
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

--============================================================
-- PARENT
--============================================================
local function getParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:FindFirstChildOfClass("PlayerGui")
end

--============================================================
-- THEME
--============================================================
local Theme = {
    -- фон (с прозрачностью)
    bg = Color3.fromRGB(20, 18, 24),
    bgTransparency = 0.15,
    
    card = Color3.fromRGB(30, 27, 34),
    cardTransparency = 0.15,
    
    header = Color3.fromRGB(16, 14, 20),
    headerTransparency = 0.2,
    
    sidebar = Color3.fromRGB(14, 12, 18),
    sidebarTransparency = 0.15,
    
    -- акцент
    accent = Color3.fromRGB(168, 85, 247),
    accentDim = Color3.fromRGB(120, 60, 180),
    
    -- текст
    text = Color3.fromRGB(240, 238, 245),
    textDim = Color3.fromRGB(150, 145, 155),
    textMuted = Color3.fromRGB(90, 88, 95),
    
    -- элементы
    toggleOff = Color3.fromRGB(60, 56, 65),
    toggleOn = Color3.fromRGB(168, 85, 247),
    outline = Color3.fromRGB(45, 42, 50),
    outlineSoft = Color3.fromRGB(35, 32, 40),
    
    -- шрифты
    font = Enum.Font.Gotham,
    fontMedium = Enum.Font.GothamMedium,
    fontBold = Enum.Font.GothamBold,
}

--============================================================
-- HELPERS
--============================================================
local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = r or UDim.new(0, 8) }, p)
end

local function stroke(p, color, thickness, transparency)
    return new("UIStroke", {
        Color = color or Theme.outline,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function tween(i, t, p)
    TweenService:Create(i, TweenInfo.new(t or 0.15), p):Play()
end

--============================================================
-- ROOT
--============================================================
local Root = new("ScreenGui", {
    Name = "MM2_GUI_" .. math.random(100000, 999999),
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999,
    Enabled = true,
}, getParent())

--============================================================
-- WINDOW
--============================================================
local W = new("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 900, 0, 550),
    Position = UDim2.new(0.5, -450, 0.5, -275),
    BackgroundColor3 = Theme.bg,
    BackgroundTransparency = Theme.bgTransparency,
    BorderSizePixel = 0,
    Active = true,
    Visible = true,
    ClipsDescendants = true,
}, Root)
corner(W, UDim.new(0, 12))
stroke(W, Theme.outline, 1, 0.3)

--============================================================
-- HEADER
--============================================================
local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
    Active = true,
}, W)
corner(Header, UDim.new(0, 12))
new("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
}, Header)

-- Logo
local LogoFrame = new("Frame", {
    Size = UDim2.new(0, 34, 0, 34),
    Position = UDim2.new(0, 14, 0.5, -17),
    BackgroundColor3 = Theme.accent,
    BorderSizePixel = 0,
}, Header)
corner(LogoFrame, UDim.new(0, 9))
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Theme.fontBold,
    TextSize = 18,
}, LogoFrame)

-- Title
new("TextLabel", {
    Size = UDim2.new(0, 300, 0, 18),
    Position = UDim2.new(0, 58, 0, 8),
    BackgroundTransparency = 1,
    Text = "MM2",
    TextColor3 = Theme.text,
    Font = Theme.fontBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)
new("TextLabel", {
    Size = UDim2.new(0, 300, 0, 14),
    Position = UDim2.new(0, 58, 0, 26),
    BackgroundTransparency = 1,
    Text = "Murder Mystery 2",
    TextColor3 = Theme.textDim,
    Font = Theme.font,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

-- Close button
local CloseB = new("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -42, 0.5, -15),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.3,
    Text = "X",
    TextColor3 = Theme.textDim,
    Font = Theme.fontBold,
    TextSize = 14,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
}, Header)
corner(CloseB, UDim.new(0, 8))
stroke(CloseB, Theme.outline, 1, 0.5)

--============================================================
-- SIDEBAR (текстовый, без иконок)
--============================================================
local Sidebar = new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 130, 1, -48),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundColor3 = Theme.sidebar,
    BackgroundTransparency = Theme.sidebarTransparency,
    BorderSizePixel = 0,
    Active = true,
}, W)

new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
new("UIPadding", {
    PaddingTop = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
}, Sidebar)

--============================================================
-- CONTENT
--============================================================
local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -130, 1, -48),
    Position = UDim2.new(0, 130, 0, 48),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
}, W)

--============================================================
-- WATERMARK
--============================================================
local Watermark = new("Frame", {
    Size = UDim2.new(0, 220, 0, 26),
    Position = UDim2.new(0, 140, 1, -36),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Active = false,
}, W)
corner(Watermark, UDim.new(0, 6))
stroke(Watermark, Theme.outline, 1, 0.4)

local WMText = new("TextLabel", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "MM2  •  0 fps  •  0 ms",
    TextColor3 = Theme.accent,
    Font = Theme.fontBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Watermark)

--============================================================
-- TAB SYSTEM
--============================================================
local Tabs = {}
local ActiveBtn, ActivePage = nil, nil

local function makeTab(name, displayName)
    -- Кнопка в sidebar
    local btn = new("TextButton", {
        Name = "Tab_" .. name,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.sidebar,
        BackgroundTransparency = 1,
        Text = "  " .. displayName,
        TextColor3 = Theme.textDim,
        Font = Theme.fontMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
    }, Sidebar)
    corner(btn, UDim.new(0, 7))
    
    -- Индикатор слева (фиолетовая полоска при выборе)
    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0, 18),
        Position = UDim2.new(0, 0, 0.5, -9),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
        Visible = false,
    }, btn)
    corner(indicator, UDim.new(1, 0))
    
    -- Страница
    local page = new("ScrollingFrame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1, -24, 1, -24),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Active = true,
    }, Content)
    
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    
    local ref = { btn = btn, page = page, indicator = indicator }
    Tabs[name] = ref
    
    local function select()
        if ActiveBtn and ActiveBtn ~= ref then
            tween(ActiveBtn.btn, 0.15, {
                BackgroundColor3 = Theme.sidebar,
                BackgroundTransparency = 1,
                TextColor3 = Theme.textDim,
            })
            ActiveBtn.indicator.Visible = false
        end
        tween(btn, 0.15, {
            BackgroundColor3 = Theme.card,
            BackgroundTransparency = 0.3,
            TextColor3 = Theme.text,
        })
        indicator.Visible = true
        ActiveBtn = ref
        ActivePage = page
        
        for _, other in pairs(Tabs) do
            other.page.Visible = (other == ref)
        end
    end
    
    btn.MouseButton1Click:Connect(select)
    btn.Activated:Connect(select)
    btn.MouseEnter:Connect(function()
        if ActiveBtn ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.card, BackgroundTransparency = 0.6 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveBtn ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.sidebar, BackgroundTransparency = 1 })
        end
    end)
    
    if not ActivePage then select() end
    
    return page
end

--============================================================
-- SECTION
--============================================================
local function makeSection(parent, title)
    local sec = new("Frame", {
        Name = "Section_" .. title,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.card,
        BackgroundTransparency = Theme.cardTransparency,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
    }, parent)
    corner(sec, UDim.new(0, 10))
    stroke(sec, Theme.outline, 1, 0.4)
    
    -- Заголовок секции
    local secHeader = new("Frame", {
        Name = "SecHeader",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
    }, sec)
    
    new("TextLabel", {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        TextColor3 = Theme.accent,
        Font = Theme.fontBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, secHeader)
    
    -- Внутренний контейнер
    local inner = new("Frame", {
        Name = "Inner",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
    }, sec)
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, inner)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
    }, inner)
    
    return inner
end

--============================================================
-- TOGGLE
--============================================================
local function makeToggle(parent, name, default, callback)
    local state = default == true
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)
    
    -- Название слева
    new("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Theme.fontMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    
    -- Свитч
    local sw = new("Frame", {
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -38, 0.5, -10),
        BackgroundColor3 = state and Theme.accent or Theme.toggleOff,
        BorderSizePixel = 0,
        Active = true,
    }, row)
    corner(sw, UDim.new(1, 0))
    
    local kn = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    }, sw)
    corner(kn, UDim.new(1, 0))
    
    -- Клик-зона
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Active = true,
    }, row)
    
    local function doToggle()
        state = not state
        tween(sw, 0.15, { BackgroundColor3 = state and Theme.accent or Theme.toggleOff })
        kn.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if callback then pcall(callback, state) end
    end
    
    btn.MouseButton1Click:Connect(doToggle)
    btn.Activated:Connect(doToggle)
    
    return {
        get = function() return state end,
        set = function(v)
            state = v and true or false
            tween(sw, 0.15, { BackgroundColor3 = state and Theme.accent or Theme.toggleOff })
            kn.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        end,
    }
end

--============================================================
-- SLIDER
--============================================================
local function makeSlider(parent, name, min, max, default, callback, suffix)
    suffix = suffix or ""
    local value = default or min
    
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)
    
    -- Название
    new("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Theme.fontMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    
    -- Значение
    local valLbl = new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 16),
        Position = UDim2.new(0.6, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value) .. suffix,
        TextColor3 = Theme.accent,
        Font = Theme.fontBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    
    -- Бар
    local barBg = new("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = Theme.toggleOff,
        BorderSizePixel = 0,
        Active = true,
    }, row)
    corner(barBg, UDim.new(1, 0))
    
    local pct = (value - min) / (max - min)
    
    local barFill = new("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    }, barBg)
    corner(barFill, UDim.new(1, 0))
    
    -- Кружок
    local knob = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(pct, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
    }, barBg)
    corner(knob, UDim.new(1, 0))
    
    local dragging = false
    local function apply(input)
        local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        value = math.floor((min + (max - min) * rel) * 100) / 100
        barFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
        valLbl.Text = tostring(value) .. suffix
        if callback then pcall(callback, value) end
    end
    
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            apply(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            apply(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return {
        get = function() return value end,
        set = function(v)
            value = math.clamp(v, min, max)
            barFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            valLbl.Text = tostring(value) .. suffix
        end,
    }
end

--============================================================
-- СОЗДАЁМ ТАБЫ И СЕКЦИИ (ПУСТЫЕ)
--============================================================

-- COMBAT
local combatPage = makeTab("combat", "Combat")
local cSec1 = makeSection(combatPage, "Kill Aura")
makeToggle(cSec1, "Kill Aura", false, function(v) end)
makeSlider(cSec1, "Range", 5, 50, 15, function(v) end, " st")

local cSec2 = makeSection(combatPage, "Auto Shoot")
makeToggle(cSec2, "Auto Shoot", false, function(v) end)

-- VISUALS
local visualPage = makeTab("visuals", "Visuals")
local vSec1 = makeSection(visualPage, "ESP")
makeToggle(vSec1, "ESP", false, function(v) end)
makeToggle(vSec1, "Show Name", true, function(v) end)
makeToggle(vSec1, "Show Role", true, function(v) end)
makeToggle(vSec1, "Show Distance", true, function(v) end)

local vSec2 = makeSection(visualPage, "Chams")
makeToggle(vSec2, "Chams", false, function(v) end)

local vSec3 = makeSection(visualPage, "World")
makeToggle(vSec3, "Fullbright", false, function(v) end)

-- MOVE
local movePage = makeTab("move", "Move")
local mSec1 = makeSection(movePage, "Fly")
makeToggle(mSec1, "Fly", false, function(v) end)
makeSlider(mSec1, "Fly Speed", 10, 300, 60, function(v) end, " spd")

local mSec2 = makeSection(movePage, "Other")
makeToggle(mSec2, "Noclip", false, function(v) end)
makeToggle(mSec2, "Infinite Jump", false, function(v) end)
makeToggle(mSec2, "Speed", false, function(v) end)
makeSlider(mSec2, "Speed Value", 16, 200, 16, function(v) end, "")

-- MISC
local miscPage = makeTab("misc", "Misc")
local miSec = makeSection(miscPage, "Utilities")
makeToggle(miSec, "Anti-AFK", false, function(v) end)

--============================================================
-- DRAG
--============================================================
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = W.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        W.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--============================================================
-- CLOSE / TOGGLE
--============================================================
local visible = true

CloseB.MouseButton1Click:Connect(function()
    W.Visible = false
    visible = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        visible = not visible
        W.Visible = visible
    end
end)

--============================================================
-- WATERMARK UPDATE (FPS/PING)
--============================================================
local fps = 0
local lastTime = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = tick()
    end
end)

task.spawn(function()
    while W.Parent do
        task.wait(0.5)
        local ping = 0
        local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
        if ok and type(p) == "number" then ping = math.floor(p) end
        if WMText then
            WMText.Text = string.format("MM2  •  %d fps  •  %d ms", fps, ping)
        end
    end
end)

print("[MM2 GUI] Загружено. RightShift — меню.")
