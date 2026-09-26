local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Config = {
    ESP = false,
    AutoDodge = false,
}

local gui = Instance.new("ScreenGui")
gui.Name = "ViolenceDistrictGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(500, 320)
window.Position = UDim2.fromScale(0.5, 0.5)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
window.BorderSizePixel = 0
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = window

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 42)
title.BackgroundTransparency = 1
title.Text = "Violence District"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = window

local function createToggle(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 38)
    button.Position = UDim2.fromOffset(15, y)
    button.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    button.BorderSizePixel = 0
    button.Text = text .. ": OFF"
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = window

    local state = false

    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

createToggle("ESP", 60, function(value)
    Config.ESP = value
end)

createToggle("Auto Dodge", 108, function(value)
    Config.AutoDodge = value
end)
