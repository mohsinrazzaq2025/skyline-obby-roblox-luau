local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function alignCamera(character)
	local humanoid =
		character:WaitForChild("Humanoid")

	local rootPart =
		character:WaitForChild("HumanoidRootPart")

	task.wait(0.2)

	if not character.Parent then
		return
	end

	local camera = workspace.CurrentCamera

	camera.CameraSubject = humanoid
	camera.CameraType = Enum.CameraType.Scriptable

	local focusPosition =
		rootPart.Position + Vector3.new(0, 2, 0)

	local cameraPosition =
		focusPosition
		- rootPart.CFrame.LookVector * 10
			+ Vector3.new(0, 4, 0)

	camera.CFrame = CFrame.lookAt(
		cameraPosition,
		focusPosition
	)

	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = humanoid
end

player.CharacterAdded:Connect(function(character)
	task.spawn(alignCamera, character)
end)

if player.Character then
	task.spawn(alignCamera, player.Character)
end
