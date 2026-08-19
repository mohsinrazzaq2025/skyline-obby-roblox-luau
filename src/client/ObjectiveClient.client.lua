local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local finishEvent =
	ReplicatedStorage:WaitForChild("FinishEvent")

local restartEvent =
	ReplicatedStorage:WaitForChild("RestartEvent")

local REQUIRED_COINS = 5
local LEAVE_DISTANCE = 5

local leaderstats =
	player:WaitForChild("leaderstats")

local coins =
	leaderstats:WaitForChild("Coins")

local playerGui =
	player:WaitForChild("PlayerGui")

-- Remove duplicate GUI
local oldGui = playerGui:FindFirstChild("ObjectiveGui")

if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObjectiveGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = false
screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets

local objectiveLabel = Instance.new("TextLabel")
objectiveLabel.Name = "ObjectiveLabel"
objectiveLabel.AnchorPoint = Vector2.new(0.5, 0)

-- Positioned above the timer
objectiveLabel.Position = UDim2.new(0.5, 0, 0, 4)
objectiveLabel.Size = UDim2.fromOffset(330, 58)

objectiveLabel.BackgroundColor3 =
	Color3.fromRGB(25, 35, 55)

objectiveLabel.BackgroundTransparency = 0.1

objectiveLabel.TextColor3 =
	Color3.fromRGB(255, 255, 255)

objectiveLabel.TextStrokeColor3 =
	Color3.fromRGB(0, 200, 255)

objectiveLabel.TextStrokeTransparency = 0
objectiveLabel.TextScaled = false
objectiveLabel.TextSize = 20
objectiveLabel.TextWrapped = true
objectiveLabel.Font = Enum.Font.GothamBold

objectiveLabel.Text =
	"SKYLINE OBBY\nCOLLECT ALL 5 COINS!"

objectiveLabel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = objectiveLabel

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.Parent = objectiveLabel

local showingIntro = false
local runFinished = false
local introNumber = 0

local function updateObjective()
	if runFinished then
		objectiveLabel.Visible = false
		return
	end

	objectiveLabel.Visible = true

	if showingIntro then
		objectiveLabel.Size =
			UDim2.fromOffset(330, 58)

		objectiveLabel.Text =
			"SKYLINE OBBY\nCOLLECT ALL 5 COINS!"

	elseif coins.Value < REQUIRED_COINS then
		objectiveLabel.Size =
			UDim2.fromOffset(310, 46)

		objectiveLabel.Text =
			"COLLECT COINS: "
			.. coins.Value
			.. "/"
			.. REQUIRED_COINS

	else
		objectiveLabel.Size =
			UDim2.fromOffset(310, 46)

		objectiveLabel.Text =
			"REACH THE FINISH!"
	end
end

local function showIntroUntilPlayerMoves()
	introNumber += 1
	local currentIntro = introNumber

	runFinished = false
	showingIntro = true
	updateObjective()

	task.spawn(function()
		local character =
			player.Character
			or player.CharacterAdded:Wait()

		local root =
			character:WaitForChild(
				"HumanoidRootPart"
			)

		local spawnPosition = root.Position

		while currentIntro == introNumber
			and not runFinished
		do
			if not root.Parent then
				return
			end

			local movement =
				root.Position - spawnPosition

			local horizontalDistance =
				Vector3.new(
					movement.X,
					0,
					movement.Z
				).Magnitude

			if horizontalDistance >= LEAVE_DISTANCE then
				break
			end

			RunService.Heartbeat:Wait()
		end

		if currentIntro ~= introNumber
			or runFinished
		then
			return
		end

		showingIntro = false
		updateObjective()
	end)
end

coins:GetPropertyChangedSignal("Value"):Connect(function()
	updateObjective()
end)

finishEvent.OnClientEvent:Connect(function()
	introNumber += 1
	showingIntro = false
	runFinished = true
	objectiveLabel.Visible = false

	local character = player.Character

	if character then
		local humanoid =
			character:FindFirstChildOfClass("Humanoid")

		local root =
			character:FindFirstChild("HumanoidRootPart")

		if humanoid then
			humanoid:Move(Vector3.zero, false)
		end

		if root then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero

			-- Freeze the player completely
			root.Anchored = true
		end
	end
end)

restartEvent.OnClientEvent:Connect(function()
	local character = player.Character

	if character then
		local root =
			character:FindFirstChild("HumanoidRootPart")

		if root then
			-- Release player movement
			root.Anchored = false
		end
	end

	showIntroUntilPlayerMoves()
end)

showIntroUntilPlayerMoves()
