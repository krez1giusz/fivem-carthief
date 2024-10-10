PlayerData = {}
local stolenCars = {}
local activeBlips = {}

if ESX.IsPlayerLoaded() then -- If the resource starts while players are loaded
	Citizen.SetTimeout(100, function()
		ESX.PlayerLoaded = true
		PlayerData = ESX.GetPlayerData()
	end)
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData, isNew) -- When a player loads
	ESX.PlayerLoaded = true
	PlayerData = playerData
end)


RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function() -- When a player logs out
	ESX.PlayerLoaded = false
	PlayerData = {}
end)



RegisterCommand('zlecenie', function()
	local activeThievs = 0
	if activeThievs >= DL.MaxActiveJobs then
		ESX.ShowNotification("Nie mozesz wziąc kolejnego zlecenia! Odpuść na teraz!")
	else
		zlecenie(activeThievs)
	end
end)

zlecenie = function(activeThievs)
	local vehiclesToSteal = {}
	activeThievs = activeThievs + 1
	coords = DL.CarPositions[math.random(#DL.CarPositions)]
	car = DL.CarList[math.random(#DL.CarList)]
	color = DL.Colors[math.random(#DL.Colors)]



	ESX.Game.SpawnVehicle(car, vector3(coords.x,coords.y,coords.z), coords.h, function(vehicle)
		if DoesEntityExist(vehicle) then
			vehiclesToSteal[#vehiclesToSteal+1] = {vehicle = NetworkGetNetworkIdFromEntity(vehicle), color = color.name, reset = DL.ResetTime}
			SetVehicleColours(vehicle, color.id, color.id)
			ESX.ShowNotification("Pojazd który musisz ukraść to: "..GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)).. ' Rejestracja: '.. GetVehicleNumberPlateText(vehicle).. ' Lakier: '..color.name)
			carLoop(vehiclesToSteal, activeThievs)
			addBlip(coords,vehiclesToSteal)
		end	 
	end)
end


carLoop = function(vehiclesToSteal, activeThievs)
	CreateThread(function()
		while activeThievs > 0 do
			if IsPedInAnyVehicle(PlayerPedId()) then
				for i=1, #vehiclesToSteal do
					if NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId())) == vehiclesToSteal[i].vehicle then
						killBlip(vehiclesToSteal[i].vehicle)
						stolenCars[#stolenCars+1] = {vehicle = vehiclesToSteal[i].vehicle}
						table.remove(vehiclesToSteal, i)
					end
				end
			end

			for i=1, #vehiclesToSteal do
				if vehiclesToSteal[i].reset > 0 then
					vehiclesToSteal[i].reset = vehiclesToSteal[i].reset - 3000
				elseif vehiclesToSteal[i].reset <= 0 then
					ESX.ShowNotification('Minął czas na przejęcie tego pojazdu !')
					ESX.Game.DeleteVehicle(NetworkGetEntityFromNetworkId(vehiclesToSteal[i].vehicle))
					for i=1, #activeBlips do
						if activeBlips[i].vehicle == vehiclesToSteal[i].vehicle then
							RemoveBlip(activeBlips[i].value)
						end
					end
					activeThievs = activeThievs - 1
					table.remove(vehiclesToSteal, i)
				end
			end
			Wait(3000)
		end
	end)
end


addBlip = function(coords, vehiclesToSteal)
	for i=1, #vehiclesToSteal do
		coord = GetEntityCoords(NetworkGetEntityFromNetworkId(vehiclesToSteal[i].vehicle))
		blip = AddBlipForCoord(coord.x, coord.y, coord.z)
		SetBlipSprite (blip, 596)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour(blip, 61)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString("Zlecenie: "..GetDisplayNameFromVehicleModel(GetEntityModel(NetworkGetEntityFromNetworkId(vehiclesToSteal[i].vehicle))))
		EndTextCommandSetBlipName(blip)
		activeBlips[#activeBlips+1] = {value = blip, vehicle = vehiclesToSteal[i].vehicle, timeout = DL.Alert.PDStop}
		blip = nil
	end
end

killBlip = function(vehicle)
	local onroutewithcar = false
	ESX.ShowNotification("Udało Ci się ukraść pojazd, teraz przez 10 minut LSPD będzie miało twoją dokładną lokalizację! Postaraj się ich zgubić.")
	for i=1, #activeBlips do
		if activeBlips[i].vehicle == vehicle then
			RemoveBlip(activeBlips[i].value)
			TriggerServerEvent("carthief:pdnotify", activeBlips, activeBlips[i].vehicle)
			Wait(DL.Alert.PDStop)
			table.remove(activeBlips, i )
			ESX.ShowNotification('Nadajnik się rozładował! Możesz odstawić samochód do punktu zrzutu')
			onroutewithcar = true
			SetDestinationRoute(onroutewithcar)
		end
	end

end


RegisterNetEvent('carthief:alert')
AddEventHandler('carthief:alert', function(activeblips, vehicles)
	local pdBlips = {}
	if ESX.PlayerData.job.name == 'police' then
		for i=1, #activeBlips do
			repeat
				coord = GetEntityCoords(NetworkGetEntityFromNetworkId(activeblips[i].vehicle))
				blip = AddBlipForCoord(coord.x, coord.y, coord.z)
				SetBlipSprite (blip, 433)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour(blip, 61)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString("Skradziony pojazd")
				EndTextCommandSetBlipName(blip)
				pdBlips[#pdBlips+1] = {value = blip, vehicle = activeblips[i].vehicle}
				Wait(5000)
				activeblips[i].timeout = activeblips[i].timeout - 5000
				for i=1, #pdBlips do
					if pdBlips[i].value == blip then
						RemoveBlip(pdBlips[i].value)
						blip = nil
						table.remove(pdBlips, i)
					end
				end
			until activeblips[i].timeout <= 0

			impulse = GetEntityCoords(NetworkGetEntityFromNetworkId(activeblips[i].vehicle))
			lastBlip = AddBlipForCoord(impulse)
			SetBlipSprite (lastBlip, 645)
			SetBlipDisplay(lastBlip, 4)
			SetBlipScale  (lastBlip, 0.8)
			SetBlipColour(lastBlip, 61)
			SetBlipAsShortRange(lastBlip, true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString("Ostatni impuls GPS")
			EndTextCommandSetBlipName(lastBlip)
			ESX.ShowNotification('Nadajnik się rozładował, na gps\'ie zaznaczono jego ostatni impuls!')
			Wait(DL.Alert.LastImpulseTime)

		end
	end
end)


SetDestinationRoute = function(onroutewithcar)
	local area = AddBlipForRadius(DL.DropOff.x, DL.DropOff.y, DL.DropOff.z, DL.DropOff.radius)
	CreateThread(function()
		while onroutewithcar do
			Wait(2000)
			if #(GetEntityCoords(PlayerPedId()) - vector3(DL.DropOff.x, DL.DropOff.y, DL.DropOff.z)) <= DL.DropOff.radius then
				carsInArea = ESX.Game.GetVehiclesInArea(vector3(DL.DropOff.x, DL.DropOff.y, DL.DropOff.z), DL.DropOff.radius)
				for i=1, #stolenCars do
					id = i
					for i=1, #carsInArea do
						if NetworkGetNetworkIdFromEntity(carsInArea[i]) == stolenCars[i].vehicle then
							veh = GetVehiclePedIsIn(PlayerPedId())
							Wait(4000)
							table.remove(stolenCars, id)
							TriggerServerEvent('DL_CarThief:payment')
							RemoveBlip(area)
							onroutewithcar = false
							ESX.Game.DeleteVehicle(veh)
						end
					end
				end	
			end
		end
	end)
end
