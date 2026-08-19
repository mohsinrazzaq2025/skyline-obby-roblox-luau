local Players = game:GetService("Players")
local ReplicatedStorage =
	game:GetService("ReplicatedStorage")

local SoundService =
	game:GetService("SoundService")

local player = Players.LocalPlayer

local coinVisibilityEvent =
	ReplicatedStorage:WaitForChild("CoinVisibilityEvent")

local checkpointEvent =
	ReplicatedStorage:WaitForChild("CheckpointEvent")

local finishEvent =
	ReplicatedStorage:WaitForChild("FinishEvent")

local restartEvent =
	ReplicatedStorage:WaitForChild("RestartEvent")

local feedbackEvent =
	ReplicatedStorage:WaitForChild("FeedbackEvent")

local function createSound(
	name,
	soundId,
	volume,
	playbackSpeed
)
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.SoundId = soundId
	sound.Volume = volume
	sound.PlaybackSpeed = playbackSpeed or 1
	sound.Parent = SoundService

	return sound
end

local backgroundMusic = createSound(
	"BackgroundMusic",
	"rbxassetid://1838838892",
	0.08,
	1
)

backgroundMusic.Looped = true
backgroundMusic:Play()

local coinSound = createSound(
	"CoinSound",
	"rbxassetid://108525063947000",
	0.65,
	1
)

local checkpointSound = createSound(
	"CheckpointSound",
	"rbxassetid://72383260709559",
	0.6,
	1
)

local winSound = createSound(
	"WinSound",
	"rbxassetid://12222253",
	0.8,
	1
)

local warningSound = createSound(
	"WarningSound",
	"rbxassetid://12221944",
	0.6,
	1
)

local deathSound = createSound(
	"DeathSound",
	"rbxassetid://12222152",
	0.55,
	1
)

local restartSound = createSound(
	"RestartSound",
	"rbxassetid://12222140",
	0.55,
	1
)

local function playSound(sound)
	sound:Stop()
	sound.TimePosition = 0
	sound:Play()
end

-- Coin sound
coinVisibilityEvent.OnClientEvent:Connect(
	function(action)
		if action == "Hide" then
			playSound(coinSound)
		end
	end
)

-- Checkpoint sound
checkpointEvent.OnClientEvent:Connect(function()
	playSound(checkpointSound)
end)

-- Victory sound
finishEvent.OnClientEvent:Connect(function()
	playSound(winSound)
end)

-- Missing-coins warning sound
feedbackEvent.OnClientEvent:Connect(function(action)
	if action == "MissingCoins" then
		playSound(warningSound)
	end
end)

-- Restart confirmation sound
restartEvent.OnClientEvent:Connect(function()
	playSound(restartSound)
end)

-- Death/failure sound
local function connectCharacter(character)
	local humanoid =
		character:WaitForChild("Humanoid")

	humanoid.Died:Connect(function()
		playSound(deathSound)
	end)
end

if player.Character then
	connectCharacter(player.Character)
end

player.CharacterAdded:Connect(connectCharacter)
