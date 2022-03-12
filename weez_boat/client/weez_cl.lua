ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local societyboatmoney = nil

boat             = {}
boat.DrawDistance = 100
boat.Size         = {x = 1.0, y = 1.0, z = 1.0}
boat.Color        = {r = 255, g = 255, b = 255}
boat.Type         = 20

weez_boatsh = {
	catevehi = {},
	listecatevehi = {},
}

local derniervoituresorti = {}
local sortirvoitureacheter = {}

Citizen.CreateThread(function()

        local boatmap = AddBlipForCoord(-805.96, -1369.33, 5.17) -- Blips
        SetBlipSprite(boatmap, 427)
        SetBlipColour(boatmap, 18)
        SetBlipScale(boatmap, 0.90)
        SetBlipAsShortRange(boatmap, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Concessionnaire | Bateau")
        EndTextCommandSetBlipName(boatmap)

end)

local markerjob = {
        {x = -805.96, y = -1369.33, z = 5.17}, -- point de vente
}  

Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(markerjob) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boat' then 
            if (boat.Type ~= -1 and GetDistanceBetweenCoords(coords, markerjob[k].x, markerjob[k].y, markerjob[k].z, true) < boat.DrawDistance) then
                DrawMarker(boat.Type, markerjob[k].x, markerjob[k].y, markerjob[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boat.Size.x, boat.Size.y, boat.Size.z, boat.Color.r, boat.Color.g, boat.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    
end
end)

local boatpointvente = false
RMenu.Add('weezboatv', 'main', RageUI.CreateMenu("Menu Concess", "Pour vendre des bateau"))
RMenu.Add('weezboatv', 'listeboat', RageUI.CreateSubMenu(RMenu:Get('weezboatv', 'main'), "Catalogue", "Pour acheter un bateau"))
RMenu.Add('weezboatv', 'categorievehicule', RageUI.CreateSubMenu(RMenu:Get('weezboatv', 'listeboat'), "Bateau", "Pour acheter un bateau"))
RMenu.Add('weezboatv', 'achatvehicule', RageUI.CreateSubMenu(RMenu:Get('weezboatv', 'categorievehicule'), "Bateau", "Pour acheter un bateau"))
RMenu.Add('weezboatv', 'annonces', RageUI.CreateSubMenu(RMenu:Get('weezboatv', 'main'), "Annonces", "Annonces de la ville"))
RMenu:Get('weezboatv', 'main').Closed = function()
    boatpointvente = false
end
RMenu:Get('weezboatv', 'categorievehicule').Closed = function()
    supprimervehiculeconcess()
end

function ouvrirpointventeconc()
    if not boatpointvente then
        boatpointvente = true
        RageUI.Visible(RMenu:Get('weezboatv', 'main'), true)
    while boatpointvente do

        RageUI.IsVisible(RMenu:Get('weezboatv', 'main'), true, true, true, function()
           
            RageUI.ButtonWithStyle("Catalogue bateau", nil, {RightLabel = "→→→"},true, function()
           end, RMenu:Get('weezboatv', 'listeboat'))
           
           RageUI.ButtonWithStyle("Facture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else
                    	local amount = KeyboardInput('Veuillez saisir le montant de la facture', '', 4)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_boat', 'boat', amount)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Annonces", nil, {RightLabel = "→→→"},true, function()
            end, RMenu:Get('weezboatv', 'annonces'))
    
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('weezboatv', 'listeboat'), true, true, true, function()
        	for i = 1, #weez_boatsh.catevehi, 1 do
            RageUI.ButtonWithStyle("Catégorie - "..weez_boatsh.catevehi[i].label, nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            		nomcategorie = weez_boatsh.catevehi[i].label
                    categorievehi = weez_boatsh.catevehi[i].name
                    ESX.TriggerServerCallback('weez_boat:grabliste', function(listevehi)
                            weez_boatsh.listecatevehi = listevehi
                    end, categorievehi)
                end
            end, RMenu:Get('weezboatv', 'categorievehicule'))
        	end
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('weezboatv', 'categorievehicule'), true, true, true, function()
        	RageUI.ButtonWithStyle("↓ Catégorie : "..nomcategorie.." ↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)

        	for i2 = 1, #weez_boatsh.listecatevehi, 1 do
            RageUI.ButtonWithStyle(weez_boatsh.listecatevehi[i2].name, "Pour acheter ce bateau", {RightLabel = weez_boatsh.listecatevehi[i2].price.."$"},true, function(Hovered, Active, Selected)
            if (Selected) then
            		nomvoiture = weez_boatsh.listecatevehi[i2].name
            		prixvoiture = weez_boatsh.listecatevehi[i2].price
            		modelevoiture = weez_boatsh.listecatevehi[i2].model
            		supprimervehiculeconcess()
					chargementvoiture(modelevoiture)

					ESX.Game.SpawnLocalVehicle(modelevoiture, {x = -807.73, y = -1362.07, z = 5.17}, 251.959, function (vehicle) -- Point d'apparition
					table.insert(derniervoituresorti, vehicle)
					FreezeEntityPosition(vehicle, true)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					SetModelAsNoLongerNeeded(modelevoiture)
					end)
                end
            end, RMenu:Get('weezboatv', 'achatvehicule'))

        	end
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('weezboatv', 'achatvehicule'), true, true, true, function()
        	RageUI.ButtonWithStyle("Nom du modèle : "..nomvoiture, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)
            RageUI.ButtonWithStyle("Prix du véhicule : "..prixvoiture.."$", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)
            RageUI.ButtonWithStyle("Vendre au client", "Attribue le véhicule au client le plus proche (paiement avec argent entreprise)", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            	ESX.TriggerServerCallback('weez_boat:verifsousconcess', function(suffisantsous)
                if suffisantsous then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification('Personne autour')
				else
				supprimervehiculeconcess()
				chargementvoiture(modelevoiture)

				ESX.Game.SpawnVehicle(modelevoiture, {x = -846.23, y = -1361.1, z = -0.48}, 99.5, function (vehicle)  -- Point d'apparition apres vente
				table.insert(sortirvoitureacheter, vehicle)
				FreezeEntityPosition(vehicle, true)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				SetModelAsNoLongerNeeded(modelevoiture)
				local plaque     = GeneratePlate()
                local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                vehicleProps.plate = plaque
                SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)

				TriggerServerEvent('weez_boat:selltoplayer', GetPlayerServerId(closestPlayer), vehicleProps, prixvoiture)
				ESX.ShowNotification('Le bateau '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(closestPlayer))
                TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
				end)
				end
                else
                    ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce bateau!')
                end

            end, prixvoiture)
                end
            end)

            RageUI.ButtonWithStyle("Acheter le Bateau", "Attribue le bateau à vous même ( argent de societé )", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                    ESX.TriggerServerCallback('weez_boat:verifsousconcess', function(suffisantsous)
                    if suffisantsous then
                    supprimervehiculeconcess()
                    chargementvoiture(modelevoiture)
                    ESX.Game.SpawnVehicle(modelevoiture, {x = -846.23, y = -1361.1, z = -0.48}, 99.5, function (vehicle)  -- Point d'apparition apres vente
                    table.insert(sortirvoitureacheter, vehicle)
                    FreezeEntityPosition(vehicle, true)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    SetModelAsNoLongerNeeded(modelevoiture)
                    local plaque     = GeneratePlate()
                    local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                    vehicleProps.plate = plaque
                    SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                    FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)

                    TriggerServerEvent('shop:vehicule', vehicleProps, prixvoiture)
                    ESX.ShowNotification('Le bateau '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(closestPlayer))
                    TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
                    end)

                    else
                        ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce bateau!')
                    end
    
                end, prixvoiture)
                    end
                end)

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('weezboatv', 'annonces'), true, true, true, function()
                
                RageUI.ButtonWithStyle("Ouvert", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TriggerServerEvent('Open:Ads')
                    end
                end)

                RageUI.ButtonWithStyle("Fermer", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TriggerServerEvent('Close:Ads')
                    end
                end)

                end, function()
                end)

            Citizen.Wait(0)
        end
    else
        boatpointvente = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
                local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, -805.96, -1369.33, 5.17) -- point de vente
            if jobdist <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'boat' then  
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au menu concess")
                    if IsControlJustPressed(1,51) then
                    	ESX.TriggerServerCallback('weez_boat:grabcate', function(catevehi)
                            weez_boatsh.catevehi = catevehi
                        end)
                        boatpointvente = false
                        ouvrirpointventeconc()
                    end   
                end
               end 
        end
end)

function supprimervehiculeconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('shop_awaiting_model')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end