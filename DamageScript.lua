local turret = script.Parent.Parent.Parent
local ownerName = turret.Owner.Value
local debounce = false

--If a player touches the hitbox, tag and damage them
script.Parent.Touched:Connect(function(Hit)
	if debounce then return end	
	if Hit.Parent:FindFirstChild("Humanoid") then
		local vCharacter = workspace:FindFirstChild(ownerName)
		local vPlayer = game.Players:playerFromCharacter(vCharacter)
		local hum = Hit.Parent:FindFirstChild("Humanoid")
		tagHumanoid(hum, vPlayer)
		hum:TakeDamage(1)

		debounce = true
		wait(0.05)
		untagHumanoid(hum)
		debounce = false
	end
end)

--Tag hit player to earn points if they're killed
function tagHumanoid(humanoid, player)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
end

--Removes tag from hit player
function untagHumanoid(humanoid)
	if humanoid == nil then return end
	local tag = humanoid:findFirstChild("creator")
	if tag ~= nil then
		tag.Parent = nil
	end
end