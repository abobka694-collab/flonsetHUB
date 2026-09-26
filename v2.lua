--// MM2 GUI
--// Standalone UI / no external libraries

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local Config = {
    Visuals = {
        ESP = false,
        Names = false,
        Distance = false,
        Tracers = false,
    },

    Combat = {
        AutoDodge = false,
        SilentAim = false,
        KillAura = false,
    },

    Movement = {
        Speed = false,
        Jump = false,
        NoClip = false,
    },

    Settings = {
        MenuKey = Enum.KeyCode.RightShift,
    }
}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "MM2Hub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(620, 400)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(45, 45, 55)
Stroke.Thickness = 1
Stroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 52)
Top.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2  •  HUB"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Status = Instance.new("TextLabel")
Status.Size = UDim2.fromOffset(100, 30)
Status.Position = UDim2.new(1, -115, 0, 11)
Status.BackgroundTransparency = 1
Status.Text = "ONLINE"
Status.TextColor3 = Color3.fromRGB(100, 220, 140)
Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Right
Status.Parent = Top

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, -52)
Sidebar.Position = UDim2.fromOffset(0, 52)
Sidebar.BackgroundColor3 = Color3.fromRGB(21, 21, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 15)
SidePadding.PaddingLeft = UDim.new(0, 10)
SidePadding.PaddingRight = UDim.new(0, 10)
SidePadding.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 7)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -145, 1, -52)
Content.Position = UDim2.fromOffset(145, 52)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}
local TabButtons = {}

--==================================================
-- HELPERS
--==================================================

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, -30, 1, -30)
    Page.Position = UDim2.fromOffset(15, 15)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Pages[name] = Page

    return Page
end

local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(170, 170, 180)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    TabButtons[name] = Button

    return Button
end

local function SwitchTab(name)
    for PageName, Page in pairs(Pages) do
        Page.Visible = PageName == name
    end

    for TabName, Button in pairs(TabButtons) do
        if TabName == name then
            Button.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
            Button.TextColor3 = Color3.fromRGB(170, 170, 180)
        end
    end
end

local function CreateSection(Parent, Text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Color3.fromRGB(130, 130, 145)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Parent

    return Label
end

local function CreateToggle(Parent, Text, Default, Callback)
    local State = Default or false

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 44)
    Button.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.fromOffset(14, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(38, 20)
    Switch.Position = UDim2.new(1, -52, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
    Switch.BorderSizePixel = 0
    Switch.Parent = Button

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.fromOffset(16, 16)
    Circle.Position = UDim2.fromOffset(2, 2)
    Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local function Update()
        if State then
            Switch.BackgroundColor3 = Color3.fromRGB(90, 130, 255)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(1, -18, 0, 2)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
            Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
            Circle.Position = UDim2.fromOffset(2, 2)
        end

        if Callback then
            Callback(State)
        end
    end

    Button.MouseButton1Click:Connect(function()
        State = not State
        Update()
    end)

    Update()

    return {
        Set = function(value)
            State = value
            Update()
        end,

        Get = function()
            return State
        end
    }
end

--==================================================
-- CREATE PAGES
--==================================================

local Visuals = CreatePage("Visuals")
local Combat = CreatePage("Combat")
local Movement = CreatePage("Movement")
local Settings = CreatePage("Settings")

--==================================================
-- VISUALS
--==================================================

CreateSection(Visuals, "PLAYER VISUALS")

CreateToggle(Visuals, "Player ESP", false, function(value)
    Config.Visuals.ESP = value
end)

CreateToggle(Visuals, "Player Names", false, function(value)
    Config.Visuals.Names = value
end)

CreateToggle(Visuals, "Distance", false, function(value)
    Config.Visuals.Distance = value
end)

CreateToggle(Visuals, "Tracers", false, function(value)
    Config.Visuals.Tracers = value
end)

--==================================================
-- COMBAT
--==================================================

CreateSection(Combat, "COMBAT")

CreateToggle(Combat, "Auto Dodge", false, function(value)
    Config.Combat.AutoDodge = value
end)

CreateToggle(Combat, "Silent Aim", false, function(value)
    Config.Combat.SilentAim = value
end)

CreateToggle(Combat, "Kill Aura", false, function(value)
    Config.Combat.KillAura = value
end)

--==================================================
-- MOVEMENT
--==================================================

CreateSection(Movement, "MOVEMENT")

CreateToggle(Movement, "Speed", false, function(value)
    Config.Movement.Speed = value
end)

CreateToggle(Movement, "Jump", false, function(value)
    Config.Movement.Jump = value
end)

CreateToggle(Movement, "No Clip", false, function(value)
    Config.Movement.NoClip = value
end)

--==================================================
-- SETTINGS
--==================================================

CreateSection(Settings, "INTERFACE")

CreateToggle(Settings, "Menu Animation", true, function(value)
    -- reserved
end)

CreateToggle(Settings, "Notifications", true, function(value)
    -- reserved
end)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, 0, 0, 40)
KeyLabel.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
KeyLabel.BorderSizePixel = 0
KeyLabel.Text = "  Menu Key: RightShift"
KeyLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
KeyLabel.TextSize = 13
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = Settings

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 7)
KeyCorner.Parent = KeyLabel

--==================================================
-- TABS
--==================================================

local VisualsTab = CreateTab("Visuals")
local CombatTab = CreateTab("Combat")
local MovementTab = CreateTab("Movement")
local SettingsTab = CreateTab("Settings")

VisualsTab.MouseButton1Click:Connect(function()
    SwitchTab("Visuals")
end)

CombatTab.MouseButton1Click:Connect(function()
    SwitchTab("Combat")
end)

MovementTab.MouseButton1Click:Connect(function()
    SwitchTab("Movement")
end)

SettingsTab.MouseButton1Click:Connect(function()
    SwitchTab("Settings")
end)

SwitchTab("Visuals")

--==================================================
-- DRAGGING
--==================================================

local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- MENU KEY
--==================================================

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then
        return
    end

    if Input.KeyCode == Config.Settings.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

print("[MM2Hub] Loaded")
