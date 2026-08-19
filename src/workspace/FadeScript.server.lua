local TweenService = game:GetService("TweenService")

local platform = script.Parent
local activated = false

local fadeSettings = TweenInfo.new(
	0.6,
	Enum.EasingStyle.Linear
)

local fadeOut = TweenService:Create(
	platform,
	fadeSettings,
	{Transparency = 1}
)

local fadeIn = TweenService:Create(
	platform,
	fadeSettings,
	{Transparency = 0}
)

platform.Touched:Connect(function(hit)
	if activated then
		return
	end

	local character = hit:FindFirstAncestorOfClass("Model")
	local humanoid =
		character and character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	activated = true

	task.wait(0.35)

	fadeOut:Play()
	fadeOut.Completed:Wait()

	platform.CanCollide = false

	task.wait(2)

	fadeIn:Play()
	fadeIn.Completed:Wait()

	platform.CanCollide = true
	activated = false
end)
