local ELSBETH_TYPE = Isaac.GetPlayerTypeByName("Elsbeth", false)
local ELSBETH_HAIR_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/character_elsbeth_head.anm2")
local CLOWN_HORN_ID = Isaac.GetItemIdByName("Clown Horn")
local CLOWN_SHOES_ID = Isaac.GetTrinketIdByName("Clown Shoes")

local TEAR_PASSIVE_VALID_FLAGS = {
    TearFlags.TEAR_SPECTRAL,
    TearFlags.TEAR_PIERCING,
    TearFlags.TEAR_HOMING,
    TearFlags.TEAR_SLOW,
    TearFlags.TEAR_POISON,
    TearFlags.TEAR_FREEZE,
    TearFlags.TEAR_SPLIT,
    TearFlags.TEAR_GROW,
    TearFlags.TEAR_BOOMERANG,
    TearFlags.TEAR_PERSISTENT,
    TearFlags.TEAR_WIGGLE,
    TearFlags.TEAR_MULLIGAN,
    TearFlags.TEAR_EXPLOSIVE,
    TearFlags.TEAR_CHARM,
    TearFlags.TEAR_CONFUSION,
    TearFlags.TEAR_ORBIT,
    TearFlags.TEAR_WAIT,
    TearFlags.TEAR_QUADSPLIT,
    TearFlags.TEAR_BOUNCE,
    TearFlags.TEAR_FEAR,
    TearFlags.TEAR_SHRINK,
    TearFlags.TEAR_BURN,
    TearFlags.TEAR_ATTRACTOR,
    TearFlags.TEAR_KNOCKBACK,
    TearFlags.TEAR_PULSE,
    TearFlags.TEAR_SPIRAL,
    TearFlags.TEAR_FLAT,
    TearFlags.TEAR_SQUARE,
    TearFlags.TEAR_GLOW,
    TearFlags.TEAR_GISH,
    TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
    TearFlags.TEAR_SHIELDED,
    TearFlags.TEAR_STICKY,
    TearFlags.TEAR_CONTINUUM,
    TearFlags.TEAR_LIGHT_FROM_HEAVEN,
    TearFlags.TEAR_TRACTOR_BEAM,
    TearFlags.TEAR_GODS_FLESH,
    TearFlags.TEAR_GREED_COIN,
    TearFlags.TEAR_BIG_SPIRAL,
    TearFlags.TEAR_BOOGER,
    TearFlags.TEAR_EGG,
    TearFlags.TEAR_ACID,
    TearFlags.TEAR_BONE,
    TearFlags.TEAR_BELIAL,
    TearFlags.TEAR_MIDAS,
    TearFlags.TEAR_JACOBS,
    TearFlags.TEAR_HORN,
    TearFlags.TEAR_LASER,
    TearFlags.TEAR_POP,
    TearFlags.TEAR_ABSORB,
    TearFlags.TEAR_LASERSHOT,
    TearFlags.TEAR_HYDROBOUNCE,
    TearFlags.TEAR_BURSTSPLIT,
    TearFlags.TEAR_CREEP_TRAIL,
    TearFlags.TEAR_PUNCH,
    TearFlags.TEAR_ICE,
    TearFlags.TEAR_MAGNETIZE,
    TearFlags.TEAR_BAIT,
    TearFlags.TEAR_OCCULT,
    TearFlags.TEAR_ROCK,
    TearFlags.TEAR_TURN_HORIZONTAL,
    TearFlags.TEAR_ECOLI,
    TearFlags.TEAR_RIFT,
    TearFlags.TEAR_SPORE,
}

---@param player EntityPlayer
local function onPlayerInit(_, player)
    if player:GetPlayerType() == ELSBETH_TYPE then
        player:AddTrinket(CLOWN_SHOES_ID)
        player:AddNullCostume(ELSBETH_HAIR_COSTUME)
        player:SetPocketActiveItem(CLOWN_HORN_ID, ActiveSlot.SLOT_POCKET, false)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_NOCOSTUME | UseFlag.USE_NOHUD)
    end
end
Elsbeth:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onPlayerInit)

---@param entity Entity
---@param amount number
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
local function onPlayerDamage(_, entity, amount, flags, source, countdown)
    print(flags)
    if entity:ToPlayer():GetPlayerType() == ELSBETH_TYPE and flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION then
        return false
    end
end
Elsbeth:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onPlayerDamage, EntityType.ENTITY_PLAYER)

---@param tear EntityTear
local function onFireTear(_, tear)
    if tear.Parent then
        local player = tear.Parent:ToPlayer()
        if player and player:GetPlayerType() == ELSBETH_TYPE then
            tear:AddTearFlags(TEAR_PASSIVE_VALID_FLAGS[tear:GetDropRNG():RandomInt(#TEAR_PASSIVE_VALID_FLAGS) + 1])
        end
    end
end
Elsbeth:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, onFireTear)