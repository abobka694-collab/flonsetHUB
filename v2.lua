--[[
    MM2 GUI  •  v3
    Только интерфейс, без функционала
    700x600, табы сверху
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
    bg = Color3.fromRGB(22, 20, 28),
    bgTransparency = 0.15,
    
    header = Color3.fromRGB(18, 16, 22),
    headerTransparency = 0.1,
    
    card = Color3.fromRGB(32, 29, 40),
    cardTransparency = 0.2,
    
    cardHover = Color3.fromRGB(38, 34, 48),
    
    accent = Color3.fromRGB(160, 90, 255),
    accentGlow = Color3.fromRGB(190, 130, 255),
    
    text = Color3.fromRGB(240, 238, 245),
    textDim = Color3.fromRGB(150, 145, 160),
    textMuted = Color3.fromRGB(95, 90, 105),
    
    toggleOff = Color3.fromRGB(60, 56, 70),
    outline = Color3.fromRGB(50, 45, 62),
    outlineSoft = Color3.fromRGB(38, 34, 46),
    
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

local function tween(i, t, p, style)
    TweenService:Create(i, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
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
-- WINDOW 700x600
--============================================================
local W = new("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 700, 0, 600),
    Position = UDim2.new(0.5, -350, 0.5, -300),
    BackgroundColor3 = Theme.bg,
    BackgroundTransparency = Theme.bgTransparency,
    BorderSizePixel = 0,
    Active = true,
    Visible = true,
    ClipsDescendants = true,
}, Root)
corner(W, UDim.new(0, 14))
stroke(W, Theme.outline, 1, 0.3)

--============================================================
-- HEADER (с табами внутри)
--============================================================
local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
    Active = true,
}, W)
corner(Header, UDim.new(0, 14))
new("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
}, Header)

-- Logo
local LogoFrame = new("Frame", {
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(0, 16, 0, 8),
    BackgroundColor3 = Theme.accent,
    BorderSizePixel = 0,
}, Header)
corner(LogoFrame, UDim.new(0, 10))
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Theme.fontBold,
    TextSize = 20,
}, LogoFrame)

-- Title
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 62, 0, 8),
    BackgroundTransparency = 1,
    Text = "MM2",
    TextColor3 = Theme.text,
    Font = Theme.fontBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 62, 0, 28),
    BackgroundTransparency = 1,
    Text = "Murder Mystery 2",
    TextColor3 = Theme.textDim,
    Font = Theme.font,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

-- Close
local CloseB = new("TextButton", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -48, 0, 10),
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
-- TAB BAR (внутри header снизу)
--============================================================
local TabBar = new("Frame", {
    Size = UDim2.new(1, -32, 0, 26),
    Position = UDim2.new(0, 16, 0, 44),
    BackgroundTransparency = 1,
    Active = true,
}, Header)

new("UIListLayout", {
    Padding = UDim.new(0, 6),
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
}, TabBar)

--============================================================
-- CONTENT
--============================================================
local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 70),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
}, W)

--============================================================
-- WATERMARK
--============================================================
local Watermark = new("Frame", {
    Size = UDim2.new(0, 220, 0, 28),
    Position = UDim2.new(1, -236, 1, -40),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Active = false,
}, W)
corner(Watermark, UDim.new(0, 7))
stroke(Watermark, Theme.outline, 1, 0.4)

local WMText = new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
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
local ActiveTab = nil

