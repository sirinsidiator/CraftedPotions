local ADDON_NAME = "CraftedPotions"

local function OnAddonLoaded(_, addon)
    if addon ~= ADDON_NAME then return end

    -- Utility functions
    local function IsCraftedPotion(itemLink)
        local itemType = GetItemLinkItemType(itemLink)
        return (itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON) and (select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0")
    end

    local function ChangeQuality(itemLink)
        local quality = ITEM_QUALITY_NORMAL
        for i = 1, GetMaxTraits() do
            local hasTraitAbility = GetItemLinkTraitOnUseAbilityInfo(itemLink, i)

            if hasTraitAbility then
                quality = quality + 1
            end
        end

        if quality == ITEM_QUALITY_NORMAL then
            quality = ITEM_QUALITY_MAGIC
        end

        return quality
    end

    -- Rewriting core functions

    -- Shared (Gamepad UI, Addons)
    local original_GetItemQuality = GetItemQuality
    GetItemQuality = function(bagId, slotIndex)
        local itemLink = GetItemLink(bagId, slotIndex)
        if IsCraftedPotion(itemLink) then
            return ChangeQuality(itemLink)
        end
        return original_GetItemQuality(bagId, slotIndex)
    end

    -- Shared (Gamepad UI, Addons)
    local original_GetItemLinkQuality = GetItemLinkQuality
    GetItemLinkQuality = function(itemLink)
        if IsCraftedPotion(itemLink) then
            return ChangeQuality(itemLink)
        end
        return original_GetItemLinkQuality(itemLink)
    end

    -- QuickSlots
    local original_GetSlotItemQuality = GetSlotItemQuality
    GetSlotItemQuality = function(slotIndex)
        local itemLink = GetSlotItemLink(slotIndex)
        if IsCraftedPotion(itemLink) then
            return ChangeQuality(itemLink)
        end
        return original_GetSlotItemQuality(slotIndex)
    end

    -- Bags
    local GET_ITEM_INFO_QUALITY_INDEX = 8
    local original_GetItemInfo = GetItemInfo
    GetItemInfo = function(bagId, slotIndex)
        local itemLink = GetItemLink(bagId, slotIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetItemInfo(bagId, slotIndex)}
            data[GET_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetItemInfo(bagId, slotIndex)
    end

    -- Trading House listings
    local GET_TRADING_HOUSE_LISTING_ITEM_INFO_QUALITY_INDEX = 3
    local original_GetTradingHouseListingItemInfo = GetTradingHouseListingItemInfo
    GetTradingHouseListingItemInfo = function(index)
        local itemLink = GetTradingHouseListingItemLink(index)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetTradingHouseListingItemInfo(index)}
            data[GET_TRADING_HOUSE_LISTING_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetTradingHouseListingItemInfo(index)
    end

    -- Trading House searches
    local GET_TRADING_HOUSE_SEARCH_RESULT_ITEM_INFO_QUALITY_INDEX = 3
    local original_GetTradingHouseSearchResultItemInfo = GetTradingHouseSearchResultItemInfo
    GetTradingHouseSearchResultItemInfo = function(index)
        local itemLink = GetTradingHouseSearchResultItemLink(index)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetTradingHouseSearchResultItemInfo(index)}
            data[GET_TRADING_HOUSE_SEARCH_RESULT_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetTradingHouseSearchResultItemInfo(index)
    end

    -- Stores
    local GET_STORE_ENTRY_INFO_QUALITY_INDEX = 8
    local original_GetStoreEntryInfo = GetStoreEntryInfo
    GetStoreEntryInfo = function(entryIndex)
        local itemLink = GetStoreItemLink(entryIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetStoreEntryInfo(entryIndex)}
            data[GET_STORE_ENTRY_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetStoreEntryInfo(entryIndex)
    end

    -- Guild Log
    local GET_GUILD_SPECIFIC_ITEM_INFO_QUALITY_INDEX = 3
    local original_GetGuildSpecificItemInfo = GetGuildSpecificItemInfo
    GetGuildSpecificItemInfo = function(index)
        local itemLink = GetGuildSpecificItemLink(index)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetGuildSpecificItemInfo(index)}
            data[GET_GUILD_SPECIFIC_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetGuildSpecificItemInfo(index)
    end

    -- Trade between players
    local GET_TRADE_ITEM_INFO_QUALITY_INDEX = 3
    local original_GetTradeItemInfo = GetTradeItemInfo
    GetTradeItemInfo = function(who, tradeIndex)
        local itemLink = GetTradeItemLink(who, tradeIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetTradeItemInfo(who, tradeIndex)}
            data[GET_TRADE_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetTradeItemInfo(who, tradeIndex)
    end

    -- Store Buyback
    local GET_BUY_BACK_ITEM_INFO_QUALITY_INDEX = 3
    local original_GetBuybackItemInfo = GetBuybackItemInfo
    GetBuybackItemInfo = function(entryIndex)
        local itemLink = GetBuybackItemLink(entryIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetBuybackItemInfo(entryIndex)}
            data[GET_BUY_BACK_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetBuybackItemInfo(entryIndex)
    end

    -- Mails
    local GET_ATTACHED_ITEM_INFO_QUALITY_INDEX = 8
    local original_GetAttachedItemInfo = GetAttachedItemInfo
    GetAttachedItemInfo = function(mailId, attachIndex)
        local itemLink = GetAttachedItemLink(mailId, attachIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetAttachedItemInfo(mailId, attachIndex)}
            data[GET_ATTACHED_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetAttachedItemInfo(mailId, attachIndex)
    end

    -- Loots
    local GET_LOOT_ITEM_INFO_QUALITY_INDEX = 5
    local original_GetLootItemInfo = GetLootItemInfo
    GetLootItemInfo = function(lootIndex)
        local itemLink = GetLootItemLink(lootIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetLootItemInfo(lootIndex)}
            data[GET_LOOT_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetLootItemInfo(lootIndex)
    end

    -- Gamepad Alchemy UI
    local GET_ALCHEMY_RESULTING_ITEM_INFO_QUALITY_INDEX = 8
    local original_GetAlchemyResultingItemInfo = GetAlchemyResultingItemInfo
    GetAlchemyResultingItemInfo = function(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
        local itemLink = GetAlchemyResultingItemLink(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetAlchemyResultingItemInfo(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)}
            data[GET_ALCHEMY_RESULTING_ITEM_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetAlchemyResultingItemInfo(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
    end

    -- When you learn a new trait ?
    local GET_LAST_CRAFTING_RESULT_LEARNED_TRAIT_INFO_QUALITY_INDEX = 8
    local original_GetLastCraftingResultLearnedTraitInfo = GetLastCraftingResultLearnedTraitInfo
    GetLastCraftingResultLearnedTraitInfo = function(resultIndex)
        local itemLink = GetAlchemyResultingItemLink(resultIndex)
        if IsCraftedPotion(itemLink) then
            local data = {original_GetLastCraftingResultLearnedTraitInfo(resultIndex)}
            data[GET_LAST_CRAFTING_RESULT_LEARNED_TRAIT_INFO_QUALITY_INDEX] = ChangeQuality(itemLink)
            return unpack(data)
        end
        return original_GetLastCraftingResultLearnedTraitInfo(resultIndex)
    end

    -- Shared function for tooltips
    local function ModifyTooltip(itemLink)
        if IsCraftedPotion(itemLink) then
            local quality = ChangeQuality(itemLink)
            local color = GetItemQualityColor(quality)
            SafeAddString(SI_TOOLTIP_ITEM_NAME, color:Colorize(GetString(SI_TOOLTIP_ITEM_NAME)), 1)
        end
    end

    local function TooltipHook(tooltipControl, method, linkFunc)
        local origMethod = tooltipControl[method]
        tooltipControl[method] = function(self, ...)
            local orgText = GetString(SI_TOOLTIP_ITEM_NAME)
            local itemLink = linkFunc(...)
            ModifyTooltip(itemLink)
            origMethod(self, ...)
            SafeAddString(SI_TOOLTIP_ITEM_NAME, orgText, 1)
        end
    end

    local function ReturnItemLink(itemLink)
        return itemLink
    end

    -- ItemTooltip are tooltips displayed when you hover an item
    TooltipHook(ItemTooltip, "SetBagItem", GetItemLink)
    TooltipHook(ItemTooltip, "SetTradeItem", GetTradeItemLink)
    TooltipHook(ItemTooltip, "SetBuybackItem", GetBuybackItemLink)
    TooltipHook(ItemTooltip, "SetStoreItem", GetStoreItemLink)
    TooltipHook(ItemTooltip, "SetAttachedMailItem", GetAttachedItemLink)
    TooltipHook(ItemTooltip, "SetLootItem", GetLootItemLink)
    TooltipHook(ItemTooltip, "SetTradingHouseItem", GetTradingHouseSearchResultItemLink)
    TooltipHook(ItemTooltip, "SetTradingHouseListing", GetTradingHouseListingItemLink)
    TooltipHook(ItemTooltip, "SetAction", GetSlotItemLink)
    TooltipHook(ItemTooltip, "SetLink", ReturnItemLink)

    -- Is the Tooltip at the Craft Station
    TooltipHook(ZO_AlchemyTopLevelTooltip, "SetPendingAlchemyItem", GetAlchemyResultingItemLink)

    -- Is the Tooltip when you click on a link
    TooltipHook(PopupTooltip, "SetLink", ReturnItemLink)

    -- PotionMaker Addon Tooltip
    if PotionMakerTooltip then
        TooltipHook(PotionMakerTooltip, "SetLink", ReturnItemLink)
    end

    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
