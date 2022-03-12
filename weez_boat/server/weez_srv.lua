ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'boat', 'alerte concess-bateau', true, true)

TriggerEvent('esx_society:registerSociety', 'boat', 'Concess Bateau', 'society_boat', 'society_boat', 'society_boat', {type = 'public'})


ESX.RegisterServerCallback('weez_boat:grabcate', function(source, cb)
    local catevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM boat_categories', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(catevehi, {
                name = result[i].name,
                label = result[i].label
            })
        end

        cb(catevehi)
    end)
end)

ESX.RegisterServerCallback('weez_boat:grabliste', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM boat WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = result[i].price
            })
        end

        cb(listevehi)
    end)
end)

ESX.RegisterServerCallback('weez_boat:camarche', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

RegisterServerEvent('weez_boat:selltoplayer')
AddEventHandler('weez_boat:selltoplayer', function (playerId, vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
            account.removeMoney(prix)
    end)
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
    {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@type'] = 'boat'
    }, function (rowsChanged)
    end)
end)

RegisterServerEvent('shop:vehicule')
AddEventHandler('shop:vehicule', function(vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
        account.removeMoney(prix)
end)
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@type'] = 'boat'
    }, function(rowsChange)
    end)
end)

ESX.RegisterServerCallback('weez_boat:verifsousconcess', function(source, cb, prixvoiture)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_boat', function (account)
        if account.money >= prixvoiture then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('Open:Ads')
AddEventHandler('Open:Ads', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Bateau', '~b~Annonce', 'Le Concess Bateau est désormais ~g~Ouvert~s~ !', 'CHAR_CARSITE', 8)
	end
end)

RegisterServerEvent('Close:Ads')
AddEventHandler('Close:Ads', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Bateau', '~b~Annonce', 'Le Concess Bateau est désormais ~r~Fermer~s~ !', 'CHAR_CARSITE', 8)
	end
end)

RegisterCommand('acon', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "boat" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Bateau', '~b~Annonce', ''..msg..'', 'CHAR_CARSITE', 0)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas concessionnaire pour faire cette commande', 'CHAR_CARSITE', 0)
    end
else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas concessionnaire pour faire cette commande', 'CHAR_CARSITE', 0)
end
end, false)