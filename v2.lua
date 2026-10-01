-- Чекпоинт-скрипт с GUI для executor
-- R - сохранить | E - телепорт | V - удалить | RightShift - показать/скрыть меню

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local savedCFrame = nil

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0, 20, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- можно перетаскивать
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
title.BackgroundTransparency = 0.3
title.BorderSizePixel = 0
title.Text = "📍 Checkpoint"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Статус (сохранён чекпоинт или нет)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Статус: не сохранён"
statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Функция создания кнопки
local function makeButton(text, yPos, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = mainFrame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Обновление статуса
local function updateStatus()
	if savedCFrame then
		statusLabel.Text = "Статус: ✅ сохранён"
		statusLabel.TextColor3 = Color3.fromRGB(90, 255, 120)
	else
		statusLabel.Text = "Статус: ❌ не сохранён"
		statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
	end
end

------------------------------------------------------------
-- Логика чекпоинтов
------------------------------------------------------------
local function getHRP()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		return char.HumanoidRootPart
	end
	return nil
end

local function saveCheckpoint()
	local hrp = getHRP()
	if not hrp then return end
	savedCFrame = hrp.CFrame
	updateStatus()
	print("✅ Чекпоинт сохранён!")
end

local function loadCheckpoint()
	if not savedCFrame then
		print("❌ Сначала сохрани чекпоинт!")
		return
	end
	local hrp = getHRP()
	if not hrp then return end
	hrp.CFrame = savedCFrame
	print("🚀 Телепорт к чекпоинту!")
end

local function deleteCheckpoint()
	savedCFrame = nil
	updateStatus()
	print("🗑️ Чекпоинт удалён!")
end

-- Кнопки
makeButton("💾  Сохранить (R)", 80, Color3.fromRGB(40, 140, 70), saveCheckpoint)
makeButton("🚀  Телепорт (E)", 128, Color3.fromRGB(40, 90, 170), loadCheckpoint)
makeButton("🗑️  Удалить (V)", 176, Color3.fromRGB(170, 50, 50), deleteCheckpoint)

-- Подсказка
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -20, 0, 25)
hint.Position = UDim2.new(0, 10, 0, 224)
hint.BackgroundTransparency = 1
hint.Text = "RightShift — скрыть/показать"
hint.TextColor3 = Color3.fromRGB(150, 150, 150)
hint.Font = Enum.Font.Gotham
hint.TextSize = 11
hint.Parent = mainFrame

updateStatus()

------------------------------------------------------------
-- Горячие клавиши
------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.R then
		saveCheckpoint()
	elseif input.KeyCode == Enum.KeyCode.E then
		loadCheckpoint()
	elseif input.KeyCode == Enum.KeyCode.V then
		deleteCheckpoint()
	elseif input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

print("📌 Чекпоинт-скрипт с GUI загружен.")
print("R - сохранить | E - телепорт | V - удалить | RightShift - меню")
