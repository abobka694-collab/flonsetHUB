print("[FLONSET-SIMPLE] Отрисовка супер-простого интерфейса...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Изолируем контейнер от старого кэша
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FlonsetUltraSimpleGui") then
    LocalPlayer.PlayerGui.FlonsetUltraSimpleGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetUltraSimpleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Компактная темно-матовая панель
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Появится в левой части экрана
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- Можно перетаскивать мышкой по экрану ПК
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

-- Аккуратный заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "  FLONSET MINI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- КНОПКА 1: WALKSPEED
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 45)
SpeedButton.Text = "WalkSpeed: OFF"
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextSize = 11
SpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Parent = Frame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedButton

local speedEnabled = false
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "WalkSpeed: ON (32)"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    else
        SpeedButton.Text = "WalkSpeed: OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- КНОПКА 2: ESP
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0.9, 0, 0, 35)
EspButton.Position = UDim2.new(0.05, 0, 0, 90)
EspButton.Text = "Role ESP: OFF"
EspButton.Font = Enum.Font.GothamBold
EspButton.TextSize = 11
EspButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Parent = Frame

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 6)
EspCorner.Parent = EspButton

local espEnabled = false
EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspButton.Text = "Role ESP: ON"
        EspButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    else
        EspButton.Text = "Role ESP: OFF"
        EspButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

print("[FLONSET-SIMPLE] Сверхлёгкий интерфейс успешно создан в PlayerGui.")
