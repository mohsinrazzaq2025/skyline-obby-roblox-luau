local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local finishEvent =
	ReplicatedStorage:WaitForChild("FinishEvent")

local restartEvent =
	ReplicatedStorage:WaitForChild("RestartEvent")

local feedbackEvent =
	ReplicatedStorage:WaitForChild("FeedbackEvent")

local finishPlatform = script.Parent

local REQUIRED_COINS = 5

local finishedPlayers = {}
local messageCooldowns = {}

local function showMessage(
	player,
	text,
	backgroundColor,
	duration
)
	local playerGui = player:WaitForChild("PlayerGui")
	local oldGui = playerGui:FindFirstChild("WinGui")

	if oldGui then
		oldGui:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "WinGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local message = Instance.new("TextLabel")
	message.Name = "WinMessage"
	message.AnchorPoint = Vector2.new(0.5, 0.5)
	message.Position = UDim2.fromScale(0.5, 0.35)
	message.Size = UDim2.fromScale(0.55, 0.18)
	message.BackgroundColor3 = backgroundColor
	message.BackgroundTransparency = 0.1
	message.TextColor3 = Color3.fromRGB(255, 255, 255)
	message.TextScaled = true
	message.Font = Enum.Font.GothamBold
	message.Text = text
	message.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = message

	task.wait(duration)

	if screenGui.Parent then
		screenGui:Destroy()
	end
end

finishPlatform.Touched:Connect(function(otherPart)
	local character =
		otherPart:FindFirstAncestorOfClass("Model")

	local player =
		character and Players:GetPlayerFromCharacter(character)

	if not player or finishedPlayers[player] then
		return
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	local coins =
		leaderstats and leaderstats:FindFirstChild("Coins")

	if not coins then
		return
	end

	-- Check required coins
	if coins.Value < REQUIRED_COINS then
		if messageCooldowns[player] then
			return
		end

		messageCooldowns[player] = true

		feedbackEvent:FireClient(
			player,
			"MissingCoins"
		)

		local remainingCoins =
			REQUIRED_COINS - coins.Value

		local coinWord =
			remainingCoins == 1 and "COIN" or "COINS"

		task.spawn(
			showMessage,
			player,
			"COLLECT "
				.. remainingCoins
				.. " MORE "
				.. coinWord
				.. "!",
			Color3.fromRGB(230, 120, 30),
			3
		)

		task.delay(3, function()
			messageCooldowns[player] = nil
		end)

		return
	end

	finishedPlayers[player] = true

	-- Freeze player on finish
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
		root.Anchored = true
	end

	-- Update Wins
	local wins = leaderstats:FindFirstChild("Wins")

	if wins then
		wins.Value += 1
	end

	-- Calculate completion time
	local bestTime = leaderstats:FindFirstChild("BestTime")
	local runStartTime =
		player:GetAttribute("RunStartTime")

	local completionTime = 0

	if runStartTime then
		completionTime = math.max(
			1,
			math.floor(
				workspace:GetServerTimeNow() - runStartTime
			)
		)

		-- Update only when this is a new best time
		if bestTime
			and (
				bestTime.Value == 0
					or completionTime < bestTime.Value
			)
		then
			bestTime.Value = completionTime
		end
	end

	-- Stop the client timer
	finishEvent:FireClient(player, completionTime)

	local victoryParticles =
		finishPlatform:FindFirstChild("VictoryParticles")

	if victoryParticles then
		victoryParticles:Emit(60)
	end

	task.spawn(
		showMessage,
		player,
		"YOU WIN!",
		Color3.fromRGB(40, 200, 90),
		4
	)
end)

-- Restart the game after pressing Play Again
restartEvent.OnServerEvent:Connect(function(player)
	if not finishedPlayers[player] then
		return
	end

	finishedPlayers[player] = nil
	messageCooldowns[player] = nil

	local leaderstats = player:FindFirstChild("leaderstats")
	local coins =
		leaderstats and leaderstats:FindFirstChild("Coins")

	-- Reset coins only
	if coins then
		coins.Value = 0
	end

	-- Remove win message
	local playerGui = player:FindFirstChild("PlayerGui")
	local winGui =
		playerGui and playerGui:FindFirstChild("WinGui")

	if winGui then
		winGui:Destroy()
	end

	-- Tell CheckpointSystem to clear checkpoint
	player:SetAttribute("RestartingRun", true)

	player:LoadCharacterAsync()

	local newCharacter = player.Character

	if not newCharacter then
		return
	end

	local newRoot =
		newCharacter:WaitForChild("HumanoidRootPart")

	newRoot.Anchored = false
	newRoot.AssemblyLinearVelocity = Vector3.zero
	newRoot.AssemblyAngularVelocity = Vector3.zero

	-- Start the new timer
	local newStartTime = workspace:GetServerTimeNow()

	player:SetAttribute("RunStartTime", newStartTime)
	restartEvent:FireClient(player, newStartTime)
end)

Players.PlayerRemoving:Connect(function(player)
	finishedPlayers[player] = nil
	messageCooldowns[player] = nil
end)