local function makeTab(name, displayName)
    -- Кнопка таба
    local btn = new("TextButton", {
        Name = "Tab_" .. name,
        Size = UDim2.new(0, 100, 0, 26),
        BackgroundColor3 = Theme.card,
        BackgroundTransparency = 1,
        Text = displayName,
        TextColor3 = Theme.textDim,
        Font = Theme.fontMedium,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
    }, TabBar)
    corner(btn, UDim.new(0, 7))
    
    -- Подсветка (полоска снизу)
    local underline = new("Frame", {
        Size = UDim2.new(0, 0, 0, 2),
        Position = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
        Visible = false,
    }, btn)
    corner(underline, UDim.new(1, 0))
    
    -- Страница
    local page = new("ScrollingFrame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1, -32, 1, -32),
        Position = UDim2.new(0, 16, 0, 16),
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
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    
    local ref = { btn = btn, page = page, underline = underline }
    Tabs[name] = ref
    
    local function select()
        if ActiveTab and ActiveTab ~= ref then
            tween(ActiveTab.btn, 0.15, {
                BackgroundColor3 = Theme.card,
                BackgroundTransparency = 1,
                TextColor3 = Theme.textDim,
            })
            ActiveTab.underline.Visible = false
        end
        tween(btn, 0.15, {
            BackgroundColor3 = Theme.card,
            BackgroundTransparency = 0.3,
            TextColor3 = Theme.text,
        })
        underline.Visible = true
        tween(underline, 0.2, { Size = UDim2.new(0, 60, 0, 2) })
        ActiveTab = ref
        
        for _, other in pairs(Tabs) do
            other.page.Visible = (other == ref)
        end
    end
    
    btn.MouseButton1Click:Connect(select)
    btn.Activated:Connect(select)
    btn.MouseEnter:Connect(function()
        if ActiveTab ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.cardHover, BackgroundTransparency = 0.5, TextColor3 = Theme.text })
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.card, BackgroundTransparency = 1, TextColor3 = Theme.textDim })
        end
    end)
    
    if not ActiveTab then select() end
    
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
    corner(sec, UDim.new(0, 12))
    stroke(sec, Theme.outline, 1, 0.4)
    
    -- Заголовок
    new("TextLabel", {
        Size = UDim2.new(1, -28, 0, 36),
        Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        TextColor3 = Theme.accent,
        Font = Theme.fontBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, sec)
    
    -- Внутренний контейнер
    local inner = new("Frame", {
        Name = "Inner",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
    }, sec)
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, inner)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
    }, inner)
    
    return inner
end

--============================================================
-- TOGGLE
--============================================================
local function makeToggle(parent, name, default, callback)
    local state = default == true
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)
    
    new("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Theme.fontMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    
    local sw = new("Frame", {
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -40, 0.5, -11),
        BackgroundColor3 = state and Theme.accent or Theme.toggleOff,
        BorderSizePixel = 0,
        Active = true,
    }, row)
    corner(sw, UDim.new(1, 0))
    
    local kn = new("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    }, sw)
    corner(kn, UDim.new(1, 0))
    
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Active = true,
    }, row)
    
    local function doToggle()
        state = not state
        tween(sw, 0.15, { BackgroundColor3 = state and Theme.accent or Theme.toggleOff })
        tween(kn, 0.15, { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
        if callback then pcall(callback, state) end
    end
    
    btn.MouseButton1Click:Connect(doToggle)
    btn.Activated:Connect(doToggle)
    
    return {
        get = function() return state end,
        set = function(v)
            state = v and true or false
            tween(sw, 0.15, { BackgroundColor3 = state and Theme.accent or Theme.toggleOff })
            tween(kn, 0.15, { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
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
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)
    
    new("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Theme.fontMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    
    local valLbl = new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 18),
        Position = UDim2.new(0.6, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value) .. suffix,
        TextColor3 = Theme.accent,
        Font = Theme.fontBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    
    local barBg = new("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 32),
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
    
    local knob = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
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
-- ТАБЫ И СЕКЦИИ (ПУСТЫЕ)
--============================================================

local combatPage = makeTab("combat", "Combat")
local cSec1 = makeSection(combatPage, "Kill Aura")
makeToggle(cSec1, "Kill Aura", false, function(v) end)
makeSlider(cSec1, "Range", 5, 50, 15, function(v) end, " st")

local cSec2 = makeSection(combatPage, "Auto Shoot")
makeToggle(cSec2, "Auto Shoot", false, function(v) end)

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

local movePage = makeTab("move", "Move")
local mSec1 = makeSection(movePage, "Fly")
makeToggle(mSec1, "Fly", false, function(v) end)
makeSlider(mSec1, "Fly Speed", 10, 300, 60, function(v) end, " spd")

local mSec2 = makeSection(movePage, "Other")
makeToggle(mSec2, "Noclip", false, function(v) end)
makeToggle(mSec2, "Infinite Jump", false, function(v) end)
makeToggle(mSec2, "Speed", false, function(v) end)
makeSlider(mSec2, "Speed Value", 16, 200, 16, function(v) end, "")

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
        -- не тащим если клик по кнопкам
        if input.Target and (input.Target:IsA("TextButton")) then return end
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
-- FPS/PING
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

print("[MM2 GUI v3] Загружено. RightShift — меню.")
