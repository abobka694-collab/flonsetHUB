-- ═══════════════════════════════════════════════════════════════
-- FLONSET HUB - GUI v2 (Fixed + Hotkey G)
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старую GUI если есть
if PlayerGui:FindFirstChild("FlonsetHUB") then
    PlayerGui:FindFirstChild("FlonsetHUB"):Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- ЦВЕТА И СТИЛИ
-- ═══════════════════════════════════════════════════════════════
local COLORS = {
    Background = Color3.fromRGB(20, 20, 25),
    Header = Color3.fromRGB(30, 30, 35),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Content = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Button = Color3.fromRGB(45, 45, 50),
    ButtonHover = Color3.fromRGB(60, 60, 70),
    Toggle = Color3.fromRGB(60, 60, 70),
    ToggleActive = Color3.fromRGB(100, 150, 255),
    Border = Color3.fromRGB(50, 50, 55),
    Close = Color3.fromRGB(220, 50, 50),
    CloseHover = Color3.fromRGB(240, 70, 70),
}

-- ═══════════════════════════════════════════════════════════════
-- СОЗДАНИЕ GUI
-- ═══════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Скрыто по умолчанию
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = COLORS.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- Текст заголовка
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FlonsetHUB  |  [G]"
Title.TextColor3 = COLORS.Accent
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Подсказка о хоткее
local HotkeyHint = Instance.new("TextLabel")
HotkeyHint.Name = "HotkeyHint"
HotkeyHint.Size = UDim2.new(0, 100, 1, 0)
HotkeyHint.Position = UDim2.new(1, -130, 0, 0)
HotkeyHint.BackgroundTransparency = 1
HotkeyHint.Text = "Press G to toggle"
HotkeyHint.TextColor3 = COLORS.TextDim
HotkeyHint.TextSize = 12
HotkeyHint.Font = Enum.Font.Gotham
HotkeyHint.TextXAlignment = Enum.TextXAlignment.Right
HotkeyHint.Parent = Header

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = COLORS.Close
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Боковая панель
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = COLORS.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Область контента
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -120, 1, -40)
Content.Position = UDim2.new(0, 120, 0, 40)
Content.BackgroundColor3 = COLORS.Content
Content.BorderSizePixel = 0
Content.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА ОТКРЫТИЯ / ЗАКРЫТИЯ (ИСПРАВЛЕНО)
-- ═══════════════════════════════════════════════════════════════
local isOpen = false
local isAnimating = false

local function ToggleMenu()
    if isAnimating then return end
    isAnimating = true
    
    if isOpen then
        -- ЗАКРЫТИЕ с анимацией
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local tween = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 600, 0, 0),
            Position = UDim2.new(0.5, -300, 0.5, -200)
        })
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 600, 0, 400) -- Восстанавливаем размер
            isOpen = false
            isAnimating = false
        end)
    else
        -- ОТКРЫТИЕ с анимацией
        MainFrame.Size = UDim2.new(0, 600, 0, 0)
        MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        MainFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 600, 0, 400)
        })
        tween:Play()
        tween.Completed:Connect(function()
            isOpen = true
            isAnimating = false
        end)
    end
end

-- Крестик (теперь работает корректно)
CloseButton.MouseButton1Click:Connect(function()
    if isOpen then
        ToggleMenu()
    end
end)

-- Hover эффект на крестике
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = COLORS.CloseHover
end)
CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = COLORS.Close
end)

-- ═══════════════════════════════════════════════════════════════
-- ХОТКЕЙ G (ОТКРЫТИЕ / ЗАКРЫТИЕ)
-- ═══════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Игнорируем если игрок печатает в чат
    if input.KeyCode == Enum.KeyCode.G then
        ToggleMenu()
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- СИСТЕМА ВКЛАДОК
-- ═══════════════════════════════════════════════════════════════
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    -- Кнопка вкладки
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.BackgroundColor3 = COLORS.Button
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = COLORS.Text
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.BorderSizePixel = 0
    TabButton.Parent = Sidebar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    -- Контейнер контента
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "_Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = COLORS.Accent
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = Content
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabContent
    
    Tabs[name] = {
        Button = TabButton,
        Content = TabContent,
        Elements = {}
    }
    
    -- Обработка клика
    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        
        -- Скрываем предыдущую вкладку
        if ActiveTab and Tabs[ActiveTab] then
            Tabs[ActiveTab].Content.Visible = false
            Tabs[ActiveTab].Button.BackgroundColor3 = COLORS.Button
        end
        
        -- Показываем новую
        TabContent.Visible = true
        TabButton.BackgroundColor3 = COLORS.Accent
        ActiveTab = name
    end)
    
    -- Hover эффект
    TabButton.MouseEnter:Connect(function()
        if ActiveTab ~= name then
            TabButton.BackgroundColor3 = COLORS.ButtonHover
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if ActiveTab ~= name then
            TabButton.BackgroundColor3 = COLORS.Button
        end
    end)
    
    return Tabs[name]
end

-- ═══════════════════════════════════════════════════════════════
-- ЭЛЕМЕНТЫ UI
-- ═══════════════════════════════════════════════════════════════

-- Создать переключатель (Toggle)
local function CreateToggle(tab, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = COLORS.Button
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = tab.Content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = COLORS.Text
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and COLORS.ToggleActive or COLORS.Toggle
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local ToggleCircleCorner = Instance.new("UICorner")
    ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCircleCorner.Parent = ToggleCircle
    
    local state = default
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.BackgroundColor3 = state and COLORS.ToggleActive or COLORS.Toggle
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        if callback then callback(state) end
    end)
    
    return {
        GetValue = function() return state end,
        SetValue = function(v)
            state = v
            ToggleButton.BackgroundColor3 = v and COLORS.ToggleActive or COLORS.Toggle
            ToggleCircle.Position = v and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        end
    }
