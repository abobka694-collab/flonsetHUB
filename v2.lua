--[[
    MM2 Cheat  •  KITI-style GUI
    Работает на: ProjectReal, Xeno, Solara, Wave, Real
    RightShift — открыть/закрыть меню
]]

--============================================================
-- SERVICES
--============================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")
local LP = Players.LocalPlayer

--============================================================
-- GET PARENT (с fallback — работает везде)
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
-- STATE
--============================================================
local State = {
    -- Visuals
    esp = false,
    espName = true,
    espRole = true,
    espDist = true,
    chams = false,
    
    -- Combat
    killaura = false,
    killauraRange = 15,
    autoShoot = false,
    
    -- Movement
    fly = false,
    flySpeed = 60,
    noclip = false,
    infjump = false,
    speed = 16,
    speedOn = false,
    
    -- Misc
    fullbright = false,
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

    local highlight = Instance.new("Highlight")
    highlight.Name = "MM2ESP"
    highlight.Adornee = char
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = getParent()

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MM2ESPBB"
    billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = getParent()

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.Parent = billboard

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "Role"
    roleLabel.Size = UDim2.new(1, 0, 0, 14)
    roleLabel.Position = UDim2.new(0, 0, 0, 16)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = ""
    roleLabel.TextStrokeTransparency = 0
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextSize = 11
    roleLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Distance"
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 0, 30)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 10
    distLabel.Parent = billboard

    espData[player] = {
        highlight = highlight,
        billboard = billboard,
        nameLabel = nameLabel,
        roleLabel = roleLabel,
        distLabel = distLabel,
    }
end

local function removeESP(player)
    local data = espData[player]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.billboard then pcall(function() data.billboard:Destroy() end) end
    espData[player] = nil
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if not espData[player] then createESP(player) end
            local data = espData[player]
            if data then
                local role = getRole(player)
                local color = getRoleColor(role)
                if data.highlight then
                    data.highlight.Adornee = char
                    data.highlight.FillColor = color
                    data.highlight.OutlineColor = color
                    data.highlight.FillTransparency = 0.6
                end
                if data.billboard then
                    data.billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                end
                if data.nameLabel then
                    data.nameLabel.Text = State.espName and player.Name or ""
                    data.nameLabel.Visible = State.espName
                end
                if data.roleLabel then
                    data.roleLabel.Text = State.espRole and ("[" .. role .. "]") or ""
                    data.roleLabel.TextColor3 = color
                    data.roleLabel.Visible = State.espRole
                end
                if data.distLabel then
                    local myChar = LP.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local targetRoot = char:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot and State.espDist then
                        local dist = (myRoot.Position - targetRoot.Position).Magnitude
                        data.distLabel.Text = string.format("%.0fm", dist)
                        data.distLabel.Visible = true
                    else
                        data.distLabel.Visible = false
                    end
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
-- CHAMS (Material)
--============================================================
local function applyChams(player)
    if player == LP then return end
    local char = player.Character
    if not char then return end
    local role = getRole(player)
    local color = getRoleColor(role)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not chamsCache[part] then
                chamsCache[part] = { mat = part.Material, col = part.Color }
            end
            part.Material = Enum.Material.ForceField
            part.Color = color
        end
    end
end

local function restoreChams(player)
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local cache = chamsCache[part]
            if cache then
                pcall(function()
                    part.Material = cache.mat
                    part.Color = cache.col
                end)
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
-- AUTO SHOOT (простой, без хуков)
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
    if hum and hum.WalkSpeed ~= State.speed then
        hum.WalkSpeed = State.speed
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
local VirtualUser = game:GetService("VirtualUser")
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
local lastESP = 0
local lastKA = 0
local lastAS = 0

RunService.Heartbeat:Connect(function()
    local now = tick()
    if State.esp and now - lastESP > 0.3 then
        lastESP = now
        pcall(updateESP)
    end
    if State.chams then pcall(updateChams) end
    if State.killaura and now - lastKA > 0.1 then
        lastKA = now
        pcall(doKillAura)
    end
    if State.autoShoot and now - lastAS > 0.15 then
        lastAS = now
        pcall(doAutoShoot)
    end
    pcall(updateFly)
    pcall(updateNoclip)
    pcall(updateSpeed)
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.fly then startFly() end
end)

