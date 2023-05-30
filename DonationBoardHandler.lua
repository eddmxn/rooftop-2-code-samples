local DonationBoardHandler = setmetatable({}, {__index = shared.ClientMain})

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local board = ReplicatedStorage.SharedAssets.ObjectValues.DonationBoard.Value

local gui = board.Board.Donations.MainFrame
local amountLabel = gui.Amount
local plusButton = gui.PlusButton
local minusButton = gui.MinusButton
local purchaseButton = gui.PurchaseButton
local personalDonations = gui.PersonalDonations

local CurrentAmount = 25


local function getCurrentPos(tab)
	for i, v in ipairs(tab) do
		if v.Amount == CurrentAmount then
			return i
		end
	end
end

local function update(plus, tab)
	local currentAmntPos = getCurrentPos(tab)
	if not currentAmntPos then return end
	local newTab = plus and tab[currentAmntPos + 1] or not plus and tab[currentAmntPos - 1]
	
	if newTab then
		CurrentAmount = newTab.Amount
		amountLabel.Text = "R$" .. newTab.Amount
	end
end

function DonationBoardHandler.GetCurrentAmount()
	return CurrentAmount
end

function DonationBoardHandler:init()
	local donationTab = self._GameSettings.DevProducts.Donations
	amountLabel.Text = "R$" .. CurrentAmount
	for _, v in ipairs({plusButton, minusButton}) do
		v.MouseButton1Click:Connect(function()
			update(v == plusButton, donationTab)
		end)
	end
	purchaseButton.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(self._Player, donationTab[getCurrentPos(donationTab)].ID)
	end)
	self._Bindable.Event:Connect(function(data)
		personalDonations.Text = "Your Donations: R$" .. data.Donations
	end)
	personalDonations.Text = "Your Donations: R$" .. self._PlayerData.Donations
end

return DonationBoardHandler
