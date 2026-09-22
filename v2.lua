-- ═══════════════════════════════════════════════════════════════
-- FLONSET HUB - BASE GUI
-- Clean skeleton for MM2 cheat
-- ═══════════════════════════════════════════════════════════════

-- Загружаем UI библиотеку (Rayfield - стабильная и красивая)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ═══════════════════════════════════════════════════════════════
-- ГЛАВНОЕ ОКНО
-- ═══════════════════════════════════════════════════════════════
local Window = Rayfield:CreateWindow({
    Name = "FlonsetHUB | MM2",
    LoadingTitle = "FlonsetHUB Interface",
    LoadingSubtitle = "by You",
    Theme = "Default",
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FlonsetHUB",
        FileName = "Config_" .. tostring(game.Players.LocalPlayer.UserId)
    },
    
    Discord = {
        Enabled = false,
    },
    
    KeySystem = false,
})

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: COMBAT (Боевка)
-- ═══════════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", 4483362458)

local CombatAim = CombatTab:CreateSection("Aimbot")
-- Сюда будем пастить Silent Aim, Prediction и т.д.

local CombatAura = CombatTab:CreateSection("Kill Aura")
-- Сюда Kill Aura, Auto Stab

local CombatAuto = CombatTab:CreateSection("Auto")
-- Сюда Auto Shoot, Auto Throw

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: VISUALS (Визуалы)
-- ═══════════════════════════════════════════════════════════════
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local VisualsESP = VisualsTab:CreateSection("ESP")
-- Сюда Box, Name, Distance, Skeleton, Arrows

local VisualsChams = VisualsTab:CreateSection("Chams")
-- Сюда Glow Chams, Material Chams

local VisualsWorld = VisualsTab:CreateSection("World")
-- Сюда Fullbright, Shaders, Skybox, Fog, Weather Effects

local VisualsLocal = VisualsTab:CreateSection("Local")
-- Сюда Self Chams, Tool Chams, China Hat, Backtrack

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: PLAYER (Игрок)
-- ═══════════════════════════════════════════════════════════════
local PlayerTab = Window:CreateTab("Player", 4483362458)

local PlayerMove = PlayerTab:CreateSection("Movement")
-- Сюда Fly, Noclip, Infinite Jump, Wallhop, Pixel Surf

local PlayerChar = PlayerTab:CreateSection("Character")
-- Сюда WalkSpeed, JumpPower, Fake Headless, Fake Korblox, Model Changer

local PlayerMisc = PlayerTab:CreateSection("Misc")
-- Сюда Anti AFK, Anti Fling, Anti Void, Anti Trap

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: MISC (Разное)
-- ═══════════════════════════════════════════════════════════════
local MiscTab = Window:CreateTab("Misc", 4483362458)

local MiscTools = MiscTab:CreateSection("Tools")
-- Сюда TP Tool, Fling Tool, Show Values, Teleport to Map

local MiscFarm = MiscTab:CreateSection("Farming")
-- Сюда Auto Farm, Auto Grab Gun

local MiscAlerts = MiscTab:CreateSection("Alerts")
-- Сюда Notify (Miss/Kill/Roles), Custom Kill Sounds

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: TARGET (Цели)
-- ═══════════════════════════════════════════════════════════════
local TargetTab = Window:CreateTab("Target", 4483362458)

local TargetPlayers = TargetTab:CreateSection("Players")
-- Сюда список игроков с аватарками

local TargetActions = TargetTab:CreateSection("Actions")
-- Сюда Fling, Kill, Spectate, Headsit, Bang, Loop TP

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: SKINS (Скины)
-- ═══════════════════════════════════════════════════════════════
local SkinsTab = Window:CreateTab("Skins", 4483362458)

local SkinsFilter = SkinsTab:CreateSection("Filter")
-- Сюда фильтры (Slot, Rarity, Records)

local SkinsList = SkinsTab:CreateSection("Library")
-- Сюда галерея скинов ножей и пушек

-- ═══════════════════════════════════════════════════════════════
-- ВКЛАДКА: SETTINGS (Настройки)
-- ═══════════════════════════════════════════════════════════════
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local SettingsMenu = SettingsTab:CreateSection("Menu")

SettingsMenu:AddToggle({
    Name = "Menu Sounds",
    CurrentValue = false,
    Flag = "MenuSounds",
    Callback = function(Value)
        -- Звуки меню
    end,
})

SettingsMenu:AddKeybind({
    Name = "Menu Keybind",
    CurrentValue = "Insert",
    Flag = "MenuKeybind",
    Callback = function(Key)
        -- Бинд открытия меню
    end,
})

SettingsMenu:AddButton({
    Name = "Unload",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- ЗАГРУЗКА КОНФИГА
-- ═══════════════════════════════════════════════════════════════
Rayfield:LoadConfiguration()

-- Приветственное уведомление
Rayfield:Notify({
    Title = "FlonsetHUB",
    Content = "Welcome, " .. game.Players.LocalPlayer.DisplayName .. "! GUI loaded successfully.",
    Duration = 6,
    Image = 4483362458,
})
