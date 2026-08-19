local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local checkpointsFolder = workspace:WaitForChild("Checkpoints")
local checkpointEvent =
	ReplicatedStorage:WaitForChild("CheckpointEvent")

local savedCheckpoints = {}

local function setupCheckpoint(checkpoint)
	if not checkpoint:IsA("BasePart") then
		return
	end

	checkpoint.Touched:Connect(function(otherPart)
		local character =
			otherPart:FindFirstAncestorOfClass("Model")

		local player =
			character and Players:GetPlayerFromCharacter(character)

		if player and savedCheckpoints[player] ~= checkpoint then
			savedCheckpoints[player] = checkpoint
			checkpointEvent:FireClient(player, checkpoint.Name)
		end
	end)
end

for _, checkpoint in ipairs(checkpointsFolder:GetChildren()) do
	setupCheckpoint(checkpoint)
end

checkpointsFolder.ChildAdded:Connect(setupCheckpoint)

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(character)
		-- Clear the saved checkpoint when restarting a run
		if player:GetAttribute("RestartingRun") then
			savedCheckpoints[player] = nil
			player:SetAttribute("RestartingRun", false)
			return
		end

		local checkpoint = savedCheckpoints[player]

		if checkpoint and checkpoint.Parent then
			character:WaitForChild("HumanoidRootPart")
			task.wait(0.1)

			local respawnCFrame =
				checkpoint.CFrame
					* CFrame.new(0, 4, 0)
					* CFrame.Angles(0, math.rad(180), 0)

			character:PivotTo(respawnCFrame)
		end
	end)
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

Players.PlayerRemoving:Connect(function(player)
	savedCheckpoints[player] = nil
end)
