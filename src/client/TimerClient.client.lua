local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local finishEvent =
	ReplicatedStorage:WaitForChild("FinishEvent")

local restartEvent =
	ReplicatedStorage:WaitForChild("RestartEvent")

local playerGui = player:WaitForChild("PlayerGui")

local oldTimerGui = playerGui:FindFirstChild("TimerGui")

if oldTimerGui then
	oldTimerGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TimerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = false
screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets

-- Timer background
local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.AnchorPoint = Vector2.new(0.5, 0)
timerFrame.Position = UDim2.new(0.5, 0, 0, 66)
timerFrame.Size = UDim2.fromOffset(185, 60)
timerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
timerFrame.BackgroundTransparency = 0.15
timerFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = timerFrame

-- TIME text
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Position = UDim2.fromOffset(20, 0)
titleLabel.Size = UDim2.fromOffset(85, 60)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "TIME"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = timerFrame

-- Timer digits
local valueLabel = Instance.new("TextLabel")
valueLabel.Name = "ValueLabel"
valueLabel.Position = UDim2.fromOffset(105, 0)
valueLabel.Size = UDim2.fromOffset(100, 60)
valueLabel.BackgroundTransparency = 1
valueLabel.Text = "000"
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.TextSize = 32
valueLabel.Font = Enum.Font.Code
valueLabel.TextXAlignment = Enum.TextXAlignment.Left
valueLabel.Parent = timerFrame

-- Play Again button
local restartButton = Instance.new("TextButton")
restartButton.Name = "RestartButton"
restartButton.AnchorPoint = Vector2.new(0.5, 0)
restartButton.Position = UDim2.new(0.5, 0, 1, 12)
restartButton.Size = UDim2.fromOffset(185, 46)
restartButton.BackgroundColor3 = Color3.fromRGB(40, 200, 90)
restartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restartButton.Text = "PLAY AGAIN"
restartButton.TextSize = 20
restartButton.Font = Enum.Font.GothamBold
restartButton.AutoButtonColor = true
restartButton.Visible = false
restartButton.Parent = timerFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = restartButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Transparency = 0.4
buttonStroke.Thickness = 2
buttonStroke.Parent = restartButton

local startTime
local timerRunning = false
local restartRequested = false

local function getRunStartTime()
	local serverStartTime =
		player:GetAttribute("RunStartTime")

	while not serverStartTime do
		player:GetAttributeChangedSignal(
			"RunStartTime"
		):Wait()

		serverStartTime =
			player:GetAttribute("RunStartTime")
	end

	return serverStartTime
end

local function startTimer(serverStartTime)
	startTime = serverStartTime or getRunStartTime()
	timerRunning = true
	restartRequested = false

	titleLabel.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	valueLabel.Text = "000"
	valueLabel.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	restartButton.Text = "PLAY AGAIN"
	restartButton.Active = true
	restartButton.Visible = false
end

RunService.RenderStepped:Connect(function()
	if timerRunning and startTime then
		local elapsedTime =
			workspace:GetServerTimeNow() - startTime

		valueLabel.Text =
			string.format(
				"%03d",
				math.floor(elapsedTime)
			)
	end
end)

finishEvent.OnClientEvent:Connect(function(completionTime)
	timerRunning = false

	valueLabel.Text =
		string.format(
			"%03d",
			tonumber(completionTime) or 0
		)

	valueLabel.TextColor3 =
		Color3.fromRGB(80, 255, 120)

	restartButton.Visible = true
end)

restartButton.Activated:Connect(function()
	if restartRequested then
		return
	end

	restartRequested = true
	restartButton.Active = false
	restartButton.Text = "RESTARTING..."

	restartEvent:FireServer()
end)

restartEvent.OnClientEvent:Connect(function(newStartTime)
	startTimer(newStartTime)
end)

if not player.Character then
	player.CharacterAdded:Wait()
end

startTimer()
