local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local soundNames = {
	"CoinSound",
	"CheckpointSound",
	"WinSound",
	"WarningSound",
	"DeathSound",
	"RestartSound",
	"BackgroundMusic"
}

local originalVolumes = {}

for _, soundName in ipairs(soundNames) do
	local sound = SoundService:WaitForChild(soundName)
	originalVolumes[sound] = sound.Volume
end

local oldGui = playerGui:FindFirstChild("AudioGui")

if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AudioGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

screenGui.IgnoreGuiInset = false
screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets

local soundButton = Instance.new("TextButton")
soundButton.Name = "SoundButton"
soundButton.AnchorPoint = Vector2.new(1, 1)
soundButton.Position = UDim2.new(1, -20, 1, -20)
soundButton.Size = UDim2.fromOffset(140, 48)
soundButton.BackgroundColor3 = Color3.fromRGB(40, 200, 90)
soundButton.BackgroundTransparency = 0.1
soundButton.Text = "SOUND: ON"
soundButton.TextColor3 = Color3.fromRGB(255, 255, 255)
soundButton.TextSize = 18
soundButton.Font = Enum.Font.GothamBold
soundButton.AutoButtonColor = true
soundButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = soundButton

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.5
stroke.Thickness = 2
stroke.Parent = soundButton

local soundEnabled = true

if UserInputService.TouchEnabled then
	-- Mobile: compact button beside timer
	soundButton.AnchorPoint = Vector2.new(1, 0)
	soundButton.Position = UDim2.new(1, -8, 0, 75)
	soundButton.Size = UDim2.fromOffset(60, 42)
	soundButton.TextSize = 12
	soundButton.TextWrapped = true
else
	-- Computer: bottom-right
	soundButton.AnchorPoint = Vector2.new(1, 1)
	soundButton.Position = UDim2.new(1, -30, 1, -30)
	soundButton.Size = UDim2.fromOffset(175, 60)
end

local function updateSound()
	for sound, originalVolume in pairs(originalVolumes) do
		if sound.Parent then
			sound.Volume =
				soundEnabled and originalVolume or 0
		end
	end

	if soundEnabled then
		soundButton.Text = UserInputService.TouchEnabled
			and "SOUND\nON"
			or "SOUND: ON"
		soundButton.BackgroundColor3 =
			Color3.fromRGB(40, 200, 90)
	else
		soundButton.Text = UserInputService.TouchEnabled
			and "SOUND\nOFF"
			or "SOUND: OFF"
		soundButton.BackgroundColor3 =
			Color3.fromRGB(200, 70, 70)
	end
end

soundButton.Activated:Connect(function()
	soundEnabled = not soundEnabled
	updateSound()
end)

updateSound()
