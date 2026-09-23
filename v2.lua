--[[
    KITI-Style GUI  •  cross-platform
    Работает на: Arceus X, Xeno, Solara, Real, Synapse, Krnl, Fluxus
    
    Использование:
        local lib = loadstring(game:HttpGet("URL"))()
        local win = lib:window({name = "MM2", subtitle = "Murder Mystery 2"})
        local tab = win:tab({name = "Main", icon = "home"})
        local sec = tab:section({name = "shoot murderer"})
        sec:toggle({name = "Auto Shoot", default = false, callback = function(v) end})
        sec:slider({name = "FOV", min = 0, max = 500, default = 200, callback = function(v) end})
        sec:dropdown({name = "Mode", values = {"A", "B"}, default = "A", callback = function(v) end})
        sec:keybind({name = "Panic", default = "None", callback = function(k) end})
]]

--============================================================
-- SERVICES
--============================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local LP                = Players.LocalPlayer

--============================================================
-- PLATFORM DETECTION
--============================================================
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_PC     = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

--============================================================
-- API FALLBACKS (важно для кроссплатформы!)
--============================================================
local function safe_hui()
    -- 1. gethui (Real, Synapse, Xeno, Solara)
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    -- 2. CoreGui (большинство экзекуторов)
    local ok, cg = pcall(function() return CoreGui end)
    if ok and cg then return cg end
    -- 3. PlayerGui (Arceus X fallback)
    local ok2, pg = pcall(function()
        return LP:FindFirstChildOfClass("PlayerGui")
    end)
    if ok2 and pg then return pg end
    return game:GetService("CoreGui")
end

local function safe_asset(path)
    -- для картинок если понадобятся
    local fn = getcustomasset or getsynasset
        or (syn and syn.get_custom_asset)
        or (fluxus and fluxus.get_custom_asset)
    if type(fn) == "function" then
        local ok, res = pcall(fn, path)
        if ok then return res end
    end
    return nil
end

--============================================================
-- THEME (KITI-style)
--============================================================
local Theme = {
    -- фон (тёмно-коричневый как в KITI)
    Background      = Color3.fromRGB(15, 13, 11),
    Card            = Color3.fromRGB(22, 20, 18),
    CardHover       = Color3.fromRGB(28, 25, 22),
    Sidebar         = Color3.fromRGB(12, 10, 9),
    Header          = Color3.fromRGB(18, 16, 14),
    
    -- фиолетовый акцент
    Accent          = Color3.fromRGB(168, 85, 247),
    AccentDim       = Color3.fromRGB(120, 60, 180),
    AccentGlow      = Color3.fromRGB(200, 130, 255),
    
    -- текст
    Text            = Color3.fromRGB(240, 240, 245),
    TextDim         = Color3.fromRGB(140, 135, 130),
    TextMuted       = Color3.fromRGB(90, 88, 85),
    
    -- элементы
    ToggleOff       = Color3.fromRGB(55, 52, 50),
    ToggleOn        = Color3.fromRGB(168, 85, 247),
    Outline         = Color3.fromRGB(35, 32, 30),
    OutlineLight    = Color3.fromRGB(50, 46, 43),
    
    -- шрифт
    Font            = Enum.Font.GothamMedium,
    FontBold        = Enum.Font.GothamBold,
}

