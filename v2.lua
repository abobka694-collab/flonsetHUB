-- ═══════════════════════════════════════════════════════════════
-- FLONSET HUB v8.0 - PROJECT REAL OPTIMIZED (UNC/sUNC 100%)
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FlonsetHUB") then
    PlayerGui:FindFirstChild("FlonsetHUB"):Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- GUI (Полупрозрачный, закругленный, стиль Shitaro)
-- ═══════════════════════════════════════════════════════════════
local COLORS = {
    Background = Color3.fromRGB(15, 15, 25),
    Sidebar = Color3.fromRGB(10, 10, 20),
    Section = Color3.fromRGB(25, 25, 40),
    Accent = Color3.fromRGB(100, 140, 255),
    AccentDark = Color3.fromRGB(70, 100, 220),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(150, 150, 170),
    ToggleOff = Color3.fromRGB(70, 70, 90),
    ToggleOn = Color3.fromRGB(100, 140, 255),
    Border = Color3.fromRGB(50, 50, 70),
    Hover = Color3.fromRGB(40, 40, 60),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlonsetHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 800, 0, 500)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = COLORS.Border
MainStroke.Thickness = 1

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = COLORS.Sidebar
Header.BackgroundTransparency = 0.1
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("Frame", Header)
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 12, 0, 8)
Logo.BackgroundColor3 = COLORS.Accent
Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 8)

local LogoText = Instance.new("TextLabel", Logo)
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "F"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBold

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 55, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FlonsetHUB v8.0"
Title.TextColor3 = COLORS.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = COLORS.Sidebar
Sidebar.BackgroundTransparency = 0.1

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 3)
local SidebarPad = Instance.new("UIPadding", Sidebar)
SidebarPad.PaddingTop = UDim.new(0, 12)
SidebarPad.PaddingLeft = UDim.new(0, 10)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -160, 1, -50)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundColor3 = COLORS.Background
Content.BackgroundTransparency = 0.15

local Tabs = {}
local ActiveTab = nil
local TabNames = {"COMBAT", "VISUALS", "PLAYER", "MISC", "TARGET"}

for _, name in ipairs(TabNames) do
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Name = name
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = COLORS.Section
    Btn.BackgroundTransparency = 0.2
    Btn.Text = "  " .. name
    Btn.TextColor3 = COLORS.TextDim
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local TabContent = Instance.new("ScrollingFrame", Content)
    TabContent.Name = name .. "_Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = COLORS.Accent
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    
    local TabLayout = Instance.new("UIListLayout", TabContent)
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    Tabs[name] = { Button = Btn, Content = TabContent }
    
    Btn.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        if ActiveTab and Tabs[ActiveTab] then
            Tabs[ActiveTab].Button.BackgroundColor3 = COLORS.Section
            Tabs[ActiveTab].Button.BackgroundTransparency = 0.2
            Tabs[ActiveTab].Button.TextColor3 = COLORS.TextDim
            Tabs[ActiveTab].Content.Visible = false
        end
        Btn.BackgroundColor3 = COLORS.AccentDark
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.new(1, 1, 1)
        TabContent.Visible = true
        ActiveTab = name
    end)
end

-- UI Helpers
local function CreateToggle(parent, name, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = COLORS.Section
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    ToggleBtn.BackgroundColor3 = default and COLORS.ToggleOn or COLORS.ToggleOff
    ToggleBtn.Text = ""
    ToggleBtn.BorderSizePixel = 0
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", ToggleBtn)
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and COLORS.ToggleOn or COLORS.ToggleOff
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then task.spawn(callback, state) end
    end)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = COLORS.Section
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 8)
    Bar.Position = UDim2.new(0, 10, 0, 32)
    Bar.BackgroundColor3 = COLORS.ToggleOff
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = COLORS.Accent
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame", Bar)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.BorderSizePixel = 0
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local value = default
    local dragging = false
    
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - Bar.AbsolutePosition.X
            local percent = math.clamp(pos / Bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Knob.Position = UDim2.new(percent, -7, 0.5, -7)
            Label.Text = name .. ": " .. value
            if callback then task.spawn(callback, value) end
        end
    end)
end

local function SectionLabel(parent, name)
    local Label = Instance.new("TextLabel", parent)
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Accent
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
end

-- ═══════════════════════════════════════════════════════════════
-- COMBAT: НАСТОЯЩИЙ SILENT AIM (через hookmetamethod)
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["COMBAT"].Content, "⚔ SILENT AIM")

