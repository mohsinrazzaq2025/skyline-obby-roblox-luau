local RunService = game:GetService("RunService")

local beam = script.Parent
local ROTATION_SPEED = math.rad(90)

beam.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local humanoid =
		character and character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health > 0 then
		humanoid.Health = 0
	end
end)

RunService.Heartbeat:Connect(function(deltaTime)
	beam.CFrame =
		beam.CFrame * CFrame.Angles(
			0,
			ROTATION_SPEED * deltaTime,
			0
		)
end)
