--props
local propsToDelete = {
   `prop_streetlight_01`,   
    `prop_streetlight_03`,
   `prop_fire_hydrant_2`,
    `prop_fire_hydrant_1`,
    `prop_traffic_01d`,
}


local function isDeletableProp(entity)
    local model = GetEntityModel(entity)
    for _, prop in ipairs(propsToDelete) do
        if model == prop then
            return true
        end
    end
    return false
end


local function deleteEntityWithPhysics(entity)
    if DoesEntityExist(entity) then
        if not NetworkHasControlOfEntity(entity) then
            NetworkRequestControlOfEntity(entity)
            local timeout = 0
            while not NetworkHasControlOfEntity(entity) and timeout < 500 do
                Wait(10)
                timeout = timeout + 10
            end
        end

        if NetworkHasControlOfEntity(entity) then
            FreezeEntityPosition(entity, false) 
            DetachEntity(entity, false, true)   
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
            print("deleted:", entity)
        else
            print("Cant delete:", entity)
        end
    end
end


CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehCoords = GetEntityCoords(vehicle)

            
            local entities = GetGamePool('CObject')
            for _, entity in ipairs(entities) do
                if DoesEntityExist(entity) and isDeletableProp(entity) then
                    local entityCoords = GetEntityCoords(entity)
                    local distance = #(vehCoords - entityCoords)

                    
                    if distance < 5.0 and IsEntityTouchingEntity(vehicle, entity) then
                        deleteEntityWithPhysics(entity) 
                    end
                end
            end
        end
        Wait(50) 
    end
end)