--============================================================
-- THEME
--============================================================
local Theme = {
    bg = Color3.fromRGB(18, 16, 14),
    card = Color3.fromRGB(26, 24, 22),
    cardHover = Color3.fromRGB(32, 30, 28),
    header = Color3.fromRGB(14, 12, 11),
    sidebar = Color3.fromRGB(12, 10, 9),
    accent = Color3.fromRGB(168, 85, 247),
    text = Color3.fromRGB(240, 240, 245),
    textDim = Color3.fromRGB(140, 135, 130),
    off = Color3.fromRGB(55, 52, 50),
    outline = Color3.fromRGB(40, 38, 35),
}

local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = r or UDim.new(0, 6) }, p)
end

local function tween(i, t, p)
    TweenService:Create(i, TweenInfo.new(t or 0.15), p):Play()
end

--============================================================
-- ROOT GUI
--============================================================
local Root = new("ScreenGui", {
    Name = "MM2_" .. math.random(100000, 999999),
    ResetOnSpawn = false,
    IgnoreGuiInset = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 10,
}, getParent())

--============================================================
-- WINDOW
--============================================================
local W = new("Frame", {
    Size = UDim2.new(0, 700, 0, 440),
    Position = UDim2.new(0.5, -350, 0.5, -220),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    Active = true,
    Visible = true,
    ClipsDescendants = true,
}, Root)
corner(W, UDim.new(0, 10))
new("UIStroke", { Color = Theme.outline, Thickness = 1 }, W)

-- HEADER
local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.header,
    BorderSizePixel = 0,
    Active = true,
}, W)
corner(Header, UDim.new(0, 10))
new("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Theme.header,
    BorderSizePixel = 0,
}, Header)

local Logo = new("Frame", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 12, 0.5, -15),
    BackgroundColor3 = Theme.accent,
    BorderSizePixel = 0,
}, Header)
corner(Logo, UDim.new(0, 8))
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
}, Logo)

new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 18),
    Position = UDim2.new(0, 52, 0, 4),
    BackgroundTransparency = 1,
    Text = "MM2",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 12),
    Position = UDim2.new(0, 52, 0, 22),
    BackgroundTransparency = 1,
    Text = "Murder Mystery 2",
    TextColor3 = Theme.textDim,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local CloseB = new("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -34, 0.5, -13),
    BackgroundColor3 = Theme.card,
    Text = "X",
    TextColor3 = Theme.textDim,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
}, Header)
corner(CloseB, UDim.new(0, 6))

-- SIDEBAR
local Sidebar = new("Frame", {
    Size = UDim2.new(0, 60, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Theme.sidebar,
    BorderSizePixel = 0,
}, W)
new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Sidebar)
new("UIPadding", { PaddingTop = UDim.new(0, 12) }, Sidebar)

-- CONTENT
local Content = new("Frame", {
    Size = UDim2.new(1, -60, 1, -40),
    Position = UDim2.new(0, 60, 0, 40),
    BackgroundColor3 = Theme.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, W)

-- WATERMARK
local Watermark = new("Frame", {
    Size = UDim2.new(0, 200, 0, 22),
    Position = UDim2.new(0, 60, 1, -26),
    BackgroundColor3 = Theme.card,
    BorderSizePixel = 0,
}, W)
corner(Watermark, UDim.new(0, 6))
local WMText = new("TextLabel", {
    Size = UDim2.new(1, -12, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "MM2  •  0 fps  •  0 ms",
    TextColor3 = Theme.accent,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Watermark)

--============================================================
-- TAB SYSTEM
--============================================================
local Tabs = {}
local ActiveTab, ActiveBtn = nil, nil

local function makeTab(icon, name)
    local btn = new("TextButton", {
        Size = UDim2.new(0, 42, 0, 42),
        BackgroundColor3 = Theme.sidebar,
        Text = icon,
        TextColor3 = Theme.textDim,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
    }, Sidebar)
    corner(btn, UDim.new(0, 8))

    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
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
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)

    local function select()
        if ActiveBtn then
            tween(ActiveBtn, 0.15, { BackgroundColor3 = Theme.sidebar, TextColor3 = Theme.textDim })
        end
        tween(btn, 0.15, { BackgroundColor3 = Theme.accent, TextColor3 = Color3.new(1,1,1) })
        ActiveBtn = btn
        ActiveTab = page
        for _, p in ipairs(Content:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = (p == page) end
        end
    end

    btn.MouseButton1Click:Connect(select)
    btn.Activated:Connect(select)

    if not ActiveTab then select() end

    return page
end

--============================================================
-- SECTION
--============================================================
local function makeSection(parent, title)
    local sec = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.card,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
    }, parent)
    corner(sec, UDim.new(0, 8))

    new("TextLabel", {
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = Theme.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, sec)

    local inner = new("Frame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 28),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
    }, sec)
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, inner)
    new("UIPadding", { PaddingBottom = UDim.new(0, 8) }, inner)

    return inner
