--[[
    MM2 Simple Cheat
    Без хуков, без silent aim, без новых API
    Работает везде где есть базовый экзекутор
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- родитель для GUI с fallback
local function getParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:FindFirstChildOfClass("PlayerGui")
end

local State = {
    esp = false,
    chams = false,
    killaura = false,
    fly = false,
    noclip = false,
    infjump = false,
    fullbright = false,
}

--============ ESP ============
local espData = {}

local function getRole(p)
    local char = p.Character
    local bp = p:FindFirstChildOfClass("Backpack")
    if (char and char:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    if (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then
        return "Murderer"
    end
    return "Innocent"
end

local function roleColor(r)
    if r == "Murderer" then return Color3.fromRGB(255,60,60) end
    if r == "Sheriff" then return Color3.fromRGB(60,180,255) end
    return Color3.fromRGB(240,240,240)
end

local function makeESP(p)
    if p == LP or espData[p] then return end
    local char = p.Character
    if not char then return end
    
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = getParent()
    
    local bb = Instance.new("BillboardGui")
    bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    bb.Size = UDim2.new(0, 200, 0, 40)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = getParent()
    
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1,0,0,16)
    nl.BackgroundTransparency = 1
    nl.Text = p.Name
    nl.TextColor3 = Color3.new(1,1,1)
    nl.TextStrokeTransparency = 0
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 13
    nl.Parent = bb
    
    local rl = Instance.new("TextLabel")
    rl.Size = UDim2.new(1,0,0,14)
    rl.Position = UDim2.new(0,0,0,16)
    rl.BackgroundTransparency = 1
    rl.TextStrokeTransparency = 0
    rl.Font = Enum.Font.GothamBold
    rl.TextSize = 11
    rl.Parent = bb
    
    espData[p] = {hl = hl, bb = bb, nl = nl, rl = rl}
end

local function updateESP()
    if not State.esp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if not espData[p] then makeESP(p) end
            local d = espData[p]
            if d then
                local role = getRole(p)
                local col = roleColor(role)
                d.hl.Adornee = char
                d.hl.FillColor = col
                d.hl.OutlineColor = col
                d.bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                d.rl.Text = "[" .. role .. "]"
                d.rl.TextColor3 = col
            end
        else
            local d = espData[p]
            if d then
                pcall(function() d.hl:Destroy() end)
                pcall(function() d.bb:Destroy() end)
                espData[p] = nil
            end
        end
    end
end

--============ KILL AURA ============
local function getKnife()
    local char = LP.Character
    if char and char:FindFirstChild("Knife") then return char.Knife end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp and bp:FindFirstChild("Knife") then return bp.Knife end
    return nil
end

local function doKillAura()
    if not State.killaura then return end
    local knife = getKnife()
    if not knife then return end
    if knife.Parent ~= LP.Character then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(knife) end) end
        return
    end
    local ev = knife:FindFirstChild("Events")
    if not ev then return end
    local stab = ev:FindFirstChild("KnifeStabbed")
    local touch = ev:FindFirstChild("HandleTouched")
    if not stab or not touch then return end
    
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= 15 then
                pcall(function() stab:FireServer() end)
                pcall(function() touch:FireServer(root) end)
            end
        end
    end
end

--============ FLY ============
local flyBV, flyBG
local function startFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(4e5,4e5,4e5)
    flyBG.P = 9000
    flyBG.Parent = hrp
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(4e5,4e5,4e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
end

local function updateFly()
    if not State.fly then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not flyBV then startFly() return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    flyBG.CFrame = cam.CFrame
    local m = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m = m - Vector3.yAxis end
    if m.Magnitude > 0 then m = m.Unit * 60 end
    flyBV.Velocity = m
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

--============ NOCLIP ============
local function updateNoclip()
    if not State.noclip then return end
    local char = LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

--============ INF JUMP ============
UserInputService.JumpRequest:Connect(function()
    if State.infjump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--============ FULLBRIGHT ============
local origL = {}
local function saveL()
    local L = game:GetService("Lighting")
    origL.b = L.Brightness
    origL.a = L.Ambient
    origL.o = L.OutdoorAmbient
    origL.g = L.GlobalShadows
    origL.c = L.ClockTime
    origL.f = L.FogEnd
end
local function applyFB()
    local L = game:GetService("Lighting")
    L.Brightness = 2
    L.Ambient = Color3.fromRGB(150,150,150)
    L.OutdoorAmbient = Color3.fromRGB(150,150,150)
    L.GlobalShadows = false
    L.ClockTime = 14
    L.FogEnd = 100000
end
local function restoreL()
    local L = game:GetService("Lighting")
    if origL.b then
        L.Brightness = origL.b
        L.Ambient = origL.a
        L.OutdoorAmbient = origL.o
        L.GlobalShadows = origL.g
        L.ClockTime = origL.c
        L.FogEnd = origL.f
    end
end
saveL()

--============ MAIN LOOP ============
RunService.Heartbeat:Connect(function()
    pcall(updateESP)
    pcall(doKillAura)
    pcall(updateFly)
    pcall(updateNoclip)
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.fly then startFly() end
end)

--============ GUI ============
local Theme = {
    bg = Color3.fromRGB(18,16,14),
    card = Color3.fromRGB(26,24,22),
    accent = Color3.fromRGB(168,85,247),
    text = Color3.fromRGB(240,240,245),
    dim = Color3.fromRGB(140,135,130),
    off = Color3.fromRGB(55,52,50),
}

local Root = Instance.new("ScreenGui")
Root.Name = "MM2_" .. math.random(100000,999999)
Root.ResetOnSpawn = false
Root.IgnoreGuiInset = false
Root.DisplayOrder = 10
Root.Parent = getParent()

local W = Instance.new("Frame")
W.Size = UDim2.new(0, 380, 0, 400)
W.Position = UDim2.new(0.5, -190, 0.5, -200)
W.BackgroundColor3 = Theme.bg
W.BorderSizePixel = 0
W.Active = true
W.Parent = Root

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
    c.Parent = p
    return c
end

corner(W, UDim.new(0, 10))

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40,38,35)
stroke.Thickness = 1
stroke.Parent = W

local H = Instance.new("Frame")
H.Size = UDim2.new(1,0,0,40)
H.BackgroundColor3 = Theme.card
H.BorderSizePixel = 0
H.Active = true
H.Parent = W
corner(H, UDim.new(0,10))

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,14,0,0)
title.BackgroundTransparency = 1
title.Text = "MM2 Simple"
title.TextColor3 = Theme.text
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = H

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0,26,0,26)
closeB.Position = UDim2.new(1,-34,0.5,-13)
closeB.BackgroundColor3 = Theme.card
closeB.Text = "X"
closeB.TextColor3 = Theme.dim
closeB.Font = Enum.Font.GothamBold
closeB.TextSize = 14
closeB.BorderSizePixel = 0
closeB.AutoButtonColor = false
closeB.Active = true
closeB.Parent = H
corner(closeB, UDim.new(0,6))

local C = Instance.new("ScrollingFrame")
C.Size = UDim2.new(1,-16,1,-52)
C.Position = UDim2.new(0,8,0,44)
C.BackgroundTransparency = 1
C.BorderSizePixel = 0
C.ScrollBarThickness = 3
C.ScrollBarImageColor3 = Theme.accent
C.CanvasSize = UDim2.new(0,0,0,0)
C.AutomaticCanvasSize = Enum.AutomaticSize.Y
C.Active = true
C.Parent = W

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = C

local function toggle(name, getter, setter)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,32)
    row.BackgroundColor3 = Theme.card
    row.BorderSizePixel = 0
    row.Active = true
    row.Parent = C
    corner(row, UDim.new(0,6))
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Theme.text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local state = getter()
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0,36,0,18)
    sw.Position = UDim2.new(1,-46,0.5,-9)
    sw.BackgroundColor3 = state and Theme.accent or Theme.off
    sw.BorderSizePixel = 0
    sw.Parent = row
    corner(sw, UDim.new(1,0))
    
    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0,14,0,14)
    kn.Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    kn.BackgroundColor3 = Color3.new(1,1,1)
    kn.BorderSizePixel = 0
    kn.Parent = sw
    corner(kn, UDim.new(1,0))
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Active = true
    btn.Parent = row
    
    local function toggleFn()
        state = not state
        sw.BackgroundColor3 = state and Theme.accent or Theme.off
        kn.Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
        setter(state)
    end
    
    btn.MouseButton1Click:Connect(toggleFn)
    btn.Activated:Connect(toggleFn)
end

toggle("ESP", function() return State.esp end, function(v) State.esp = v end)
toggle("Kill Aura", function() return State.killaura end, function(v) State.killaura = v end)
toggle("Fly", function() return State.fly end, function(v)
    State.fly = v
    if v then startFly() else stopFly() end
end)
toggle("Noclip", function() return State.noclip end, function(v) State.noclip = v end)
toggle("Infinite Jump", function() return State.infjump end, function(v) State.infjump = v end)
toggle("Fullbright", function() return State.fullbright end, function(v)
    State.fullbright = v
    if v then applyFB() else restoreL() end
end)

-- drag
local dragging, dragStart, startPos = false, nil, nil
H.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = W.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        W.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local visible = true
closeB.MouseButton1Click:Connect(function()
    W.Visible = false
    visible = false
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        visible = not visible
        W.Visible = visible
    end
end)

print("[MM2 Simple] Загружено! RightShift — меню")
