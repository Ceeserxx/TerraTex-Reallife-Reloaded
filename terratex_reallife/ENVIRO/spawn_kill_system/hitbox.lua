--Weapon Balance
function setWeaponStats_balanced()
    setWeaponProperty(22, "pro", "flag_type_dual", false)
    setWeaponProperty(22, "std", "flag_type_dual", false)
    setWeaponProperty(22, "poor", "flag_type_dual", false)

    setWeaponProperty(24, "pro", "target_range", 50)
    setWeaponProperty(24, "std", "target_range", 50)
    setWeaponProperty(24, "poor", "target_range", 50)
    setWeaponProperty(24, "pro", "weapon_range", 50)
    setWeaponProperty(24, "std", "weapon_range", 50)
    setWeaponProperty(24, "poor", "weapon_range", 50)

    setWeaponProperty(34, "pro", "target_range", 1000)
    setWeaponProperty(34, "std", "target_range", 1000)
    setWeaponProperty(34, "poor", "target_range", 1000)
    setWeaponProperty(34, "pro", "weapon_range", 1000)
    setWeaponProperty(34, "std", "weapon_range", 1000)
    setWeaponProperty(34, "poor", "weapon_range", 1000)
end
addEventHandler("onResourceStart",getRootElement(),setWeaponStats_balanced)

function onPlayerDamage_func(attacker, attackerweapon, bodypart, loss)
    if(vioGetElementData(source,"smode"))then
        if(isElement(attacker))then
            if(attacker~=source)then
                outputChatBox("Dieser Admin ist im Supportmodus und kann kein Schaden erhalten!",attacker,255,0,0)
            end
        end
        return false
    end

    triggerClientEvent(source,"StopHealingTimer",source)
    if(vioGetElementData(source,"flys_spawner_damage"))then
        loss=0
    end



    --* 3: Torso
    --* 4: Ass
    --* 5: Left Arm
    --* 6: Right Arm
    --7: Left Leg
    --* 8: Right leg
    --* 9: Head
    local schaden={1,1,1,1,1,1,1,1,4}

    local weaponNowDamage=1

    if(attackerweapon)then
        if(attackerweapon == 34)then
            weaponNowDamage = 5
        end
    end

    local newloss=schaden[bodypart]*loss*weaponNowDamage
    local health=getElementHealth(source)
    local oldhealth=health
    local armor=getPedArmor(source)

    if (armor > 0) then
        armor = armor - newloss
    else
        armor = -newloss
    end

    if(armor <= 0)then
        health = health + armor
        armor = 0
    end
    if(health < 1)then
        if (isPedInVehicle(source)) then
            removePedFromVehicle(source)
        end

        local x,y,z = getElementPosition(source)
        killPed(source,attacker, attackerweapon, bodypart,false)
        setElementPosition(source, x, y, z)
    else
        if(isElement(attacker))then
            local hitTimer=setTimer(resetHitTimer,30000,1,source)
            if(isTimer(vioGetElementData(source,"hitTimer")))then
                killTimer(vioGetElementData(source,"hitTimer"))
            end
            vioSetElementData(source,"hitTimer",hitTimer)
        end
        setElementHealth(source,health)
        setPedArmor(source,armor)
    end
end
addEvent("onCustomPlayerDamage",true)
addEventHandler("onCustomPlayerDamage",getRootElement(),onPlayerDamage_func, true, "high+6")


function onPlayerDamageControl_func(attacker, attackerweapon, bodypart, loss)
    if not vioGetElementData(source, "healthControl") then
        vioSetElementData(source, "healthControl", getElementHealth(source))
        vioSetElementData(source, "armorControl", getPedArmor(source))
    end

    if(vioGetElementData(source,"smode"))then
        return false
    end

    if(vioGetElementData(source,"flys_spawner_damage"))then
        loss=0
    end

    --* 3: Torso
    --* 4: Ass
    --* 5: Left Arm
    --* 6: Right Arm
    --7: Left Leg
    --* 8: Right leg
    --* 9: Head
    local schaden={1,1,1,1,1,1,1,1,4}

    local weaponNowDamage=1

    if(attackerweapon)then
        if(attackerweapon == 34)then
            weaponNowDamage = 5
        end
    end

    local newloss=schaden[bodypart]*loss*weaponNowDamage
    local health=getElementHealth(source)
    local oldhealth=health
    local armor=getPedArmor(source)

    if (armor > 0) then
        armor = armor - newloss
    else
        armor = -newloss
    end

    if(armor <= 0)then
        health = health + armor
        armor = 0
    end

    if(health < 1)then
        setTimer(checkPlayerDeath, 500 , 1, source)
    else
        vioSetElementData(source, "healthControl",health)
        vioSetElementData(source, "armorControl", armor)
    end

    --    setTimer(checkHealthArmorCheat, 2000, 1, source)
end
addEvent("onCustomPlayerDamageControl",true)
addEventHandler("onCustomPlayerDamageControl",getRootElement(),onPlayerDamageControl_func, true, "high+6")

function checkPlayerDeath(source)
    if not isPedDead(source) and getElementHealth(source) > 1 then
        for theKey, thePlayer in ipairs(getElementsByType("player")) do
            if (isAdminLevel(thePlayer, 4)) then
                outputChatBox(getPlayerName(source) .. " sollte jetzt tod sein.", thePlayer, 255, 255, 0)
            end
        end
    end
end

--function checkHealthArmorCheat(asd)
--    if (getElementHealth(asd) > vioGetElementData(asd, "healthControl")) then
--        --		outputChatBox("cheat detected by ".. getPlayerName(asd));
--    end
--end


function resetHitTimer(player)
    if(isElement(player))then
        vioSetElementData(player,"hitTimer",false)
    end
end


function onPlayerStealthKill_func(targetPlayer)
    --outputChatBox(tostring(vioGetElementData(source,"inArena")))
    if not(vioGetElementData(source,"job")==7) and not(vioGetElementData(source,"fraktion")==8) then
        if(not(vioGetElementData(source,"inArena")==1))then
            cancelEvent()
        end
    end
end
addEventHandler("onPlayerStealthKill",getRootElement(),onPlayerStealthKill_func)

local restTimer=false
local addSPCSeconds=0
local dummy=0

function setPedChocking_server()
    if(isTimer(restTimer))then
        local a,b,c=getTimerDetails ( restTimer )
        addSPCSeconds=a
        killTimer(restTimer)

        -- outputChatBox("rest: "..addSPCSeconds)
    else
        addSPCSeconds=0
    end
    setPedChoking(source,true)
    -- outputChatBox("started")
end
addEvent("spc_start_event",true)
addEventHandler("spc_start_event",getRootElement(),setPedChocking_server)

function setPedChockingStop_server(spruehtimer)
    spruehtimer=spruehtimer+addSPCSeconds
    -- outputChatBox(spruehtimer)
    restTimer=setTimer(setPedChoking,spruehtimer,1,source,false)
end
addEvent("spc_stop_event",true)
addEventHandler("spc_stop_event",getRootElement(),setPedChockingStop_server)