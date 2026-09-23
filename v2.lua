-- ═══════════════════════════════════════════════════════════════
-- FLONSET HUB v6.0 - FULL SHITARO RECODE (UNC 100)
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
local CollectionService = game:GetService("CollectionService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FlonsetHUB") then
    PlayerGui:FindFirstChild("FlonsetHUB"):Destroy()
end

-- ══════════════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════════════
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
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(50, 50, 70)
MainStroke.Thickness = 1

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Header.BackgroundTransparency = 0.1
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("Frame", Header)
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 12, 0, 8)
Logo.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
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
Title.Text = "FlonsetHUB v6.0"
Title.TextColor3 = Color3.fromRGB(240, 240, 250)
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
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Sidebar.BackgroundTransparency = 0.1

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 3)
local SidebarPad = Instance.new("UIPadding", Sidebar)
SidebarPad.PaddingTop = UDim.new(0, 12)
SidebarPad.PaddingLeft = UDim.new(0, 10)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -160, 1, -50)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Content.BackgroundTransparency = 0.15

local Tabs = {}
local ActiveTab = nil
local TabNames = {"COMBAT", "VISUALS", "PLAYER", "MISC", "TARGET", "SKINS"}

for _, name in ipairs(TabNames) do
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Btn.BackgroundTransparency = 0.2
    Btn.Text = "  " .. name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 170)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local TabContent = Instance.new("ScrollingFrame", Content)
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 140, 255)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    Instance.new("UIListLayout", TabContent).Padding = UDim.new(0, 8)
    
    Tabs[name] = { Button = Btn, Content = TabContent }
    
    Btn.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        if ActiveTab then
            Tabs[ActiveTab].Button.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
            Tabs[ActiveTab].Button.BackgroundTransparency = 0.2
            Tabs[ActiveTab].Button.TextColor3 = Color3.fromRGB(150, 150, 170)
            Tabs[ActiveTab].Content.Visible = false
        end
        Btn.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.new(1, 1, 1)
        TabContent.Visible = true
        ActiveTab = name
    end)
end

local function CreateToggle(parent, name, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(240, 240, 250)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 140, 255) or Color3.fromRGB(70, 70, 90)
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
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(100, 140, 255) or Color3.fromRGB(70, 70, 90)
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then callback(state) end
    end)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(240, 240, 250)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 8)
    Bar.Position = UDim2.new(0, 10, 0, 32)
    Bar.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
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
            if callback then callback(value) end
        end
    end)
end

local function SectionLabel(parent, name)
    local Label = Instance.new("TextLabel", parent)
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(100, 140, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
end

-- ═══════════════════════════════════════════════════════════════
-- COMBAT - SILENT AIM (полный с предикшном)
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["COMBAT"].Content, "⚔ SILENT AIM")

local SilentSettings = { Enabled = false, FOV = 200, Prediction = true, ForceShoot = false, MaxDistance = 500, StandOff = 15 }
local SilentThread = nil
local NamecallHook = nil
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

local function GetWeaponService()
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"))
    end)
    if ok then return module end
    return nil
end

local function InstallHooks()
    local module = GetWeaponService()
    if not module then return end
    
    if type(module.GetMouseTargetCFrame) == "function" then
        OriginalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if SilentSettings.Enabled and method == "FireServer" then
                if self and self.Name == "Shoot" and self.Parent and self.Parent.Name == "Gun" then
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
                                    if SilentSettings.ForceShoot then
                                        local aimCFrame = CFrame.new(startCFrame.Position, targetPos)
                                        return OriginalNamecall(self, startCFrame, aimCFrame, select(3, ...))
                                    else
                                        return OriginalNamecall(self, startCFrame, CFrame.new(startCFrame.Position, targetPos), select(3, ...))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return OriginalNamecall(self, ...)
        end)
    end
end

CreateToggle(Tabs["COMBAT"].Content, "Silent Aim", false, function(v)
    SilentSettings.Enabled = v
    if v then
        task.spawn(function()
            task.wait(0.5)
            pcall(InstallHooks)
        end)
    else
        if OriginalNamecall then
            hookmetamethod(game, "__namecall", OriginalNamecall)
            OriginalNamecall = nil
        end
    end
end)

CreateSlider(Tabs["COMBAT"].Content, "FOV", 50, 500, 200, function(v) SilentSettings.FOV = v end)
CreateToggle(Tabs["COMBAT"].Content, "Prediction", true, function(v) SilentSettings.Prediction = v end)
CreateToggle(Tabs["COMBAT"].Content, "Force Shoot", false, function(v) SilentSettings.ForceShoot = v end)
CreateSlider(Tabs["COMBAT"].Content, "Max Distance", 100, 1000, 500, function(v) SilentSettings.MaxDistance = v end)