end

--============================================================
-- TOGGLE
--============================================================
local function makeToggle(parent, name, getter, setter)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local state = getter()
    local sw = new("Frame", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -40, 0.5, -9),
        BackgroundColor3 = state and Theme.accent or Theme.off,
        BorderSizePixel = 0,
    }, row)
    corner(sw, UDim.new(1, 0))

    local kn = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
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
        tween(sw, 0.15, { BackgroundColor3 = state and Theme.accent or Theme.off })
        kn.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        setter(state)
    end

    btn.MouseButton1Click:Connect(doToggle)
    btn.Activated:Connect(doToggle)
end

--============================================================
-- SLIDER
--============================================================
local function makeSlider(parent, name, min, max, default, setter, suffix)
    suffix = suffix or ""
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Active = true,
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local valLbl = new("TextLabel", {
        Size = UDim2.new(0.3, -8, 0, 16),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default) .. suffix,
        TextColor3 = Theme.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)

    local barBg = new("Frame", {
        Size = UDim2.new(1, -8, 0, 6),
        Position = UDim2.new(0, 4, 0, 28),
        BackgroundColor3 = Theme.off,
        BorderSizePixel = 0,
        Active = true,
    }, row)
    corner(barBg, UDim.new(1, 0))

    local val = default
    local pct = (val - min) / (max - min)

    local barFill = new("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    }, barBg)
    corner(barFill, UDim.new(1, 0))

    local knob = new("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(pct, 0, 0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, barBg)
    corner(knob, UDim.new(1, 0))

    local dragging = false
    local function apply(input)
        local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        val = math.floor((min + (max - min) * rel) * 100) / 100
        barFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        knob.Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0)
        valLbl.Text = tostring(val) .. suffix
        setter(val)
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
-- ДОБАВЛЯЕМ ВСЁ
--============================================================

-- COMBAT
local combatPage = makeTab("⚔", "Combat")
local cSec1 = makeSection(combatPage, "Kill Aura")
makeToggle(cSec1, "Kill Aura", function() return State.killaura end, function(v) State.killaura = v end)
makeSlider(cSec1, "Range", 5, 50, 15, function(v) State.killauraRange = v end, " st")

local cSec2 = makeSection(combatPage, "Auto Shoot")
makeToggle(cSec2, "Auto Shoot (Sheriff)", function() return State.autoShoot end, function(v) State.autoShoot = v end)

-- VISUALS
local visualPage = makeTab("👁", "Visuals")
local vSec1 = makeSection(visualPage, "ESP")
makeToggle(vSec1, "ESP", function() return State.esp end, toggleESP)
makeToggle(vSec1, "Show Name", function() return State.espName end, function(v) State.espName = v end)
makeToggle(vSec1, "Show Role", function() return State.espRole end, function(v) State.espRole = v end)
makeToggle(vSec1, "Show Distance", function() return State.espDist end, function(v) State.espDist = v end)

local vSec2 = makeSection(visualPage, "Chams")
makeToggle(vSec2, "Chams (Material)", function() return State.chams end, toggleChams)

local vSec3 = makeSection(visualPage, "World")
makeToggle(vSec3, "Fullbright", function() return State.fullbright end, toggleFB)

-- MOVEMENT
local movePage = makeTab("🏃", "Move")
local mSec1 = makeSection(movePage, "Fly")
makeToggle(mSec1, "Fly", function() return State.fly end, toggleFly)
makeSlider(mSec1, "Fly Speed", 10, 300, 60, function(v) State.flySpeed = v end, " spd")

local mSec2 = makeSection(movePage, "Other")
makeToggle(mSec2, "Noclip", function() return State.noclip end, function(v) State.noclip = v end)
makeToggle(mSec2, "Infinite Jump", function() return State.infjump end, function(v) State.infjump = v end)
makeToggle(mSec2, "Speed", function() return State.speedOn end, function(v) State.speedOn = v end)
makeSlider(mSec2, "Speed Value", 16, 200, 16, function(v) State.speed = v end, "")

-- MISC
local miscPage = makeTab("⚙", "Misc")
local miSec = makeSection(miscPage, "Utilities")
makeToggle(miSec, "Anti-AFK", function() return State.antiAfk end, function(v) State.antiAfk = v end)

--============================================================
-- WATERMARK UPDATE
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
        W.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--============================================================
-- TOGGLE / CLOSE
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

print("[MM2] Загружено! RightShift — меню")
