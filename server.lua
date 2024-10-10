RegisterServerEvent('carthief:pdnotify')
AddEventHandler('carthief:pdnotify', function(activeBlipsx, activeBlipsVehicle)
	TriggerClientEvent('carthief:alert', -1, activeBlipsx, activeBlipsVehicle)
end)





RegisterServerEvent('DL_CarThief:payment')
AddEventHandler('DL_CarThief:payment', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if DL.Reward.Money then
		old = xPlayer.getMoney()
		xPlayer.addMoney(DL.Reward.MoneyAmount)
		new = xPlayer.getMoney()
		xPlayer.showNotification('Udało Ci się dostarczyć pojazd otrzymujesz za to: '..new-old.. "$")

	end
	if DL.Reward.Items then
		item = DL.Reward.ItemPool[math.random(#DL.Reward.ItemPool)]
		xPlayer.addInventoryItem(item, math.random(DL.Reward.Item.Min, DL.Reward.Item.Max))

	end
end)

