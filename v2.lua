-- ═══════════════════════════════════════════
--  flonset hub · gui foundation
-- ═══════════════════════════════════════════

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый GUI если есть
if playerGui:FindFirstChild("FlonsetHub") then
    playerGui.FlonsetHub:Destroy()
end

-- ── Цветовая палитра (ярко-голубой) ──
local C = {
    accent     = Color3.fromRGB(0, 200, 255),
    accentDim  = Color3.fromRGB(0, 150, 200),
    bg         = Color3.fromRGB(16, 16, 22),
    bgPanel    = Color3.fromRGB(24, 24, 34),
    bgSide     = Color3.fromRGB(20, 20, 28),
    text       = Color3.fromRGB(255, 255, 255),
    muted      = Color3.fromRGB(140, 140, 165),
    stroke     = Color3.fromRGB(0, 180, 235),
    red        = Color3.fromRGB(255, 65, 65),
}

-- ── ScreenGui ──
local gui = Instance.new("ScreenGui")
gui.Name = "FlonsetHub"
gui.ResetPlayerGuiOnDeath = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- ── Основной фрейм 650×650 ──
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 650, 0, 650)
main.Position = UDim2.new(0.5, -325, 0.5, -325)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.stroke
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.35
mainStroke.Parent = main

-- ── Title Bar (слайдер / drag bar) ──
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = C.bgPanel
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = titleBar

-- Закрываем нижние скругления titlebar
local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 12)
tbFix.Position = UDim2.new(0, 0, 1, -12)
tbFix.BackgroundColor3 = C.bgPanel
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "flonset"
title.TextColor3 = C.accent
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 7)
closeBtn.BackgroundColor3 = C.red
closeBtn.Text = "×"
closeBtn.TextColor3 = C.text
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Кнопка сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -70, 0, 7)
minBtn.BackgroundColor3 = C.accent
minBtn.Text = "−"
minBtn.TextColor3 = C.text
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ── Sidebar ──
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, -42)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = C.bgSide
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 12)
sbCorner.Parent = sidebar

-- Фикс скруглений сайдбара
local sbFixR = Instance.new("Frame")
sbFixR.Size = UDim2.new(0, 12, 1, 0)
sbFixR.Position = UDim2.new(1, -12, 0, 0)
sbFixR.BackgroundColor3 = C.bgSide
sbFixR.BorderSizePixel = 0
sbFixR.Parent = sidebar

local sbFixT = Instance.new("Frame")
sbFixT.Size = UDim2.new(1, 0, 0, 12)
sbFixT.BackgroundColor3 = C.bgSide
sbFixT.BorderSizePixel = 0
sbFixT.Parent = sidebar

-- Разделительная линия
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 1, 1, -20)
divider.Position = UDim2.new(1, 0, 0, 10)
divider.BackgroundColor3 = C.accent
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Parent = sidebar

-- ── Content Area ──
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -155, 1, -55)
content.Position = UDim2.new(0, 148, 0, 48)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.Parent = main

-- ── Watermark ──
local wm = Instance.new("TextLabel")
wm.Name = "Watermark"
wm.Size = UDim2.new(0, 200, 0, 20)
wm.Position = UDim2.new(1, -215, 1, -28)
wm.BackgroundTransparency = 1
wm.Text = "flonset · mm2"
wm.TextColor3 = C.accent
wm.TextTransparency = 0.45
wm.TextSize = 12
wm.Font = Enum.Font.GothamBold
wm.TextXAlignment = Enum.TextXAlignment.Right
wm.Parent = main

-- ══════════════════════════════════════════
--  Dragging (слайдер / перетаскивание)
-- ══════════════════════════════════════════
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════════
--  Minimize toggle
-- ══════════════════════════════════════════
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    sidebar.Visible = not minimized
    wm.Visible = not minimized
    main.Size = minimized
        and UDim2.new(0, 650, 0, 42)
        or  UDim2.new(0, 650, 0, 650)
end)

-- ══════════════════════════════════════════
--  Toggle key (Insert)
-- ══════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        gui.Enabled = not gui.Enabled
    end
end)
