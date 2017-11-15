-- Constants
MAX_WORKER_COUNT = 10

function InsertKeysDefs()
	function InsertKeysTable(tabl)
		for key,entry in pairs(tabl) do
			local curName = entry.name
			if curName then
				tabl[curName] = entry
			end
			local curSpell = entry.spell
			if curSpell then
				tabl[curSpell] = entry
			end
		end
	end

	InsertKeysTable(defs)
	InsertKeysTable(unitdefs)
	InsertKeysTable(buildefs)
end

function GetSpellForEntity(entName)
	local entry = defs[entName] or unitdefs[entName] or buildefs[entName]
	return entry.spell
end

function FindStructByName(name)
    for k,struct in pairs(defs) do
		if struct.name == name or struct.spell == name then
			return struct
		end
	end
	for k,struct in pairs(unitdefs) do
		if struct.name == name or struct.spell == name then
			return struct
		end
	end
	for k,struct in pairs(buildefs) do
		if struct.name == name or struct.spell == name then
			return struct
		end
	end

	return nil
end

function FindUnitStructByName(unitName)
    return FindStructByName(unitName)
end


function GetConstructionSpellForBuilding(buildingName)
	return GetSpellForEntity(buildingName)
end

function GetEntityNameFromConstant(constant)
	local entry = defs[constant] or unitdefs[constant] or buildefs[constant]
	return entry.name
end

function GetEntitySpellFromConstant(constant)
	local entry = defs[constant] or unitdefs[constant] or buildefs[constant]
	return entry.spell
	--return defs[constant].spell
end

function GetEntityFieldFromConstant(constant, heroTeam, field)
	local suffix = ""
	if heroTeam and heroTeam == DOTA_TEAM_GOODGUYS then
		suffix = "_RADIANT"
	elseif heroTeam and heroTeam == DOTA_TEAM_BADGUYS then
		suffix = "_DIRE"
	end
	local key = constant .. suffix
	local entityTable = defs[constant] or defs[key] or unitdefs[constant] or unitdefs[key] or buildefs[constant] or buildefs[key]
	if entityTable then
		return entityTable[field]
	end
	return nil
end


