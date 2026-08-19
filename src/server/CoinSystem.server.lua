local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local coinsFolder = workspace:WaitForChild("Coins")

local coinVisibilityEvent =
	ReplicatedStorage:WaitForChild("CoinVisibilityEvent")

local restartEvent =
	ReplicatedStorage:WaitForChild("RestartEvent")

local ROTATION_SPEED = math.rad(120)

local collectedCoinsByPlayer = {}

local function createLeaderstats(player)
	local leaderstats = player:FindFirstChild("leaderstats")

	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local coins = leaderstats:FindFirstChild("Coins")

	if not coins then
		coins = Instance.new("IntValue")
		coins.Name = "Coins"
		coins.Value = 0
		coins.Parent = leaderstats
	end

	collectedCoinsByPlayer[player] = {}
end

Players.PlayerAdded:Connect(createLeaderstats)

for _, player in ipairs(Players:GetPlayers()) do
	createLeaderstats(player)
end

local function setupCoin(coin)
	if not coin:IsA("BasePart") then
		return
	end

	coin.Transparency = 0
	coin.CanTouch = true

	coin.Touched:Connect(function(hit)
		local character =
			hit:FindFirstAncestorOfClass("Model")

		local humanoid =
			character
			and character:FindFirstChildOfClass("Humanoid")

		local player =
			humanoid
			and Players:GetPlayerFromCharacter(character)

		if not player then
			return
		end

		local playerCollection =
			collectedCoinsByPlayer[player]

		if not playerCollection then
			playerCollection = {}
			collectedCoinsByPlayer[player] = playerCollection
		end

		-- Prevent collecting the same coin twice
		if playerCollection[coin] then
			return
		end

		local leaderstats =
			player:FindFirstChild("leaderstats")

		local coinScore =
			leaderstats
			and leaderstats:FindFirstChild("Coins")

		if not coinScore then
			return
		end

		playerCollection[coin] = true
		coinScore.Value += 1

		-- Hide this coin only for this player
		coinVisibilityEvent:FireClient(
			player,
			"Hide",
			coin
		)
	end)
end

for _, coin in ipairs(coinsFolder:GetChildren()) do
	setupCoin(coin)
end

coinsFolder.ChildAdded:Connect(setupCoin)

-- Reset coins for the player's new run
restartEvent.OnServerEvent:Connect(function(player)
	collectedCoinsByPlayer[player] = {}

	local leaderstats = player:FindFirstChild("leaderstats")
	local coinScore =
		leaderstats and leaderstats:FindFirstChild("Coins")

	if coinScore then
		coinScore.Value = 0
	end

	coinVisibilityEvent:FireClient(
		player,
		"Reset"
	)
end)

RunService.Heartbeat:Connect(function(deltaTime)
	for _, coin in ipairs(coinsFolder:GetChildren()) do
		if coin:IsA("BasePart") then
			coin.CFrame =
				coin.CFrame
					* CFrame.Angles(
						0,
						ROTATION_SPEED * deltaTime,
						0
					)
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	collectedCoinsByPlayer[player] = nil
end)