--============================================================
-- HELPERS
--============================================================
local function new(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function tween(inst, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local function corner(parent, radius)
    return new("UICorner", { CornerRadius = radius or UDim.new(0, 8) }, parent)
end

local function stroke(parent, color, thickness)
    return new("UIStroke", {
        Color = color or Theme.Outline,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

--============================================================
-- ROOT GUI
--============================================================
local Root = new("ScreenGui", {
    Name = "KITI_Style_" .. tostring(math.random(100000, 999999)),
    ResetOnSpawn = false,
    IgnoreGuiInset = IS_MOBILE,  -- на ПК false (иначе клики не работают!)
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = IS_MOBILE and 999 or 10,  -- на ПК умеренный
}, safe_hui())

--============================================================
-- LIB TABLE
--============================================================
local Lib = {}
Lib.Theme = Theme

--============================================================
-- WINDOW
--============================================================
function Lib:window(cfg)
    cfg = cfg or {}
    
    local Window = new("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 700, 0, 460),
        Position = UDim2.new(0.5, -350, 0.5, -230),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,  -- ВАЖНО для ПК!
        ClipsDescendants = true,
        Visible = true,
    }, Root)
    corner(Window, UDim.new(0, 10))
    stroke(Window, Theme.Outline, 1)
    
    --============================================================
    -- HEADER
    --============================================================
    local Header = new("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Active = true,
    }, Window)
    corner(Header, UDim.new(0, 10))
    
    -- костыль чтобы сгладить нижние углы header
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
    }, Header)
    
    -- Logo
    local LogoFrame = new("Frame", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 12, 0.5, -16),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, Header)
    corner(LogoFrame, UDim.new(0, 8))
    
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "K",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Theme.FontBold,
        TextSize = 18,
    }, LogoFrame)
    
    -- Title
    new("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 0, 18),
        Position = UDim2.new(0, 52, 0, 6),
        BackgroundTransparency = 1,
        Text = cfg.name or "KITI",
        TextColor3 = Theme.Text,
        Font = Theme.FontBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Header)
    
    new("TextLabel", {
        Size = UDim2.new(0, 200, 0, 12),
        Position = UDim2.new(0, 52, 0, 22),
        BackgroundTransparency = 1,
        Text = cfg.subtitle or "Murder Mystery 2",
        TextColor3 = Theme.TextDim,
        Font = Theme.Font,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Header)
    
    --============================================================
    -- SEARCH (сверху справа)
    --============================================================
    local SearchFrame = new("Frame", {
        Size = UDim2.new(0, 180, 0, 26),
        Position = UDim2.new(1, -230, 0.5, -13),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
    }, Header)
    corner(SearchFrame, UDim.new(0, 6))
    stroke(SearchFrame, Theme.Outline, 1)
    
    new("ImageLabel", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 8, 0.5, -6),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(24, 924),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = Theme.TextDim,
    }, SearchFrame)
    
    new("TextBox", {
        Name = "SearchBox",
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.TextMuted,
        TextColor3 = Theme.Text,
        Font = Theme.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, SearchFrame)
    
    --============================================================
    -- CLOSE BUTTON
    --============================================================
    local CloseBtn = new("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -38, 0.5, -13),
        BackgroundColor3 = Theme.Card,
        Text = "✕",
        TextColor3 = Theme.TextDim,
        Font = Theme.FontBold,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
    }, Header)
    corner(CloseBtn, UDim.new(0, 6))
    
    --============================================================
    -- SIDEBAR (только иконки, 60px)
    --============================================================
    local Sidebar = new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 60, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Active = true,
    }, Window)
    
    new("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, Sidebar)
    
    new("UIPadding", {
        PaddingTop = UDim.new(0, 12),
    }, Sidebar)
    
    --============================================================
    -- CONTENT AREA
    --============================================================
    local Content = new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -60, 1, -40),
        Position = UDim2.new(0, 60, 0, 40),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
    }, Window)
    
    --============================================================
    -- WATERMARK (снизу)
    --============================================================
    local Watermark = new("Frame", {
        Name = "Watermark",
        Size = UDim2.new(0, 200, 0, 22),
        Position = UDim2.new(0, 60, 1, -26),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Active = false,
    }, Window)
    corner(Watermark, UDim.new(0, 6))
    
    new("TextLabel", {
        Name = "WM_Text",
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "KITI  •  0 fps  •  0 ms",
        TextColor3 = Theme.Accent,
        Font = Theme.FontBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Watermark)
    
    --============================================================
    -- DRAG (окно можно двигать)
    --============================================================
    local dragging = false
    local dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    --============================================================
    -- WATERMARK UPDATE (FPS/Ping)
    --============================================================
    local fps = 0
    local lastTime = tick()
    local frames = 0
    
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - lastTime >= 1 then
            fps = frames
            frames = 0
            lastTime = tick()
        end
    end)
    
    task.spawn(function()
        while Window.Parent do
            task.wait(0.5)
            local ping = 0
            local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
            if ok and type(p) == "number" then ping = math.floor(p) end
            local txt = Watermark:FindFirstChild("WM_Text")
            if txt then
                txt.Text = string.format("KITI  •  %d fps  •  %d ms", fps, ping)
            end
        end
    end)
    
    --============================================================
    -- CLOSE BUTTON
    --============================================================
    CloseBtn.MouseButton1Click:Connect(function()
        Window.Visible = false
    end)
    
    --============================================================
    -- TABS SYSTEM
    --============================================================
    local Tabs = {}
    local ActiveTab = nil
    local ActiveBtn = nil
    
    --============================================================
    -- WINDOW OBJECT
    --============================================================
    local win = {}
    win.Window = Window
    win.Sidebar = Sidebar
    win.Content = Content
    
    function win:tab(cfg)
        cfg = cfg or {}
        
        -- Sidebar button (только иконка)
        local TabBtn = new("TextButton", {
            Name = "Tab_" .. (cfg.name or "tab"),
            Size = UDim2.new(0, 42, 0, 42),
            BackgroundColor3 = Theme.Sidebar,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Active = true,
        }, Sidebar)
        corner(TabBtn, UDim.new(0, 8))
        
        -- Иконка
        local TabIcon = new("ImageLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0.5, -10, 0.5, -10),
            BackgroundTransparency = 1,
            Image = cfg.icon or "rbxassetid://3926305904",
            ImageColor3 = Theme.TextDim,
        }, TabBtn)
        
        -- Page
        local Page = new("ScrollingFrame", {
            Name = "Page_" .. (cfg.name or "tab"),
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Active = true,
        }, Content)
        
        local PageLayout = new("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Page)
        
        --============================================================
        -- TAB SELECT LOGIC
        --============================================================
        local function selectTab()
            if ActiveTab == Page then return end
            if ActiveBtn then
                tween(ActiveBtn, 0.15, { BackgroundColor3 = Theme.Sidebar })
                local oldIcon = ActiveBtn:FindFirstChildWhichIsA("ImageLabel")
                if oldIcon then tween(oldIcon, 0.15, { ImageColor3 = Theme.TextDim }) end
            end
            tween(TabBtn, 0.15, { BackgroundColor3 = Theme.Accent })
            tween(TabIcon, 0.15, { ImageColor3 = Color3.new(1, 1, 1) })
            ActiveTab = Page
            ActiveBtn = TabBtn
            for _, otherPage in ipairs(Content:GetChildren()) do
                if otherPage:IsA("ScrollingFrame") then
                    otherPage.Visible = (otherPage == Page)
                end
            end
        end
        
        TabBtn.MouseButton1Click:Connect(selectTab)
        TabBtn.Activated:Connect(selectTab)  -- для тача
        
        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if ActiveBtn ~= TabBtn then
                tween(TabBtn, 0.1, { BackgroundColor3 = Theme.CardHover })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if ActiveBtn ~= TabBtn then
                tween(TabBtn, 0.1, { BackgroundColor3 = Theme.Sidebar })
            end
        end)
        
        -- Автовыбор первого таба
        if not ActiveTab then
            selectTab()
        end
        
        Tabs[cfg.name or "tab"] = Page
        
        --============================================================
        -- TAB OBJECT
        --============================================================
        local tab = {}
        tab.Page = Page
        
        function tab:section(scfg)
            scfg = scfg or {}
            
            -- Контейнер секции
            local SectionFrame = new("Frame", {
                Name = "Section_" .. (scfg.name or "section"),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                Active = true,
            }, Page)
            corner(SectionFrame, UDim.new(0, 8))
            
            -- Заголовок
            local SecHeader = new("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
            }, SectionFrame)
            
            new("TextLabel", {
                Name = "SecTitle",
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = (scfg.name or "section"):upper(),
                TextColor3 = Theme.Accent,
                Font = Theme.FontBold,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, SecHeader)
            
            -- Внутренний контейнер
            local SecContent = new("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 28),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Active = true,
            }, SectionFrame)
            
            new("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, SecContent)
            
            --============================================================
            -- SECTION OBJECT
            --============================================================
            local section = {}
            section.Content = SecContent
            section.Frame = SectionFrame
            
            --==========================================