local SilentSettings = { Enabled = false, FOV = 200, Prediction = true, MaxDistance = 500 }
local OriginalNamecall = nil

local function GetTargetInFOV()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, closestDist = nil, SilentSettings.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        local part = char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and (part.Position - myRoot.Position).Magnitude > SilentSettings.MaxDistance then continue end
        
        local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = player
        end
    end
    return closest
end

local function PredictPosition(part)
    if not SilentSettings.Prediction then return part.Position end
    local velocity = Vector3.zero
    local ok, vel = pcall(function() return part.AssemblyLinearVelocity end)
    if ok then velocity = vel end
    
    local ping = 0
    local ok2, p = pcall(function() return LocalPlayer:GetNetworkPing() end)
    if ok2 then ping = p end
    
    local gravity = Workspace.Gravity
    local air = part.Parent:FindFirstChildOfClass("Humanoid").FloorMaterial == Enum.Material.Air
    local predicted = part.Position + velocity * ping
    
    if air then
        predicted = predicted + Vector3.new(0, -0.5 * gravity * ping * ping, 0)
    end
    return predicted
end

local function InstallSilentAimHooks()
    local WeaponService = ReplicatedStorage:FindFirstChild("ClientServices") and ReplicatedStorage.ClientServices:FindFirstChild("WeaponService")
    if not WeaponService then return end
    
    local mt = getrawmetatable(WeaponService)
    if not mt then return end
    
    local old_namecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if SilentSettings.Enabled and method == "FireServer" and self.Name == "Shoot" then
            local args = {...}
            local myChar = LocalPlayer.Character
            if myChar and (self.Parent:IsDescendantOf(myChar) or self.Parent:IsDescendantOf(LocalPlayer:FindFirstChildOfClass("Backpack"))) then
                local target = GetTargetInFOV()
                if target then
                    local char = target.Character
                    local part = char:FindFirstChild("HumanoidRootPart")
                    if part then
                        local targetPos = PredictPosition(part)
                        local startCFrame = args[1]
                        if typeof(startCFrame) == "CFrame" then
                            local aimCFrame = CFrame.new(startCFrame.Position, targetPos)
                            return old_namecall(self, startCFrame, aimCFrame, select(3, ...))
                        end
                    end
                end
            end
        end
        return old_namecall(self, ...)
    end)
    OriginalNamecall = old_namecall
end

CreateToggle(Tabs["COMBAT"].Content, "Silent Aim", false, function(v)
    SilentSettings.Enabled = v
    if v then
        task.spawn(InstallSilentAimHooks)
    else
        if OriginalNamecall then
            local mt = getrawmetatable(ReplicatedStorage.ClientServices.WeaponService)
            if mt then
                setreadonly(mt, false)
                mt.__namecall = OriginalNamecall
                OriginalNamecall = nil
            end
        end
    end
end)

CreateSlider(Tabs["COMBAT"].Content, "FOV", 50, 500, 200, function(v) SilentSettings.FOV = v end)
CreateToggle(Tabs["COMBAT"].Content, "Prediction", true, function(v) SilentSettings.Prediction = v end)

-- ═══════════════════════════════════════════════════════════════
-- VISUALS: ESP
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["VISUALS"].Content, "👁 PLAYER ESP")

local ESPSettings = { Enabled = false, ShowBox = true, ShowName = true, ShowDistance = true, ShowRole = true, MaxDistance = 1000 }
local ESP_Data = {}
local ESPThread = nil

