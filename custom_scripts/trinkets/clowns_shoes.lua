local CLOWNS_SHOES_ID = Isaac.GetTrinketIdByName("Clown's Shoes")

print("Loading Clown's Shoes...")

local MOVE_SPEED_DEBUFF = 0.2
local DAMAGE_MULTIPLIER = 1.5

if EID then
    EID:addTrinket(CLOWNS_SHOES_ID, "{{ArrowUp}} Enemies with status effects applied to them take " .. DAMAGE_MULTIPLIER .. "x more damage.#{{ArrowDown}} -" .. MOVE_SPEED_DEBUFF .." speed.", "Clown's Shoes")
end

local validStatusEffects = {}
table.insert(validStatusEffects, EntityFlag.FLAG_POISON)
table.insert(validStatusEffects, EntityFlag.FLAG_SLOW)
table.insert(validStatusEffects, EntityFlag.FLAG_CHARM)
table.insert(validStatusEffects, EntityFlag.FLAG_CONFUSION)
table.insert(validStatusEffects, EntityFlag.FLAG_MIDAS_FREEZE)
table.insert(validStatusEffects, EntityFlag.FLAG_FEAR)
table.insert(validStatusEffects, EntityFlag.FLAG_BURN)
table.insert(validStatusEffects, EntityFlag.FLAG_FREEZE)
table.insert(validStatusEffects, EntityFlag.FLAG_SHRINK)
table.insert(validStatusEffects, EntityFlag.FLAG_CONTAGIOUS)
table.insert(validStatusEffects, EntityFlag.FLAG_BLEED_OUT)
table.insert(validStatusEffects, EntityFlag.FLAG_KNOCKED_BACK)
table.insert(validStatusEffects, EntityFlag.FLAG_MAGNETIZED)
table.insert(validStatusEffects, EntityFlag.FLAG_BAITED)
table.insert(validStatusEffects, EntityFlag.FLAG_WEAKNESS)

---@param player EntityPlayer
---@param cacheFlag CacheFlag
local function onCacheEval(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
        --print("Cache Speed Eval")
        if player:HasTrinket(CLOWNS_SHOES_ID) then
            --print("Player has Clown's Shoes")
            player.MoveSpeed = player.MoveSpeed - MOVE_SPEED_DEBUFF
        end
    end
end

---@param entity Entity
---@param amount number
---@param damageFlags integer
---@param sourceRef EntityRef
---@param countdownFrames integer
local function onEntityDMG(_, entity, amount, damageFlags, sourceRef, countdownFrames)
    --print("Source type: " .. sourceRef.Type)
    --print("Fake flag: " .. (damageFlags & DamageFlag.DAMAGE_FAKE))
    if entity.Type == EntityType.ENTITY_PLAYER or damageFlags & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then
        return
    end

    if sourceRef.Entity == nil then
        return
    end

    local player = nil

    if sourceRef.Type == EntityType.ENTITY_PLAYER then
        player = sourceRef.Entity:ToPlayer()
    else
        player = sourceRef.Entity.Parent:ToPlayer()
    end

    if player == nil then
        player = sourceRef.Entity.Parent:ToPlayer()
    end

    if player == nil then
        return
    end

    local npc = entity:ToNPC()

    if npc == nil then
        return
    end

    if player:HasTrinket(CLOWNS_SHOES_ID) then
        --print("Player has Clown's Shoes")
        local eligibleForBuff = false

        for _, effect in pairs(validStatusEffects) do
            if npc:HasEntityFlags(effect) then
                eligibleForBuff = true
                break
            end
        end

        if eligibleForBuff then
            --print("Damage buffed hit")
            entity:TakeDamage(DAMAGE_MULTIPLIER*amount, damageFlags | DamageFlag.DAMAGE_FAKE, EntityRef(player), countdownFrames)
            return false
        end
        
    end



    
end

MOD:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, onCacheEval)
MOD:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onEntityDMG)

print("Clown's Shoes loaded!")