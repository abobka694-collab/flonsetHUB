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

--============================================================
-- ФУНКЦИОНАЛ  •  вставить в конец файла
--============================================================

--============================================================
-- EXTRA SERVICES
--============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

--============================================================
-- CHEAT STATE
--============================================================
local State = {
    esp = false, espName = true, espRole = true, espDist = true,
    chams = false, fullbright = false,
    killaura = false, killauraRange = 15, autoShoot = false,
    fly = false, flySpeed = 60, noclip = false, infjump = false,
    speedOn = false, speedValue = 16,
    antiAfk = false,
}

local espData = {}
local chamsCache = {}
local originalLighting = {}

--============================================================
-- ROLE DETECTION
--============================================================
local roleModule = nil

local function getRoleModule()
    if roleModule and roleModule.PlayerData then return roleModule end
    local ok, m = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient", 5))
    end)
    if ok and type(m) == "table" then roleModule = m end
    return roleModule
end

local function getRole(player)
    local m = getRoleModule()
    local data = m and m.PlayerData
    if type(data) == "table" then
        local info = data[player.Name]
        if type(info) == "table" and not info.Dead then
            return info.Role or "Innocent"
        end
    end
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")
    local function hasTool(name)
        if char and char:FindFirstChild(name) then return true end
        if bp and bp:FindFirstChild(name) then return true end
        return false
    end
    if hasTool("Gun") then return "Sheriff" end
    if hasTool("Knife") then return "Murderer" end
    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 60, 60) end
    if role == "Sheriff" or role == "Hero" then return Color3.fromRGB(60, 180, 255) end
    return Color3.fromRGB(240, 240, 240)
end

--============================================================
-- ESP
--============================================================
local function createESP(player)
    if player == LP or espData[player] then return end
    local char = player.Character
    if not char then return end

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = getParent()

    local bb = Instance.new("BillboardGui")
    bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Parent = getParent()

    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0, 16)
    nl.BackgroundTransparency = 1
    nl.TextColor3 = Color3.new(1, 1, 1)
    nl.TextStrokeTransparency = 0
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 13
    nl.Parent = bb

    local rl = Instance.new("TextLabel")
    rl.Size = UDim2.new(1, 0, 0, 14)
    rl.Position = UDim2.new(0, 0, 0, 16)
    rl.BackgroundTransparency = 1
    rl.TextStrokeTransparency = 0
    rl.Font = Enum.Font.GothamBold
    rl.TextSize = 11
    rl.Parent = bb

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0, 12)
    dl.Position = UDim2.new(0, 0, 0, 30)
    dl.BackgroundTransparency = 1
    dl.TextColor3 = Color3.fromRGB(200, 200, 200)
    dl.TextStrokeTransparency = 0
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 10
    dl.Parent = bb

    espData[player] = { hl = hl, bb = bb, nl = nl, rl = rl, dl = dl }
end

local function removeESP(player)
    local d = espData[player]
    if not d then return end
    pcall(function() d.hl:Destroy() end)
    pcall(function() d.bb:Destroy() end)
    espData[player] = nil
end

local function updateESP()
    if not State.esp then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if not espData[player] then createESP(player) end
            local d = espData[player]
            if d then
                local role = getRole(player)
                local col = getRoleColor(role)
                d.hl.Adornee = char
                d.hl.FillColor = col
                d.hl.OutlineColor = col
                d.bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                d.nl.Text = State.espName and player.Name or ""
                d.nl.Visible = State.espName
                d.rl.Text = State.espRole and ("[" .. role .. "]") or ""
                d.rl.TextColor3 = col
                d.rl.Visible = State.espRole
                if State.espDist then
                    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local tRoot = char:FindFirstChild("HumanoidRootPart")
                    if myRoot and tRoot then
                        d.dl.Text = string.format("%.0fm", (myRoot.Position - tRoot.Position).Magnitude)
                        d.dl.Visible = true
                    else
                        d.dl.Visible = false
                    end
                else
                    d.dl.Visible = false
                end
            end
        else
            removeESP(player)
        end
    end
end

local function toggleESP(v)
    State.esp = v
    if not v then
        for player in pairs(espData) do removeESP(player) end
    end
end

--============================================================
-- CHAMS
--============================================================
local function applyChams(player)
    if player == LP then return end
    local char = player.Character
    if not char then return end
    local col = getRoleColor(getRole(player))
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not chamsCache[part] then
                chamsCache[part] = { mat = part.Material, col = part.Color }
            end
            part.Material = Enum.Material.ForceField
            part.Color = col
        end
    end
end

local function restoreChams(player)
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local c = chamsCache[part]
            if c then
                pcall(function() part.Material = c.mat part.Color = c.col end)
                chamsCache[part] = nil
            end
        end
    end
end

local function updateChams()
    if not State.chams then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then applyChams(player) end
    end
end

local function toggleChams(v)
    State.chams = v
    if not v then
        for _, player in ipairs(Players:GetPlayers()) do restoreChams(player) end
        chamsCache = {}
    end
end

