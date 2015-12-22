
-- Constants
MAX_WORKER_COUNT = 10

-- Hero names --
heroes = {
  COMMANDER = "npc_dota_hero_legion_commander",
  FURION = "npc_dota_hero_furion",
  GEOMANCER = "npc_dota_hero_meepo",
  KING_OF_THE_DEAD = "npc_dota_hero_skeleton_king",
  WARLORD = "npc_dota_hero_troll_warlord"
}



-- Spell definitions --
defs = {
  -- Other
  EMPTY_FILLER = {
    spell = "srts_empty_filler",
    category = "spell"
  },

  BUILDING = {
    spell = "srts_ability_building",
    category = "spell"
  },

  UNIT = {
    spell = "srts_ability_unit",
    category = "spell"
  },

  ENTER_TOWER = {
    spell = "srts_enter_tower",
    category = "spell"
  },

  REPAIR_BUILDING = {
    spell = "srts_repair_building",
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

  -- Buildings 
  TENT_SMALL = {
    name = "npc_dota_building_main_tent_small",
    spell = "srts_construct_main_building",
    category = "building",
    max = 1,
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  TENT_LARGE = {
    name = "npc_dota_building_main_tent_large",
    spell = "srts_upgrade_main_building",
    category = "building",
    max = 1,
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  WATCH_TOWER = {
    name = "npc_dota_building_watch_tower",
    spell = "srts_construct_watch_tower",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {
	defs.ENTER_BUILDING
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },
  
  WOODEN_WALL = {
    name = "npc_dota_building_wooden_wall",
    spell = "srts_construct_wooden_wall",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {},
      HIDDEN = {
	defs.BUILDING
      }
    }
  },
  
  MARKET = {
    name = "npc_dota_building_market",
    spell = "srts_construct_market",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {
	defs.SELL_LUMBER_SMALL,
	defs.DELIVERY_POINT
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  }, 

  GOLD_MINE = {
    name = "npc_dota_building_gold_mine",
    spell = "srts_construct_gold_mine",
    category = "building",
    max = 1,
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {
	defs.PERIODIC_MINE_GOLD
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  -- Radiant
  BARRACKS_RADIANT = {
    name = "npc_dota_building_barracks_radiant",
    spell = "srts_construct_barracks_radiant",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  ARMORY_RADIANT = {
    name = "npc_dota_building_armory",
    spell = "srts_construct_armory_radiant",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}, defs.BARRACKS_RADIANT},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  HEALING_CRYSTAL_RADIANT = {
    name = "npc_dota_building_crystal_radiant",
    spell = "srts_construct_crystal_radiant",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}, BARRACKS_RADIANT},
    pages = {
      PAGE_MAIN = {
	defs.CRYSTAL_AURA
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  -- Dire
  BARRACKS_DIRE = {
    name = "npc_dota_building_barracks_dire",
    spell = "srts_construct_barracks_dire",
    category = "building"
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  ARMORY_DIRE = {
    name = "npc_dota_building_armory",
    spell = "srts_construct_armory_dire",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}, defs.BARRACKS_DIRE},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  HEALING_CRYSTAL_DIRE = {
    name = "npc_dota_building_crystal_dire",
    spell = "srts_construct_crystal_dire",
    category = "building",
    req = {{defs.TENT_SMALL, defs.TENT_LARGE}, defs.BARRACKS_DIRE},
    pages = {
      PAGE_MAIN = {
	defs.CRYSTAL_AURA
      },
      HIDDEN = {
	defs.BUILDING
      }
    }
  },

  -- Units

}



--[=[

--[[ -----| Tables |----- ]]--
ABILITY_PAGES = {}							-- All the ability pages for the heroes will be stored here.
HERO_TRAINING_SPELLS = {}					-- All the spells for the heroes that is not construction spells.
HERO_SPELLS_FOR_BUILDINGS = {}				-- All the spells for the buildings of the heroes.
MAX_COUNT = {}								-- All the spells with a max unit or building count.
SPELLS = {}									-- All the spells. Accessed with a spellname.

-- Setup the ability pages tables for the heroes.
ABILITY_PAGES[COMMANDER] = {}
ABILITY_PAGES[FURION] = {}
ABILITY_PAGES[GEOMANCER] = {}
ABILITY_PAGES[KING_OF_THE_DEAD] = {}
ABILITY_PAGES[WARLORD] = {}

-- Setup the training spells for the heroes.
HERO_TRAINING_SPELLS[COMMANDER] = {}
HERO_TRAINING_SPELLS[FURION] = {}
HERO_TRAINING_SPELLS[GEOMANCER] = {}
HERO_TRAINING_SPELLS[KING_OF_THE_DEAD] = {}
HERO_TRAINING_SPELLS[WARLORD] = {}

-- Setup the spells of the buildings for the heroes.
HERO_SPELLS_FOR_BUILDINGS[COMMANDER] = {}
HERO_SPELLS_FOR_BUILDINGS[FURION] = {}
HERO_SPELLS_FOR_BUILDINGS[GEOMANCER] = {}
HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD] = {}
HERO_SPELLS_FOR_BUILDINGS[WARLORD] = {}

MAX_WORKER_COUNT = 10
]=]


--[[ SPELLS ]]--

-- Common

COMMON_TRAIN_WORKER = {
   name = "npc_dota_creature_worker",
   spell = "srts_train_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[COMMON_TRAIN_WORKER["name"]] = COMMON_TRAIN_WORKER["maximum"]



-- Radiant

-- Commander
COMMANDER_WORKER = {
   name = "npc_dota_creature_human_worker",
   spell = "srts_train_human_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[COMMANDER_WORKER["name"]] = COMMANDER_WORKER["maximum"]

COMMANDER_FOOTMAN = {}
COMMANDER_FOOTMAN["name"] = "npc_dota_creature_human_guard_1"
COMMANDER_FOOTMAN["spell"] = "srts_train_human_footman"
COMMANDER_FOOTMAN["req"] = {}
COMMANDER_FOOTMAN["category"] = "unit"

COMMANDER_GUNNER = {}
COMMANDER_GUNNER["name"] = "npc_dota_creature_human_ranged_1"
COMMANDER_GUNNER["spell"] = "srts_train_human_gunner"
COMMANDER_GUNNER["req"] = {MARKET}
COMMANDER_GUNNER["category"] = "unit"

COMMANDER_CATAPULT = {}
COMMANDER_CATAPULT["name"] = "npc_dota_creature_catapult_radiant"
COMMANDER_CATAPULT["spell"] = "srts_train_catapult_radiant"
COMMANDER_CATAPULT["req"] = {ARMORY_RADIANT}
COMMANDER_CATAPULT["category"] = "unit"

COMMANDER_TRAINING_SPELLS =
   {COMMON_BUILDING,
    COMMON_UNIT,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_CRYSTAL_AURA,
    COMMON_SELL_LUMBER_SMALL,
    COMMON_REPAIR_BUILDING,
    COMMON_PERIODIC_MINE_GOLD,
    COMMON_ENTER_TOWER,
    COMMANDER_WORKER,
    COMMANDER_FOOTMAN,
    COMMANDER_GUNNER,
    COMMANDER_CATAPULT}

SPELLS[COMMANDER_WORKER["spell"]] = COMMANDER_WORKER
SPELLS[COMMANDER_FOOTMAN["spell"]] = COMMANDER_FOOTMAN
SPELLS[COMMANDER_GUNNER["spell"]] = COMMANDER_GUNNER
SPELLS[COMMANDER_CATAPULT["spell"]] = COMMANDER_CATAPULT

-- Furion
FURION_WORKER = {
   name = "npc_dota_creature_forest_worker",
   spell = "srts_train_forest_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[FURION_WORKER["name"]] = FURION_WORKER["maximum"]

FURION_WARRIOR = {}
FURION_WARRIOR["name"] = "npc_dota_creature_treant_warrior_1"
FURION_WARRIOR["spell"] = "srts_train_forest_warrior"
FURION_WARRIOR["req"] = {}
FURION_WARRIOR["category"] = "unit"

FURION_DRYAD = {}
FURION_DRYAD["name"] = "npc_dota_creature_forest_ranged_1"
FURION_DRYAD["spell"] = "srts_train_forest_dryad"
FURION_DRYAD["req"] = {MARKET}
FURION_DRYAD["category"] = "unit"

FURION_CATAPULT = {}
FURION_CATAPULT["name"] = "npc_dota_creature_catapult_radiant"
FURION_CATAPULT["spell"] = "srts_train_catapult_radiant"
FURION_CATAPULT["req"] = {ARMORY_RADIANT}
FURION_CATAPULT["category"] = "unit"

FURION_REGENERATIVE_BARK = {
   name = "none",
   spell = "srts_regenerative_bark",
   req = {},
   category = "spell"
}

FURION_TRAINING_SPELLS =
   {COMMON_BUILDING,
    COMMON_UNIT,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_CRYSTAL_AURA,
    COMMON_SELL_LUMBER_SMALL,
    COMMON_REPAIR_BUILDING,
    COMMON_PERIODIC_MINE_GOLD,
    COMMON_ENTER_TOWER,
    FURION_WORKER,
    FURION_WARRIOR,
    FURION_DRYAD,
    FURION_CATAPULT}

SPELLS[FURION_WORKER["spell"]] = FURION_WORKER
SPELLS[FURION_WARRIOR["spell"]] = FURION_WARRIOR
SPELLS[FURION_DRYAD["spell"]] = FURION_DRYAD
SPELLS[FURION_CATAPULT["spell"]] = FURION_CATAPULT



-- Dire

-- Geomancer
GEOMANCER_WORKER = {
   name = "npc_dota_creature_kobold_worker",
   spell = "srts_train_kobold_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[GEOMANCER_WORKER["name"]] = GEOMANCER_WORKER["maximum"]

GEOMANCER_SPEARMAN = {}
GEOMANCER_SPEARMAN["name"] = "npc_dota_creature_kobold_guard_1"
GEOMANCER_SPEARMAN["spell"] = "srts_train_kobold_spearman"
GEOMANCER_SPEARMAN["req"] = {}
GEOMANCER_SPEARMAN["category"] = "unit"

GEOMANCER_FLAME_THROWER = {}
GEOMANCER_FLAME_THROWER["name"] = "npc_dota_creature_kobold_ranged_1"
GEOMANCER_FLAME_THROWER["spell"] = "srts_train_kobold_flame_thrower"
GEOMANCER_FLAME_THROWER["req"] = {MARKET}
GEOMANCER_FLAME_THROWER["category"] = "unit"

GEOMANCER_CATAPULT = {}
GEOMANCER_CATAPULT["name"] = "npc_dota_creature_catapult_dire"
GEOMANCER_CATAPULT["spell"] = "srts_train_catapult_dire"
GEOMANCER_CATAPULT["req"] = {ARMORY_DIRE}
GEOMANCER_CATAPULT["category"] = "unit"

GEOMANCER_TRAINING_SPELLS =
   {COMMON_BUILDING,
    COMMON_UNIT,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_CRYSTAL_AURA,
    COMMON_SELL_LUMBER_SMALL,
    COMMON_REPAIR_BUILDING,
    COMMON_PERIODIC_MINE_GOLD,
    COMMON_ENTER_TOWER,
    GEOMANCER_WORKER,
    GEOMANCER_SPEARMAN,
    GEOMANCER_FLAME_THROWER,
    GEOMANCER_CATAPULT}

SPELLS[GEOMANCER_WORKER["spell"]] = GEOMANCER_WORKER
SPELLS[GEOMANCER_SPEARMAN["spell"]] = GEOMANCER_SPEARMAN
SPELLS[GEOMANCER_FLAME_THROWER["spell"]] = GEOMANCER_FLAME_THROWER
SPELLS[GEOMANCER_CATAPULT["spell"]] = GEOMANCER_CATAPULT

-- King of the Dead
KING_OF_THE_DEAD_WORKER = {
   name = "npc_dota_creature_skeleton_worker",
   spell = "srts_train_skeleton_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[KING_OF_THE_DEAD_WORKER["name"]] = KING_OF_THE_DEAD_WORKER["maximum"]

KING_OF_THE_DEAD_WARRIOR = {}
KING_OF_THE_DEAD_WARRIOR["name"] = "npc_dota_creature_skeleton_warrior_1"
KING_OF_THE_DEAD_WARRIOR["spell"] = "srts_train_skeleton_warrior"
KING_OF_THE_DEAD_WARRIOR["req"] = {}
KING_OF_THE_DEAD_WARRIOR["category"] = "unit"

KING_OF_THE_DEAD_ARCHER = {}
KING_OF_THE_DEAD_ARCHER["name"] = "npc_dota_creature_skeleton_ranged_1"
KING_OF_THE_DEAD_ARCHER["spell"] = "srts_train_skeleton_archer"
KING_OF_THE_DEAD_ARCHER["req"] = {MARKET}
KING_OF_THE_DEAD_ARCHER["category"] = "unit"

KING_OF_THE_DEAD_CATAPULT = {}
KING_OF_THE_DEAD_CATAPULT["name"] = "npc_dota_creature_catapult_dire"
KING_OF_THE_DEAD_CATAPULT["spell"] = "srts_train_catapult_dire"
KING_OF_THE_DEAD_CATAPULT["req"] = {ARMORY_DIRE}
KING_OF_THE_DEAD_CATAPULT["category"] = "unit"

KING_OF_THE_DEAD_TRAINING_SPELLS =
   {COMMON_BUILDING,
    COMMON_UNIT,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_CRYSTAL_AURA,
    COMMON_SELL_LUMBER_SMALL,
    COMMON_REPAIR_BUILDING,
    COMMON_PERIODIC_MINE_GOLD,
    COMMON_ENTER_TOWER,
    KING_OF_THE_DEAD_WORKER,
    KING_OF_THE_DEAD_WARRIOR,
    KING_OF_THE_DEAD_ARCHER,
    KING_OF_THE_DEAD_CATAPULT}

SPELLS[KING_OF_THE_DEAD_WORKER["spell"]] = KING_OF_THE_DEAD_WORKER
SPELLS[KING_OF_THE_DEAD_WARRIOR["spell"]] = KING_OF_THE_DEAD_WARRIOR
SPELLS[KING_OF_THE_DEAD_ARCHER["spell"]] = KING_OF_THE_DEAD_ARCHER
SPELLS[KING_OF_THE_DEAD_CATAPULT["spell"]] = KING_OF_THE_DEAD_CATAPULT

-- Warlord
WARLORD_WORKER = {
   name = "npc_dota_creature_troll_worker",
   spell = "srts_train_troll_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[WARLORD_WORKER["name"]] = WARLORD_WORKER["maximum"]

WARLORD_FIGHTER = {}
WARLORD_FIGHTER["name"] = "npc_dota_creature_troll_guard_1"
WARLORD_FIGHTER["spell"] = "srts_train_troll_fighter"
WARLORD_FIGHTER["req"] = {}
WARLORD_FIGHTER["category"] = "unit"

WARLORD_AXE_THROWER = {}
WARLORD_AXE_THROWER["name"] = "npc_dota_creature_troll_ranged_1"
WARLORD_AXE_THROWER["spell"] = "srts_train_troll_axe_thrower"
WARLORD_AXE_THROWER["req"] = {MARKET}
WARLORD_AXE_THROWER["category"] = "unit"

WARLORD_CATAPULT = {}
WARLORD_CATAPULT["name"] = "npc_dota_creature_catapult_dire"
WARLORD_CATAPULT["spell"] = "srts_train_catapult_dire"
WARLORD_CATAPULT["req"] = {ARMORY_DIRE}
WARLORD_CATAPULT["category"] = "unit"
