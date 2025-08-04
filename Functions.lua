--[[

	» Roblox Asset Hub | Functions Module | «
	
	Functions Module v0.1.0
	
	Written by iiBright2676
	**DO NOT TOUCH UNLESS YOU ARE FORKING.**

]]--

local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Functions = {}

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

function Functions.AddHoverEffect(Button)
	if not Button or not Button:IsA("GuiButton") then return end

	local DefaultSize = Button.Size

	local HoverTween = TweenService:Create(Button, TweenInfo.new(.15, Enum.EasingStyle.Sine), {
		Size = DefaultSize + UDim2.new(.02, 0, .02, 0)
	})

	local UnhoverTween = TweenService:Create(Button, TweenInfo.new(.15, Enum.EasingStyle.Sine), {
		Size = DefaultSize
	})

	Button.MouseEnter:Connect(function()
		PlayerGui.UserInterface.Hover:Play()
		HoverTween:Play()
	end)

	Button.MouseLeave:Connect(function()
		UnhoverTween:Play()
	end)
end

function Functions.SelectProduct(Frame, AssetsModule)
	for _, Tagged in CollectionService:GetTagged("Product") do
		if Tagged:FindFirstChild("UIStroke") then
			Tagged.UIStroke.Color = Color3.fromRGB(200, 200, 200)
		end
	end

	if Frame:FindFirstChild("UIStroke") then
		Frame.UIStroke.Color = Color3.fromRGB(0, 122, 255)
	end

	return Frame.Name, AssetsModule[Frame.Name]
end

function Functions.UpdatePurchaseLogUI(PurchaseHistory, Template, PurchasesFrame)
	for _, Child in ipairs(PurchasesFrame:GetChildren()) do
		if Child:IsA("TextButton") and Child ~= Template then
			Child:Destroy()
		end
	end

	for i, Log in ipairs(PurchaseHistory) do
		local Entry = Template:Clone()
		Entry.Visible = true
		Entry.Name = "Log_" .. i
		Entry.Text = "[" .. Log.Time .. "] " .. Log.Name .. " (Product ID: " .. Log.ID .. ")"
		Entry.Parent = PurchasesFrame

		Functions.AddHoverEffect(Entry)
	end
end

function Functions.ToggleUI(From, To)
	From.Visible = false
	To.Visible = true
end

return Functions