local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DemoMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(560, 360)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 42)
title.Position = UDim2.fromOffset(12, 8)
title.BackgroundTransparency = 1
title.Text = "Visuals"
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local tabs = Instance.new("Frame")
tabs.Size = UDim2.fromOffset(135, 285)
tabs.Position = UDim2.fromOffset(12, 58)
tabs.BackgroundColor3 = Color3.fromRGB(29, 29, 37)
tabs.BorderSizePixel = 0
tabs.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabs

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -170, 1, -70)
content.Position = UDim2.fromOffset(158, 58)
content.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new()
content.Parent = main

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
\tcontent.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 24)
end)

local function addTab(name)
\tlocal button = Instance.new("TextButton")
\tbutton.Size = UDim2.new(1, -12, 0, 36)
\tbutton.Position = UDim2.fromOffset(6, 0)
\tbutton.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
\tbutton.Text = name
\tbutton.TextColor3 = Color3.fromRGB(220, 220, 230)
\tbutton.Font = Enum.Font.Gotham
\tbutton.TextSize = 14
\tbutton.BorderSizePixel = 0
\tbutton.Parent = tabs

\tlocal c = Instance.new("UICorner")
\tc.CornerRadius = UDim.new(0, 6)
\tc.Parent = button

\tbutton.MouseButton1Click:Connect(function()
\t\ttitle.Text = name
\tend)
end

local function addToggle(name, defaultValue)
\tlocal row = Instance.new("TextButton")
\trow.Size = UDim2.new(1, -8, 0, 42)
\trow.BackgroundColor3 = Color3.fromRGB(38, 38, 47)
\trow.Text = ""
\trow.BorderSizePixel = 0
\trow.Parent = content

\tlocal label = Instance.new("TextLabel")
\tlabel.Size = UDim2.new(1, -70, 1, 0)
\tlabel.Position = UDim2.fromOffset(12, 0)
\tlabel.BackgroundTransparency = 1
\tlabel.Text = name
\tlabel.TextColor3 = Color3.fromRGB(230, 230, 235)
\tlabel.Font = Enum.Font.Gotham
\tlabel.TextSize = 14
\tlabel.TextXAlignment = Enum.TextXAlignment.Left
\tlabel.Parent = row

\tlocal state = defaultValue == true
\tlocal indicator = Instance.new("TextLabel")
\tindicator.Size = UDim2.fromOffset(48, 24)
\tindicator.Position = UDim2.new(1, -60, 0.5, -12)
\tindicator.BackgroundColor3 = state
\t\tand Color3.fromRGB(95, 180, 120)
\t\tor Color3.fromRGB(75, 75, 85)
\tindicator.Text = state and "ON" or "OFF"
\tindicator.TextColor3 = Color3.new(1, 1, 1)
\tindicator.Font = Enum.Font.GothamBold
\tindicator.TextSize = 11
\tindicator.Parent = row

\trow.MouseButton1Click:Connect(function()
\t\tstate = not state
\t\tindicator.Text = state and "ON" or "OFF"
\t\tindicator.BackgroundColor3 = state
\t\t\tand Color3.fromRGB(95, 180, 120)
\t\t\tor Color3.fromRGB(75, 75, 85)
\tend)
end

local function addSection(name)
\tlocal label = Instance.new("TextLabel")
\tlabel.Size = UDim2.new(1, -8, 0, 28)
\tlabel.BackgroundTransparency = 1
\tlabel.Text = name
\tlabel.TextColor3 = Color3.fromRGB(140, 145, 165)
\tlabel.Font = Enum.Font.GothamBold
\tlabel.TextSize = 13
\tlabel.TextXAlignment = Enum.TextXAlignment.Left
\tlabel.Parent = content
end

addTab("Combat")
addTab("Visuals")
addTab("World")
addTab("Settings")

addSection("World")
addToggle("Fullbright", false)
addToggle("Custom fog", false)
addToggle("Time changer", false)

addSection("Interface")
addToggle("Crosshair", false)
addToggle("Show notifications", true)
addToggle("Enable animations", true)
