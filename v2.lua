-- =======================================================
-- FLONSET PREMIUM MM2 HUB FOR XENO (RAYFIELD UI FIXED)
-- =======================================================
print("[XENO-FLONSET] Инициализация премиум-интерфейса...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Переменные для функций чита
local speedEnabled = false
local speedValue = 32
local espEnabled = false
local grabEnabled = false
local shootMurdererEnabled = false

local activeEsp = {}

-- ИСПРАВЛЕНО: Загружаем стабильное зеркало Rayfield из официального репозитория GitHub
local Rayfield = loadstring(game:HttpGet('https://githubusercontent.com'))()

-- Создаем главное окно чита
local Window = Rayfield:CreateWindow({
   Name = "FLONSET PREMIUM V2 (MM2)",
   LoadingTitle = "Flonset Hub Loading...",
   LoadingSubtitle = "by abobka694-collab",
   Theme = "DarkTheme", -- Стильная темная тема
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = { Enabled = false }
})

-- =======================================================
-- ВКЛАДКА 1: VISUALS (Профессиональное 2D-Box ESP)
-- =======================================================
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

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

VisualsTab:CreateToggle({
   Name = "2D Box ESP (Through Walls)",
   CurrentValue = false,
   Flag = "BoxEspToggle",
   Callback = function(Value)
      espEnabled = Value
      if Value then
          for _, p in ipairs(Players:GetPlayers()) do createEsp(p) end
      else
          for p, _ in pairs(activeEsp) do removeEsp(p) end
          table.clear(activeEsp)
      end
   end,
})

Players.PlayerAdded:Connect(function(p)
    if espEnabled then createEsp(p) end
end)

-- =======================================================
-- ВКЛАДКА 2: MOVEMENT (Скорость и Автоподбор)
-- =======================================================
local MovementTab = Window:CreateTab("Movement", 4483362618)

MovementTab:CreateToggle({
   Name = "Enable Speed Hack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      speedEnabled = Value
   end,
})

MovementTab:CreateSlider({
   Name = "Speed Value",
   Min = 16,
   Max = 100,
   DefaultValue = 32,
   Color = Color3.fromRGB(0, 150, 100),
   Increment = 1,
   ValueName = "Studs",
   Flag = "SpeedSlider",
   Callback = function(Value)
      speedValue = Value
   end,
})

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = speedEnabled and speedValue or 16 end
        end)
    end
end)

MovementTab:CreateToggle({
   Name = "Auto-Grab Dropped Gun",
   CurrentValue = false,
   Flag = "GrabToggle",
   Callback = function(Value)
      grabEnabled = Value
   end,
})

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if grabEnabled then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local gunDrop = workspace:FindFirstChild("GunDrop")
                if gunDrop and hrp then
                    local distance = (hrp.Position - gunDrop.Position).Magnitude
                    local duration = distance / 45
                    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(gunDrop, tweenInfo, {CFrame = hrp.CFrame})
                    tween:Play()
                end
            end
        end)
    end
end)

-- =======================================================
-- ВКЛАДКА 3: TARGET (Аимбот / Авто-выстрел)
-- =======================================================
local TargetTab = Window:CreateTab("Target", 4483364237)

local function findMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local knife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if knife and hum and hum.Health > 0 then return player end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if shootMurdererEnabled then
                local char = LocalPlayer.Character
                local gun = char and char:FindFirstChild("Gun")
                if gun and gun:FindFirstChild("Shoot") and gun.Shoot:IsA("RemoteEvent") then
                    local m = findMurderer()
                    if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = m.Character.HumanoidRootPart
                        local myHrp = char:FindFirstChild("HumanoidRootPart")
                        if myHrp and targetHrp then
                            gun.Shoot:FireServer(myHrp.CFrame, CFrame.new(targetHrp.Position))
                            task.wait(1)
                        end
                    end
                end
            end
        end)
    end
end)

TargetTab:CreateToggle({
   Name = "Shoot Murderer (Auto-Aim)",
   CurrentValue = false,
   Flag = "ShootToggle",
   Callback = function(Value)
      shootMurdererEnabled = Value
   end,
})

-- =======================================================
-- ВКЛАДКА 4: CONFIG (Управление скриптом)
-- =======================================================
local ConfigTab = Window:CreateTab("Config", 4483362748)

ConfigTab:CreateButton({
   Name = "Close / Unload Script",
   Callback = function()
      speedEnabled = false espEnabled = false grabEnabled = false shootMurdererEnabled = false
      for p, _ in pairs(activeEsp) do removeEsp(p) end
      table.clear(activeEsp)
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "Flonset Hub Loaded!",
   Content = "Enjoy professional features on Xeno.",
   Duration = 5,
   Image = 4483362458,
   Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
})
