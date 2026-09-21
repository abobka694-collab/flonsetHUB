-- =======================================================
-- FLONSET PREMIUM MM2 — MOBILE FIX TEMPLATE (F LOGO)
-- =======================================================
print("[FLONSET-GUI] Отрисовка ультра-стабильного интерфейса...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- 1. КОНТЕЙНЕР ИНТЕРФЕЙСА
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetShitaroGui"
ScreenGui.ResetOnSpawn = false

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- 2. ГЛАВНОЕ ОКНО ЧИТА (Серый квадрат)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 200) -- Немного уменьшили размер, чтобы всё было компактно
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 3. БОКОВАЯ СТИЛЬНАЯ ПАНЕЛЬ (Sidebar) — Прописана вручную
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 75, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = SideBar

-- Ограничитель скругления
local SideHide = Instance.new("Frame")
SideHide.Size = UDim2.new(0, 15, 1, 0)
SideHide.Position = UDim2.new(1, -15, 0, 0)
SideHide.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
SideHide.BorderSizePixel = 0
SideHide.Parent = SideBar

-- ЛОГОТИП: Буква "F"
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 45)
Logo.Text = "F"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 28
Logo.BackgroundTransparency = 1
Logo.Parent = SideBar

-- 4. ПАНЕЛЬ ДЛЯ КОНТЕНТА (Вкладки)
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -85, 1, -10)
ContentPanel.Position = UDim2.new(0, 80, 0, 5)
ContentPanel.BackgroundTransparency = 1
ContentPanel.Parent = MainFrame

local tabs = {}
local tabButtons = {}

-- ФУНКЦИЯ СОЗДАНИЯ ВКЛАДОК (Без ломающихся ScrollingFrame)
local function CreateTab(tabName, shortName)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Visible = false
    TabContainer.Parent = ContentPanel
    
    tabs[tabName] = TabContainer
    
    -- Кнопки в сайдбаре
    local btnCount = #tabButtons
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.85, 0, 0, 24)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 50 + (btnCount * 28))
    TabBtn.Text = shortName
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 9
    TabBtn.TextColor3 = Color3.fromRGB(130, 130, 145)
    TabBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
    TabBtn.Parent = SideBar
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 5)
    BCorner.Parent = TabBtn
    
    table.insert(tabButtons, TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, container in pairs(tabs) do container.Visible = false end
        for _, btn in ipairs(tabButtons) do 
            btn.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
            btn.TextColor3 = Color3.fromRGB(130, 130, 145) 
        end
        TabContainer.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- ФУНКЦИЯ ДОБАВЛЕНИЯ ПЛИТОК (Вручную по координатам, без Grid)
local function AddCard(tabName, titleText, descText, index)
    local container = tabs[tabName]
    if not container then return end
    
    -- Вычисляем позицию X и Y для плиток вручную (всего 2 плитки на вкладку, встанут рядом)
    local posX = (index == 1) and 5 or 120
    
    local Card = Instance.new("TextButton")
    Card.Size = UDim2.new(0, 105, 0, 95)
    Card.Position = UDim2.new(0, posX, 0, 40)
    Card.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Card.BorderSizePixel = 0
    Card.Text = ""
    Card.Parent = container
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    -- Мини-картинка внутри плитки
    local ImgBox = Instance.new("Frame")
    ImgBox.Size = UDim2.new(1, -12, 0, 50)
    ImgBox.Position = UDim2.new(0, 6, 0, 6)
    ImgBox.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
    ImgBox.BorderSizePixel = 0
    ImgBox.Parent = Card
    
    local ImgCorner = Instance.new("UICorner")
    ImgCorner.CornerRadius = UDim.new(0, 6)
    ImgCorner.Parent = ImgBox
    
    local InnerText = Instance.new("TextLabel")
    InnerText.Size = UDim2.new(1, 0, 1, 0)
    InnerText.Text = "FLON"
    InnerText.Font = Enum.Font.GothamBold
    InnerText.TextSize = 14
    InnerText.TextColor3 = Color3.fromRGB(65, 65, 85)
    InnerText.BackgroundTransparency = 1
    InnerText.Parent = ImgBox
    
    -- Имя функции
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -12, 0, 18)
    Title.Position = UDim2.new(0, 6, 0, 60)
    Title.Text = titleText
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 10
    Title.TextColor3 = Color3.fromRGB(220, 220, 230)
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.BackgroundTransparency = 1
    Title.Parent = Card
    
    -- Статус
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -12, 0, 12)
    Status.Position = UDim2.new(0, 6, 0, 76)
    Status.Text = descText .. ": OFF"
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 8
    Status.TextColor3 = Color3.fromRGB(120, 120, 140)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.BackgroundTransparency = 1
    Status.Parent = Card
    
    local enabled = false
    Card.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Status.Text = descText .. ": ON"
            Status.TextColor3 = Color3.fromRGB(0, 200, 120)
            Card.BackgroundColor3 = Color3.fromRGB(34, 46, 42)
        else
            Status.Text = descText .. ": OFF"
            Status.TextColor3 = Color3.fromRGB(120, 120, 140)
            Card.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        end
    end)
end

-- =======================================================
-- ГЕНЕРАЦИЯ ВКЛАДОК (Ультра-короткие имена для кнопок)
-- =======================================================
CreateTab("Visuals", "VISUAL")
CreateTab("Movement", "MOVE")
CreateTab("Target", "TARGET")
CreateTab("Config", "CONFIG")

-- Открытие первой вкладки
if tabs["Visuals"] and tabButtons[1] then
    tabs["Visuals"].Visible = true
    tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Добавление плиток строго по индексам 1 и 2
AddCard("Visuals", "Neon Chams", "ESP", 1)
AddCard("Visuals", "Player Box", "ESP", 2)

AddCard("Movement", "Speed Hack", "Speed", 1)
AddCard("Movement", "Auto-Grab", "Grab", 2)

AddCard("Target", "Kill Aura", "Aura", 1)
AddCard("Target", "Fling Player", "Fling", 2)

-- Кнопка закрытия в разделе CONFIG
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(0, 105, 0, 32)
UnloadBtn.Position = UDim2.new(0, 5, 0, 40)
UnloadBtn.Text = "Close Script"
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.TextSize = 11
UnloadBtn.BackgroundColor3 = Color3.fromRGB(130, 40, 40)
UnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadBtn.Parent = tabs["Config"]

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 6)
UnloadCorner.Parent = UnloadBtn

UnloadBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =======================================================
-- ПЛАВАЮЩАЯ КРУГЛАЯ КНОПКА "F"
-- =======================================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "F"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
    end
end)

print("[FLONSET-GUI] Код полностью адаптирован под рендеринг Arceus!")
