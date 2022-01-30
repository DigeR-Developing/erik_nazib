startWork = false
nearWork = false
NearWork1 = false
isDone = false
nearEnd = false

function DrawMissionText(text, height, length)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(length, height)
end

function BlipDetails(blipName, blipText, color, route)
    BeginTextCommandSetBlipName("STRING")
    SetBlipColour(blipName, color)
    AddTextComponentString(blipText)
    SetBlipRoute(blipName, route)
    EndTextCommandSetBlipName(blipName)
end

function DrawText3Ds(x,y,z, text, scale)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function CancelMission()
    RemoveBlip(PickUpPosBlipCoke)
    RemoveBlip(PickUpPosBlipWeed)
    RemoveBlip(PickUpPosBlipMeth)
    RemoveBlip(PickUpPosBlipRadius)
    RemoveBlip(returnToKalle)
    RemoveBlip(PickUpPosBlipRadiusWeed)
    RemoveBlip(PickUpPosBlipRadiusMeth)
    RemoveBlip(PickUpPosBlipRadiusCoke)
end

function Draw3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    SetTextScale(0.38, 0.38)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 200)
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end



function AddBlip()
    homeblip = AddBlipForCoord(Config.HomeBlip)
    AddTextEntry('MYBLIP', 'Nazib')
    SetBlipSprite(homeblip, 149)
    SetBlipScale(homeblip, 0.7)
    BeginTextCommandSetBlipName('MYBLIP')
    AddTextComponentSubstringPlayerName('me')
    EndTextCommandSetBlipName(homeblip)
end

function SpawnNazib()
    mainPed = Config.Nazib
    RequestModel(mainPed)
	while not HasModelLoaded(Config.Nazib) do
		Wait(7)
	end
	if not DoesEntityExist(mainPed) then
		mainPed = CreatePed(4, Config.Nazib, Config.NazibPos, 77.0, false, true)
        Wait(3000)
        FreezeEntityPosition(mainPed, true)
        SetBlockingOfNonTemporaryEvents(mainPed, true)
        SetEntityInvincible(mainPed, true)
        ESX.LoadAnimDict("mini@strip_club@idles@bouncer@base")
        TaskPlayAnim(mainPed, 'mini@strip_club@idles@bouncer@base', 'base', 1.0, -1.0, -1, 69, 0, 0, 0, 0)
	end
end



function Near()
    player = PlayerPedId()
    isNear = false
    while true do
        Wait(1)
        if Vdist(GetEntityCoords(player), Config.NazibText) < 4 and not startWork then
            isNear = true
        else
            isNear = false
        end
    end
end


local options = {
    {label = "Ja", value = "yes"},
    {label = "Nej", value = "no" }
}



function OpenMenu()
	isOpen = true
	spawncar = false
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general', {
			title = "Vill du hjälpa Nazib att städa?",
			align = 'top-right',
			elements = options,
	},
	function(data, menu)
		menu.close()
		isOpen = false

		if data.current.value == 'yes' then
			ESX.ShowNotification("Vad snällt av dig! Städa vid dem runda ringarna som jag placerat ut lite här och där!")
            HelpNotify()
            startWork = true
		end
		if data.current.value == 'no' then
           ESX.ShowNotification("Okej! Du vet vart jag finns om du ångrar dig!")
            startWork = false
		end
	end,
	function(data, menu)
		menu.close()
		isOpen = false
	end)
end

function HelpNotify()
    while true do
        Citizen.Wait(10)
        ESX.ShowHelpNotification('Det du ska göra är att gå till cirklarna och städa dem!', false, true, true, 1000)
        Citizen.Wait(10)
        break
    end
end




function NearClean()
    player = PlayerPedId()
    while true do
        Citizen.Wait(1)
        if Vdist(GetEntityCoords(player), Config.WorkMarker1) < 4  and startWork then
            nearWork = true
        else
            nearWork = false
        end
    end
end

function NearWork1()
    player = PlayerPedId()
    while true do
        Citizen.Wait(1)
        if Vdist(GetEntityCoords(player), Config.WorkText1) < 4 and startWork then
            nearWork1 = true
        else
            nearWork1 = false
        end
    end
end


function Work1()
    player = PlayerPedId()
    workpos1 = Config.WorkMarker1
	worktxt1 = Config.WorkText1
    while true do
        Citizen.Wait(1)
        if startWork then
            workblip1 = DrawMarker(27, workpos1.x, workpos1.y, workpos1.z + -0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 1, 0, 50, false, true, 2, nil, nil, false)
			worktext1 = DrawText3Ds(worktxt1.x, worktxt1.y, worktxt1.z, 'Tryck ~r~[E]~w~ för att ~b~städa', 0.3)
            if Vdist(GetEntityCoords(player), Config.WorkMarker1 and Config.WorkText1) < 0.5 and IsControlJustReleased(1, 38) then
                FreezeEntityPosition(player, true)
                exports["horizon_progressbar"]:StartDelayedFunction({
 					["text"] = "Städar",
 					["delay"] = 9250
 				})
                Citizen.Wait(9250)
                FreezeEntityPosition(player, false)
                ESX.ShowNotification('Bra Jobbat! Bara 4 Positioner Kvar!')
                workblip1 = false
                worktext1 = false
                break
            end
        end
    end