-- Kill Aura
SectionLabel(Tabs["COMBAT"].Content, " KILL AURA")
local AuraSettings = { Enabled = false, Range = 30 }
local AuraThread = nil

CreateToggle(Tabs["COMBAT"].Content, "Kill Aura", false, function(v)
    AuraSettings.Enabled = v
    if v then
        AuraThread = RunService.Heartbeat:Connect(function()
            if not AuraSettings.Enabled then return end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= AuraSettings.Range then
                    local gun = myChar:FindFirstChild("Gun")
                    if gun then
                        local shoot = gun:FindFirstChild("Shoot")
                        if shoot and shoot:IsA("RemoteEvent") then
                            shoot:FireServer(myRoot.CFrame, CFrame.new(myRoot.Position, root.Position))
                        end
                    end
                end
            end
        end)
    else
        if AuraThread then AuraThread:Disconnect() end
    end
end)
CreateSlider(Tabs["COMBAT"].Content, "Aura Range", 5, 60, 30, function(v) AuraSettings.Range = v end)

-- ═══════════════════════════════════════════════════════════════
-- VISUALS - ESP
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["VISUALS"].Content, "👁 PLAYER ESP")

local ESPSettings = { Enabled = false, ShowBox = true, ShowName = true, ShowDistance = true, ShowRole = true, ShowSkeleton = true, MaxDistance = 1000 }
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
    local data = { highlight = nil, billboard = nil, skeleton = {} }
    
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

-- Gun ESP
SectionLabel(Tabs["VISUALS"].Content, "🔫 GUN ESP")
local GunESPSettings = { Enabled = false, MaxDistance = 500 }
local GunESP_Data = {}
local GunESPThread = nil

local function GetGunPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true) end
    return obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
end

local function IsInCharacter(obj)
    local node = obj.Parent
    while node and node ~= Workspace do
        if node:IsA("Model") and Players:GetPlayerFromCharacter(node) then return true end
        node = node.Parent
    end
    return false
end

local function CreateGunESP(obj)
    if GunESP_Data[obj] or not obj.Parent or IsInCharacter(obj) then return end
    local part = GetGunPart(obj)
    if not part then return end
    
    local data = { highlight = nil, billboard = nil }
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "FlonsetGunHL"
    highlight.Adornee = obj
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = CoreGui
    data.highlight = highlight
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FlonsetGunBB"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = CoreGui
    
    local txt = Instance.new("TextLabel", billboard)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "🔫 GUN"
    txt.TextColor3 = Color3.fromRGB(255, 215, 0)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 16
    
    data.billboard = billboard
    GunESP_Data[obj] = data
end

local function RemoveGunESP(obj)
    local data = GunESP_Data[obj]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.billboard then pcall(function() data.billboard:Destroy() end) end
    GunESP_Data[obj] = nil
end

local function UpdateGunESP()
    if not GunESPSettings.Enabled then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for obj, data in pairs(GunESP_Data) do
        if not obj.Parent or IsInCharacter(obj) then
            RemoveGunESP(obj)
            continue
        end
        local part = GetGunPart(obj)
        if not part or not part.Parent then
            RemoveGunESP(obj)
            continue
        end
        if myRoot then
            local dist = (part.Position - myRoot.Position).Magnitude
            if dist > GunESPSettings.MaxDistance then
                if data.highlight then data.highlight.Enabled = false end
                if data.billboard then data.billboard.Enabled = false end
            else
                if data.highlight then data.highlight.Enabled = true end
                if data.billboard then data.billboard.Enabled = true end
            end
        end
    end
end

CreateToggle(Tabs["VISUALS"].Content, "Gun ESP", false, function(v)
    GunESPSettings.Enabled = v
    if v then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and not IsInCharacter(obj) then CreateGunESP(obj) end
        end
        GunESPThread = RunService.Heartbeat:Connect(function() pcall(UpdateGunESP) end)
    else
        if GunESPThread then GunESPThread:Disconnect() end
        for obj in pairs(GunESP_Data) do RemoveGunESP(obj) end
    end
end)

-- World Visuals
SectionLabel(Tabs["VISUALS"].Content, " WORLD")
local OriginalLighting = {}

