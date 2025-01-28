local CLOWNS_SHOES_ID = Isaac.GetTrinketIdByName("Clown's Shoes")

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
    if entity:IsVulnerableEnemy() and not (damageFlags & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE) then
        local player = sourceRef.Entity and sourceRef.Entity:ToPlayer() or (sourceRef.Entity and sourceRef.Entity.Parent and sourceRef.Entity.Parent:ToPlayer())
        if player and player:HasTrinket(CLOWNS_SHOES_ID) then
            local npc = entity:ToNPC()
            if npc and npc:IsActiveEnemy(false) then
                for _, effect in pairs(validStatusEffects) do
                    if npc:HasEntityFlags(effect) then
                        --print("Damage buffed hit")
                        npc:TakeDamage(DAMAGE_MULTIPLIER * amount, damageFlags | DamageFlag.DAMAGE_FAKE, EntityRef(player), countdownFrames)
                        return false
                    end
                end
            end
        end
    end
end

MOD:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, onCacheEval)
MOD:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onEntityDMG)