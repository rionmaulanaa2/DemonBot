-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Noire Blox",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FastAttackConfig"
})

-- Settings for Fast Attack
_G.Settings = {
    Configs = {
        ["Fast Attack"] = false,
        ["Fast Attack Type"] = "Normal" -- Default: Normal
    }
}

-- Fast Attack Tab
local FastAttackTab = Window:MakeTab({
    Name = "Fast Attack",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Debug Tab
local DebugTab = Window:MakeTab({
    Name = "Debug",
    Icon = "rbxassetid://4483345998", -- Replace with any suitable icon ID
    PremiumOnly = false
})

-- Variables to store logs
local debugLogs = {}
local errorLogs = {}

-- Add UI elements for debug and error logs
local DebugLabel = DebugTab:AddLabel("Debug Logs:")
local ErrorLabel = DebugTab:AddLabel("Error Logs:")


-- Status Tab
local StatusTab = Window:MakeTab({
    Name = "Status",
    Icon = "rbxassetid://4483345998", -- Replace with any suitable icon ID
    PremiumOnly = false
})


-- Fast Attack Toggle
FastAttackTab:AddToggle({
    Name = "Enable Fast Attack",
    Default = _G.Settings.Configs["Fast Attack"],
    Callback = function(value)
        _G.Settings.Configs["Fast Attack"] = value
        print("Fast Attack: " .. tostring(value))
    end
})

-- Fast Attack Type Dropdown
FastAttackTab:AddDropdown({
    Name = "Fast Attack Type",
    Default = _G.Settings.Configs["Fast Attack Type"],
    Options = {"Normal", "Fast", "Slow", "Extreme"},
    Callback = function(value)
        _G.Settings.Configs["Fast Attack Type"] = value
        print("Fast Attack Type set to: " .. value)
    end
})

-- Weapon Dropdown Options
local WeaponTypes = {"Melee", "Sword", "Fruit"}
local SelectWeapon = nil

-- Add Select Weapon Dropdown to Fast Attack Tab
FastAttackTab:AddDropdown({
    Name = "Select Weapon",
    Default = "Sword",
    Options = WeaponTypes,
    Callback = function(value)
        SelectWeapon = value
        print("Selected Weapon Type: " .. value)
    end
})

-- [require module]

local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(game:GetService("Players")["LocalPlayer"].PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]
local realbhit = require(game.ReplicatedStorage.CombatFramework.RigLib)
local cooldownfastattack = tick()

-- Fast Attack Logic
coroutine.wrap(function()
    while task.wait(0.1) do
        local ac = CombatFrameworkR.activeController
        if ac and ac.equipped then
            if _G.Settings.Configs["Fast Attack"] then
                AttackFunction()
                if _G.Settings.Configs["Fast Attack Type"] == "Normal" then
                    if tick() - cooldownfastattack > 0.9 then wait(0.1) cooldownfastattack = tick() end
                elseif _G.Settings.Configs["Fast Attack Type"] == "Fast" then
                    if tick() - cooldownfastattack > 1.5 then wait(0.01) cooldownfastattack = tick() end
                elseif _G.Settings.Configs["Fast Attack Type"] == "Extreme" then
                    if tick() - cooldownfastattack > 0.5 then wait(0.001) cooldownfastattack = tick() end
                elseif _G.Settings.Configs["Fast Attack Type"] == "Slow" then
                    if tick() - cooldownfastattack > 0.3 then wait(0.7) cooldownfastattack = tick() end
                end
            else
                if ac.hitboxMagnitude ~= 55 then
                    ac.hitboxMagnitude = 55
                end
                ac:attack()
            end
        end
    end
end)()

function getAllBladeHits(Sizes)
	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Enemies = game:GetService("Workspace").Enemies:GetChildren()
	for i=1,#Enemies do local v = Enemies[i]
		local Human = v:FindFirstChildOfClass("Humanoid")
		if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 then
			table.insert(Hits,Human.RootPart)
		end
	end
	return Hits
end

function CurrentWeapon()
	local ac = CombatFrameworkR.activeController
	local ret = ac.blades[1]
	if not ret then return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name end
	pcall(function()
		while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
	end)
	if not ret then return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name end
	return ret
end

function AttackFunction()
	local ac = CombatFrameworkR.activeController
	if ac and ac.equipped then
		for indexincrement = 1, 1 do
			local bladehit = getAllBladeHits(60)
			if #bladehit > 0 then
				local AcAttack8 = debug.getupvalue(ac.attack, 5)
				local AcAttack9 = debug.getupvalue(ac.attack, 6)
				local AcAttack7 = debug.getupvalue(ac.attack, 4)
				local AcAttack10 = debug.getupvalue(ac.attack, 7)
				local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
				local NumberAc13 = AcAttack7 * 798405
				(function()
					NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
					AcAttack8 = math.floor(NumberAc12 / AcAttack9)
					AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
				end)()
				AcAttack10 = AcAttack10 + 1
				debug.setupvalue(ac.attack, 5, AcAttack8)
				debug.setupvalue(ac.attack, 6, AcAttack9)
				debug.setupvalue(ac.attack, 4, AcAttack7)
				debug.setupvalue(ac.attack, 7, AcAttack10)
				for k, v in pairs(ac.animator.anims.basic) do
					v:Play(0.01,0.01,0.01)
				end                 
				if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and ac.blades and ac.blades[1] then 
					game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(CurrentWeapon()))
					game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
					game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 2, "") 
				end
			end
		end
	end
