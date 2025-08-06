--[[

	» Roblox Asset Hub | Roblox README.md | «
	Client Version 0.2.0
	
	---

	A way to properly sell assets on the Roblox platform, in line with the ToS
	to allow legal DevEx and prevents your account from moderation.

	This service is not affiliated with the Roblox Corporation.
	Use it responsibly and in compliance with Roblox's Terms of Use and Community Standards.
	
	---
	
	Written by iiBright2676
	
	Note:
		Please try not to modify much as it may result in breaking some contents of the system.
		To contribute, please read more on the GitHub repository.
		
	---

]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character
local PlayerGui = Player.PlayerGui
local UI = PlayerGui.UserInterface

local Container = UI.Container
local PurchasesContainer = UI.Purchases

local AssetsFrame = Container.Assets
local PrePurchaseFrame = UI.PrePurchase
local PurchasesFrame = PurchasesContainer.Assets
local AgreementFrame = UI.Agreement

local PurchaseButton = Container.Purchase

local Template = AssetsFrame.Template

local AssetsModule = require(script.Assets)
local Functions = require(script.Functions)

local SelectedKey = nil
local SelectedObject = nil
local PurchaseHistory = {}

-- some functions for QoL

StarterGui:SetCore("ResetButtonCallback", false)
--Character.HumanoidRootPart.Anchored = true

-- real script

for Key, Data in pairs(AssetsModule) do
	local Clone = Template:Clone()
	
	Clone.Parent = AssetsFrame
	Clone.Name = Key
	Clone.Visible = true
	Clone.Text = Data.Name

	CollectionService:AddTag(Clone, "Product")

	Clone.MouseButton1Click:Connect(function()
		SelectedKey, SelectedObject = Functions.SelectProduct(Clone, AssetsModule)
		UI.Enter:Play()
	end)

	Functions.AddHoverEffect(Clone)
end

for _, Button in UI:GetDescendants() do
	if Button:IsA("GuiButton") then
		Functions.AddHoverEffect(Button)

		Button.MouseButton1Click:Connect(function()
			Player.PlayerGui.UserInterface.Enter:Play()
		end)
	end
end

PurchaseButton.MouseButton1Click:Connect(function()
	if not SelectedObject then
		return
	end

	if SelectedObject.Code and SelectedObject.Code ~= "" then
		UI.Code.Visible = true

		UI.Code.TextButton.MouseButton1Click:Connect(function()
			if UI.Code.Link.Text == SelectedObject.Code then
				UI.Code.Visible = false
				MarketplaceService:PromptGamePassPurchase(Player, SelectedObject.Price)
			else
				UI.Code.Link.Text = "Incorrect code. Try again."
			end
		end)
	else
		MarketplaceService:PromptGamePassPurchase(Player, SelectedObject.Price)
	end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(P, AssetId, Purchased)
	if P ~= Player or not SelectedObject or AssetId ~= SelectedObject.Price or not Purchased then
		return
	end

	table.insert(PurchaseHistory, {
		Name = SelectedObject.Name,
		ID = SelectedObject.ID,
		Time = os.date("%x %X")
	})

	Functions.UpdatePurchaseLogUI(PurchaseHistory, Template, PurchasesFrame)

	UI.PostPurchase.Visible = true
	UI.PostPurchase.Link.Text = "https://create.roblox.com/store/asset/" .. SelectedObject.ID

	task.spawn(function()
		local Counter = 5
		local Button = UI.PostPurchase.TextButton
		
		Button.Interactable = false
		Button.BackgroundTransparency = 0.5

		repeat
			task.wait(1)
			
			Counter -= 1
			Button.Text = "Exit (" .. Counter .. ")"
		until Counter <= 0

		Button.Text = "Exit"
		Button.BackgroundTransparency = 0
		Button.Interactable = true

		Button.MouseButton1Click:Connect(function()
			UI.PostPurchase.Visible = false
		end)
	end)
end)

-- experienced scripters, do NOT look beyond this point. you will have a stroke.

PrePurchaseFrame.ViewStore.MouseButton1Click:Connect(function()
	Functions.ToggleUI(UI.PrePurchase, UI.Container)
end)

PrePurchaseFrame.ViewPurchases.MouseButton1Click:Connect(function()
	Functions.ToggleUI(UI.PrePurchase, UI.Purchases)
end)

PrePurchaseFrame.ViewAgreement.MouseButton1Click:Connect(function()
	Functions.ToggleUI(UI.PrePurchase, UI.Agreement)
end)

PurchasesContainer.Purchase.MouseButton1Click:Connect(function()
	Functions.ToggleUI(UI.Purchases, UI.PrePurchase)
end)

Container.Return.MouseButton1Click:Connect(function()
	Functions.ToggleUI(UI.Container, UI.PrePurchase)
end)

AgreementFrame.Return.MouseButton1Click:Connect(function()
	Functions.ToggleUI(AgreementFrame, PrePurchaseFrame)
end)
