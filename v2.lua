--[[
    MM2 Simple Cheat  •  for Arceus X Neo
    Всё в одном файле, без обфускации
]]

--============================================================
-- SERVICES
--============================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")
local CoreGui           = game:GetService("CoreGui")

local LP = Players.LocalPlayer

--============================================================
-- PLATFORM
--============================================================
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

--============================================================
-- GET PARENT (с fallback для Arceus X)
--============================================================
local function get_parent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return CoreGui end)
    if ok and cg then return cg end
    local ok2, pg = pcall(function()
        return LP:FindFirstChildOfClass("PlayerGui")
    end)
    if ok2 and pg then return pg end
    return LP:FindFirstChildOfClass("PlayerGui")
end

--============================================================
-- STATE
--============================================================
local State = {
    esp = false,
    chams = false,
    killAura = false,
    autoShoot = false,
    fly = false,
    noclip = false,
    infJump = false,
    antiAfk = false,
    fullbright = false,
}

local espData = {}
local flyVelocity = nil
local flyGyro = nil
local originalLighting = {}
local connections = {}

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
    -- Fallback по оружию
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
    highlight.Name = "SimpleESP"
    highlight.Adornee = char
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = get_parent()

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SimpleESPBB"
    billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = get_parent()

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
                end
                if data.billboard then
                    data.billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                end
                if data.roleLabel then
                    data.roleLabel.Text = "[" .. role .. "]"
                    data.roleLabel.TextColor3 = color
                end
                if data.distLabel then
                    local myChar = LP.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local targetRoot = char:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot then
                        local dist = (myRoot.Position - targetRoot.Position).Magnitude
                        data.distLabel.Text = string.format("%.0fm", dist)
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
-- CHAMS
--============================================================
local chamsCache = {}

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
        if player ~= LP and player.Character then
            applyChams(player)
        end
    end
end

local function toggleChams(v)
    State.chams = v
    if not v then
        for _, player in ipairs(Players:GetPlayers()) do
            restoreChams(player)
        end
        chamsCache = {}
    end
end

--============================================================
-- KILL AURA (Knife)
--============================================================
local function getKnife()
    local char = LP.Character
    if char then
        local k = char:FindFirstChild("Knife")
        if k then return k end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        local k = bp:FindFirstChild("Knife")
        if k then return k end
    end
    return nil
end

local function equipKnife()
    local knife = getKnife()
    if not knife then return nil end
    if knife.Parent ~= LP.Character then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(knife) end) end
        return nil
    end
    return knife
end

local function doKillAura()
    if not State.killAura then return end
    local knife = equipKnife()
    if not knife then return end
    local events = knife:FindFirstChild("Events")
    if not events then return end
    local stabbed = events:FindFirstChild("KnifeStabbed")
    local touched = events:FindFirstChild("HandleTouched")
    if not stabbed or not touched then return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= 15 then
                pcall(function()
                    stabbed:FireServer()
                    touched:FireServer(root)
                end)
            end
        end
    end
end

--============================================================
-- AUTO SHOOT
--============================================================
local function getGun()
    local char = LP.Character
    if char then
        local g = char:FindFirstChild("Gun")
        if g then return g end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        local g = bp:FindFirstChild("Gun")
        if g then return g end
    end
    return nil
end

local function doAutoShoot()
    if not State.autoShoot then return end
    local gun = getGun()
    if not gun then return end
    local shoot = gun:FindFirstChild("Shoot")
    if not shoot or not shoot:IsA("RemoteEvent") then return end

    -- Ищем murderer
    local target = nil
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local role = getRole(player)
        if role == "Murderer" then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= 200 then
                    target = root
                    break
                end
            end
        end
    end

    if target then
        local origin = myRoot.CFrame
        local aim = CFrame.new(origin.Position, target.Position)
        pcall(function()
            shoot:FireServer(origin, aim)
        end)
    end
end

--============================================================
-- FLY
--============================================================
local function startFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    flyGyro.P = 9000
    flyGyro.Parent = hrp

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = hrp
end

local function stopFly()
    if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
end

local function updateFly()
    if not State.fly then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not flyVelocity or not flyGyro then startFly() return end

    local cam = workspace.CurrentCamera
    flyGyro.CFrame = cam.CFrame

    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.yAxis end

    if move.Magnitude > 0 then move = move.Unit * 60 end
    flyVelocity.Velocity = move
end

local function toggleFly(v)
    State.fly = v
    if v then startFly() else stopFly() end
end

--============================================================
-- NOCLIP
--============================================================
local function updateNoclip()
    if not State.noclip then return end
    local char = LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function toggleNoclip(v)
    State.noclip = v
    if not v then
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

--============================================================
-- INFINITE JUMP
--============================================================
local function doInfJump()
    if not State.infJump then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

--============================================================
-- ANTI-AFK
--============================================================
connections[#connections + 1] = LP.Idled:Connect(function()
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
    originalLighting.Brightness = Lighting.Brightness
    originalLighting.Ambient = Lighting.Ambient
    originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    originalLighting.GlobalShadows = Lighting.GlobalShadows
    originalLighting.ClockTime = Lighting.ClockTime
    originalLighting.FogEnd = Lighting.FogEnd
end

local function applyFullbright()
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
end

local function restoreLighting()
    if originalLighting.Brightness then
        Lighting.Brightness = originalLighting.Brightness
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
    end
end

local function toggleFullbright(v)
    State.fullbright = v
    if v then applyFullbright() else restoreLighting() end
end

saveLighting()

--============================================================
-- JUMP REQUEST (для Infinite Jump)
--============================================================
connections[#connections + 1] = UserInputService.JumpRequest:Connect(function()
    if State.infJump then
        doInfJump()
    end
end)

--============================================================
-- CHARACTER RESPAWN
--============================================================
connections[#connections + 1] = LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.fly then startFly() end
    if State.chams then updateChams() end
end)

--============================================================
-- MAIN LOOP
--============================================================
local lastKillAura = 0
local lastAutoShoot = 0
local lastESP = 0

RunService.Heartbeat:Connect(function()
    local now = tick()

    -- ESP (раз в 0.3 сек)
    if State.esp and now - lastESP > 0.3 then
        lastESP = now
        pcall(updateESP)
    end

    -- Chams (раз в 0.5 сек)
    if State.chams then
        pcall(updateChams)
    end

    -- Kill Aura (раз в 0.1 сек)
    if State.killAura and now - lastKillAura > 0.1 then
        lastKillAura = now
        pcall(doKillAura)
    end

    -- Auto Shoot (раз в 0.15 сек)
    if State.autoShoot and now - lastAutoShoot > 0.15 then
        lastAutoShoot = now
        pcall(doAutoShoot)
    end

    -- Fly / Noclip
    pcall(updateFly)
    pcall(updateNoclip)
end)

--============================================================
-- GUI
--============================================================
local Theme = {
    bg = Color3.fromRGB(18, 18, 20),
    card = Color3.fromRGB(26, 26, 30),
    accent = Color3.fromRGB(150, 100, 255),
    text = Color3.fromRGB(240, 240, 245),
    textDim = Color3.fromRGB(140, 140, 150),
    toggleOff = Color3.fromRGB(55, 55, 60),
    outline = Color3.fromRGB(40, 40, 45),
}

local function new(class, props, parent)
    local inst = Instance.new(class)