end

-- Background Weapon Selection Logic
task.spawn(function()
    while task.wait() do
        pcall(function()
            if SelectWeapon == "Melee" then
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.Settings.Configs["Select Weapon"] = v.Name
                            print("Selected Weapon: " .. v.Name)
                        end
                    end
                end
            elseif SelectWeapon == "Sword" then
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.Settings.Configs["Select Weapon"] = v.Name
                            print("Selected Weapon: " .. v.Name)
                        end
                    end
                end
            elseif SelectWeapon == "Fruit" then
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.Settings.Configs["Select Weapon"] = v.Name
                            print("Selected Weapon: " .. v.Name)
                        end
                    end
                end
            else
                -- Default to Sword if no valid selection
                for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.Settings.Configs["Select Weapon"] = v.Name
                            print("Default Weapon Selected: " .. v.Name)
                        end
                    end
                end
            end
        end)
    end
end)

-- Function to update debug logs
local function updateDebugLogs(newLog)
    print("Debug: " .. newLog) -- Log to console
    table.insert(debugLogs, newLog)
    if #debugLogs > 10 then -- Keep the latest 10 logs
        table.remove(debugLogs, 1)
    end
    DebugLabel:Set("Debug Logs:\n" .. table.concat(debugLogs, "\n"))
end

-- Function to update error logs
local function updateErrorLogs(newLog)
    print("Error: " .. newLog) -- Log to console
    table.insert(errorLogs, newLog)
    if #errorLogs > 10 then -- Keep the latest 10 logs
        table.remove(errorLogs, 1)
    end
    ErrorLabel:Set("Error Logs:\n" .. table.concat(errorLogs, "\n"))
end

-- Example error handling
task.spawn(function()
    local success, err = pcall(function()
        -- Simulate an intentional error for logging purposes
        error("Example intentional error for debugging.")
    end)
    if not success then
        updateErrorLogs(err)
    end
end)


local function createOrUpdateLabel()
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = PlayerGui:FindFirstChild("LevelDisplayGui")

    -- If ScreenGui doesn't exist, create it
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui", PlayerGui)
        ScreenGui.Name = "LevelDisplayGui"
    end

    local LevelLabel = ScreenGui:FindFirstChild("LevelLabel")

    -- If LevelLabel doesn't exist, create it
    if not LevelLabel then
        LevelLabel = Instance.new("TextLabel", ScreenGui)
        LevelLabel.Name = "LevelLabel"
        LevelLabel.Size = UDim2.new(0, 200, 0, 50) -- Example size
        LevelLabel.Position = UDim2.new(0.5, -100, 0.1, 0) -- Example position
        LevelLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        LevelLabel.Font = Enum.Font.SourceSans
        LevelLabel.TextSize = 24
    end

    return LevelLabel
end


-- Player Level Status Logic
local LevelLabel = StatusTab:AddLabel("Player Level: Fetching...")

local function updatePlayerLevel()
    task.spawn(function()
        updateDebugLogs("Attempting to fetch player level...")
        local Player = game.Players.LocalPlayer
        local LevelLabel = createOrUpdateLabel()

        -- Check if Player has Data and Level, if not set to 0
        if Player:FindFirstChild("Data") then
            updateDebugLogs("Found Player Data.")
            if Player.Data:FindFirstChild("Level") then
                updateDebugLogs("Found Player Level.")
                local MyLevel = Player.Data.Level.Value
                updateDebugLogs("Player level fetched: " .. tostring(MyLevel))
                LevelLabel.Text = "Player Level: " .. tostring(MyLevel)
            else
                updateErrorLogs("Level not found under Data. Setting level to 0.")
                LevelLabel.Text = "Player Level: 0"
            end
        else
            updateErrorLogs("Data not found for player. Setting level to 0.")
            LevelLabel.Text = "Player Level: 0"
        end
    end)
end

-- Periodically update player level
task.spawn(function()
    while task.wait(5) do -- Update every 5 seconds
        updatePlayerLevel()
    end
end)


-- Initialize UI
OrionLib:Init()
