--[[
    MM2 Cheat  •  ProjectReal Edition
    Полная версия: ESP, Chams, Silent Aim, Kill Aura, Fake Position
    Для ProjectReal / Real / Wave / Volt (sUNC 100%)
    
    Инструкция:
        1. Запусти ProjectReal
        2. Инжект в Roblox
        3. Вставь этот скрипт
        4. RightShift — открыть/закрыть меню
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
local Stats             = game:GetService("Stats")

local LP = Players.LocalPlayer

--============================================================
-- GET PARENT (для ПК все API есть, но fallback оставим)
--============================================================
local function get_parent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return CoreGui end)
    if ok and cg then return cg end
    return LP:FindFirstChildOfClass("PlayerGui")
end

--============================================================
-- STATE
--============================================================
local State = {
    -- ESP
    esp = false,
    espName = true,
    espRole = true,
    espDist = true,
    espBox = true,
    
    -- Chams
    chams = false,
    chamsMode = "Highlight",  -- Highlight / Material
    
    -- Combat
    silentAim = false,
    silentFov = 200,
    silentPrediction = true,
    killAura = false,
    killAuraRange = 15,
    autoShoot = false,
    
    -- Movement
    fly = false,
    flySpeed = 60,
    noclip = false,
    infJump = false,
    speed = 16,
    speedEnabled = false,
    
    -- Misc
    antiAfk = false,
    fullbright = false,
    fakePos = false,
    fakePosRange = 9e7,
}

local espData = {}
local chamsCache = {}
local fakePosData = {
    active = false,
    realCF = nil,
    fakePos = nil,
    originalFPDH = nil,
    conns = {},
}

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
    highlight.Parent = get_parent()

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MM2ESPBB"
    billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
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
                    data.highlight.FillTransparency = State.espBox and 0.6 or 1
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
-- CHAMS
--============================================================
local function applyChamsHighlight(player)
    -- уже делается через ESP highlight
    if not espData[player] then createESP(player) end
end

local function applyChamsMaterial(player)
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

local function restoreChamsMaterial(player)
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
            if State.chamsMode == "Highlight" then
                applyChamsHighlight(player)
            else
                applyChamsMaterial(player)
            end
        end
    end
end

local function toggleChams(v)
    State.chams = v
    if not v then
        for _, player in ipairs(Players:GetPlayers()) do
            restoreChamsMaterial(player)
        end
        chamsCache = {}
    end
end

--============================================================
-- SILENT AIM (работает на ProjectReal!)
--============================================================
local silentFov = State.silentFov

local function getClosestTarget()
    local mouse = UserInputService:GetMouseLocation()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local closest, closestDist = nil, silentFov

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local pos = hrp.Position
        if State.silentPrediction then
            local vel = hrp.AssemblyLinearVelocity
            local ping = LP:GetNetworkPing() or 0
            pos = pos + vel * ping
        end

        local screenPos, onScreen = cam:WorldToViewportPoint(pos)
        if not onScreen then continue end

        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = hrp
        end
    end
    return closest
end

-- Хук WeaponService
local weaponService = nil
local hookedMouse = false
local hookedTarget = false
local originalGetMouse = nil
local originalGetTarget = nil

local function installSilentHooks()
    if hookedMouse and hookedTarget then return end
    
    local ok, svc = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"))
    end)
    if not ok or not svc then return end
    weaponService = svc

    if not hookedMouse and type(svc.GetMouseTargetCFrame) == "function" then
        originalGetMouse = svc.GetMouseTargetCFrame
        local hook = newcclosure(function(self, ...)
            if State.silentAim and not checkcaller() then
                local target = getClosestTarget()
                if target then
                    return CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
                end
            end
            return originalGetMouse(self, ...)
        end)
        pcall(function() setreadonly(svc, false) end)
        pcall(function() svc.GetMouseTargetCFrame = hook end)
        hookedMouse = true
    end

    if not hookedTarget and type(svc.GetTargetPosition) == "function" then
        originalGetTarget = svc.GetTargetPosition
        local hook = newcclosure(function(self, x, y, ...)
            if State.silentAim and not checkcaller() then
                local target = getClosestTarget()
                if target then
                    return target.Position
                end
            end
            return originalGetTarget(self, x, y, ...)
        end)
        pcall(function() setreadonly(svc, false) end)
        pcall(function() svc.GetTargetPosition = hook end)
        hookedTarget = true
    end
end

local function uninstallSilentHooks()
    if weaponService then
        pcall(function() setreadonly(weaponService, false) end)
        if originalGetMouse then
            pcall(function() weaponService.GetMouseTargetCFrame = originalGetMouse end)
        end
        if originalGetTarget then
            pcall(function() weaponService.GetTargetPosition = originalGetTarget end)
        end
    end
    hookedMouse = false
    hookedTarget = false
end

task.spawn(function()
    while true do
        task.wait(1)
        if State.silentAim then
            pcall(installSilentHooks)
        end
    end
end)

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
            if root and (root.Position - myRoot.Position).Magnitude <= State.killAuraRange then
                pcall(function()
                    stabbed:FireServer()
                    touched:FireServer(root)
                end)
            end
        end
    end
end

--============================================================
-- AUTO SHOOT (стреляет в murderer если ты шериф)
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
                    local origin = myRoot.CFrame
                    local aim = CFrame.new(origin.Position, root.Position)
                    pcall(function()
                        shoot:FireServer(origin, aim)
                    end)
                    return
                end
            end
        end
    end
end

--============================================================
-- FLY
--============================================================
local flyVelocity, flyGyro

local function startFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    flyGyro.P = 9000
    flyGyro.Parent = hrp

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(4e5, 4e5, 4e5)
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

    if move.Magnitude > 0 then move = move.Unit * State.flySpeed end
    flyVelocity.Velocity = move
end

local function toggleFly(v)
    St
