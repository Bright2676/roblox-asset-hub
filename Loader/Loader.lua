local InsertService = game:GetService("InsertService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = nil

local AssetId = 72074871419698
local Settings = require(script.Settings)

local Success, Response = pcall(function()
	local Require = InsertService:LoadAsset(AssetId)
	
	if Require then
		Require.Parent = workspace
		return Require
	else
		return nil
	end
end)

if not Success then
	warn(Response)
	return
else
	print("Successfully loaded Asset Hub")
end

for _, Ins in Response.Loaded:GetChildren() do
	if Ins:IsA("ScreenGui") then
		Ins.Parent = StarterGui
	elseif Ins.Name == "Events" then
		Ins.Parent = ReplicatedStorage
	end
end

task.wait()

Events = ReplicatedStorage.Events

Events.ApplyLoaderSettings:FireAllClients(Settings.Settings)

print("Ready :)")
