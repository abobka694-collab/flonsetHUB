-- =======================================================
-- OFFICIAL FLONSET PREMIUM PC HUB FOR XENO (V2 FIXED)
-- =======================================================
print("[XENO-FLONSET] Инициализация кастомного интерфейса...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Переменные для функций чита
local speedEnabled = false
local speedValue = 32
local espEnabled = false
local grabEnabled = false
local shootMurdererEnabled = false

local activeEsp = {}

-- 1. КОНТЕЙНЕР ИНТЕРФЕЙСА (Пробиваем CoreGui на ПК)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetXenoPremiumGui"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- 2. ГЛАВНОЕ ОКНО ЧИТА (Дизайн со скриншота)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно двигать мышкой по экрану!
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 3. БОКОВАЯ СТИЛЬНАЯ ПАНЕЛЬ (Sidebar)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 85, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = SideBar

local SideHide = Instance.new("Frame")
SideHide.Size = UDim2.new(0, 15, 1, 0)
SideHide.Position = UDim2.new(1, -15, 0, 0)
SideHide.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SideHide.BorderSizePixel = 0
SideHide.Parent = SideBar

-- Твой логотип: Буква "F"
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 45)
Logo.Text = "F"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 32
Logo.BackgroundTransparency = 1
Logo.Parent = SideBar

-- 4. ПАНЕЛЬ ДЛЯ КОНТЕНТА ВКЛАДОК
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -95, 1, -10)
ContentPanel.Position = UDim2.new(0, 90, 0, 5)
ContentPanel.BackgroundTransparency = 1
ContentPanel.Parent = MainFrame

local tabs = {}
local tabButtons = {}

-- Функция создания вкладок
local function CreateTab(tabName)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Visible = false
    TabContainer.Parent = ContentPanel
    
    tabs[tabName] = TabContainer
    
    local btnCount = #tabButtons
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.85, 0, 0, 26)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 55 + (btnCount * 30))
    TabBtn.Text = tabName:upper()
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 9
    TabBtn.TextColor3 = Color3.fromRGB(130, 130, 145)
    TabBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    TabBtn.Parent = SideBar
    
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 5)
    BC.Parent = TabBtn
    
    table.insert(tabButtons, TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, container in pairs(tabs) do container.Visible = false end
        for _, btn in ipairs(tabButtons) do 
            btn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            btn.TextColor3 = Color3.fromRGB(130, 130, 145) 
        end
        TabContainer.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Функция добавления красивых интерактивных кнопок
local function AddToggleButton(tabName, text, yPos, callback)
    local container = tabs[tabName]
    if not container then return end
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 32)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.Text = text .. ": OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    Btn.Parent = container
    
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Btn
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Btn.Text = text .. ": ON"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Btn.Text = text .. ": OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        end
        callback(enabled)
    end)
end

-- =======================================================
-- ГЕНЕРАЦИЯ ВКЛАДОК ДЛЯ ПК МЕНЮ
-- =======================================================
CreateTab("Visuals")
CreateTab("Movement")
CreateTab("Target")
CreateTab("Config")

-- Открываем первую вкладку по умолчанию
if tabs["Visuals"] and tabButtons then
    tabs["Visuals"].Visible = true
    tabButtons.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    tabButtons.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- =======================================================
-- ВКЛАДКА 1: VISUALS (2D-Box ESP через Drawing API для Xeno)
-- =======================================================
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

AddToggleButton("Visuals", "2D Box ESP", 35, function(state)
    espEnabled = state
    if state then
        for _, p in ipairs(Players:GetPlayers()) do createEsp(p) end
    else
        for p, _ in pairs(activeEsp) do removeEsp(p) end
        table.clear(activeEsp)
    end
end)

Players.PlayerAdded:Connect(function(p) if espEnabled then createEsp(p) end end)

-- =======================================================
-- ВКЛАДКА 2: MOVEMENT (Скорость и Автоподбор пистолета)
-- =======================================================
AddToggleButton("Movement", "Speed Hack (32)", 35, function(state)
    speedEnabled = state
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = speedEnabled and 32 or 16 end
        end)
    end
end)

AddToggleButton("Movement", "Auto-Grab Gun", 75, function(state)
    grabEnabled = state
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if grabEnabled then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local gunDrop = workspace:FindFirstChild("GunDrop")
                if gunDrop and hrp then