--============================================================
-- KILL AURA
--============================================================
local function getKnife()
    local char = LP.Character
    if char and char:FindFirstChild("Knife") then return char.Knife end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp and bp:FindFirstChild("Knife") then return bp.Knife end
    return nil
end

local function doKillAura()
    if not State.killaura then return end
    local knife = getKnife()
    if not knife then return end
    if knife.Parent ~= LP.Character then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(knife) end) end
        return
    end
    local ev = knife:FindFirstChild("Events")
    if not ev then return end
    local stab = ev:FindFirstChild("KnifeStabbed")
    local touch = ev:FindFirstChild("HandleTouched")
    if not stab or not touch then return end
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= State.killauraRange then
                pcall(function() stab:FireServer() end)
                pcall(function() touch:FireServer(root) end)
            end
        end
    end
end

--============================================================
-- AUTO SHOOT
--============================================================
local function getGun()
    local char = LP.Character
    if char and char:FindFirstChild("Gun") then return char.Gun end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp and bp:FindFirstChild("Gun") then return bp.Gun end
    return nil
end

local function doAutoShoot()
    if not State.autoShoot then return end
    local gun = getGun()
    if not gun then return end
    local shoot = gun:FindFirstChild("Shoot")
    if not shoot or not shoot:IsA("RemoteEvent") then return end
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if getRole(p) == "Murderer" then
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= 200 then
                    local origin = myRoot.CFrame
                    local aim = CFrame.new(origin.Position, root.Position)
                    pcall(function() shoot:FireServer(origin, aim) end)
                    return
                end
            end
        end
    end
end

--============================================================
-- FLY
--============================================================
local flyBV, flyBG

