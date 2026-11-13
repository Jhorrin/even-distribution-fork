local distribution = require("scripts.batch-distribution")
local fuel = require("scripts.fuel")
local ammoPolicy = require("scripts.ammo-policy")
-- Inventory Cleanup Hotkey

local this = {}
local drag = scripts.drag
local util = scripts.util
local metatables = scripts.metatables
local config = require("config")

local helpers = scripts.helpers
local _ = helpers.on

local function cleanupPort(entity)
    if entity.name == "recycler" then return "input" end
    if entity.name == "heating-tower" then return "fuel" end
end

local function blockedCleanupTarget(entity, item, prechecked)
    if item == "atomic-bomb" and entity.type:find("turret", 1, true) ~= nil then return true end
    -- Heating towers share the reactor type, but use the seeded-fuel rule.
    local port = cleanupPort(entity)
    if port then
        if prechecked then return false end
        local inventory = entity:inventory(port)
        return not inventory or inventory.is_empty()
    end
    return entity.type == "reactor" or entity.type == "fusion-reactor"
end

local function refillTargets(entities, item, quality, port)
    local targets = metatables.new("entityAsIndex")
    local prototype = prototypes.item[item]
    for _index, entity in ipairs(entities) do
        entity = _(entity)
        if not blockedCleanupTarget(entity, item) then
            local inventory = entity:inventory(port)
            if inventory and inventory.can_insert({name = item, quality = quality, count = 1}) then
                local compatible
                if port == "fuel" then
                    compatible = fuel.accepts(entity.burner, prototype)
                else
                    compatible = entity.type == "car" or entity.type == "spider-vehicle" or entity:supportsAmmo(prototype)
                end
                if compatible then targets[entity] = entity end
            end
        end
    end
    return targets
end

local function orderedOffers(offers, strongestAmmoFirst, highestFuelFirst)
    local result = {}
    for qualityIndex, offer in ipairs(offers) do
        local function add(item, maximum)
            local prototype = prototypes.item[item]
            local group = prototype.type == "ammo" and 1 or (fuel.is_fuel(prototype) and 2 or 3)
            result[#result + 1] = {
                item = item, maximum = maximum, quality = offer.quality,
                qualityIndex = qualityIndex, group = group, prototype = prototype,
                refillPort = offer.refillPorts and offer.refillPorts[item],
            }
        end
        for item, maximum in pairs(offer.items) do add(item, maximum) end
        for item in pairs(offer.refillPorts or {}) do
            if not offer.items[item] then add(item, 0) end
        end
    end
    table.sort(result, function(a, b)
        if a.group ~= b.group then return a.group < b.group end
        if a.item == b.item then return a.qualityIndex < b.qualityIndex end
        if a.group == 1 then return ammoPolicy.dumpLess(a.item, b.item, strongestAmmoFirst) end
        if a.group == 2 then
            if highestFuelFirst then return fuel.less(b.prototype, a.prototype) end
            return fuel.less(a.prototype, b.prototype)
        end
        return a.item < b.item
    end)
    return result
end

local function dumpBatches(player, entities, offers, dropToChests, dropToOutput, balance)
    local freshFirst = player:setting("disableSpoiledFirst") == true
    local order = orderedOffers(offers, player:setting("cleanupStrongAmmoFirst"), player:setting("cleanupHighFuelFirst"))
    local offY, marked = 0, metatables.new("entityAsIndex")
    for _index, offer in ipairs(order) do
        local item, quality, refillPort = offer.item, offer.quality, offer.refillPort
        local function feedback(entity, inserted)
            if inserted ~= 0 then
                entity:spawnDistributionText(player, item, inserted, offY)
                if not marked[entity] then entity:mark(player); marked[entity] = true end
            end
        end
        local function insert(entity, amount, port)
            -- Eligibility was checked before balancing could debit seed items.
            return this.insert(player, entity, item, amount, port, true, quality)
        end
        local personalAmmoMaximum
        local startingPersonalStock
        if refillPort == "ammo" and offer.maximum > 0 then
            personalAmmoMaximum = ammoPolicy.personalAllowance(player, item, quality)
            if personalAmmoMaximum < math.huge then
                startingPersonalStock = player:playeritemcount(item, true, false, quality)
            end
        end
        if offer.maximum > 0 then
            local targets = this.filterEntities(entities, item, dropToChests, dropToOutput, balance, quality)
            distribution.apply(player, targets, item, quality, {
                inventory = true, trash = true, balance = balance, maximum = offer.maximum,
                targetPort = cleanupPort, profile = "cleanup", quality = quality, freshFirst = freshFirst,
            }, insert, feedback)
        end
        if refillPort then
            if startingPersonalStock then
                local used = math.max(0, startingPersonalStock - player:playeritemcount(item, true, false, quality))
                personalAmmoMaximum = math.max(0, personalAmmoMaximum - used)
            end
            local targets = refillTargets(entities, item, quality, refillPort)
            if not _(targets):is("empty") then
                -- Only compatible ammo or fuel slots can use requested stock.
                distribution.apply(player, targets, item, quality, {
                    inventory = true, balance = balance, targetPort = function() return refillPort end,
                    profile = "cleanup", quality = quality, personalAmmoMaximum = personalAmmoMaximum,
                    freshFirst = freshFirst,
                }, insert, feedback)
            end
        end
        offY = offY - 0.5
    end
end

