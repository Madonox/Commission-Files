-- Madonox
-- Controls rank changes.

local rankupParticle = Instance.new("ParticleEmitter")
rankupParticle.LightEmission = 1
rankupParticle.LightInfluence = 1
rankupParticle.Lifetime = NumberRange.new(1)
rankupParticle.Brightness = 3
rankupParticle.Texture = "http://www.roblox.com/asset/?id=241685484"

function updateRank(player)
	local stat = player.leaderstats
	local currentValue = stat.Rank.Value
	if stat.Completed.Value <= 25 then
		stat.Rank.Value = "Rank one"
	elseif stat.Completed.Value <= 50 then
		stat.Rank.Value = "Rank two"
	end
	if stat.Rank.Value ~= currentValue then
		if game.Workspace[player.Name] then
			local inst = rankupParticle:Clone()
			inst.Parent = game.Workspace[player.Name].HumanoidRootPart
			game.Debris:AddItem(inst,5)
		end
	end
end

local guiTemplate = Instance.new("BillboardGui")
guiTemplate.Name = "RankGui"
guiTemplate.AlwaysOnTop = true
guiTemplate.Enabled = true
guiTemplate.Size = UDim2.new(3,0,1,0)
guiTemplate.StudsOffset = Vector3.new(0,3,0)
local guiLabel = Instance.new("TextLabel",guiTemplate)
guiLabel.BackgroundTransparency = 1
guiLabel.Size = UDim2.new(1,0,1,0)
guiLabel.TextColor3 = Color3.new(1,1,1)
guiLabel.TextScaled = true
guiLabel.Text = ""
guiLabel.Font = Enum.Font.Cartoon

function setupOverhead(player)
	player.CharacterAdded:Connect(function()
		delay(1,function()
			local gui = guiTemplate:Clone()
			gui.TextLabel.Text = player.leaderstats.Rank.Value
			gui.Parent = game.Workspace[player.Name].Head
		end)
	end)
end
function updateOverhead(player)
	if game.Workspace[player.Name].Head:FindFirstChild("RankGui") then
		game.Workspace[player.Name].Head.RankGui.TextLabel.Text = player.leaderstats.Rank.Value
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	delay(3,function() -- Allows player data to load.
		if plr:FindFirstChild("leaderstats") then
			if plr.leaderstats:FindFirstChild("Completed") then
				if plr.leaderstats:FindFirstChild("Rank") then
					updateRank(plr)
					setupOverhead(plr)
					plr.leaderstats.Completed.Changed:Connect(function() -- Fires whenever the Completed value changes.
						updateRank(plr)
						updateOverhead(plr)
					end)
				else
					warn("No leaderstats.Rank file found, time after join: 3 seconds.")
				end
			else
				warn("No leaderstats.Completed file found, time after join: 3 seconds.")
			end
		else
			warn("No leaderstats file found, time after join: 3 seconds.")
		end
	end)
end)
