-- Чекпоинт-скрипт с GUI для executor
-- R - сохранить | E - телепорт к последнему | V - удалить последний
-- LeftCtrl - телепорт к предыдущему чекпоинту | RightShift - показать/скрыть меню

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local checkpoints = {} -- стек чекпоинтов

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

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

-- Счётчик чекпоинтов
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Чекпоинтов: 0"
statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Функция создания кнопки
local function makeButton(text, yPos, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 36)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = mainFrame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function updateStatus()
	local count = #checkpoints
	if count == 0 then
		statusLabel.Text = "Чекпоинтов: 0"
		statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
	else
		statusLabel.Text = "Чекпоинтов: " .. count .. " (последний #" .. count .. ")"
		statusLabel.TextColor3 = Color3.fromRGB(90, 255, 120)
	end
end

------------------------------------------------------------
-- Логика
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
	table.insert(checkpoints, hrp.CFrame)
	updateStatus()
	print("✅ Чекпоинт #" .. #checkpoints .. " сохранён!")
end

local function loadCheckpoint()
	if #checkpoints == 0 then
		print("❌ Нет сохранённых чекпоинтов!")
		return
	end
	local hrp = getHRP()
	if not hrp then return end
	hrp.CFrame = checkpoints[#checkpoints]
	print("🚀 Телепорт к чекпоинту #" .. #checkpoints)
end

local function loadPrevious()
	if #checkpoints < 2 then
		print("❌ Нет предыдущего чекпоинта!")
		return
	end
	local hrp = getHRP()
	if not hrp then return end
	-- Удаляем последний и прыгаем к предыдущему
	table.remove(checkpoints)
	hrp.CFrame = checkpoints[#checkpoints]
	updateStatus()
	print("⬅️ Телепорт к чекпоинту #" .. #checkpoints)
end

local function deleteLast()
	if #checkpoints == 0 then
		print("❌ Нечего удалять!")
		return
	end
	table.remove(checkpoints)
	updateStatus()
	print("🗑️ Удалён последний чекпоинт. Осталось: " .. #checkpoints)
end

local function clearAll()
	checkpoints = {}
	updateStatus()
	print("🧹 Все чекпоинты очищены!")
end

-- Кнопки
makeButton("💾  Сохранить (F)", 80, Color3.fromRGB(40, 140, 70), saveCheckpoint)
makeButton("🚀  Телепорт (E)", 122, Color3.fromRGB(40, 90, 170), loadCheckpoint)
makeButton("⬅️  Предыдущий (Ctrl)", 164, Color3.fromRGB(130, 90, 40), loadPrevious)
makeButton("🗑️  Удалить последний (V)", 206, Color3.fromRGB(170, 50, 50), deleteLast)
makeButton("🧹  Очистить всё", 248, Color3.fromRGB(90, 40, 90), clearAll)

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
		deleteLast()
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		loadPrevious()
	elseif input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

print("📌 Чекпоинт-скрипт с GUI загружен.")
print("R - сохранить | E - телепорт | V - удалить последний | Ctrl - предыдущий | RightShift - меню")
