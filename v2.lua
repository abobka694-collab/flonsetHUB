--[[
    MM2 GUI  •  бело-голубая тема
    Только каркас, без функционала
    650x650, квадратное
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
-- RESOURCES
--============================================================
local RES = {
    bg        = "rbxassetid://101818396313138",
    combat    = "rbxassetid://7485051733",
    visuals   = "rbxassetid://6523858422",
    movement  = "rbxassetid://9525535526",
    misc      = "rbxassetid://13321880293",
    search    = "rbxassetid://132302594577680",
    close     = "rbxassetid://10152135074",
    settings  = "rbxassetid://9405931596",
    kokomi    = "rbxassetid://7903522093",
}

--============================================================
-- THEME (бело-голубая)
--============================================================
local Theme = {
    bg = Color3.fromRGB(15, 20, 35),
    bgTransparency = 0.1,
    
    header = Color3.fromRGB(10, 15, 30),
    headerTransparency = 0.4,
    
    card = Color3.fromRGB(22, 30, 50),
    cardTransparency = 0.2,
    
    cardHover = Color3.fromRGB(30, 42, 68),
    
    accent = Color3.fromRGB(90, 160, 255),
    accentGlow = Color3.fromRGB(130, 190, 255),
    accentDim = Color3.fromRGB(60, 110, 190),
    
    text = Color3.fromRGB(240, 245, 255),
    textDim = Color3.fromRGB(140, 160, 190),
    textMuted = Color3.fromRGB(90, 110, 140),
    
    toggleOff = Color3.fromRGB(50, 65, 90),
    toggleOn = Color3.fromRGB(90, 160, 255),
    outline = Color3.fromRGB(45, 60, 90),
    outlineSoft = Color3.fromRGB(30, 42, 68),
    
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
    return new("UICorner", { CornerRadius = r or UDim.new(0, 10) }, p)
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
-- WINDOW 650x650
--============================================================
local W = new("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 650, 0, 650),
    Position = UDim2.new(0.5, -325, 0.5, -325),
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
-- BACKGROUND IMAGE
--============================================================
local BGImg = new("ImageLabel", {
    Name = "Background",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://101818396313138",
    ImageTransparency = 0.35,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
}, W)
corner(BGImg, UDim.new(0, 14))

-- Тёмный синий оверлей поверх обоев
local Overlay = new("Frame", {
    Name = "Overlay",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(15, 20, 35),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    ZIndex = 1,
}, W)
corner(Overlay, UDim.new(0, 14))

--============================================================
-- HEADER
--============================================================
local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 2,
}, W)
corner(Header, UDim.new(0, 14))
new("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Theme.header,
    BackgroundTransparency = Theme.headerTransparency,
    BorderSizePixel = 0,
    ZIndex = 2,
}, Header)

-- Logo
local LogoFrame = new("Frame", {
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(0, 16, 0.5, -18),
    BackgroundColor3 = Theme.accent,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Header)
corner(LogoFrame, UDim.new(0, 10))
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Theme.fontBold,
    TextSize = 20,
    ZIndex = 4,
}, LogoFrame)

-- Title
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 62, 0, 10),
    BackgroundTransparency = 1,
    Text = "MM2",
    TextColor3 = Theme.text,
    Font = Theme.fontBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
}, Header)
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 62, 0, 30),
    BackgroundTransparency = 1,
    Text = "Murder Mystery 2",
    TextColor3 = Theme.textDim,
    Font = Theme.font,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
}, Header)

-- Close button
local CloseB = new("TextButton", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -48, 0.5, -16),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.3,
    Text = "",
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    ZIndex = 3,
}, Header)
corner(CloseB, UDim.new(0, 8))
stroke(CloseB, Theme.outline, 1, 0.5)

new("ImageLabel", {
    Size = UDim2.new(0, 14, 0, 14),
    Position = UDim2.new(0.5, -7, 0.5, -7),
    BackgroundTransparency = 1,
    Image = RES.close,
    ImageColor3 = Theme.textDim,
    ZIndex = 4,
}, CloseB)

--============================================================
-- TYANKA (Kokomi) — свисает слева от окна
--============================================================
local Tyanka = new("ImageLabel", {
    Name = "Kokomi",
    Size = UDim2.new(0, 130, 0, 130),
    Position = UDim2.new(0, -105, 0, 20),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Image = RES.kokomi,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 5,
}, W)

--============================================================
-- SEARCH BAR
--============================================================
local SearchFrame = new("Frame", {
    Name = "Search",
    Size = UDim2.new(1, -32, 0, 36),
    Position = UDim2.new(0, 16, 0, 72),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 3,
}, W)
corner(SearchFrame, UDim.new(0, 10))
stroke(SearchFrame, Theme.outline, 1, 0.5)

