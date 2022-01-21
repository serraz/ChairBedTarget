local plyCoords = GetEntityCoords(PlayerPedId())
local isWithinObject = false
local oElement = {}

-- // BASIC
local InUse = false
local IsTextInUse = false
local PlyLastPos = 0

-- // ANIMATION
local Anim = 'sit'
local AnimScroll = 0

-- Fast Thread
CreateThread(function()                
	exports['qtarget']:AddTargetModel(Config.seats, {
        options = {
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Sit",
                anim = "sit"
            },

        },
        job = {"all"},
        distance = 2.5
    })
	exports['qtarget']:AddTargetModel(Config.beds, {
        options = {
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Sit on Bed",
                anim = "sit"
            },
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Lay on your back",
                anim = "back"
            },
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Lay on your stomach",
                anim = "stomach"
            },

        },
        job = {"all"},
        distance = 3.5
    })
    local delroadcone = {
       	'prop_roadcone02a',
    }
	exports['qtarget']:AddTargetModel(delroadcone, {
        options = {
            {
                event = "propie:rcone",
                icon = "fas fa-clipboard",
                label = "Remove Cone",
                job = 'police',
            },
            {
                event = "propie:rcone",
                icon = "fas fa-clipboard",
                label = "Remove Cone",
                job = 'sheriff',
            },
        },
        distance = 2.5
    })
    local delbarrier = {
       	'prop_barrier_work06a',
    }
	exports['qtarget']:AddTargetModel(delbarrier, {
        options = {
            {
                event = "propie:rbarrier",
                icon = "fas fa-clipboard",
                label = "Remove Barrier",
                job = 'police',
            },
            {
                event = "propie:rbarrier",
                icon = "fas fa-clipboard",
                label = "Remove Barrier",
                job = 'sheriff',
            },
        },
        distance = 2.5
    })
    local delsstrips = {
       	'p_ld_stinger_s',
    }
	exports['qtarget']:AddTargetModel(delsstrips, {
        options = {
            {
                event = "propie:rspikes",
                icon = "fas fa-clipboard",
                label = "Remove Road Spikes",
                job = 'police',
            },
            {
                event = "propie:rspikes",
                icon = "fas fa-clipboard",
                label = "Remove Road Spikes",
                job = 'sheriff',
            },
        },
        distance = 2.5
    })

end)

-- Medium Thread
CreateThread(function()
    while true do
        ply = PlayerPedId()
        plyCoords = GetEntityCoords(PlayerPedId())
        Wait(1000)
    end
end)

-- Healing Thread
CreateThread(function()
    while Config.Healing ~= 0 do
        Wait(Config.Healing * 1000)
        if InUse == true then
            if oElement.fObjectIsBed == true then
                local ply = PlayerPedId()
                local health = GetEntityHealth(ply)
                if health <= 199 then
                    SetEntityHealth(ply, health + 1)
                end
            end
        end
    end
end)

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(data)
    Anim = data.anim
    local hash = GetEntityModel(data.entity)
    local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, hash, 0, 0, 0)
    local coordsObject = GetEntityCoords(closestObject)
    local distanceDiff = #(coordsObject - plyCoords)
    if (distanceDiff < 3.0 and closestObject ~= 0) then
        if (distanceDiff < 1.5) then
            oElement = {
                fObject = closestObject,
                fObjectCoords = coordsObject,
                fObjectcX = Config.objects.locations[hash].verticalOffsetX,
                fObjectcY = Config.objects.locations[hash].verticalOffsetY,
                fObjectcZ = Config.objects.locations[hash].verticalOffsetZ,
                fObjectDir = Config.objects.locations[hash].direction,
                fObjectIsBed = Config.objects.locations[hash].bed
            }
        end
    end
    if oElement.fObject then
        local object = oElement.fObject
        local vertx = oElement.fObjectcX
        local verty = oElement.fObjectcY
        local vertz = oElement.fObjectcZ
        local dir = oElement.fObjectDir
        local isBed = oElement.fObjectIsBed
        local objectcoords = oElement.fObjectCoords
        
        local ped = PlayerPedId()
        PlyLastPos = GetEntityCoords(ped)
        FreezeEntityPosition(object, true)
        FreezeEntityPosition(ped, true)
        InUse = true
        if isBed == false then
            if Config.objects.SitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.SitAnimation.dict
                local anim = Config.objects.SitAnimation.anim
                
                AnimLoadDict(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
            end
        else
            if Anim == 'back' then
                if Config.objects.BedBackAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config.objects.BedBackAnimation.dict
                    local anim = Config.objects.BedBackAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true
                )
                end
            elseif Anim == 'stomach' then
                if Config.objects.BedStomachAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config.objects.BedStomachAnimation.dict
                    local anim = Config.objects.BedStomachAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
                end
            elseif Anim == 'sit' then
                if Config.objects.BedSitAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config.objects.BedSitAnimation.dict
                    local anim = Config.objects.BedSitAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
                end
            end
        end
    end
end)

RegisterKeyMapping('ChairBedSystem:Client:Leave', 'Leave Chair/Bed', 'keyboard', 'F')
RegisterCommand('ChairBedSystem:Client:Leave', function(raw)
if InUse then
    InUse = false
    ClearPedTasksImmediately(ply)
    FreezeEntityPosition(ply, false)
    
    local x, y, z = table.unpack(PlyLastPos)
    if GetDistanceBetweenCoords(x, y, z, plyCoords) < 10 then
        SetEntityCoords(ply, PlyLastPos)
    end
    oElement = {}
end
end)

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end