-- Spell definitions --
defs = {
	-- Other
	EMPTY_FILLER = {
		spell = "srts_empty_filler",
		category = "spell"
	},

	BUILDING = {
		spell = "ability_building",
		category = "spell"
	},

	TOWER = {
		spell = "ability_tower",
		category = "spell"
	},

	UNIT = {
		spell = "srts_ability_units",
		category = "spell"
	},

	PROP = {
		 spell = "srts_ability_prop",
		 category = "spell"
	},

	ENTER_TOWER = {
		spell = "srts_enter_tower",
		category = "spell"
	},

	LEAVE_TOWER = {
		spell = "srts_leave_tower",
		category = "spell"
	},

	REPAIR_BUILDING = {
		spell = "srts_repair_building",
		category = "spell"
	},

	DEMOLISH_BUILDING = {
		 spell = "srts_demolish_building",
		 category = "spell"
	},

	-- Auras
	GLOBAL_SPEED_AURA = {
		spell = "srts_global_speed_aura",
		category = "spell"
	},

	CRYSTAL_AURA = {
		spell = "srts_crystal_aura",
		category = "spell"
	},

	-- Lumber related
	HARVEST_LUMBER_HERO = {
		spell = "srts_harvest_lumber",
		category = "spell"
	},

	HARVEST_LUMBER_WORKER = {
		spell = "srts_harvest_lumber_worker",
		category = "spell"
	},

	TRANSFER_LUMBER = {
		spell = "srts_transfer_lumber",
		category = "spell"
	},

	SELL_LUMBER_SMALL = {
		spell = "srts_sell_lumber_small",
		category = "spell"
	},

	DELIVERY_POINT = {
		spell = "srts_ability_delivery_point",
		category = "spell"
	},

	-- Gold related
	PERIODIC_MINE_GOLD = {
		spell = "srts_periodic_mine_gold",
		category = "spell"
	},

	-- Ability pages
	PAGE_MAIN = {
		spell = "srts_menu_main",
		category = "spell"
	},

	PAGE_MENU_CONSTRUCTION_BASIC = {
		spell = "srts_menu_construction_1",
		category = "spell"
	},

	PAGE_MENU_CONSTRUCTION_ADVANCED = {
		spell = "srts_menu_construction_2",
		category = "spell"
	},

	PAGE_MENU_PROPS = {
		 spell = "srts_menu_props",
		 category = "spell"
	},

	-- Items
	BUY_HEALING_SALVE = {
		 spell = "srts_buy_healing_salve",
		 category = "spell"
	},

	-- Upgrades
	UPGRADE_LIGHT_ARMOR = {
		 spell = "srts_upgrade_light_armor",
		 category = "upgrade",
		 constant = "UPGRADE_LIGHT_ARMOR",
		 --items = {"item_upgrade_light_armor",
		 --"item_upgrade_medium_armor"},
		 item = "item_upgrade_light_armor",
         techname = "Light Armor",
		 max = 1
	},

	UPGRADE_LIGHT_DAMAGE = {
		 spell = "srts_upgrade_light_damage",
		 category = "upgrade",
		 constant = "UPGRADE_LIGHT_DAMAGE",
		 --items = {"item_upgrade_light_damage",
		 --"item_upgrade_medium_damage"},
		 item = "item_upgrade_light_damage",
         techname = "Light Damage",
		 max = 1
	},

    UPGRADE_ADEPT_TRAINING = {
		 spell = "srts_upgrade_adept_training",
		 category = "upgrade",
		 constant = "UPGRADE_ADEPT_TRAINING",
         req = {{"BARRACKS_ADVANCED_RADIANT", "BARRACKS_ADVANCED_DIRE"}},
		 --items = {"item_upgrade_light_damage",
		 --"item_upgrade_medium_damage"},
		 item = "item_upgrade_adept_training",
         techname = "Adept Training",
		 max = 1
	},

	-- Unit spells
	REGENERATIVE_BARK = {
		spell = "srts_regenerative_bark",
		category = "spell"
	},

	LONG_WEAPON = {
		spell = "srts_long_weapon",
		category = "spell"
	},

	SNIPER_RIFLE = {
		 spell = "srts_sniper_rifle",
		 category = "spell"
	},

	HATRED = {
		spell = "srts_hatred",
		category = "spell"
	},

	UNDEAD_STRENGTH = {
		spell = "srts_undead_strength",
		category = "spell"
	},

	HEADSHOT = {
		spell = "srts_headshot",
		category = "spell"
	},

	ENVENOMED_SPEARS = {
		spell = "srts_envenomed_spears",
		category = "spell"
	},

	CHILLING_ATTACKS = {
		spell = "srts_chilling_attacks",
		category = "spell"
	},

	BURNING_ARROWS = {
		spell = "srts_burning_arrows",
		category = "spell"
	},

	IGNITE = {
		spell = "srts_ignite",
		category = "spell"
	},

	SIEGE_DAMAGE = {
		 spell = "srts_siege_damage",
		 category = "spell"
	},

	CURSE = {
		 spell = "srts_curse",
		 category = "spell"
	},

	SLOW = {
		 spell = "srts_slow",
		 category = "spell"
	},

	FRENZY = {
		 spell = "srts_frenzy",
		 category = "spell"
	},

	LIVING_ARMOR = {
		 spell = "srts_living_armor",
		 category = "spell"
	}
}

