ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



AddEventHandler('erik_nazib:giveReward')
RegisterNetEvent('erik_nazib:giveReward', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = xPlayer.addMoney(math.random(1000,4000))
    if workDone then
        xPlayer.addMoney(amount)
    end
end)
