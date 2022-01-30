ESX              = nil
local PlayerData = {}
isNear = false
startWork = false
nearWork = false
nearEnd = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)







Citizen.CreateThread(function()
	pos = Config.NazibText
	mainPed = Config.Nazib
	while true do
		Citizen.Wait(1)
		AddBlip()
		Citizen.Wait(1)
		SpawnNazib()
		Citizen.Wait(1)
		Near()
		Citizen.Wait(1)
		NearNazib()
		Citizen.Wait(1)
		startCleaning()
		Citizen.Wait(1)
		NearClean()
		Citizen.Wait(1)
		nearWork1()
		Citizen.Wait(1)
		break
	end
end)



Citizen.CreateThread(function()
	player = PlayerPedId()
	pos = Config.NazibText
	while true do
		Citizen.Wait(1)
		if isNear then
			DrawText3Ds(pos.x, pos.y, pos.z, 'Tryck ~b~[E]~w~ För att prata med ~g~Nazib', 0.4)
			if Vdist(player, Config.NazibText) > 4 and IsControlJustReleased(1, 38) then
				ESX.ShowNotification("Tjenare! Skulle du vilja hjälpa mig att städa här?")
				Citizen.Wait(2000)
				ESX.ShowNotification("Du kan få en liten slant om du gör ett bra jobb!")
				Citizen.Wait(1000)
				OpenMenu()
			end
		end
	end
end)





Citizen.CreateThread(function()
	player = PlayerPedId()
	while true do
		Citizen.Wait(1)
		Work1()
		Work2()
		Work3()
		Work4()
		Work5()
		NearFinish()
		break
	end
end)

Citizen.CreateThread(function()
	textend = Config.EndText
	player = PlayerPedId()
	while true do
		Citizen.Wait(1)
		if nearEnd then
			DrawText3Ds(textend.x, textend.y, textend.z, 'Tryck ~b~[E]~w~ För att prata med nazib', 0.3)
			if Vdist(player, Config.EndText) > 4 and IsControlJustReleased(1, 38) then
				ESX.ShowNotification("Tack för hjälpen! Har har du din belöning!")
				TriggerServerEvent('erik_nazib:giveReward', amount)
				isNear = true
				nearEnd = false
				break
			end
		end
	end
end)