local function GetPlayerRole(player)
    if not player or not player.Parent then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")
    if (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
    if (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer" end
    return "Innocent"
end

local function GetRoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 60, 60)
    elseif role == "Sheriff" then return Color3.fromRGB(0, 153, 255)
    else return Color3.fromRGB(255, 255, 255) end
end

local function CreateESP(player)
    if player == LocalPlayer or ESP_Data[player] then return end
    local data = { highlight = nil, billboard = nil }
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "FlonsetESP"
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.new(1, 1, 1)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = CoreGui
    data.highlight = highlight
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FlonsetBB"
    billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = CoreGui
    data.billboard = billboard
    
    ESP_Data[player] = data
end

local function RemoveESP(player)
    local data = ESP_Data[player]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.billboard then pcall(function() data.billboard:Destroy() end) end
    ESP_Data[player] = nil
end

local function UpdateESP()
    if not ESPSettings.Enabled then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if char and root and hum and hum.Health > 0 then
            if not ESP_Data[player] then CreateESP(player) end
            local data = ESP_Data[player]
            if not data then continue end
            
            local role = GetPlayerRole(player)
            local color = GetRoleColor(role)
            
            if data.highlight and ESPSettings.ShowBox then
                data.highlight.Adornee = char
                data.highlight.FillColor = color
                data.highlight.OutlineColor = color
                data.highlight.Enabled = true
            elseif data.highlight then
                data.highlight.Enabled = false
            end
            
            if data.billboard then
                local head = char:FindFirstChild("Head") or root
                data.billboard.Adornee = head
                
                for _, child in ipairs(data.billboard:GetChildren()) do
                    if child:IsA("TextLabel") then child:Destroy() end
                end
                
                if ESPSettings.ShowName then
                    local nameLabel = Instance.new("TextLabel", data.billboard)
                    nameLabel.Size = UDim2.new(1, 0, 0, 20)
                    nameLabel.Position = UDim2.new(0, 0, 0, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = player.DisplayName
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextSize = 14
                end
                
                if ESPSettings.ShowRole then
                    local roleLabel = Instance.new("TextLabel", data.billboard)
                    roleLabel.Size = UDim2.new(1, 0, 0, 15)
                    roleLabel.Position = UDim2.new(0, 0, 0, 20)
                    roleLabel.BackgroundTransparency = 1
                    roleLabel.Text = "[" .. role .. "]"
                    roleLabel.TextColor3 = color
                    roleLabel.TextStrokeTransparency = 0
                    roleLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    roleLabel.Font = Enum.Font.GothamBold
                    roleLabel.TextSize = 11
                end
                
                if ESPSettings.ShowDistance and myRoot then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    local distLabel = Instance.new("TextLabel", data.billboard)
                    distLabel.Size = UDim2.new(1, 0, 0, 15)
                    distLabel.Position = UDim2.new(0, 0, 0, 35)
                    distLabel.BackgroundTransparency = 1
                    distLabel.Text = string.format("%.0fm", dist)
                    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    distLabel.TextStrokeTransparency = 0
                    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    distLabel.Font = Enum.Font.Gotham
                    distLabel.TextSize = 12
                    data.billboard.Enabled = dist <= ESPSettings.MaxDistance
                end
            end
        else
            if ESP_Data[player] then RemoveESP(player) end
        end
    end
end

CreateToggle(Tabs["VISUALS"].Content, "Player ESP", false, function(v)
    ESPSettings.Enabled = v
    if v then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then CreateESP(player) end
        end
        ESPThread = RunService.Heartbeat:Connect(function() pcall(UpdateESP) end)
    else
        if ESPThread then ESPThread:Disconnect() end
        for player in pairs(ESP_Data) do RemoveESP(player) end
    end
end)
CreateToggle(Tabs["VISUALS"].Content, "Show Box", true, function(v) ESPSettings.ShowBox = v end)
CreateToggle(Tabs["VISUALS"].Content, "Show Name", true, function(v) ESPSettings.ShowName = v end)
CreateToggle(Tabs["VISUALS"].Content, "Show Distance", true, function(v) ESPSettings.ShowDistance = v end)
CreateToggle(Tabs["VISUALS"].Content, "Show Role", true, function(v) ESPSettings.ShowRole = v end)
CreateSlider(Tabs["VISUALS"].Content, "Max Distance", 100, 2000, 1000, function(v) ESPSettings.MaxDistance = v end)

-- ═══════════════════════════════════════════════════════════════
-- PLAYER: АГРЕССИВНЫЙ ИНВИЗ + FAKE POSITION (UNC/sUNC)
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["PLAYER"].Content, "👻 VISUAL & DESYNC")

-- Агрессивный инвиз (серверный + клиентский)
local InvisEnabled = false
local InvisThread = nil
local InvisCharConn = nil

local function ApplyInvis()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.LocalTransparencyModifier = 1
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
            part.LocalTransparencyModifier = 1
        elseif part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") or part:IsA("Beam") or part:IsA("Trail") then
            part.Enabled = false
        elseif part:IsA("ForceField") then
            part.Visible = false
        end
    end
end

local function RestoreInvis()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        elseif part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") or part:IsA("Beam") or part:IsA("Trail") then
            part.Enabled = true
        elseif part:IsA("ForceField") then
            part.Visible = true
        end
    end
end

CreateToggle(Tabs["PLAYER"].Content, "Invis (Aggressive)", false, function(v)
    InvisEnabled = v
    if v then
        ApplyInvis()
        InvisThread = RunService.Heartbeat:Connect(function()
            if InvisEnabled then ApplyInvis() end
        end)
        InvisCharConn = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if InvisEnabled then ApplyInvis() end
        end)
    else
        if InvisThread then InvisThread:Disconnect() end
        if InvisCharConn then InvisCharConn:Disconnect() end
        RestoreInvis()
    end
end)

