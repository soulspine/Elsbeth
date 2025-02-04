local ELSBETH_TYPE = Isaac.GetPlayerTypeByName("Elsbeth", false)
local ELSBETH_HAIR_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/character_elsbeth_head.anm2")
local CLOWN_HORN_ID = Isaac.GetItemIdByName("Clown Horn")
local CLOWN_SHOES_ID = Isaac.GetTrinketIdByName("Clown Shoes")

---@param player EntityPlayer
local function onPlayerInit(_, player)
    if player:GetPlayerType() == ELSBETH_TYPE then
        player:AddTrinket(CLOWN_SHOES_ID)
        player:AddNullCostume(ELSBETH_HAIR_COSTUME)
        player:SetPocketActiveItem(CLOWN_HORN_ID, ActiveSlot.SLOT_POCKET, false)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_NOCOSTUME | UseFlag.USE_NOHUD)
    end
end
MOD:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onPlayerInit)