end
            

function Work2()
    player = PlayerPedId()
    workpos2 = Config.WorkMarker2
    worktxt2 = Config.WorkText2
    while true do
        Citizen.Wait(1)
        if startWork then
            workblip2 = DrawMarker(27, workpos2.x, workpos2.y, workpos2.z + -0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 1, 0, 50, false, true, 2, nil, nil, false)
            worktext2 = DrawText3Ds(worktxt2.x, worktxt2.y, worktxt2.z, 'Tryck ~r~[E]~w~ för att ~b~städa', 0.3)
            if Vdist(GetEntityCoords(player), Config.WorkMarker2, Config.WorkText2) < 0.5 and IsControlJustReleased(1, 38) then
                FreezeEntityPosition(player, true)
                exports["horizon_progressbar"]:StartDelayedFunction({
 					["text"] = "Städar",
 					["delay"] = 9250
				})
                Citizen.Wait(9250)
                FreezeEntityPosition(player, false)
                ESX.ShowNotification("Bra Jobbat! 3 Positioner Kvar!")
                workblip2 = false
                worktext2 = false
                break
            end
        end
    end
end

function Work3()
    player = PlayerPedId()
    workpos3 = Config.WorkMarker3
    worktxt3 = Config.WorkText3
    while true do
        Citizen.Wait(1)
        if startWork then
            workblip3 = DrawMarker(27, workpos3.x, workpos3.y, workpos3.z + -0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 1, 0, 50, false, true, 2, nil, nil, false)
            worktext3 = DrawText3Ds(worktxt3.x, worktxt3.y, worktxt3.z, 'Tryck ~r~[E]~w~ för att ~b~städa', 0.3)
            if Vdist(GetEntityCoords(player), Config.WorkMarker3, Config.WorkText3) < 0.5 and IsControlJustReleased(1, 38) then
                FreezeEntityPosition(player, true)
                exports["horizon_progressbar"]:StartDelayedFunction({
 					["text"] = "Städar",
 					["delay"] = 9250
				})
                Citizen.Wait(9250)
                FreezeEntityPosition(player, false)
                ESX.ShowNotification("Snyggt! Bara 2 ställen kvar!!")
                workblip3 = false
                worktext3 = false
                break
            end
        end
    end
end


function Work4()
    player = PlayerPedId()
    workpos4 = Config.WorkMarker4
    worktxt4 = Config.WorkText4
    while true do
        Citizen.Wait(1)
        if startWork then
            workblip4 = DrawMarker(27, workpos4.x, workpos4.y, workpos4.z + -0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 1, 0, 50, false, true, 2, nil, nil, false)
            worktext4 = DrawText3Ds(worktxt4.x, worktxt4.y, worktxt4.z, 'Tryck ~r~[E]~w~ för att ~b~städa', 0.3)
            if Vdist(GetEntityCoords(player), Config.WorkMarker4, Config.WorkText4) < 0.5 and IsControlJustReleased(1, 38) then
                FreezeEntityPosition(player, true)
                exports["horizon_progressbar"]:StartDelayedFunction({
 					["text"] = "Städar",
 					["delay"] = 9250
				})
                Citizen.Wait(9250)
                FreezeEntityPosition(player, false)
                ESX.ShowNotification("Snyggt! Bara 1 plats kvar!")
                workblip4 = false
                worktext4 = false
                break
            end
        end
    end
end


function Work5()
    player = PlayerPedId()
    workpos5 = Config.WorkMarker5
    worktxt5 = Config.WorkText5
    while true do
        Citizen.Wait(1)
        if startWork then
            workblip5 = DrawMarker(27, workpos5.x, workpos5.y, workpos5.z + -0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 1, 0, 50, false, true, 2, nil, nil, false)
            worktext5 = DrawText3Ds(worktxt5.x, worktxt5.y, worktxt5.z, 'Tryck ~r~[E]~w~ för att ~b~städa', 0.3)
            if Vdist(GetEntityCoords(player), Config.WorkMarker5, Config.WorkText5) < 0.5 and IsControlJustReleased(1, 38) then
                FreezeEntityPosition(player, true)
                exports["horizon_progressbar"]:StartDelayedFunction({
 					["text"] = "Städar",
 					["delay"] = 9250
				})
                Citizen.Wait(9250)
                FreezeEntityPosition(player, false)
                ESX.ShowNotification("Bra Jobbat! Gå nu och prata med nazib för att få din belöning!")
                workblip5 = false
                worktext5 = false
                isDone = true
                break
            end
        end
    end
end


function NearFinish()
    player = PlayerPedId()
    while true do
        Citizen.Wait(1)
        if Vdist(GetEntityCoords(player), Config.EndText) < 4 and startWork and not isNear then
            nearEnd = true
        else
            nearEnd = false
        end
    end
end
        