-- Fake Position (Desync)
local FakePosEnabled = false
local FakePosThread = nil
local OriginalCFrame = nil

CreateToggle(Tabs["PLAYER"].Content, "Fake Position (Desync)", false, function(v)
    FakePosEnabled = v
    if v then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            OriginalCFrame = hrp.CFrame
            -- Отключаем проверку FallenPartsDestroyHeight чтобы не умирать при десинке
            pcall(function() sethiddenproperty(Workspace, "FallenPartsDestroyHeight", -9e9) end)
        end
        
        FakePosThread = RunService.Heartbeat:Connect(function()
            if not FakePosEnabled then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Случайное смещение позиции для сервера
                local fakeCFrame = hrp.CFrame * CFrame.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                pcall(function() hrp.CFrame = fakeCFrame end)
            end
        end)
    else
        if FakePosThread then FakePosThread:Disconnect() end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and OriginalCFrame then
            pcall(function() hrp.CFrame = OriginalCFrame end)
            OriginalCFrame = nil
        end
        pcall(function() sethiddenproperty(Workspace, "FallenPartsDestroyHeight", -500) end)
    end
end)

-- Velocity Desync
local VelocityDesyncEnabled = false
local VelocityDesyncThread = nil

CreateToggle(Tabs["PLAYER"].Content, "Velocity Desync", false, function(v)
    VelocityDesyncEnabled = v
    if v then
        VelocityDesyncThread = RunService.Heartbeat:Connect(function()
            if not VelocityDesyncEnabled then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Случайная скорость для обхода предикшена
                local fakeVel = Vector3.new(math.random(-300, 300), math.random(-300, 300), math.random(-300, 300))
                pcall(function() hrp.AssemblyLinearVelocity = fakeVel end)
                task.wait()
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
            end
        end)
    else
        if VelocityDesyncThread then VelocityDesyncThread:Disconnect() end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- MISC
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["MISC"].Content, "🛡 UTILITIES")

-- Anti-AFK
local AntiAFKEnabled = false
local AFKConn = nil
CreateToggle(Tabs["MISC"].Content, "Anti-AFK", false, function(v)
    AntiAFKEnabled = v
    if v then
        local VirtualUser = game:GetService("VirtualUser")
        AFKConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if AFKConn then AFKConn:Disconnect() end
    end
end)

-- No Fall Damage
local NoFallEnabled = false
local NoFallConn = nil
CreateToggle(Tabs["MISC"].Content, "No Fall Damage", false, function(v)
    NoFallEnabled = v
    if v then
        NoFallConn = RunService.Heartbeat:Connect(function()
            if not NoFallEnabled then return end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                end
            end
        end)
    else
        if NoFallConn then NoFallConn:Disconnect() end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- УПРАВЛЕНИЕ ОКНОМ
-- ═══════════════════════════════════════════════════════════════
local isOpen = false
local isAnimating = false

local function ToggleMenu()
    if isAnimating then return end
    isAnimating = true
    
    if isOpen then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 800, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 800, 0, 500)
            isOpen = false
            isAnimating = false
        end)
    else
        MainFrame.Size = UDim2.new(0, 800, 0, 0)
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 800, 0, 500)
        })
        tween:Play()
        tween.Completed:Connect(function()
            isOpen = true
            isAnimating = false
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    if isOpen then ToggleMenu() end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then ToggleMenu() end
end)

-- Перетаскивание
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Автооткрытие
task.wait(0.5)
Tabs["COMBAT"].Button.BackgroundColor3 = COLORS.AccentDark
Tabs["COMBAT"].Button.BackgroundTransparency = 0
Tabs["COMBAT"].Button.TextColor3 = Color3.new(1, 1, 1)
Tabs["COMBAT"].Content.Visible = true
ActiveTab = "COMBAT"
ToggleMenu()

print("✅ FlonsetHUB v8.0 loaded! (ProjectReal Optimized)")
print("🔑 Press [G] to toggle menu")
