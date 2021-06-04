--// Services
local PathFindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

--// OOP
local Path = {}
Path.__index = Path

--// Variables
local waypoints = nil
local AR, AH, ACJ = 5, 10, true
local currentWaypointIndex = 2
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)

function onWaypointReached(reached, npc)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	
	if reached and currentWaypointIndex < #waypoints then
		currentWaypointIndex = currentWaypointIndex + 1
		humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
	end
end

function onPathBlocked(blockedWaypointIndex, npc, endpart, vector)
	if blockedWaypointIndex > currentWaypointIndex then
		if vector == true then
			local path = Path.new(npc, vector)
			path.Move()
		else
			local path = Path.new(npc, endpart)
			path.Move()
		end
	end
end

function setPath(npc, endpart, vector)
	local params = {AgentRadius = AR, AgentHeight = AH, AgentCanJump = ACJ}
	local path = PathFindingService:CreatePath(params)
	
	if npc then
		if npc:FindFirstChildOfClass("Humanoid") then
			if vector ~= nil then
				if npc:FindFirstChild("UpperTorso")then
					path:ComputeAsync(npc:WaitForChild("UpperTorso").Position, vector)
					path.Blocked:Connect(onPathBlocked, npc, endpart, vector)
					
				elseif npc:FindFirstChild("Torso") then
					path:ComputeAsync(npc:WaitForChild("Torso").Position, vector)
					path.Blocked:Connect(onPathBlocked, npc, endpart, vector)
				end
			else
				if npc:FindFirstChild("UpperTorso")then
					path:ComputeAsync(npc:WaitForChild("UpperTorso").Position, endpart.Position)
			
					path.Blocked:Connect(onPathBlocked, npc, endpart, vector)
				
					npc.Humanoid.MoveToFinished:Connect(function(status)	
						onWaypointReached(status, npc)
					end)
					
				elseif npc:FindFirstChild("Torso")then
					path:ComputeAsync(npc:WaitForChild("Torso").Position, endpart.Position)
			
					path.Blocked:Connect(onPathBlocked, npc, endpart, vector)
				
					npc.Humanoid.MoveToFinished:Connect(function(status)	
						onWaypointReached(status, npc)
					end)
				end
			end
			
		elseif npc:IsA("BasePart")then
			if vector ~= nil then
				path:ComputeAsync(npc.Position, vector)
			else
				path:ComputeAsync(npc.Position, endpart.Position)
			end
		end
		
		return path
	end
end

function Path.new(npc, endgoal, vector, array, power, PathSettings)
    local newPath = {}
    setmetatable(newPath, Path)
	
	local getpath = nil 
	
	if npc and endgoal then
		getpath = setPath(npc, endgoal, vector)
	end
	
	newPath.FollowPath = getpath
	
	local hum = nil
	
	if npc:FindFirstChildOfClass("Humanoid")then
		hum = npc:FindFirstChildOfClass("Humanoid")
	end
	
	local TweenPause, TweenStop = false, false
	
	newPath.Move = function()
		if getpath then
			if hum then
				waypoints = getpath:GetWaypoints()
		
				local hum
		
				if hum then
					hum = hum
				end
		
				if getpath.Status == Enum.PathStatus.Success then
					if hum then
						if waypoints[currentWaypointIndex] then
							local pos = waypoints[currentWaypointIndex].Position
							hum:MoveTo(pos)
							hum.MoveToFinished:Wait()
						end
					end
				end
			
			else
				
				local currentTweenIndex = 1
				local Finished = false
				
				waypoints = getpath:GetWaypoints()
				
				while Finished == false do
					wait()
					
					if TweenStop == true then
						
						Finished = true
						
						break
					end
					
					if TweenPause == false then
						if waypoints[currentTweenIndex]then
							local tween = TweenService:Create(npc, tweenInfo, {Position = waypoints[currentTweenIndex].Position})
							tween:Play()
							tween.Completed:Wait()
							currentTweenIndex = currentTweenIndex + 1
						else
							
							Finished = true
							
							break
						end
					end
				end
			end
		end
	end
	
	
	newPath.Pause = function()
		if hum then
			local root = npc:FindFirstChild("HumanoidRootPart")
			root.Anchored = true
			
		else
			TweenPause = true
		end
	end
	
	newPath.Stop = function()
		if hum then
			
			hum:MoveTo(npc.HumanoidRootPart.Position)
			
		else
			TweenStop = true
		end
	end
	
	newPath.ArrayMovement = function()
		if hum then
			local root = npc:FindFirstChild("HumanoidRootPart")
			local currentArrayIndex = 1
			local Finished = false
			local debounce = false
			
			while Finished == false do
				wait(1)
				
				if array[currentArrayIndex] == nil then
					Finished = true
					
					break
					
				else
					
					local currentPart = array[currentArrayIndex]
					hum:MoveTo(currentPart.Position)
				
					local connection = currentPart.Touched:Connect(function()
						if (root.Position - currentPart.Position).magnitude <= 5 then
							if debounce == false then
								debounce = true
								currentArrayIndex = currentArrayIndex + 1
								if array[currentArrayIndex]then
					
									hum:MoveTo(array[currentArrayIndex].Position)
									
									delay(3, function()
										debounce = false
									end)
								else
									Finished = true
								end
							end
						end
					end)
				
					wait(0.5)
				
					connection:Disconnect()
				end
			end
			
		else
			
			for TweenIndex = 1, #array do
				
				local new = setPath(npc, array[TweenIndex], nil)
				local TweenWaypoints = new:GetWaypoints()
					
				for index, value in pairs(TweenWaypoints)do
					if TweenPause == false then
						local tween = TweenService:Create(npc, tweenInfo, {Position = value.Position})
					
						tween:Play()
					
						tween.Completed:Wait()
						
					else
						repeat wait(1) until TweenPause == false
					end
				end
			end
		end
	end
	
	newPath.Jump = function()
		if npc then
			if hum then
				if power ~= nil then
					hum.JumpPower = power
				end
				
				hum:Jump()
				
			else
				newPath.Pause()
				npc.Anchored = false
				npc.Velocity = Vector3.new(0, power, 0)
				wait(power/120)
				npc.Anchored = true
				newPath.Resume()
			end
		end
	end
	
	newPath.Resume = function()
		if hum then
			for _,v in pairs(npc:GetChildren())do
				if v:IsA("BasePart")then
					v.Anchored = false
				end
			end
		else
			TweenPause = false
		end
	end
	
	newPath.SetSettings = function()
		if PathSettings then
			if PathSettings["TweeningInfo"]then
				tweenInfo = PathSettings["TweeningInfo"]
			end
			
			if PathSettings["AgentParameters"] then
				local params = PathSettings["AgentParameters"]
				AR, AH, ACJ = params["AgentRadius"], params["AgentHeight"], params["AgentCanJump"]
			end
			
			if PathSettings["Movement"]then
				local movement = PathSettings["Movement"]
				
				
				if movement["WalkSpeed"]then
					hum.Walkspeed = movement["WalkSpeed"]
				end
				
				if movement["JumpPower"]then
					hum.JumpPower = movement["JumpPower"]
				end
			end
		end
	end
	
	newPath.CalculateTime = function()
		if npc:FindFistChildOfClass("Humanoid")then
			if endgoal then
				local root = npc:FindFirstChild("HumanoidRootPart")
				local hum = npc:FindFistChildOfClass("Humanoid")
				
				local magnitude = (root.Position - endgoal.Position).Magnitude
				
				local calculation = magnitude / hum.WalkSpeed
				
				return calculation
			end
		end
	end
		
	return newPath
end

return Path
