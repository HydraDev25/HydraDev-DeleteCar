local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('delcar', 'Delete a vehicle from a player', {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        TriggerClientEvent('qb-car:client:openDelCarMenu', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Dont Have Permission To Use Command.', 'error')
    end
end)

RegisterNetEvent('qb-car:server:deleteCarByPlate', function(plate, targetSrc)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetPlayer = nil
    
    if targetSrc and tonumber(targetSrc) > 0 then
        TargetPlayer = QBCore.Functions.GetPlayer(tonumber(targetSrc))
    end
    
if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(vehicles)
        if vehicles and #vehicles > 0 then
            local vehicleModel = vehicles[1].vehicle
            local targetID = "Unknown"
            local targetName = "Unknown"

            if TargetPlayer then
                targetID = targetSrc
                targetName = TargetPlayer.PlayerData.name
            else
                targetID = vehicles[1].citizenid or "Unknown"

                local ownerData = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', {vehicles[1].citizenid})
                if ownerData and ownerData[1] then
                    local charInfo = json.decode(ownerData[1].charinfo)
                    if charInfo then
                        targetName = charInfo.firstname .. ' ' .. charInfo.lastname
                    end
                end
            end

            MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', {plate}, function(result)
                if result and result.affectedRows > 0 then
                    MySQL.query('DELETE FROM gloveboxitems WHERE plate = ?', {plate})
                    MySQL.query('DELETE FROM trunkitems WHERE plate = ?', {plate})

                    TriggerClientEvent('QBCore:Notify', src, 'Vehicle with plate ' .. plate .. ' has been deleted', 'success')

                    TriggerEvent('hydradev-logs:server:CreateLog', 'delcar', 'Vehicle Deleted', 'green', 
                        'Deleted by: ' .. Player.PlayerData.name .. 
                        '\nDeleter ID: ' .. src ..
                        '\nTarget player: ' .. targetName .. 
                        '\nTarget Citizen ID: ' .. targetID ..
                        '\nDeleted Vehicle Plate: ' .. plate ..
                        '\nVehicle Model: ' .. vehicleModel
                    )
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Vehicle deletion failed', 'error')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'No vehicle found with this plate', 'error')
        end
    end)
end

        end)
    end
end)