-- Services
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace")
}

Services.LocalPlayer = Services.Players.LocalPlayer
Services.Camera = Workspace.CurrentCamera

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

-- Load Modules
local Aimbot = loadstring(game:HttpGet('https://raw.githubusercontent.com/tosindustries/pf/main/big_paintball_2/modules/aimbot.lua'))()
local ESP = loadstring(game:HttpGet('https://raw.githubusercontent.com/tosindustries/pf/main/big_paintball_2/modules/esp.lua'))()
local Utils = loadstring(game:HttpGet('https://raw.githubusercontent.com/tosindustries/pf/main/big_paintball_2/modules/utils.lua'))()

-- Create Window
local Window = Library:CreateWindow({
    Title = 'TOS Industries | Big Paintball 2',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- Create Tabs
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('Settings')
}

-- Create Aimbot UI Groups
local AimbotMain = Tabs.Aimbot:AddLeftGroupbox('Main')
local AimbotRealism = Tabs.Aimbot:AddRightGroupbox('Realism')
local AimbotFOV = Tabs.Aimbot:AddLeftGroupbox('FOV')
local AimbotAdvanced = Tabs.Aimbot:AddRightGroupbox('Advanced')

-- Aimbot Main Settings
AimbotMain:AddToggle('AimbotEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Tooltip = 'Toggles the aimbot on/off',
    Callback = function(Value)
        Aimbot.settings.enabled = Value
    end
})

AimbotMain:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = true,
    Tooltip = 'Prevents targeting teammates',
    Callback = function(Value)
        Aimbot.settings.teamCheck = Value
    end
})

AimbotMain:AddDropdown('TargetPart', {
    Values = {'Head', 'UpperTorso', 'HumanoidRootPart'},
    Default = 1,
    Multi = false,
    Text = 'Target Part',
    Tooltip = 'Select which part to target',
    Callback = function(Value)
        Aimbot.settings.targetPart = Value
    end
})

-- Aimbot Realism Settings
AimbotRealism:AddToggle('Smoothing', {
    Text = 'Enable Smoothing',
    Default = true,
    Tooltip = 'Makes aim movement more natural',
    Callback = function(Value)
        Aimbot.settings.smoothing = Value
    end
})

AimbotRealism:AddSlider('SmoothingAmount', {
    Text = 'Smoothing Amount',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Tooltip = 'Higher = smoother movement',
    Callback = function(Value)
        Aimbot.settings.smoothingAmount = Value
    end
})

-- FOV Settings
AimbotFOV:AddToggle('ShowFOV', {
    Text = 'Show FOV Circle',
    Default = true,
    Tooltip = 'Displays the FOV circle',
    Callback = function(Value)
        Aimbot.settings.showFOV = Value
    end
})

AimbotFOV:AddSlider('FOVSize', {
    Text = 'FOV Size',
    Default = 120,
    Min = 30,
    Max = 800,
    Rounding = 0,
    Tooltip = 'Adjusts the FOV circle size',
    Callback = function(Value)
        Aimbot.settings.fov = Value
    end
})

-- Create ESP UI Groups
local ESPMain = Tabs.Visuals:AddLeftGroupbox('ESP')
local ESPSettings = Tabs.Visuals:AddRightGroupbox('ESP Settings')

-- ESP Main Settings
ESPMain:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = false,
    Tooltip = 'Toggles ESP features',
    Callback = function(Value)
        ESP.settings.Enabled = Value
    end
})

ESPMain:AddToggle('ESPBoxes', {
    Text = 'Boxes',
    Default = false,
    Tooltip = 'Shows boxes around players',
    Callback = function(Value)
        ESP.settings.Boxes = Value
    end
})

ESPMain:AddToggle('ESPNames', {
    Text = 'Names',
    Default = false,
    Tooltip = 'Shows player names',
    Callback = function(Value)
        ESP.settings.Names = Value
    end
})

-- ESP Settings
ESPSettings:AddSlider('ESPMaxDistance', {
    Text = 'Max Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Tooltip = 'Maximum distance to render ESP',
    Callback = function(Value)
        ESP.settings.MaxDistance = Value
    end
})

-- UI Settings Tab
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 

-- Initialize
Library.ToggleKeybind = Options.MenuKeybind

-- Theme Manager
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('TOS Industries')
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Set up save/load system
Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- Initialize the script
local function Init()
    if not game:IsLoaded() then 
        game.Loaded:Wait()
    end
    
    -- Verify game
    if game.PlaceId ~= 3606833500 then -- Big Paintball 2 PlaceID
        return error("This script is only for Big Paintball 2!")
    end
    
    Library:Notify('Loading TOS Industries...', 3)
    
    -- Initialize modules with services
    Aimbot:init(Services)
    ESP:init(Services)
    
    Library:Notify('Successfully loaded!', 5)
end

return Init() 