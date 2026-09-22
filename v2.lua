-- =======================================================
-- FLONSET PREMIUM MM2 HUB FOR XENO (ORION PC UI)
-- =======================================================
print("[XENO-FLONSET] Инициализация ПК-интерфейса Orion...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Переменные для функций чита
local speedEnabled = false
local speedValue = 32
local espEnabled = false
local grabEnabled = false
local shootMurdererEnabled = false

local activeEsp = {}

-- Загружаем проверенную и стабильную Orion Library (ПК зеркало)
local OrionLib = loadstring(game:HttpGet('https://githubusercontent.com'))()

-- Создаем главное окно чита
local Window = OrionLib:MakeWindow({
    Name = "FLONSET PREMIUM V2 (MM2)", 
    HidePremium = true, 
    SaveConfig = false, 
    ConfigFolder = "FlonsetConfig"
})

-- =======================================================
-- ВКЛАДКА 1: VISUALS (Профессиональное 2D-Box ESP через Drawing)
-- =======================================================
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local function removeEsp(player)
    if activeEsp[player] then
        pcall(function()
            activeEsp[player].Box.Visible = false
            activeEsp[player].Box:Remove()
            activeEsp[player].Text.Visible = false
            activeEsp[player].Text:Remove()
        end)
        activeEsp[player] = nil
    end
end

local function createEsp(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 1.8
    box.Filled = false
    box.Transparency = 1
    
    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Transparency = 1
    
    activeEsp[player] = {Box = box, Text = text}
    
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not espEnabled or not player.Parent or not player.Character then
            removeEsp(player)
            if connection then connection:Disconnect() end
            return
        end
        
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local scale = 1 / (pos.Z * math.tan(math.rad(Camera.FieldOfView / 2))) * 1000
                local boxX = scale * 0.5
                local boxY = scale * 0.7
                
                local knife = char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
                local gun = char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
                
                local color = Color3.fromRGB(50, 255, 100)
                local roleText = player.DisplayName
                
                if knife then
                    color = Color3.fromRGB(255, 50, 50)
                    roleText = "[MURDERER] " .. player.DisplayName
                elseif gun then
                    color = Color3.fromRGB(50, 150, 255)
                    roleText = "[SHERIFF] " .. player.DisplayName
                end
                
                box.Size = Vector2.new(boxX, boxY)
                box.Position = Vector2.new(pos.X - boxX/2, pos.Y - boxY/2)
                box.Color = color
                box.Visible = true
                
                text.Position = Vector2.new(pos.X, pos.Y - boxY/2 - 15)
                text.Text = roleText
                text.Color = color
                text.Visible = true
                return
            end
        end
        box.Visible = false
        text.Visible = false
    end)
end

VisualsTab:AddToggle({
    Name = "2D Box ESP (Drawing API)",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, p in ipairs(Players:GetPlayers()) do createEsp(p) end
        else
            for p, _ in pairs(activeEsp) do removeEsp(p) end
            table.clear(activeEsp)
        end
    end
})

Players.PlayerAdded:Connect(function(p)
    if espEnabled then createEsp(p) end
end)

-- =======================================================
-- ВКЛАДКА 2: MOVEMENT (Скорость бега и Автоподбор)
-- =======================================================
local MovementTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483362618",
    PremiumOnly = false
})

MovementTab:AddToggle({
    Name = "Enable Speed Hack",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
    end
})

MovementTab:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 32,
    Color = Color3.fromRGB(0, 150, 100),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        speedValue = Value
    end
})

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = speedEnabled and speedValue or 16 end
        end)
    end
end)

MovementTab:AddToggle({
    Name = "Auto-Grab Dropped Gun",
    Default = false,
    Callback = function(Value)
        grabEnabled = Value
    end
})

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if grabEnabled then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local gunDrop = workspace:FindFirstChild("GunDrop")
                if gunDrop and hrp then
                    local distance = (hrp.Position - gunDrop.Position).Magnitude
                    local duration = distance / 45
                    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(gunDrop, tweenInfo, {CFrame = hrp.CFrame})
                    tween:Play()
                end
            end
        end)
    end
end)

-- =======================================================
-- ВКЛАДКА 3: TARGET (Авто-выстрел в маньяка)
-- =======================================================
local TargetTab = Window:MakeTab({
    Name = "Target",
    Icon = "rbxassetid://4483364237",
    PremiumOnly = false
})

local function findMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local knife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if knife and hum and hum.Health > 0 then return player end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if shootMurdererEnabled then
                local char = LocalPlayer.Character
                local gun = char and char:FindFirstChild("Gun")
                if gun and gun:FindFirstChild("Shoot") and gun.Shoot:IsA("RemoteEvent") then
                    local m = findMurderer()
                    if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = m.Character.HumanoidRootPart
                        local myHrp = char:FindFirstChild("HumanoidRootPart")
                        if myHrp and targetHrp then
                            gun.Shoot:FireServer(myHrp.CFrame, CFrame.new(targetHrp.Position))
                            task.wait(1)
                        end
                    end
                end
            end
        end)
    end
end)

TargetTab:AddToggle({
    Name = "Shoot Murderer (Auto-Aim)",
    Default = false,
    Callback = function(Value)
        shootMurdererEnabled = Value
    end
})

-- =======================================================
-- ВКЛАДКА 4: CONFIG (Управление читом)
-- =======================================================
local ConfigTab = Window:MakeTab({
    Name = "Config",
    Icon = "rbxassetid://4483362748",
    PremiumOnly = false
})

ConfigTab:AddButton({
    Name = "Close / Unload Script",
    Callback = function()
        speedEnabled = false espEnabled = false grabEnabled = false shootMurdererEnabled = false
        for p, _ in pairs(activeEsp) do removeEsp(p) end
        table.clear(activeEsp)
        OrionLib:Destroy()
    end
})

-- Финальный запуск интерфейса
OrionLib:Init()