CreateToggle(Tabs["VISUALS"].Content, "Fullbright", false, function(v)
    if v then
        OriginalLighting.Brightness = Lighting.Brightness
        OriginalLighting.Ambient = Lighting.Ambient
        OriginalLighting.ClockTime = Lighting.ClockTime
        OriginalLighting.GlobalShadows = Lighting.GlobalShadows
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        if OriginalLighting.Brightness then Lighting.Brightness = OriginalLighting.Brightness end
        if OriginalLighting.Ambient then Lighting.Ambient = OriginalLighting.Ambient end
        if OriginalLighting.ClockTime then Lighting.ClockTime = OriginalLighting.ClockTime end
        if OriginalLighting.GlobalShadows ~= nil then Lighting.GlobalShadows = OriginalLighting.GlobalShadows end
    end
end)

CreateToggle(Tabs["VISUALS"].Content, "No Fog", false, function(v)
    if v then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    else
        Lighting.FogStart = 0
        Lighting.FogEnd = 1000
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- PLAYER
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["PLAYER"].Content, " MOVEMENT")

CreateSlider(Tabs["PLAYER"].Content, "WalkSpeed", 16, 300, 16, function(v)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

CreateSlider(Tabs["PLAYER"].Content, "JumpPower", 50, 300, 50, function(v)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end
end)

local BhopEnabled = false
local BhopThread = nil
CreateToggle(Tabs["PLAYER"].Content, "Bhop", false, function(v)
    BhopEnabled = v
    if v then
        BhopThread = RunService.Heartbeat:Connect(function()
            if not BhopEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if BhopThread then BhopThread:Disconnect() end
    end
end)

local NoclipEnabled = false
local NoclipThread = nil
CreateToggle(Tabs["PLAYER"].Content, "Noclip", false, function(v)
    NoclipEnabled = v
    if v then
        NoclipThread = RunService.Stepped:Connect(function()
            if not NoclipEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if NoclipThread then NoclipThread:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

local FlyEnabled = false
local FlyThread = nil
local flyBodyVelocity, flyBodyGyro = nil, nil
local FlySpeed = 50

CreateToggle(Tabs["PLAYER"].Content, "Fly", false, function(v)
    FlyEnabled = v
    if v then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        flyBodyGyro.P = 9000
        
        flyBodyVelocity = Instance.new("BodyVelocity", hrp)
        flyBodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        
        FlyThread = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then return end
            local c = LocalPlayer.Character
            if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart")
            if not h then return end
            
            local camera = Workspace.CurrentCamera
            flyBodyGyro.CFrame = camera.CFrame
            
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            flyBodyVelocity.Velocity = moveDir * FlySpeed
        end)
    else
        if FlyThread then FlyThread:Disconnect() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end)
CreateSlider(Tabs["PLAYER"].Content, "Fly Speed", 10, 200, 50, function(v) FlySpeed = v end)

local InfiniteJumpEnabled = false
local InfiniteJumpConn = nil
CreateToggle(Tabs["PLAYER"].Content, "Infinite Jump", false, function(v)
    InfiniteJumpEnabled = v
    if v then
        InfiniteJumpConn = UserInputService.JumpRequest:Connect(function()
            if not InfiniteJumpEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if InfiniteJumpConn then InfiniteJumpConn:Disconnect() end
    end
end)

-- Invis
SectionLabel(Tabs["PLAYER"].Content, "👻 VISUAL")
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
        elseif part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") then
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
        elseif part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") then
            part.Enabled = true
        elseif part:IsA("ForceField") then
            part.Visible = true
        end
    end
end

CreateToggle(Tabs["PLAYER"].Content, "Invis", false, function(v)
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

CreateToggle(Tabs["PLAYER"].Content, "Fake Headless", false, function(v)
    if v then
        local thread = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if head then
                head.LocalTransparencyModifier = 1
                head.Transparency = 1
            end
        end)
        v = thread
    else
        if type(v) == "RBXScriptConnection" then v:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                head.LocalTransparencyModifier = 0
                head.Transparency = 0
            end
        end
    end
end)

CreateToggle(Tabs["PLAYER"].Content, "Fake Korblox", false, function(v)
    if v then
        local thread = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local rightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
            if rightLeg then
                rightLeg.LocalTransparencyModifier = 1
                rightLeg.Transparency = 1
            end
        end)
        v = thread
    else
        if type(v) == "RBXScriptConnection" then v:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local rightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
            if rightLeg then
                rightLeg.LocalTransparencyModifier = 0
                rightLeg.Transparency = 0
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- MISC
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["MISC"].Content, "🛡 UTILITIES")

local AntiAFKEnabled = false
local AFKConn = nil
CreateToggle(Tabs["MISC"].Content, "Anti-AFK", false, function(v)
    AntiAFKEnabled = v
    if v then
        AFKConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if AFKConn then AFKConn:Disconnect() end
    end
end)

CreateToggle(Tabs["MISC"].Content, "No Fall Damage", false, function(v)
    if v then
        local thread = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                end
            end
        end)
        v = thread
    else
        if type(v) == "RBXScriptConnection" then v:Disconnect() end
    end
end)

-- Grab Gun
SectionLabel(Tabs["MISC"].Content, "🔫 GRAB GUN")
local GrabSettings = { Enabled = false, GrabRange = 50, GrabSpeed = 80 }
local GrabThread = nil
local LastGrabTime = 0

local function FindNearestGun()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nearest, nearestDist = nil, GrabSettings.GrabRange
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and not IsInCharacter(obj) then
            local part = GetGunPart(obj)
            if part and part.Parent then
                local dist = (part.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest, nearestDist
end

local function MoveToGun(gun)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local gunPart = GetGunPart(gun)
    if not gunPart or not gunPart.Parent then return end
    
    local targetPos = gunPart.Position + Vector3.new(0, 3, 0)
    local direction = (targetPos - myRoot.Position).Unit
    myRoot.AssemblyLinearVelocity = Vector3.new(direction.X * GrabSettings.GrabSpeed, myRoot.AssemblyLinearVelocity.Y, direction.Z * GrabSettings.GrabSpeed)
    
    local dist = (gunPart.Position - myRoot.Position).Magnitude
    if dist < 5 then
        myRoot.CFrame = CFrame.new(gunPart.Position + Vector3.new(0, 3, 0))
        task.wait(0.1)
        myRoot.CFrame = CFrame.new(gunPart.Position + Vector3.new(0, 1, 0))
    end
end

CreateToggle(Tabs["MISC"].Content, "Auto Grab Gun", false, function(v)
    GrabSettings.Enabled = v
    if v then
        GrabThread = RunService.Heartbeat:Connect(function()
            if not GrabSettings.Enabled then return end
            local now = tick()
            if now - LastGrabTime < 0.5 then return end
            local gun, dist = FindNearestGun()
            if gun and dist <= GrabSettings.GrabRange then
                LastGrabTime = now
                MoveToGun(gun)
            end
        end)
    else
        if GrabThread then GrabThread:Disconnect() end
    end
end)
CreateSlider(Tabs["MISC"].Content, "Grab Range", 10, 100, 50, function(v) GrabSettings.GrabRange = v end)

-- Server Buttons
SectionLabel(Tabs["MISC"].Content, "🌐 SERVER")

local function CreateButton(parent, name, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(1, -20, 1, -6)
    Btn.Position = UDim2.new(0, 10, 0, 3)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
    Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(100, 140, 255) end)
    Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(70, 100, 220) end)
end

CreateButton(Tabs["MISC"].Content, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
CreateButton(Tabs["MISC"].Content, "Leave Game", function()
    TeleportService:Teleport(173333898, LocalPlayer)
end)

-- ═══════════════════════════════════════════════════════════════
-- TARGET
-- ═══════════════════════════════════════════════════════════════
SectionLabel(Tabs["TARGET"].Content, "🎯 PLAYERS")

local PlayerListFrame = Instance.new("Frame", Tabs["TARGET"].Content)
PlayerListFrame.Size = UDim2.new(1, 0, 0, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
PlayerListFrame.BackgroundTransparency = 0.2
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.AutomaticSize = Enum.AutomaticSize.Y
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIListLayout", PlayerListFrame).Padding = UDim.new(0, 4)
Instance.new("UIPadding", PlayerListFrame).PaddingTop = UDim.new(0, 8)
Instance.new("UIPadding", PlayerListFrame).PaddingBottom = UDim.new(0, 8)
Instance.new("UIPadding", PlayerListFrame).PaddingLeft = UDim.new(0, 12)

local function CreatePlayerButton(player)
    if player == LocalPlayer then return end
    
    local ButtonFrame = Instance.new("Frame", PlayerListFrame)
    ButtonFrame.Size = UDim2.new(1, 0, 0, 65)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    ButtonFrame.BackgroundTransparency = 0.2
    ButtonFrame.BorderSizePixel = 0
    Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
    
    local NameLabel = Instance.new("TextLabel", ButtonFrame)
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.DisplayName
    NameLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    NameLabel.TextSize = 13
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local RoleLabel = Instance.new("TextLabel", ButtonFrame)
    RoleLabel.Size = UDim2.new(1, 0, 0, 15)
    RoleLabel.Position = UDim2.new(0, 0, 0, 25)
    RoleLabel.BackgroundTransparency = 1
    local role = GetPlayerRole(player)
    RoleLabel.Text = role
    RoleLabel.TextColor3 = GetRoleColor(role)
    RoleLabel.TextSize = 11
    RoleLabel.Font = Enum.Font.Gotham
    RoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ActionFrame = Instance.new("Frame", ButtonFrame)
    ActionFrame.Size = UDim2.new(1, 0, 0, 25)
    ActionFrame.Position = UDim2.new(0, 0, 0, 40)
    ActionFrame.BackgroundTransparency = 1
    Instance.new("UIListLayout", ActionFrame).Padding = UDim.new(0, 4)
    Instance.new("UIListLayout", ActionFrame).FillDirection = Enum.FillDirection.Horizontal
    
    local TPBtn = Instance.new("TextButton", ActionFrame)
    TPBtn.Size = UDim2.new(0, 50, 1, 0)
    TPBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
    TPBtn.Text = "TP"
    TPBtn.TextColor3 = Color3.new(1, 1, 1)
    TPBtn.TextSize = 11
    TPBtn.Font = Enum.Font.GothamBold
    TPBtn.BorderSizePixel = 0
    Instance.new("UICorner", TPBtn).CornerRadius = UDim.new(0, 4)
    TPBtn.MouseButton1Click:Connect(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
        end
    end)
    
    local SpectateBtn = Instance.new("TextButton", ActionFrame)
    SpectateBtn.Size = UDim2.new(0, 70, 1, 0)
    SpectateBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
    SpectateBtn.Text = "Spectate"
    SpectateBtn.TextColor3 = Color3.new(1, 1, 1)
    SpectateBtn.TextSize = 11
    SpectateBtn.Font = Enum.Font.GothamBold
    SpectateBtn.BorderSizePixel = 0
    Instance.new("UICorner", SpectateBtn).CornerRadius = UDim.new(0, 4)
    
    local spectating = false
    local spectateThread = nil
    SpectateBtn.MouseButton1Click:Connect(function()
        spectating = not spectating
        if spectating then
            SpectateBtn.Text = "Stop"
            spectateThread = RunService.Heartbeat:Connect(function()
                local camera = Workspace.CurrentCamera
                local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    camera.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 10)
                end
            end)
        else
            SpectateBtn.Text = "Spectate"
            if spectateThread then spectateThread:Disconnect() end
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end)
    
    local FreezeBtn = Instance.new("TextButton", ActionFrame)
    FreezeBtn.Size = UDim2.new(0, 55, 1, 0)
    FreezeBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
    FreezeBtn.Text = "Freeze"
    FreezeBtn.TextColor3 = Color3.new(1, 1, 1)
    FreezeBtn.TextSize = 11
    FreezeBtn.Font = Enum.Font.GothamBold
    FreezeBtn.BorderSizePixel = 0
    Instance.new("UICorner", FreezeBtn).CornerRadius = UDim.new(0, 4)
    
    local frozen = false
    local freezeThread = nil
    FreezeBtn.MouseButton1Click:Connect(function()
        frozen = not frozen
        if frozen then
            FreezeBtn.Text = "Unfreeze"
            freezeThread = RunService.Heartbeat:Connect(function()
                local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    targetRoot.AssemblyLinearVelocity = Vector3.zero
                    targetRoot.Anchored = true
                end
            end)
        else
            FreezeBtn.Text = "Freeze"
            if freezeThread then freezeThread:Disconnect() end
            local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then targetRoot.Anchored = false end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    CreatePlayerButton(player)
end

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    CreatePlayerButton(player)
end)

Players.PlayerRemoving:Connect(function(player)
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
            if child:FindFirstChild("TextLabel").Text == player.DisplayName then
                child:Destroy()
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
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

CloseBtn.MouseButton1Click:Connect(function() if isOpen then ToggleMenu() end end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then ToggleMenu() end
end)

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

task.wait(0.5)
Tabs["COMBAT"].Button.BackgroundColor3 = Color3.fromRGB(70, 100, 220)
Tabs["COMBAT"].Button.BackgroundTransparency = 0
Tabs["COMBAT"].Button.TextColor3 = Color3.new(1, 1, 1)
Tabs["COMBAT"].Content.Visible = true
ActiveTab = "COMBAT"
ToggleMenu()

print("✅ FlonsetHUB v6.0 loaded!")
print(" Press [G] to toggle menu")
