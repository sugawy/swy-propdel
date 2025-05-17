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
            while not NetworkHasControlOfEntity(entity) and timeout < 200 do
                Wait(10)
                timeout = timeout + 10
            end
        end

        if NetworkHasControlOfEntity(entity) then
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
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
                    if #(vehCoords - entityCoords) < 10.0 then
    
                        local touching = IsEntityTouchingEntity(vehicle, entity)
                        local isMoving = not IsEntityStatic(entity) and #(GetEntityVelocity(entity)) > 0.1

                        if touching or isMoving then
                            deleteEntityWithPhysics(entity)
                        end
                    end
                end
            end

            Wait(100)
        else
            Wait(1000)
        end
    end
end)