end

-- Создать слайдер (Slider)
local function CreateSlider(tab, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = COLORS.Button
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = tab.Content
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. default
    SliderLabel.TextColor3 = COLORS.Text
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = COLORS.Toggle
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 12, 0, 12)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.Parent = SliderBar
    
    local SliderKnobCorner = Instance.new("UICorner")
    SliderKnobCorner.CornerRadius = UDim.new(1, 0)
    SliderKnobCorner.Parent = SliderKnob
    
    local value = default
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - SliderBar.AbsolutePosition.X
            local percent = math.clamp(pos / SliderBar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
            SliderLabel.Text = name .. ": " .. value
            if callback then callback(value) end
        end
    end)
    
    return {
        GetValue = function() return value end,
        SetValue = function(v)
            value = v
            local percent = (v - min) / (max - min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
            SliderLabel.Text = name .. ": " .. value
        end
    }
end

-- Создать кнопку (Button)
local function CreateButton(tab, name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = COLORS.Button
    Button.Text = name
    Button.TextColor3 = COLORS.Text
    Button.TextSize = 13
    Button.Font = Enum.Font.Gotham
    Button.BorderSizePixel = 0
    Button.Parent = tab.Content
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = COLORS.ButtonHover
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = COLORS.Button
    end)
    
    return Button
end

-- Создать раздел (Section)
local function CreateSection(tab, name)
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = name
    SectionLabel.Size = UDim2.new(1, 0, 0, 25)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = "── " .. name .. " ──"
    SectionLabel.TextColor3 = COLORS.Accent
    SectionLabel.TextSize = 12
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Parent = tab.Content
    
    return {
        AddToggle = function(name, default, callback)
            return CreateToggle(tab, name, default, callback)
        end,
        AddSlider = function(name, min, max, default, callback)
            return CreateSlider(tab, name, min, max, default, callback)
        end,
        AddButton = function(name, callback)
            return CreateButton(tab, name, callback)
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
-- СОЗДАНИЕ ВКЛАДОК
-- ═══════════════════════════════════════════════════════════════
local CombatTab = CreateTab("Combat")
local VisualsTab = CreateTab("Visuals")
local PlayerTab = CreateTab("Player")
local MiscTab = CreateTab("Misc")
local SettingsTab = CreateTab("Settings")

-- ═══════════════════════════════════════════════════════════════
-- COMBAT ВКЛАДКА
-- ═══════════════════════════════════════════════════════════════
local CombatAim = CreateSection(CombatTab, "Aimbot")
CombatAim.AddToggle("Silent Aim", false, function(v)
    print("Silent Aim:", v)
end)
CombatAim.AddSlider("FOV", 10, 500, 100, function(v)
    print("FOV:", v)
end)

local CombatAura = CreateSection(CombatTab, "Kill Aura")
CombatAura.AddToggle("Kill Aura", false, function(v)
    print("Kill Aura:", v)
end)

-- ═══════════════════════════════════════════════════════════════
-- VISUALS ВКЛАДКА
-- ═══════════════════════════════════════════════════════════════
local VisualsESP = CreateSection(VisualsTab, "ESP")
VisualsESP.AddToggle("Player ESP", false, function(v)
    print("ESP:", v)
end)

local VisualsWorld = CreateSection(VisualsTab, "World")
VisualsWorld.AddToggle("Fullbright", false, function(v)
    print("Fullbright:", v)
end)

-- ═══════════════════════════════════════════════════════════════
-- PLAYER ВКЛАДКА
-- ═══════════════════════════════════════════════════════════════
local PlayerMove = CreateSection(PlayerTab, "Movement")
PlayerMove.AddToggle("Fly", false, function(v)
    print("Fly:", v)
end)
PlayerMove.AddToggle("Noclip", false, function(v)
    print("Noclip:", v)
end)

local PlayerChar = CreateSection(PlayerTab, "Character")
PlayerChar.AddSlider("WalkSpeed", 16, 300, 16, function(v)
    print("WalkSpeed:", v)
end)

-- ═══════════════════════════════════════════════════════════════
-- MISC ВКЛАДКА
-- ═══════════════════════════════════════════════════════════════
local MiscTools = CreateSection(MiscTab, "Tools")
MiscTools.AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS ВКЛАДКА
-- ═══════════════════════════════════════════════════════════════
local SettingsMenu = CreateSection(SettingsTab, "Menu")
SettingsMenu.AddToggle("Menu Sounds", false, function(v)
    print("Menu Sounds:", v)
end)
SettingsMenu.AddButton("Unload (Destroy GUI)", function()
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════
-- ПЕРЕТАСКИВАНИЕ ОКНА
-- ═══════════════════════════════════════════════════════════════
local dragging = false
local dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- ОТКРЫТИЕ ПЕРВОЙ ВКЛАДКИ
-- ═══════════════════════════════════════════════════════════════
Tabs["Combat"].Button.BackgroundColor3 = COLORS.Accent
Tabs["Combat"].Content.Visible = true
ActiveTab = "Combat"

-- Уведомление в консоли
print("✅ FlonsetHUB loaded!")
print("🔑 Press [G] to toggle menu")

-- ═══════════════════════════════════════════════════════════════
-- АВТООТКРЫТИЕ ПРИ ЗАГРУЗКЕ (опционально)
-- ═══════════════════════════════════════════════════════════════
task.wait(0.5)
ToggleMenu() -- Автоматически открываем меню при загрузке
