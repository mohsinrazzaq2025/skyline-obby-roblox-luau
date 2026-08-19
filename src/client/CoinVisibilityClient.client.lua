local ReplicatedStorage =
	game:GetService("ReplicatedStorage")

local coinVisibilityEvent =
	ReplicatedStorage:WaitForChild("CoinVisibilityEvent")

local coinsFolder =
	workspace:WaitForChild("Coins")

local function setCoinVisible(coin, visible)
	if not coin
		or not coin:IsA("BasePart")
		or not coin:IsDescendantOf(coinsFolder)
	then
		return
	end

	if visible then
		coin.LocalTransparencyModifier = 0
	else
		coin.LocalTransparencyModifier = 1
	end
end

coinVisibilityEvent.OnClientEvent:Connect(
	function(action, coin)
		if action == "Hide" then
			setCoinVisible(coin, false)

		elseif action == "Reset" then
			for _, currentCoin in ipairs(
				coinsFolder:GetChildren()
			) do
				setCoinVisible(currentCoin, true)
			end
		end
	end
)

-- Ensure all coins are visible on initial join
for _, coin in ipairs(coinsFolder:GetChildren()) do
	setCoinVisible(coin, true)
end

coinsFolder.ChildAdded:Connect(function(coin)
	setCoinVisible(coin, true)
end)
