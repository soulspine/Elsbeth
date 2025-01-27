local CLOWNS_HORN_ID = Isaac.GetItemIdByName("Clown's Horn")

print("Loading Clown's Horn...")

local TRANSFORMATIONS_PER_USE = 2
local DAMAGE_MULTIPLIER = 1.2

local sfx = SFXManager()

if EID then
    EID:addCollectible(CLOWNS_HORN_ID, "Grants " .. TRANSFORMATIONS_PER_USE .. " random yet unobtained transformations.#If there are no transformations to grant, multiplies {{Damage}} damage by " .. DAMAGE_MULTIPLIER .. "x for each transformation it would've granted.#Cannot grant {{Stompy}} Stompy or {{Adult}} Adult", "Clown's Horn")
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

local function onNewRoomEnter()
    for playerID = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerID)
        for _, formItemID in pairs(formItems) do
            while player:HasCollectible(formItemID) do
                player:RemoveCollectible(formItemID)
            end
        end
    end
end

---@param rng RNG
---@param player EntityPlayer
local function clownsHornActive(_, _, rng, player, _, _, _)
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

    --print("numberOfValidForms: " .. numberOfValidForms)

    if numberOfValidForms < TRANSFORMATIONS_PER_USE then
        for _ = 1, TRANSFORMATIONS_PER_USE - numberOfValidForms do
            player.Damage = player.Damage * DAMAGE_MULTIPLIER
        end
    end

    if numberOfValidForms > 0 then
        for i = 1, TRANSFORMATIONS_PER_USE do
            if numberOfValidForms == 0 then
                break
            end
            local rand = rng:RandomInt(numberOfValidForms) + 1
            for _ = 1, 3 do
                player:AddCollectible(formItems[validForms[rand]])
            end
            table.remove(validForms, rand)
            numberOfValidForms = numberOfValidForms - 1
        end
    end

    local soundID = Isaac.GetSoundIdByName("Clown's Horn " .. tostring(rng:RandomInt(4) + 1))

    local pitch = (rng:RandomInt(40) + 80)/100

    sfx:Play(soundID, 1, 0, false, pitch)
    return true
end

MOD:AddCallback(ModCallbacks.MC_USE_ITEM, clownsHornActive, CLOWNS_HORN_ID)
MOD:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onNewRoomEnter)

print("Clown's Horn loaded!")