function this.on_inventory_cleanup(event)
    local player = _(game.players[event.player_index])
    if player:isnot("valid player") or not player:setting("enableInventoryCleanupHotkey") then return end

    local offers = player:dumpOffers()
    if #offers == 0 then return end
    local area = _(player.position):perimeter(player:droprange())
    local entities = this.getEntities(area, player)
    if #entities == 0 then return end

    local dropToChests = player:setting("dropTrashToChests")
    local dropToOutput = player:setting("dropTrashToOutput")
    local balance = player:setting("distributionMode") ~= "distribute"
    dumpBatches(player, entities, offers, dropToChests, dropToOutput, balance)
end

function this.distributeItems(player, entities, items, dropToChests, dropToOutput)
    dumpBatches(player, entities, {{items = items, quality = "normal"}}, dropToChests, dropToOutput, false)
end
function this.balanceItems(player, entities, items, dropToChests, dropToOutput)
    dumpBatches(player, entities, {{items = items, quality = "normal"}}, dropToChests, dropToOutput, true)
end

function this.insert(player, entity, item, amount, port, prechecked, quality)
    if blockedCleanupTarget(entity, item, prechecked) then return 0 end

	local useFuelLimit = player:setting("cleanupUseFuelLimit")
	local useAmmoLimit = player:setting("cleanupUseAmmoLimit")
	local dropToOutput = player:setting("dropTrashToOutput")

    port = port or cleanupPort(entity)
    if port then
        return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, false,
            distribution.portMask(port), quality)
    end

	if entity.type == "furnace" and entity:recipe():isnot("valid") then
		return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, false, {
			fuel     = true,
			ammo     = false,
			input    = false,
			output   = false,
			modules  = false,
			roboport = false,
			main     = false,
		}, quality)

	elseif entity:is("crafting machine") then
		return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, false, {
			fuel     = true,
			ammo     = false,
			input    = entity:recipe():hasIngredient(item),
			output   = dropToOutput and entity.type ~= "rocket-silo" and entity:recipe():hasProduct(item),
			modules  = false,
			roboport = false,
			main     = false,
		}, quality)

	elseif entity.prototype.logistic_mode == "requester" then
		return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, true, {
			fuel     = false,
			ammo     = false,
			input    = false,
			output   = false,
			modules  = false,
			roboport = false,
			main     = true,
		}, quality)

	elseif entity.type == "spider-vehicle" and entity.get_logistic_point(defines.logistic_member_index.character_requester) then
		return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, true, {
			fuel     = true,
			ammo     = true,
			input    = false,
			output   = false,
			modules  = false,
			roboport = false,
			main     = true,
		}, quality)
		
	elseif entity.type == "car" or entity.type == "spider-vehicle" then
		return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, false, {
			fuel     = true,
			ammo     = true,
			input    = false,
			output   = false,
			modules  = false,
			roboport = false,
			main     = false,
		}, quality)
	end
	
	-- Default priority insertion
	return entity:customInsert(player, item, amount, false, true, false, useFuelLimit, useAmmoLimit, false, {
		fuel     = true,
		ammo     = true,
		input    = true,
		output   = false,
		modules  = false,
		roboport = true,
		main     = true,
	}, quality)
end

function this.filterEntities(entities, item, dropToChests, dropToOutput, balance, quality)
	local result = metatables.new("entityAsIndex")
	local prototype = prototypes.item[item]
    quality = quality or "normal"
    local stack = {name = item, quality = quality, count = 1}
	
	_(entities):each(function(__, entity)
		entity = _(entity)
        if blockedCleanupTarget(entity, item) then return end

        -- Preserve the original Cleanup eligibility rule. A full container
        -- is not silently added as a balancing source by the Space Age layer.
		if entity.can_insert(stack) then
			if fuel.accepts(entity.burner, prototype) and entity:inventory("fuel").can_insert(stack) then
				result[entity] = entity
			elseif entity.name == "recycler" or (entity:is("crafting machine") and entity:recipe():hasIngredient(item)
                and (quality == "normal" or (entity:inventory("input") and entity:inventory("input").can_insert(stack)))) then
				result[entity] = entity
			elseif (entity.prototype.logistic_mode == "requester" or (entity.type == "spider-vehicle" and entity.get_logistic_point(defines.logistic_member_index.character_requester))) and entity:remainingRequest(item, quality) > 0 then
				result[entity] = entity
			elseif dropToChests and (entity.type == "container" or entity.type == "logistic-container") and entity:itemcount(item, nil, nil, quality) > 0 then
				result[entity] = entity
			elseif entity.type == "lab" and entity:inventory("lab_input").can_insert(stack) then
				result[entity] = entity
			elseif (entity.type == "ammo-turret" or entity.type == "artillery-turret" or entity.type == "artillery-wagon") and entity:supportsAmmo(prototype) then
				result[entity] = entity
			elseif entity.type == "roboport" then
				result[entity] = entity
			elseif (entity.type == "car" or entity.type == "spider-vehicle") and prototype.type == "ammo" then
				result[entity] = entity
			end
		end
		
		if not result[entity] and dropToOutput and (entity.type == "furnace" or entity.type == "assembling-machine") and entity:recipe():hasProduct(item)
            and (quality == "normal" or (entity:inventory("output") and entity:inventory("output").can_insert(stack))) then
			result[entity] = entity
		end
	end)
	
	return result
end

function this.getEntities(area, player)
	local entities = {}

	for __,entity in ipairs(player.surface.find_entities_filtered{ area = area, force = player.force }) do

		if _(entity):is("valid") and 
		   entity.operable and 
		   not entity.to_be_deconstructed(player.force) and 
		   not _(entity):isIgnored(player) then
			
			entities[#entities + 1] = entity
		end
	end
	
	return entities
end



return this
