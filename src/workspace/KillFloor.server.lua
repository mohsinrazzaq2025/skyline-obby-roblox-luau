local killFloor = script.Parent

killFloor.Touched:Connect(function(otherPart)
	local character = otherPart:FindFirstAncestorOfClass("Model")
	local humanoid =
		character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end
end)
