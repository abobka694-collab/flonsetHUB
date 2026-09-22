print("[FLONSET-GUI] Rendering pure Shitaro V2 UI interface...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. НАДЁЖНЫЙ КОНТЕЙНЕР ДЛЯ ПК (БЕЗ COREGUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetShitaroGui"
ScreenGui.ResetOnSpawn = false
-- Принудительно вшиваем в PlayerGui — это 100% сработает на Xeno на ПК
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. ГЛАВНОЕ ОКНО ЧИТА (Матовый Тёмный Дизайн)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Позволяет плавно перетаскивать меню мышкой
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- 3. БОКОВАЯ ПАНЕЛЬ НАВИГАЦИИ (Sidebar)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 110, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

local SideHide = Instance.new("Frame")
SideHide.Size = UDim2.new(0, 20, 1, 0)
SideHide.Position = UDim2.new(1, -20, 0, 0)
SideHide.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SideHide.BorderSizePixel = 0
SideHide.Parent = SideBar

-- ЛОГОТИП: Буква "F" вверху панели
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "F"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.Accent
Logo.TextSize = 36
Logo.BackgroundTransparency = 1
Logo.Parent = SideBar

-- Контейнер для списка вкладок с прокруткой
local ButtonScroll = Instance.new("ScrollingFrame")
ButtonScroll.Size = UDim2.new(1, 0, 1, -70)
ButtonScroll.Position = UDim2.new(0, 0, 0, 65)
ButtonScroll.BackgroundTransparency = 1
ButtonScroll.BorderSizePixel = 0
ButtonScroll.ScrollBarThickness = 0
ButtonScroll.CanvasSize = UDim2.new(0, 0, 0, 250)
ButtonScroll.Parent = SideBar

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 4)
ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ScrollLayout.Parent = ButtonScroll

-- 4. ГЛАВНАЯ ПАНЕЛЬ ДЛЯ КОНТЕНТА (Где плитки)
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -125, 1, -20)
ContentPanel.Position = UDim2.new(0, 117, 0, 10)
ContentPanel.BackgroundTransparency = 1
ContentPanel.Parent = MainFrame

local tabs = {}
local tabButtons = {}

-- Функция автоматической сборки вкладок
local function CreateTab(tabName, iconText)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60)
    TabContainer.Visible = false
    TabContainer.Parent = ContentPanel
    
    local Grid = Instance.new("UIGridLayout")
    Grid.CellSize = UDim2.new(0, 105, 0, 95)
    Grid.CellPadding = UDim2.new(0, 10, 0, 10)
    Grid.SortOrder = Enum.SortOrder.LayoutOrder
    Grid.Parent = TabContainer
    
    tabs[tabName] = TabContainer
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 28)
    TabBtn.Text = "  " .. iconText .. "  " .. tabName
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 10
    TabBtn.TextColor3 = Color3.fromRGB(130, 130, 145)
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.BackgroundTransparency = 1
    TabBtn.Parent = ButtonScroll
    
    table.insert(tabButtons, TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, container in pairs(tabs) do container.Visible = false end
        for _, btn in ipairs(tabButtons) do btn.TextColor3 = Color3.fromRGB(130, 130, 145) end
        TabContainer.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Функция создания карточек-плиток
local function AddCard(tabName, titleText, descText)
    local container = tabs[tabName]
    if not container then return end
    
    local Card = Instance.new("TextButton")
    Card.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    Card.BorderSizePixel = 0
    Card.Text = ""
    Card.Parent = container
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local ImgBox = Instance.new("Frame")
    ImgBox.Size = UDim2.new(1, -12, 0, 50)
    ImgBox.Position = UDim2.new(0, 6, 0, 6)
    ImgBox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
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
    InnerText.TextColor3 = Color3.fromRGB(60, 60, 80)
    InnerText.BackgroundTransparency = 1
    InnerText.Parent = ImgBox
    
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
            Card.BackgroundColor3 = Color3.fromRGB(32, 42, 42)
        else
            Status.Text = descText .. ": OFF"
            Status.TextColor3 = Color3.fromRGB(120, 120, 140)
            Card.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
        end
    end)
end

-- =======================================================
-- СБОРКА ТВОИХ РАЗДЕЛОВ МЕНЮ
-- =======================================================
CreateTab("Visuals", "👁")
CreateTab("Movement", "⚡")
CreateTab("Target", "🎯")
CreateTab("Skins", "🎨")
CreateTab("Config", "⚙")

-- Открываем вкладку Visuals по умолчанию
if tabs["Visuals"] and tabButtons then
    tabs["Visuals"].Visible = true
    tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Расставляем плитки
AddCard("Visuals", "Neon Chams", "ESP")
AddCard("Visuals", "Player Box", "ESP")

AddCard("Movement", "Speed Hack", "Speed")
AddCard("Movement", "Auto-Grab", "Grab")

AddCard("Target", "Shoot Murderer", "Aim")
AddCard("Target", "Kill Aura", "Aura")
AddCard("Target", "Fling Targets", "Fling")

AddCard("Skins", "Knife Skin", "Weapon")
AddCard("Skins", "Gun Skin", "Weapon")

-- Кнопка закрытия
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

print("[FLONSET-GUI] Pure interface frames spawned successfully through PlayerGui.")