new("ImageLabel", {
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.new(0, 12, 0.5, -8),
    BackgroundTransparency = 1,
    Image = RES.search,
    ImageColor3 = Theme.textDim,
    ZIndex = 4,
}, SearchFrame)

new("TextBox", {
    Name = "SearchBox",
    Size = UDim2.new(1, -44, 1, 0),
    Position = UDim2.new(0, 36, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Поиск",
    PlaceholderColor3 = Theme.textDim,
    TextColor3 = Theme.text,
    Font = Theme.font,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 4,
}, SearchFrame)

--============================================================
-- CATEGORY BADGE
--============================================================
local Badge = new("Frame", {
    Name = "Category",
    Size = UDim2.new(0, 90, 0, 26),
    Position = UDim2.new(0, 16, 0, 116),
    BackgroundColor3 = Theme.accent,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 3,
}, W)
corner(Badge, UDim.new(0, 8))

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "MM2",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Theme.fontBold,
    TextSize = 12,
    ZIndex = 4,
}, Badge)

--============================================================
-- SIDEBAR
--============================================================
local Sidebar = new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 52, 1, -200),
    Position = UDim2.new(0, 16, 0, 156),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 3,
}, W)
corner(Sidebar, UDim.new(0, 12))
stroke(Sidebar, Theme.outline, 1, 0.5)

new("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
new("UIPadding", { PaddingTop = UDim.new(0, 10) }, Sidebar)

--============================================================
-- CONTENT
--============================================================
local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -96, 1, -200),
    Position = UDim2.new(0, 80, 0, 156),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 3,
}, W)
corner(Content, UDim.new(0, 12))
stroke(Content, Theme.outline, 1, 0.5)

--============================================================
-- TAB SYSTEM
--============================================================
local ActiveBtn, ActivePage = nil, nil
local Pages = {}

local function makeTab(name, iconId, layoutOrder)
    local btn = new("TextButton", {
        Name = "Tab_" .. name,
        Size = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = Theme.card,
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        LayoutOrder = layoutOrder,
        ZIndex = 4,
    }, Sidebar)
    corner(btn, UDim.new(0, 10))

    local icon = new("ImageLabel", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0.5, -11, 0.5, -11),
        BackgroundTransparency = 1,
        Image = iconId,
        ImageColor3 = Theme.textDim,
        ZIndex = 5,
    }, btn)

    local page = new("Frame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1, -24, 1, -24),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ZIndex = 4,
    }, Content)

    local ref = { btn = btn, icon = icon, page = page }
    Pages[name] = ref

    local function select()
        if ActiveBtn and ActiveBtn ~= ref then
            tween(ActiveBtn.btn, 0.15, { BackgroundColor3 = Theme.card, BackgroundTransparency = 1 })
            tween(ActiveBtn.icon, 0.15, { ImageColor3 = Theme.textDim })
        end
        tween(btn, 0.15, { BackgroundColor3 = Theme.accent, BackgroundTransparency = 0.15 })
        tween(icon, 0.15, { ImageColor3 = Color3.fromRGB(255, 255, 255) })
        ActiveBtn = ref
        ActivePage = page

        for _, other in pairs(Pages) do
            other.page.Visible = (other == ref)
        end
    end

    btn.MouseButton1Click:Connect(select)
    btn.Activated:Connect(select)
    btn.MouseEnter:Connect(function()
        if ActiveBtn ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.card, BackgroundTransparency = 0.5 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveBtn ~= ref then
            tween(btn, 0.1, { BackgroundColor3 = Theme.card, BackgroundTransparency = 1 })
        end
    end)

    if not ActivePage then select() end

    return page
end

-- 4 пустых таба
makeTab("combat", RES.combat, 1)
makeTab("visuals", RES.visuals, 2)
makeTab("movement", RES.movement, 3)
makeTab("misc", RES.misc, 4)

--============================================================
-- WATERMARK
--============================================================
local Watermark = new("Frame", {
    Name = "Watermark",
    Size = UDim2.new(1, -32, 0, 28),
    Position = UDim2.new(0, 16, 1, -44),
    BackgroundColor3 = Theme.card,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 3,
}, W)
corner(Watermark, UDim.new(0, 8))
stroke(Watermark, Theme.outline, 1, 0.5)

local WMText = new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "MM2  •  0 fps  •  0 ms",
    TextColor3 = Theme.accent,
    Font = Theme.fontBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, Watermark)

--============================================================
-- DRAG
--============================================================
local dragging, dragStart, startPos = false, nil, nil

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

print("[MM2 GUI] Каркас загружен. RightShift — меню.")
