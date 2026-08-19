local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local playerDataStore =
	DataStoreService:GetDataStore("SkylineObbyPlayerData_v1")

local pendingSaves = {}

local function savePlayerData(player)
	if not player:GetAttribute("DataLoaded") then
		return
	end

	local leaderstats = player:FindFirstChild("leaderstats")

	if not leaderstats then
		return
	end

	local wins = leaderstats:FindFirstChild("Wins")
	local bestTime = leaderstats:FindFirstChild("BestTime")

	if not wins or not bestTime then
		return
	end

	local dataToSave = {
		Wins = wins.Value,
		BestTime = bestTime.Value
	}

	local success, errorMessage = pcall(function()
		playerDataStore:UpdateAsync(
			"Player_" .. player.UserId,
			function()
				return dataToSave
			end
		)
	end)

	if success then
		print("Data saved for " .. player.Name)
	else
		warn(
			"Could not save data for "
				.. player.Name
				.. ": "
				.. errorMessage
		)
	end
end

local function scheduleSave(player)
	if pendingSaves[player] then
		return
	end

	pendingSaves[player] = true

	task.delay(1, function()
		pendingSaves[player] = nil

		if player.Parent then
			savePlayerData(player)
		end
	end)
end

local function loadPlayerData(player)
	local leaderstats =
		player:WaitForChild("leaderstats", 10)

	if not leaderstats then
		warn("Leaderstats not found for " .. player.Name)
		return
	end

	local wins = leaderstats:FindFirstChild("Wins")

	if not wins then
		wins = Instance.new("IntValue")
		wins.Name = "Wins"
		wins.Value = 0
		wins.Parent = leaderstats
	end

	local bestTime =
		leaderstats:FindFirstChild("BestTime")

	if not bestTime then
		bestTime = Instance.new("IntValue")
		bestTime.Name = "BestTime"
		bestTime.Value = 0
		bestTime.Parent = leaderstats
	end

	player:SetAttribute("DataLoaded", false)

	if not player.Character then
		player.CharacterAdded:Wait()
	end

	player:SetAttribute(
		"RunStartTime",
		workspace:GetServerTimeNow()
	)

	local success, savedData = pcall(function()
		return playerDataStore:GetAsync(
			"Player_" .. player.UserId
		)
	end)

	if success then
		if savedData then
			wins.Value = savedData.Wins or 0
			bestTime.Value = savedData.BestTime or 0
		end

		player:SetAttribute("DataLoaded", true)

		-- Save whenever Wins or BestTime changes
		wins.Changed:Connect(function()
			scheduleSave(player)
		end)

		bestTime.Changed:Connect(function()
			scheduleSave(player)
		end)

		print("Data loaded for " .. player.Name)
	else
		warn("Could not load data for " .. player.Name)
	end
end

Players.PlayerAdded:Connect(loadPlayerData)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(loadPlayerData, player)
end

Players.PlayerRemoving:Connect(function(player)
	pendingSaves[player] = nil
	savePlayerData(player)
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		savePlayerData(player)
	end
end)
