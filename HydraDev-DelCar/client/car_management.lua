local QBCore = exports['qb-core']:GetCoreObject()
local ServerName = "Hydra Development"

RegisterNetEvent('qb-car:client:openDelCarMenu')
AddEventHandler('qb-car:client:openDelCarMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = ServerName .. " - Delete Car",
        submitText = "Confirm",
        inputs = {
            {
                text = "Plate (Maximum 9 characters)",
                name = "plate",
                type = "text",
                isRequired = true
            }
        }
    })
    
    if dialog then
        if not dialog.plate then
            QBCore.Functions.Notify("Plate is required.", "error")
            return
        end
        
        if string.len(dialog.plate) > 9 then
            QBCore.Functions.Notify("Plate maximum 9 characters.", "error")
            return
        end
        
        TriggerServerEvent('qb-car:server:deleteCarByPlate', dialog.plate)
    end
end)

TriggerEvent('chat:addSuggestion', '/delcar - Delete A Vehicle By License Plate (Admin Only)')
