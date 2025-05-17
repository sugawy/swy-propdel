local function isDeletableProp(entity)
    local model = GetEntityModel(entity)
    for _, prop in ipairs(Config.PropsToDelete) do
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
            FreezeEntityPosition(entity, false)
            ActivatePhysics(entity)
            SetEntityDynamic(entity, true)
            SetEntityCollision(entity, true, true)
            Wait(100)
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
        end
    end
end

local function deleteEntityNoPhysics(entity)
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
            local hitboxCoords = Config.UseHitbox
                and GetOffsetFromEntityInWorldCoords(vehicle, 0.0, Config.HitboxDepth, 0.0)
                or vehCoords

            local entities = GetGamePool('CObject')

            for _, entity in ipairs(entities) do
                if DoesEntityExist(entity) and isDeletableProp(entity) then
                    local entityCoords = GetEntityCoords(entity)
                    local distance = #(hitboxCoords - entityCoords)

                    local touching = IsEntityTouchingEntity(vehicle, entity)
                    local isMoving = not IsEntityStatic(entity) and #(GetEntityVelocity(entity)) > 0.1

                    if touching or isMoving then
                        deleteEntityWithPhysics(entity) 
                    elseif Config.UseHitbox and distance < Config.DeleteRadius then
                        deleteEntityNoPhysics(entity) 
                    end
                end
            end

            Wait(50)
        else
            Wait(1000)
        end
    end
end)

