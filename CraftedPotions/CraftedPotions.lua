
local ADDON_NAME = "CraftedPotions"

local function OnAddonLoaded(_, addon)

	local function changeQuality(itemLink)

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

	if addon == ADDON_NAME then

		-- Rewriting core functions
		
		-- Shared (Gamepad UI, Addons)
		local original_GetItemQuality = GetItemQuality
		GetItemQuality = function(bagId, slotId)
			local itemType = GetItemType(bagId, slotId)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				local itemLink = GetItemLink(bagId, slotId)
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					return changeQuality(itemLink)
				end
			end
			return original_GetItemQuality(bagId, slotId)
		end

		-- Shared (Gamepad UI, Addons)
		local original_GetItemLinkQuality = GetItemLinkQuality
		GetItemLinkQuality = function(itemLink)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					return changeQuality(itemLink)
				end
			end
			return original_GetItemLinkQuality(itemLink)
		end

		-- QuickSlots
		local original_GetSlotItemQuality = GetSlotItemQuality
		GetSlotItemQuality = function(slotIndex)
			local itemLink = GetSlotItemLink(slotIndex) 
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					return changeQuality(itemLink)
				end
			end
			return original_GetSlotItemQuality(slotIndex)
		end
		
		-- Bags
		local original_GetItemInfo = GetItemInfo
		GetItemInfo = function(bagId, slotId)
			local itemType = GetItemType(bagId, slotId)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				local itemLink = GetItemLink(bagId, slotId)
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyle = original_GetItemInfo(bagId, slotId)
					return icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyle, quality
				end
			end
			return original_GetItemInfo(bagId, slotId)
		end
		
		-- Trading House listings
		local original_GetTradingHouseListingItemInfo = GetTradingHouseListingItemInfo
		GetTradingHouseListingItemInfo = function(index)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, itemName, _, stackCount, sellerName, timeRemaining, purchasePrice = original_GetTradingHouseListingItemInfo(index)
					return icon, itemName, quality, stackCount, sellerName, timeRemaining, purchasePrice
				
				end
			end
			return original_GetTradingHouseListingItemInfo(index)
		end
		
		-- Trading House searchs
		local original_GetTradingHouseSearchResultItemInfo = GetTradingHouseSearchResultItemInfo
		GetTradingHouseSearchResultItemInfo = function(index)
			local itemLink = GetTradingHouseSearchResultItemLink(index)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, itemName, _, stackCount, sellerName, timeRemaining, purchasePrice, currencyType = original_GetTradingHouseSearchResultItemInfo(index)
					return icon, itemName, quality, stackCount, sellerName, timeRemaining, purchasePrice, currencyType
				end
			end
			return original_GetTradingHouseSearchResultItemInfo(index)
		end
		
		-- Stores
		local original_GetStoreEntryInfo = GetStoreEntryInfo
		GetStoreEntryInfo = function(entryIndex)
			local itemLink = GetStoreItemLink(entryIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, name, stack, price, sellPrice, meetsRequirementsToBuy, meetsRequirementsToUse, _, questNameColor, currencyType1, currencyQuantity1, currencyType2, currencyQuantity2, entryType = original_GetStoreEntryInfo(entryIndex)
					return icon, name, stack, price, sellPrice, meetsRequirementsToBuy, meetsRequirementsToUse, quality, questNameColor, currencyType1, currencyQuantity1, currencyType2, currencyQuantity2, entryType
				end
			end
			return original_GetStoreEntryInfo(entryIndex)
		end
		
		-- Guild Log
		local original_GetGuildSpecificItemInfo = GetGuildSpecificItemInfo
		GetGuildSpecificItemInfo = function(index)
			local itemLink = GetGuildSpecificItemLink(index)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, itemName, _, stackCount, requiredLevel, requiredVeteranRank, purchasePrice, currencyType = original_GetGuildSpecificItemInfo(index)
					return icon, itemName, quality, stackCount, requiredLevel, requiredVeteranRank, purchasePrice, currencyType
				end
			end
			return original_GetGuildSpecificItemInfo(index)
		end
		
		-- Trade between players
		local original_GetTradeItemInfo = GetTradeItemInfo
		GetTradeItemInfo = function(who, tradeIndex)
			local itemLink = GetTradeItemLink(who, tradeIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local name, icon, stack, _, creatorName, sellPrice, meetsUsageRequirement, equipType, itemStyle = original_GetTradeItemInfo(who, tradeIndex)
					return name, icon, stack, quality, creatorName, sellPrice, meetsUsageRequirement, equipType, itemStyle
				end
			end
			return original_GetTradeItemInfo(who, tradeIndex)
		end
		
		-- Store Buyback
		local original_GetBuybackItemInfo = GetBuybackItemInfo
		GetBuybackItemInfo = function(entryIndex)
			local itemLink = GetBuybackItemLink(entryIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, name, stack, price, _, meetsRequirementsToEquip = original_GetBuybackItemInfo(entryIndex)
					return icon, name, stack, price, quality, meetsRequirementsToEquip 
				end
			end
			return original_GetBuybackItemInfo(entryIndex)
		end
		
		-- Mails
		local original_GetAttachedItemInfo = GetAttachedItemInfo
		GetAttachedItemInfo = function(mailId, attachIndex)
			local itemLink = GetAttachedItemLink(mailId, attachIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local icon, stack, creatorName, sellPrice, meetsUsageRequirement, equipType, itemStyle, _ = original_GetAttachedItemInfo(mailId, attachIndex)
					return icon, stack, creatorName, sellPrice, meetsUsageRequirement, equipType, itemStyle, quality
				end
			end
			return original_GetAttachedItemInfo(mailId, attachIndex)
		end
		
		-- Loots
		local original_GetLootItemInfo = GetLootItemInfo
		GetLootItemInfo = function(lootIndex)
			local itemLink = GetLootItemLink(lootIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local lootId, name, icon, count, _, value, isQuest, stolen = original_GetLootItemInfo(lootIndex)
					return lootId, name, icon, count, quality, value, isQuest, stolen
				end
			end
			return original_GetLootItemInfo(lootIndex)
		end
		
		-- Gamepad Alchemy UI
		local original_GetAlchemyResultingItemInfo = GetAlchemyResultingItemInfo
		GetAlchemyResultingItemInfo = function(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
			local itemLink = GetAlchemyResultingItemLink(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local name, icon, stack, sellPrice, meetsUsageRequirement, equipType, itemStyle, _ = original_GetAlchemyResultingItemInfo(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
					return name, icon, stack, sellPrice, meetsUsageRequirement, equipType, itemStyle, quality 
				end
			end
			return original_GetAlchemyResultingItemInfo(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex)
		end
		
		-- When you learn a new trait ?
		local original_GetLastCraftingResultLearnedTraitInfo = GetLastCraftingResultLearnedTraitInfo
		GetLastCraftingResultLearnedTraitInfo = function(resultIndex)
			local itemLink = GetAlchemyResultingItemLink(resultIndex)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local name, icon, stack, sellPrice, meetsUsageRequirement, equipType, itemType, itemStyle, _, soundCategory, itemInstanceId = original_GetLastCraftingResultLearnedTraitInfo(resultIndex)
					return name, icon, stack, sellPrice, meetsUsageRequirement, equipType, itemType, itemStyle, quality, soundCategory, itemInstanceId
				end
			end
			return original_GetLastCraftingResultLearnedTraitInfo(resultIndex)
		end
		
		-- Shared function for tooltips
		local function ModifyTooltip(itemLink)
			local itemType = GetItemLinkItemType(itemLink)
			if itemType == ITEMTYPE_POTION or itemType == ITEMTYPE_POISON then
				if select(24, ZO_LinkHandler_ParseLink(itemLink)) ~= "0" then
					local quality = changeQuality(itemLink)
					local color = GetItemQualityColor(quality)
					SafeAddString(SI_TOOLTIP_ITEM_NAME, ("|c%s%s|r"):format(color:ToHex(), zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))), 1)
				end
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
	
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)