local function startFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    flyBG.P = 9000
    flyBG.Parent = hrp
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(4e5, 4e5, 4e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

local function updateFly()
    if not State.fly then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not flyBV or not flyBG then startFly() return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    flyBG.CFrame = cam.CFrame
    local m = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m = m - Vector3.yAxis end
    if m.Magnitude > 0 then m = m.Unit * State.flySpeed end
    flyBV.Velocity = m
end

local function toggleFly(v)
    State.fly = v
    if v then startFly() else stopFly() end
end

--============================================================
-- NOCLIP / SPEED
--============================================================
local function updateNoclip()
    if not State.noclip then return end
    local char = LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

local function updateSpeed()
    if not State.speedOn then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed ~= State.speedValue then
        hum.WalkSpeed = State.speedValue
    end
end

--============================================================
-- INF JUMP
--============================================================
UserInputService.JumpRequest:Connect(function()
    if State.infjump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--============================================================
-- ANTI-AFK
--============================================================
LP.Idled:Connect(function()
    if State.antiAfk then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

--============================================================
-- FULLBRIGHT
--============================================================
local function saveLighting()
    originalLighting.b = Lighting.Brightness
    originalLighting.a = Lighting.Ambient
    originalLighting.o = Lighting.OutdoorAmbient
    originalLighting.g = Lighting.GlobalShadows
    originalLighting.c = Lighting.ClockTime
    originalLighting.f = Lighting.FogEnd
end

local function applyFB()
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
end

local function restoreL()
    if originalLighting.b then
        Lighting.Brightness = originalLighting.b
        Lighting.Ambient = originalLighting.a
        Lighting.OutdoorAmbient = originalLighting.o
        Lighting.GlobalShadows = originalLighting.g
        Lighting.ClockTime = originalLighting.c
        Lighting.FogEnd = originalLighting.f
    end
end

local function toggleFB(v)
    State.fullbright = v
    if v then applyFB() else restoreL() end
end

saveLighting()

--============================================================
-- MAIN LOOP
--============================================================
local lastESP, lastKA, lastAS = 0, 0, 0
RunService.Heartbeat:Connect(function()
    local now = tick()
    if State.esp and now - lastESP > 0.3 then lastESP = now pcall(updateESP) end
    if State.chams then pcall(updateChams) end
    if State.killaura and now - lastKA > 0.1 then lastKA = now pcall(doKillAura) end
    if State.autoShoot and now - lastAS > 0.15 then lastAS = now pcall(doAutoShoot) end
    pcall(updateFly)
    pcall(updateNoclip)
    pcall(updateSpeed)
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.fly then startFly() end
end)

--============================================================
-- UI BUILDERS
--============================================================
local function makeSection(parent, title)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
    sec.BackgroundTransparency = 0.3
    sec.BorderSizePixel = 0
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Active = true
    sec.ZIndex = 5
    sec.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = sec
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(45, 60, 90)
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = sec

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 26)
    titleLbl.Position = UDim2.new(0, 12, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = string.upper(title)
    titleLbl.TextColor3 = Color3.fromRGB(90, 160, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 6
    titleLbl.Parent = sec

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, 0, 0, 0)
    inner.Position = UDim2.new(0, 0, 0, 32)
    inner.BackgroundTransparency = 1
    inner.AutomaticSize = Enum.AutomaticSize.Y
    inner.Active = true
    inner.ZIndex = 6
    inner.Parent = sec
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = inner
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = inner

    return inner
end

local function makeToggle(parent, name, getter, setter)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.Active = true
    row.ZIndex = 6
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7
    lbl.Parent = row

    local state = getter()
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 40, 0, 22)
    sw.Position = UDim2.new(1, -40, 0.5, -11)
    sw.BackgroundColor3 = state and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(50, 65, 90)
    sw.BorderSizePixel = 0
    sw.ZIndex = 7
    sw.Parent = row
    
    local swc = Instance.new("UICorner")
    swc.CornerRadius = UDim.new(1, 0)
    swc.Parent = sw

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 18, 0, 18)
    kn.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.BorderSizePixel = 0
    kn.ZIndex = 8
    kn.Parent = sw
    
    local knc = Instance.new("UICorner")
    knc.CornerRadius = UDim.new(1, 0)
    knc.Parent = kn

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Active = true
    btn.ZIndex = 8
    btn.Parent = row

    local function doToggle()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(50, 65, 90)
        }):Play()
        TweenService:Create(kn, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        setter(state)
    end

    btn.MouseButton1Click:Connect(doToggle)
    btn.Activated:Connect(doToggle)
end

local function makeSlider(parent, name, min, max, default, setter, suffix)
    suffix = suffix or ""
    local value = default or min

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundTransparency = 1
    row.Active = true
    row.ZIndex = 6
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7
    lbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.4, 0, 0, 16)
    valLbl.Position = UDim2.new(0.6, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(value) .. suffix
    valLbl.TextColor3 = Color3.fromRGB(90, 160, 255)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 7
    valLbl.Parent = row

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 6)
    barBg.Position = UDim2.new(0, 0, 0, 30)
    barBg.BackgroundColor3 = Color3.fromRGB(50, 65, 90)
    barBg.BorderSizePixel = 0
    barBg.Active = true
    barBg.ZIndex = 7
    barBg.Parent = row
    
    local bbc = Instance.new("UICorner")
    bbc.CornerRadius = UDim.new(1, 0)
    bbc.Parent = barBg

    local pct = (value - min) / (max - min)
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(pct, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 8
    barFill.Parent = barBg
    
    local bfc = Instance.new("UICorner")
    bfc.CornerRadius = UDim.new(1, 0)
    bfc.Parent = barFill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 9
    knob.Parent = barBg
    
    local knc = Instance.new("UICorner")
    knc.CornerRadius = UDim.new(1, 0)
    knc.Parent = knob

    local dragging = false
    local function apply(input)
        local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        value = math.floor((min + (max - min) * rel) * 100) / 100
        barFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
        valLbl.Text = tostring(value) .. suffix
        setter(value)
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
end

--============================================================
-- НАПОЛНЕНИЕ ТАБОВ
--============================================================

-- COMBAT → TARGET
local combatPage = Pages.combat and Pages.combat.page
if combatPage then
    local tSec = makeSection(combatPage, "Target")
    makeToggle(tSec, "Kill Aura", function() return State.killaura end, function(v) State.killaura = v end)
    makeSlider(tSec, "Kill Range", 5, 50, 15, function(v) State.killauraRange = v end, " st")
    makeToggle(tSec, "Auto Shoot", function() return State.autoShoot end, function(v) State.autoShoot = v end)
end

-- VISUALS → ESP
local visualPage = Pages.visuals and Pages.visuals.page
if visualPage then
    local eSec = makeSection(visualPage, "ESP")
    makeToggle(eSec, "ESP", function() return State.esp end, toggleESP)
    makeToggle(eSec, "Show Name", function() return State.espName end, function(v) State.espName = v end)
    makeToggle(eSec, "Show Role", function() return State.espRole end, function(v) State.espRole = v end)
    makeToggle(eSec, "Show Distance", function() return State.espDist end, function(v) State.espDist = v end)
    makeToggle(eSec, "Chams", function() return State.chams end, toggleChams)
    makeToggle(eSec, "Fullbright", function() return State.fullbright end, toggleFB)
end

-- MOVEMENT → PLAYER
local movePage = Pages.movement and Pages.movement.page
if movePage then
    local pSec = makeSection(movePage, "Player")
    makeToggle(pSec, "Fly", function() return State.fly end, toggleFly)
    makeSlider(pSec, "Fly Speed", 10, 300, 60, function(v) State.flySpeed = v end, " spd")
    makeToggle(pSec, "Noclip", function() return State.noclip end, function(v) State.noclip = v end)
    makeToggle(pSec, "Infinite Jump", function() return State.infjump end, function(v) State.infjump = v end)
    makeToggle(pSec, "Speed", function() return State.speedOn end, function(v) State.speedOn = v end)
    makeSlider(pSec, "Speed Value", 16, 200, 16, function(v) State.speedValue = v end, "")
end

-- MISC → MISC
local miscPage = Pages.misc and Pages.misc.page
if miscPage then
    local mSec = makeSection(miscPage, "Misc")
    makeToggle(mSec, "Anti-AFK", function() return State.antiAfk end, function(v) State.antiAfk = v end)
end

print("[MM2] Функционал загружен.")
