local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local checkpointEvent =
	ReplicatedStorage:WaitForChild("CheckpointEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = player:WaitForChild("PlayerGui")

local message = Instance.new("TextLabel")
message.Name = "CheckpointMessage"
message.AnchorPoint = Vector2.new(0.5, 0)
message.Position = UDim2.new(0.5, 0, 0.03, 165)
message.Size = UDim2.fromOffset(340, 60)
message.BackgroundColor3 = Color3.fromRGB(45, 140, 255)
message.BackgroundTransparency = 0.1
message.TextColor3 = Color3.fromRGB(255, 255, 255)
message.TextSize = 25
message.Font = Enum.Font.GothamBold
message.Visible = false
message.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = message

local notificationNumber = 0

checkpointEvent.OnClientEvent:Connect(function(checkpointName)
	notificationNumber += 1
	local currentNotification = notificationNumber

	local displayName =
		checkpointName:gsub("(%a)(%d)", "%1 %2"):upper()

	message.Text = displayName .. " SAVED!"
	message.BackgroundTransparency = 0.1
	message.TextTransparency = 0
	message.Visible = true

	task.wait(2)

	if currentNotification ~= notificationNumber then
		return
	end

	local fadeTween = TweenService:Create(
		message,
		TweenInfo.new(0.4),
		{
			BackgroundTransparency = 1,
			TextTransparency = 1
		}
	)

	fadeTween:Play()
	fadeTween.Completed:Wait()
	message.Visible = false
end)
