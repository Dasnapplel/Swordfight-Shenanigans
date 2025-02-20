--This script is parented to a rotating turret sentry model. 
--Its function is to detect players and rotate the kill-zone/bullets towards the player.

local turret = script.Parent
local head = turret.Head
local debounce = false

local function rotate(extra, opposite, adjacent, adjustment)
	--reset the turret rotation
	local reset = head.PastRot.Value
	local ResetRot = CFrame.Angles(0,-reset,0)
	local ResetCFrame = head:GetPivot()
	head:PivotTo(ResetCFrame * ResetRot)
	
	--calculate the real angle of rotation
	local rad = math.atan(opposite/adjacent) + adjustment
	local realrad = ((math.pi/2) - (rad - extra)) + extra
	
	--rotate the turret
	local rotation = CFrame.Angles(0,realrad,0)
	local modelCFrame = head:GetPivot()
	head:PivotTo(modelCFrame * rotation)
	head.PastRot.Value = realrad
end


turret.boundary.Touched:Connect(function(hit)
	if not hit.Parent:FindFirstChild("Humanoid") then return end
	if debounce then return end
	debounce = true

	--do pythagorean math with root position to find angle
	local rootPos = hit.Parent:FindFirstChild("HumanoidRootPart").CFrame.Position
	local centerPos = turret.stem.CFrame.Position
	local Opp = rootPos.Z - centerPos.Z
	local Adj = rootPos.X - centerPos.X
	local Hyp = math.sqrt(Opp*Opp + Adj*Adj)

	if Opp > 0 and Adj > 0 then --1st quad
		rotate(0, Opp, Adj, math.pi)
	elseif Opp > 0 and Adj < 0 then --2nd quad
		rotate(math.pi/2, Opp, Adj, math.pi)
	elseif Opp < 0 and Adj < 0 then --3rd quad
		rotate(math.pi, Opp, Adj, 0)
	elseif Opp < 0 and Adj > 0 then --4th quad
		rotate((3*math.pi)/2, Opp, Adj, (2*math.pi))
	end

	head.Particles.ParticleEmitter.Enabled = true
	head.Kill.Damage.Enabled = true
	wait(.05)
	debounce = false
end)