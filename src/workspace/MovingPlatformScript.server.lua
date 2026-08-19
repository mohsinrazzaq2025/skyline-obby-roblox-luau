local RunService = game:GetService("RunService")

local platform = script.Parent
local endPoint = workspace:WaitForChild("MovingPlatformEnd")

local MOVE_SPEED = 7
local PAUSE_TIME = 0.5
local ARRIVAL_DISTANCE = 0.25

local startPosition = platform.Position
local endPosition = endPoint.Position
local startOrientation = platform.CFrame.Rotation

-- Hide destination marker
endPoint.Transparency = 1
endPoint.CanCollide = false
endPoint.CanTouch = false
endPoint.CanQuery = false

-- Configure physical platform
platform.Anchored = false
platform.CanCollide = true
platform:SetNetworkOwner(nil)

platform.CustomPhysicalProperties = PhysicalProperties.new(
	1,
	1,
	0,
	100,
	100
)

local attachment = Instance.new("Attachment")
attachment.Name = "MovementAttachment"
attachment.Parent = platform

local alignPosition = Instance.new("AlignPosition")
alignPosition.Name = "PlatformPosition"
alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
alignPosition.Attachment0 = attachment
alignPosition.Position = startPosition
alignPosition.MaxForce = 1000000
alignPosition.MaxVelocity = MOVE_SPEED
alignPosition.Responsiveness = 10
alignPosition.ApplyAtCenterOfMass = true
alignPosition.Parent = platform

local alignOrientation = Instance.new("AlignOrientation")
alignOrientation.Name = "PlatformOrientation"
alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
alignOrientation.Attachment0 = attachment
alignOrientation.CFrame = startOrientation
alignOrientation.MaxTorque = 1000000
alignOrientation.Responsiveness = 100
alignOrientation.RigidityEnabled = true
alignOrientation.Parent = platform

local function moveTo(targetPosition)
	alignPosition.Position = targetPosition

	repeat
		RunService.Heartbeat:Wait()
	until not platform.Parent
		or (platform.Position - targetPosition).Magnitude <= ARRIVAL_DISTANCE

	platform.AssemblyLinearVelocity = Vector3.zero
end

while platform.Parent do
	moveTo(endPosition)
	task.wait(PAUSE_TIME)

	moveTo(startPosition)
	task.wait(PAUSE_TIME)
end