buildefs = {

	-- Buildings
	TENT_SMALL = {
		name = "npc_dota_building_main_tent_small",
		spell = "srts_construct_main_building",
		constant = "TENT_SMALL",
		category = "building",
		max = 1,
		pages = {
			PAGE_MAIN = {
				-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	TENT_LARGE = {
		name = "npc_dota_building_main_tent_large",
		spell = "srts_upgrade_main_building",
		constant = "TENT_LARGE",
		category = "building",
		max = 1,
        techname = "Large Tent",
		from = "TENT_SMALL",
		pages = {
			PAGE_MAIN = {
	-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	WATCH_TOWER = {
		name = "npc_dota_building_watch_tower",
		spell = "srts_construct_watch_tower",
		constant = "WATCH_TOWER",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"ENTER_TOWER",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING",
				"TOWER"
			}
		}
	},

	WOODEN_WALL = {
		name = "npc_dota_building_wooden_wall",
		spell = "srts_construct_wooden_wall",
		constant = "WOODEN_WALL",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	MARKET = {
		name = "npc_dota_building_market",
		spell = "srts_construct_market",
		constant = "MARKET",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"SELL_LUMBER_SMALL",
				"BUY_HEALING_SALVE",
				"DELIVERY_POINT",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	GOLD_MINE = {
		name = "npc_dota_building_gold_mine",
		spell = "srts_construct_gold_mine",
		constant = "GOLD_MINE",
		category = "building",
		max = 1,
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"PERIODIC_MINE_GOLD",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	-- Radiant
	BARRACKS_RADIANT = {
		name = "npc_dota_building_barracks_radiant",
		spell = "srts_construct_barracks_radiant",
		constant = "BARRACKS_RADIANT",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	BARRACKS_ADVANCED_RADIANT = {
		name = "npc_dota_building_barracks_advanced_radiant",
		spell = "srts_construct_barracks_advanced_radiant",
		constant = "BARRACKS_ADVANCED_RADIANT",
		category = "building",
		req = {"TENT_LARGE"},
		pages = {
			PAGE_MAIN = {
				-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	ARMORY_RADIANT = {
		name = "npc_dota_building_armory",
		spell = "srts_construct_armory_radiant",
		constant = "ARMORY_RADIANT",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_RADIANT"},
		max = 1,
		pages = {
			 PAGE_MAIN = {
				"UPGRADE_LIGHT_DAMAGE",
				"UPGRADE_LIGHT_ARMOR",
                "UPGRADE_ADEPT_TRAINING",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	HEALING_CRYSTAL_RADIANT = {
		name = "npc_dota_building_crystal_radiant",
		spell = "srts_construct_crystal_radiant",
		constant = "HEALING_CRYSTAL_RADIANT",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_RADIANT"},
		pages = {
			PAGE_MAIN = {
				"CRYSTAL_AURA",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	-- Dire
	BARRACKS_DIRE = {
		name = "npc_dota_building_barracks_dire",
		spell = "srts_construct_barracks_dire",
		constant = "BARRACKS_DIRE",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	BARRACKS_ADVANCED_DIRE = {
		name = "npc_dota_building_barracks_advanced_dire",
		spell = "srts_construct_barracks_advanced_dire",
		constant = "BARRACKS_ADVANCED_DIRE",
		category = "building",
		req = {"TENT_LARGE"},
		pages = {
			PAGE_MAIN = {
				-- Defined later.
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	ARMORY_DIRE = {
		name = "npc_dota_building_armory",
		spell = "srts_construct_armory_dire",
		constant = "ARMORY_DIRE",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_DIRE"},
		max = 1,
		pages = {
			PAGE_MAIN = {
				"UPGRADE_LIGHT_DAMAGE",
				"UPGRADE_LIGHT_ARMOR",
                "UPGRADE_ADEPT_TRAINING",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},

	HEALING_CRYSTAL_DIRE = {
		name = "npc_dota_building_crystal_dire",
		spell = "srts_construct_crystal_dire",
		constant = "HEALING_CRYSTAL_DIRE",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_DIRE"},
		pages = {
			PAGE_MAIN = {
				"CRYSTAL_AURA",
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"BUILDING"
			}
		}
	},



	-- Props
	PROP_BARREL = {
		name = "npc_dota_building_prop_barrel",
		spell = "srts_construct_prop_barrel",
		constant = "PROP_BARREL",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
		 		"DEMOLISH_BUILDING"
			},
			HIDDEN = {
		 		"PROP",
		 		"BUILDING"
			}
		}
	},

	PROP_CHEST = {
		name = "npc_dota_building_prop_chest",
		spell = "srts_construct_prop_chest",
		constant = "PROP_CHEST",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	},

	PROP_STASH = {
		name = "npc_dota_building_prop_stash",
		spell = "srts_construct_prop_stash",
		constant = "PROP_STASH",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	},

	PROP_WEAPON_RACK = {
		name = "npc_dota_building_prop_weapon_rack",
		spell = "srts_construct_prop_weapon_rack",
		constant = "PROP_WEAPON_RACK",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	},

	PROP_BANNER_RADIANT = {
		name = "npc_dota_building_prop_banner_radiant",
		spell = "srts_construct_prop_banner_radiant",
		constant = "PROP_BANNER_RADIANT",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	},

	PROP_BANNER_DIRE = {
		name = "npc_dota_building_prop_banner_dire",
		spell = "srts_construct_prop_banner_dire",
		constant = "PROP_BANNER_DIRE",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
				"DEMOLISH_BUILDING"
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	},

	PROP_BANNER_OWNER = {
		name = "npc_dota_building_prop_banner_owner",
		spell = "srts_construct_prop_banner_dire",
		constant = "PROP_BANNER_OWNER",
		category = "building",
		req = {{"TENT_SMALL", "TENT_LARGE"}},
		pages = {
			PAGE_MAIN = {
			},
			HIDDEN = {
				"PROP",
				"BUILDING"
			}
		}
	}
}

unitdefs = {

	-- Units
	COMMON_TRAIN_WORKER = {
		name = "npc_dota_creature_worker",
		spell = "srts_train_worker",
		category = "unit",
		upgrades = {"UPGRADE_LIGHT_ARMOR",
		"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT
	},

	-- Commander
	COMMANDER_WORKER = {
		name = "npc_dota_creature_human_worker",
		spell = "srts_train_human_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_RADIANT",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_RADIANT",
				"ARMORY_RADIANT",
				"BARRACKS_ADVANCED_RADIANT",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_RADIANT",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	COMMANDER_FOOTMAN = {
		name = "npc_dota_creature_human_guard_1",
		spell = "srts_train_human_footman",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	COMMANDER_GUNNER = {
		name = "npc_dota_creature_human_ranged_1",
		spell = "srts_train_human_gunner",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"SNIPER_RIFLE",
				"HEADSHOT"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	COMMANDER_CATAPULT = {
		name = "npc_dota_creature_catapult_radiant",
		spell = "srts_train_catapult_radiant",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_RADIANT"},
		pages = {
			 PAGE_MAIN = {
				"SIEGE_DAMAGE"
			},
			HIDDEN = {
	 			"UNIT"
			}
		}
	},

	COMMANDER_SORCERESS = {
		name = "npc_dota_creature_human_sorceress",
		spell = "srts_train_human_sorceress",
		category = "unit",
		trainedAt = "BARRACKS_ADVANCED_RADIANT",
		unitType = "caster",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		pages = {
			PAGE_MAIN = {
	 			"SLOW"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	-- Furion
	FURION_WORKER = {
		name = "npc_dota_creature_forest_worker",
		spell = "srts_train_forest_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_RADIANT",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_RADIANT",
				"ARMORY_RADIANT",
				"BARRACKS_ADVANCED_RADIANT",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_RADIANT",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	FURION_WARRIOR = {
		name = "npc_dota_creature_treant_warrior_1",
		spell = "srts_train_forest_warrior",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {
				"REGENERATIVE_BARK"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	FURION_DRYAD = {
		name = "npc_dota_creature_forest_ranged_1",
		spell = "srts_train_forest_dryad",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"ENVENOMED_SPEARS"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	FURION_CATAPULT = {
		name = "npc_dota_creature_catapult_radiant",
		spell = "srts_train_catapult_radiant",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_RADIANT"},
		pages = {
			PAGE_MAIN = {
				"SIEGE_DAMAGE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	FURION_TORMENTED_SOUL = {
		name = "npc_dota_creature_forest_tormented_soul",
		spell = "srts_train_forest_tormented_soul",
		category = "unit",
		trainedAt = "BARRACKS_ADVANCED_RADIANT",
		unitType = "caster",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		req = {},
		pages = {
			PAGE_MAIN = {
				"LIVING_ARMOR"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	-- Brewmaster
	BREWMASTER_WORKER = {
		name = "npc_dota_creature_brewmaster_worker",
		spell = "srts_train_brewmaster_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_RADIANT",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_RADIANT",
				"ARMORY_RADIANT",
				"BARRACKS_ADVANCED_RADIANT",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_RADIANT",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	BREWMASTER_WARRIOR = {
		name = "npc_dota_creature_brewmaster_bruiser",
		spell = "srts_train_brewmaster_bruiser",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	BREWMASTER_FROSTMAGE = {
		name = "npc_dota_creature_brewmaster_frostmage",
		spell = "srts_train_brewmaster_frostmage",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"CHILLING_ATTACKS"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	BREWMASTER_CATAPULT = {
		name = "npc_dota_creature_catapult_radiant",
		spell = "srts_train_catapult_radiant",
		category = "unit",
		trainedAt = "BARRACKS_RADIANT",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_RADIANT"},
		pages = {
			PAGE_MAIN = {
				"SIEGE_DAMAGE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	--[=[
	BREWMASTER_TORMENTED_SOUL = {
		name = "npc_dota_creature_forest_tormented_soul",
		spell = "srts_train_forest_tormented_soul",
		category = "unit",
		trainedAt = "BARRACKS_ADVANCED_RADIANT",
		unitType = "caster",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		req = {},
		pages = {
			PAGE_MAIN = {
				"LIVING_ARMOR"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},]=]

	-- Geomancer
	GEOMANCER_WORKER = {
		name = "npc_dota_creature_kobold_worker",
		spell = "srts_train_kobold_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_DIRE",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_DIRE",
				"ARMORY_DIRE",
				"BARRACKS_ADVANCED_DIRE",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_DIRE",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	GEOMANCER_SPEARMAN = {
		name = "npc_dota_creature_kobold_guard_1",
		spell = "srts_train_kobold_spearman",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {
				"LONG_WEAPON"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	GEOMANCER_FLAME_THROWER = {
		name = "npc_dota_creature_kobold_ranged_1",
		spell = "srts_train_kobold_flame_thrower",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"IGNITE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	GEOMANCER_CATAPULT = {
		name = "npc_dota_creature_catapult_dire",
		spell = "srts_train_catapult_dire",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_DIRE"},
		pages = {
			PAGE_MAIN = {
	 			"SIEGE_DAMAGE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	-- King of the Dead
	KING_OF_THE_DEAD_WORKER = {
		name = "npc_dota_creature_skeleton_worker",
		spell = "srts_train_skeleton_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_DIRE",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_DIRE",
				"ARMORY_DIRE",
				"BARRACKS_ADVANCED_DIRE",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_DIRE",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	KING_OF_THE_DEAD_WARRIOR = {
		name = "npc_dota_creature_skeleton_warrior_1",
		spell = "srts_train_skeleton_warrior",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {
				"UNDEAD_STRENGTH"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	KING_OF_THE_DEAD_ARCHER = {
		name = "npc_dota_creature_skeleton_ranged_1",
		spell = "srts_train_skeleton_archer",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"BURNING_ARROWS"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	KING_OF_THE_DEAD_CATAPULT = {
		name = "npc_dota_creature_catapult_dire",
		spell = "srts_train_catapult_dire",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_DIRE"},
		pages = {
			PAGE_MAIN = {
				"SIEGE_DAMAGE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	KING_OF_THE_DEAD_CASTER = {
		name = "npc_dota_creature_skeleton_caster",
		spell = "srts_train_skeleton_caster",
		category = "unit",
		trainedAt = "BARRACKS_ADVANCED_DIRE",
		unitType = "caster",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		pages = {
			PAGE_MAIN = {
				"CURSE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	-- Warlord
	WARLORD_WORKER = {
		name = "npc_dota_creature_troll_worker",
		spell = "srts_train_troll_worker",
		category = "unit",
		trainedAt = "TENT_SMALL",
		unitType = "worker",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		max = MAX_WORKER_COUNT,
		pages = {
			PAGE_MAIN = {
				"HARVEST_LUMBER_WORKER",
				"TRANSFER_LUMBER",
				"PAGE_MENU_CONSTRUCTION_BASIC",
				"PAGE_MENU_CONSTRUCTION_ADVANCED",
				"PAGE_MENU_PROPS",
				"REPAIR_BUILDING"
			},
			PAGE_MENU_CONSTRUCTION_BASIC = {
				"TENT_SMALL",
				"GOLD_MINE",
				"BARRACKS_DIRE",
				"WATCH_TOWER",
				"WOODEN_WALL",
				"PAGE_MAIN"
			},
			PAGE_MENU_CONSTRUCTION_ADVANCED = {
				"MARKET",
				"HEALING_CRYSTAL_DIRE",
				"ARMORY_DIRE",
				"BARRACKS_ADVANCED_DIRE",
				"EMPTY_FILLER",
				"PAGE_MAIN"
			},
			PAGE_MENU_PROPS = {
				"PROP_BARREL",
				"PROP_CHEST",
				"PROP_STASH",
				"PROP_WEAPON_RACK",
				"PROP_BANNER_DIRE",
				"PAGE_MAIN"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	WARLORD_FIGHTER = {
		name = "npc_dota_creature_troll_guard_1",
		spell = "srts_train_troll_fighter",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "melee",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		pages = {
			PAGE_MAIN = {
				"HATRED"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	WARLORD_AXE_THROWER = {
		name = "npc_dota_creature_troll_ranged_1",
		spell = "srts_train_troll_axe_thrower",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "ranged",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"MARKET"},
		pages = {
			PAGE_MAIN = {
				"HATRED"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	WARLORD_CATAPULT = {
		name = "npc_dota_creature_catapult_dire",
		spell = "srts_train_catapult_dire",
		category = "unit",
		trainedAt = "BARRACKS_DIRE",
		unitType = "siege",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE"},
		req = {"ARMORY_DIRE"},
		pages = {
			PAGE_MAIN = {
				"SIEGE_DAMAGE"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	},

	WARLORD_ELDER = {
		name = "npc_dota_creature_troll_elder",
		spell = "srts_train_troll_elder",
		category = "unit",
		trainedAt = "BARRACKS_ADVANCED_DIRE",
		unitType = "caster",
		upgrades = {
			"UPGRADE_LIGHT_ARMOR",
			"UPGRADE_LIGHT_DAMAGE",
            "UPGRADE_ADEPT_TRAINING"},
		req = {},
		pages = {
			PAGE_MAIN = {
				"FRENZY"
			},
			HIDDEN = {
				"UNIT"
			}
		}
	}
}

InsertKeysDefs()
