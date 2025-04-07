local CLOWN_HORN_ID = Isaac.GetItemIdByName("Clown Horn")

local TRANSFORMATIONS_PER_USE = 2
local DAMAGE_MULTIPLIER = 1.2

local sfx = SFXManager()

if EID then
    EID:addCollectible(CLOWN_HORN_ID, "Grants " .. TRANSFORMATIONS_PER_USE .. " random yet unobtained transformations.#If there are no transformations to grant, multiplies {{Damage}} damage by " .. DAMAGE_MULTIPLIER .. "x for each transformation it would've granted.#Instant pickup / health gain happens only on the first achievement.", "Clown Horn")
end

local GUPPY_FORM_PIECE_ID = Isaac.GetItemIdByName("guppyFormPiece")
local LORD_OF_THE_FLIES_FORM_PIECE_ID = Isaac.GetItemIdByName("lordOfTheFliesFormPiece")
local MUSHROOM_FORM_PIECE_ID = Isaac.GetItemIdByName("mushroomFormPiece")
local ANGEL_FORM_PIECE_ID = Isaac.GetItemIdByName("angelFormPiece")
local BOB_FORM_PIECE_ID = Isaac.GetItemIdByName("bobFormPiece")
local DRUGS_FORM_PIECE_ID = Isaac.GetItemIdByName("drugsFormPiece")
local MOM_FORM_PIECE_ID = Isaac.GetItemIdByName("momFormPiece")
local BABY_FORM_PIECE_ID = Isaac.GetItemIdByName("babyFormPiece")
local EVIL_ANGEL_FORM_PIECE_ID = Isaac.GetItemIdByName("evilAngelFormPiece")
local POOP_FORM_PIECE_ID = Isaac.GetItemIdByName("poopFormPiece")
local BOOKWORM_FORM_PIECE_ID = Isaac.GetItemIdByName("bookwormFormPiece")
local SPIDERBABY_FORM_PIECE_ID = Isaac.GetItemIdByName("spiderbabyFormPiece")
-- no stompy and adult
-- afaik there is no way to grant them via items or nullitems

local formItems = {
    [PlayerForm.PLAYERFORM_GUPPY] = GUPPY_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = LORD_OF_THE_FLIES_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_MUSHROOM] = MUSHROOM_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_ANGEL] = ANGEL_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_BOB] = BOB_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_DRUGS] = DRUGS_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_MOM] = MOM_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_BABY] = BABY_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_EVIL_ANGEL] = EVIL_ANGEL_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_POOP] = POOP_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_BOOK_WORM] = BOOKWORM_FORM_PIECE_ID,
    [PlayerForm.PLAYERFORM_SPIDERBABY] = SPIDERBABY_FORM_PIECE_ID
}

local transformationToString = {
    [PlayerForm.PLAYERFORM_GUPPY] = "GUPPY",
    [PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = "BELZEBUB",
    [PlayerForm.PLAYERFORM_MUSHROOM] = "FUN GUY",
    [PlayerForm.PLAYERFORM_ANGEL] = "SERAPHIM",
    [PlayerForm.PLAYERFORM_BOB] = "BOB",
    [PlayerForm.PLAYERFORM_DRUGS] = "SPUN",
    [PlayerForm.PLAYERFORM_MOM] = "MOM",
    [PlayerForm.PLAYERFORM_BABY] = "CONJOINED",
    [PlayerForm.PLAYERFORM_EVIL_ANGEL] = "LEVIATHAN",
    [PlayerForm.PLAYERFORM_POOP] = "OH CRAP",
    [PlayerForm.PLAYERFORM_BOOK_WORM] = "BOOKWORM",
    [PlayerForm.PLAYERFORM_SPIDERBABY] = "SPIDER BABY"
}

---@param player EntityPlayer
local function canCrushRocks(player)
    local effects = player:GetEffects()
    return player:HasCollectible(CollectibleType.COLLECTIBLE_THUNDER_THIGHS) or player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_LEO) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_THUNDER_THIGHS) or  effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) or player:HasPlayerForm(PlayerForm.PLAYERFORM_STOMPY)
end

---@param player EntityPlayer
local function hasSuperBum(player)
    return (player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_BUM) and player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM) and player:HasCollectible(CollectibleType.COLLECTIBLE_BUM_FRIEND)) or Isaac.CountEntities(player, EntityType.ENTITY_FAMILIAR, FamiliarVariant.SUPER_BUM) > 0
end

local function onNewRoomEnter()
    for playerID = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerID)
        if not hasSuperBum(player) then
            player:CheckFamiliar(FamiliarVariant.SUPER_BUM, 0, RNG())
        end
        for _, formItemID in pairs(formItems) do
            while player:HasCollectible(formItemID) do
                player:RemoveCollectible(formItemID)
            end
        end
    end
end

---@param itemId CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlags UseFlag
---@param activeSlot ActiveSlot
---@param customVarData integer
local function clownHornActive(_, itemId, rng, player, useFlags, activeSlot, customVarData)
    if useFlags & UseFlag.USE_NOANIM == UseFlag.USE_NOANIM then
        return false
    end
    
    local validForms = {}
    local numberOfValidForms = 0

    for form, _ in pairs(formItems) do
        if player:HasPlayerForm(form) then
            goto continue
        else
            table.insert(validForms, form)
            numberOfValidForms = numberOfValidForms + 1
            --print(tostring(validForms[i+1]))
        end
        ::continue::
    end

    -- add stompy manually
    if not canCrushRocks(player) then
        numberOfValidForms = numberOfValidForms + 1
        table.insert(validForms, "STOMPY")
    end

    -- add superbum manually
    if not hasSuperBum(player) then
        numberOfValidForms = numberOfValidForms + 1
        table.insert(validForms, "SUPERBUM")
    end

    --print("numberOfValidForms: " .. numberOfValidForms)

    if numberOfValidForms < TRANSFORMATIONS_PER_USE then
        for _ = 1, TRANSFORMATIONS_PER_USE - numberOfValidForms do
            player.Damage = player.Damage * DAMAGE_MULTIPLIER
        end
    end

    if numberOfValidForms > 0 then
        local hud = Game():GetHUD()
        local splashTextElements = {}
        for i = 1, TRANSFORMATIONS_PER_USE do
            if numberOfValidForms == 0 then
                break
            end
            local rand = rng:RandomInt(numberOfValidForms) + 1
            local form = validForms[rand]
            local effects = player:GetEffects()
            

            if formItems[form] ~= nil then
                for _ = 1, 3 do
                    player:AddCollectible(formItems[form])
                end
                table.insert(splashTextElements, transformationToString[form])
            else
                if form == "SUPERBUM" then
                    player:CheckFamiliar(FamiliarVariant.SUPER_BUM, 1, rng)
                elseif form == "STOMPY" then
                    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, false)
                end

                table.insert(splashTextElements, form)
            end

            table.remove(validForms, rand)
            numberOfValidForms = numberOfValidForms - 1
        end
        hud:ShowItemText(table.concat(splashTextElements, ", "))
    end

    -- play sound
    local soundID = Isaac.GetSoundIdByName("Clown Horn " .. tostring(rng:RandomInt(4) + 1))
    local pitch = (rng:RandomInt(40) + 80)/100

    sfx:Play(soundID, 1, 0, false, pitch)
    return true
end

Elsbeth:AddCallback(ModCallbacks.MC_USE_ITEM, clownHornActive, CLOWN_HORN_ID)
Elsbeth:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onNewRoomEnter)
