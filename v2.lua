print("[FLONSET-MAIN] Запуск обычного чит-меню...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Удаляем старое меню, если оно уже висело на экране, чтобы кнопки не дублировались
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FlonsetMainGui") then
    LocalPlayer.PlayerGui.FlonsetMainGui:Destroy()
end

-- Создаем графический контейнер
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetMainGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 1. ГЛАВНОЕ ОКНО ЧИТА (Обычный серый квадрат)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Появится аккуратно в левой части экрана
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(50, 50, 60)
Frame.Active = true
Frame.Draggable = true -- Меню можно спокойно перетаскивать мышкой или пальцем
Frame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FLONSET MM2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = Frame

-- 2. КНОПКА 1: WALKSPEED (СКОРОСТЬ)
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 45)
SpeedButton.Text = "WalkSpeed: OFF"
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextSize = 11
SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Parent = Frame

local speedEnabled = false
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "WalkSpeed: ON (32)"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100) -- Зеленый при включении
    else
        SpeedButton.Text = "WalkSpeed: OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    end
end)

-- Фоновый цикл удержания скорости (WalkSpeed)
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speedEnabled and 32 or 16
        end
    end)
end)

-- 3. КНОПКА 2: ROLE ESP (ВХ СКВОЗЬ СТЕНЫ)
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0.9, 0, 0, 35)
EspButton.Position = UDim2.new(0.05, 0, 0, 90)
EspButton.Text = "Role ESP: OFF"
EspButton.Font = Enum.Font.GothamBold
EspButton.TextSize = 11
EspButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Parent = Frame

local espEnabled = false
local currentActiveGuis = {}

-- Функция создания меток над головами игроков, видимых сквозь стены
local function applyMobileESP(player)
    if player == LocalPlayer then return end
    
    local function onCharAdded(char)
        task.wait(0.5)
        if not espEnabled then return end
        
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        if currentActiveGuis[player] then
            pcall(function() currentActiveGuis[player]:Destroy() end)
        end
        
        -- Вшиваем текстовый маркер прямо в голову персонажа в Workspace — это работает везде
        local bGui = Instance.new("BillboardGui")
        bGui.Name = "Flonset_WallHack"
        bGui.Size = UDim2.new(0, 120, 0, 30)
        bGui.AlwaysOnTop = true -- Самая важная строчка: делает текст видимым сквозь любые стены
        bGui.ExtentsOffset = Vector3.new(0, 3, 0)
        bGui.Adornee = head
        bGui.Parent = head
        
        currentActiveGuis[player] = bGui
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.TextStrokeTransparency = 0.2 -- Черная обводка текста, чтобы было видно на любом фоне
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Parent = bGui
        
        task.spawn(function()
            while char and char.Parent and espEnabled and head.Parent do
                local knife = char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
                local gun = char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
                
                if knife then
                    textLabel.Text = "[MURDERER] " .. player.DisplayName
                    textLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- Красный Убийца
                elseif gun then
                    textLabel.Text = "[SHERIFF] " .. player.DisplayName
                    textLabel.TextColor3 = Color3.fromRGB(50, 150, 255) -- Синий Шериф
                else
                    textLabel.Text = "[INNOCENT] " .. player.DisplayName
                    textLabel.TextColor3 = Color3.fromRGB(50, 255, 100) -- Зеленый Мирный
                end
                task.wait(1)
            end
            if bGui then bGui:Destroy() end
            currentActiveGuis[player] = nil
        end)
    end
    
    if player.Character then task.spawn(onCharAdded, player.Character) end
    player.CharacterAdded:Connect(onCharAdded)
end

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspButton.Text = "Role ESP: ON"
        EspButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        for _, p in ipairs(Players:GetPlayers()) do applyMobileESP(p) end
    else
        EspButton.Text = "Role ESP: OFF"
        EspButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        for _, bg in pairs(currentActiveGuis) do pcall(function() bg:Destroy() end) end
        table.clear(currentActiveGuis)
    end
end)

-- Отслеживание новых заходящих на сервер игроков
Players.PlayerAdded:Connect(function(p)
    if espEnabled then applyMobileESP(p) end
end)
