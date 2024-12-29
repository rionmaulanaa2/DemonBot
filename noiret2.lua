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

-- Add a toggle to enable or disable showing the level
StatusTab:AddToggle({
    Name = "Show Player Level",
    Default = false,
    Callback = function(state)
        showLevel = state
        updatePlayerLevel()
    end
})
-- Initialize variables
local LevelLabel = StatusTab:AddLabel("Player Level: Hidden")
local showLevel = false


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

-- Improved getAllBladeHits with error handling
function getAllBladeHits(Sizes)
    local Hits = {}
    local Client = game.Players.LocalPlayer
    safeExecute(function()
        for _, v in ipairs(game:GetService("Workspace").Enemies:GetChildren()) do
            local Human = v:FindFirstChildOfClass("Humanoid")
            if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes + 5 then
                table.insert(Hits, Human.RootPart)
            end
        end
    end)
    return Hits
end

-- Function to safely execute with error handling
local function safeExecute(func)
    local success, err = pcall(func)
    if not success then
        updateErrorLogs(err)
    end
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

-- Optimized Background Weapon Selection Logic
task.spawn(function()
    while task.wait(2) do -- Adjusted wait time to prevent excessive checks
        safeExecute(function()
            if SelectWeapon then
                local weaponFound = false
                for _, v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == SelectWeapon then
                        weaponFound = true
                        if _G.Settings.Configs["Select Weapon"] ~= v.Name then
                            _G.Settings.Configs["Select Weapon"] = v.Name
                            print("Selected Weapon: " .. v.Name)
                        end
                        break
                    end
                end
                if not weaponFound then
                    print("No valid weapon found for selection.")
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


-- Enhanced UI Management in createOrUpdateLabel
local function createOrUpdateLabel()
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = PlayerGui:FindFirstChild("LevelDisplayGui")

    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui", PlayerGui)
        ScreenGui.Name = "LevelDisplayGui"
    else
        -- Clean up existing labels
        for _, v in ipairs(ScreenGui:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
    end

    local LevelLabel = Instance.new("TextLabel", ScreenGui)
    LevelLabel.Name = "LevelLabel"
    LevelLabel.Size = UDim2.new(0, 200, 0, 50)
    LevelLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
    LevelLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LevelLabel.Font = Enum.Font.SourceSans
    LevelLabel.TextSize = 24

    return LevelLabel
end




-- Function to update the player's level display
local function updatePlayerLevel()
    task.spawn(function()
        if showLevel then
            local Player = game.Players.LocalPlayer

            -- Check if Player has Data and Level
            if Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Level") then
                local MyLevel = Player.Data.Level.Value
                LevelLabel:Set("Player Level: " .. tostring(MyLevel))
            else
                LevelLabel:Set("Player Level: N/A")
            end
        else
            LevelLabel:Set("Player Level: Hidden")
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
