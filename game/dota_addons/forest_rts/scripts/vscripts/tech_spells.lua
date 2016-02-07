-- Constants
MAX_WORKER_COUNT = 10

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

  UNIT = {
    spell = "srts_ability_unit",
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

  -- Unit spells
  REGENERATIVE_BARK = {
    spell = "srts_regenerative_bark",
    category = "spell"
  },

  LONG_WEAPON = {
    spell = "srts_long_weapon",
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
	"BUILDING"
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
	"BUILDING"
      }
    }
  },

  WATCH_TOWER = {
    name = "npc_dota_building_watch_tower",
    spell = "srts_construct_watch_tower",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}},
    pages = {
      PAGE_MAIN = {
	"ENTER_TOWER"
      },
      HIDDEN = {
	"BUILDING"
      }
    }
  },
  
  WOODEN_WALL = {
    name = "npc_dota_building_wooden_wall",
    spell = "srts_construct_wooden_wall",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}},
    pages = {
      PAGE_MAIN = {},
      HIDDEN = {
	"BUILDING"
      }
    }
  },
  
  MARKET = {
    name = "npc_dota_building_market",
    spell = "srts_construct_market",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}},
    pages = {
      PAGE_MAIN = {
	"SELL_LUMBER_SMALL",
	"DELIVERY_POINT"
      },
      HIDDEN = {
	"BUILDING"
      }
    }
  }, 

  GOLD_MINE = {
    name = "npc_dota_building_gold_mine",
    spell = "srts_construct_gold_mine",
    category = "building",
    max = 1,
    req = {{"TENT_SMALL", "TENT_LARGE"}},
    pages = {
      PAGE_MAIN = {
	"PERIODIC_MINE_GOLD"
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

  ARMORY_RADIANT = {
    name = "npc_dota_building_armory",
    spell = "srts_construct_armory_radiant",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_RADIANT"},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	"BUILDING"
      }
    }
  },

  HEALING_CRYSTAL_RADIANT = {
    name = "npc_dota_building_crystal_radiant",
    spell = "srts_construct_crystal_radiant",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_RADIANT"},
    pages = {
      PAGE_MAIN = {
	"CRYSTAL_AURA"
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

  ARMORY_DIRE = {
    name = "npc_dota_building_armory",
    spell = "srts_construct_armory_dire",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_DIRE"},
    pages = {
      PAGE_MAIN = {
	-- Defined later.
      },
      HIDDEN = {
	"BUILDING"
      }
    }
  },

  HEALING_CRYSTAL_DIRE = {
    name = "npc_dota_building_crystal_dire",
    spell = "srts_construct_crystal_dire",
    category = "building",
    req = {{"TENT_SMALL", "TENT_LARGE"}, "BARRACKS_DIRE"},
    pages = {
      PAGE_MAIN = {
	"CRYSTAL_AURA"
      },
      HIDDEN = {
	"BUILDING"
      }
    }
  },



  -- Units
  COMMON_TRAIN_WORKER = {
    name = "npc_dota_creature_worker",
    spell = "srts_train_worker",
    category = "unit",
    max = MAX_WORKER_COUNT
  },

  -- Commander
  COMMANDER_WORKER = {
    name = "npc_dota_creature_human_worker",
    spell = "srts_train_human_worker",
    category = "unit",
    max = MAX_WORKER_COUNT,
    pages = {
      PAGE_MAIN = {
	"HARVEST_LUMBER_WORKER",
	"TRANSFER_LUMBER",
	"REPAIR_BUILDING",
	"PAGE_MENU_CONSTRUCTION_BASIC",
	"PAGE_MENU_CONSTRUCTION_ADVANCED"
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
	"EMPTY_FILLER",
	"EMPTY_FILLER",
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
    req = {"MARKET"},
    pages = {
      PAGE_MAIN = {
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

  -- Furion
  FURION_WORKER = {
    name = "npc_dota_creature_forest_worker",
    spell = "srts_train_forest_worker",
    category = "unit",
    max = MAX_WORKER_COUNT,
    pages = {
      PAGE_MAIN = {
	"HARVEST_LUMBER_WORKER",
	"TRANSFER_LUMBER",
	"REPAIR_BUILDING",
	"PAGE_MENU_CONSTRUCTION_BASIC",
	"PAGE_MENU_CONSTRUCTION_ADVANCED"
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
	"EMPTY_FILLER",
	"EMPTY_FILLER",
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

  -- Geomancer
  GEOMANCER_WORKER = {
    name = "npc_dota_creature_kobold_worker",
    spell = "srts_train_kobold_worker",
    category = "unit",
    max = MAX_WORKER_COUNT,
    pages = {
      PAGE_MAIN = {
	"HARVEST_LUMBER_WORKER",
	"TRANSFER_LUMBER",
	"REPAIR_BUILDING",
	"PAGE_MENU_CONSTRUCTION_BASIC",
	"PAGE_MENU_CONSTRUCTION_ADVANCED"
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
	"EMPTY_FILLER",
	"EMPTY_FILLER",
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
    max = MAX_WORKER_COUNT,
    pages = {
      PAGE_MAIN = {
	"HARVEST_LUMBER_WORKER",
	"TRANSFER_LUMBE",
	"REPAIR_BUILDING",
	"PAGE_MENU_CONSTRUCTION_BASIC",
	"PAGE_MENU_CONSTRUCTION_ADVANCED"
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
	"EMPTY_FILLER",
	"EMPTY_FILLER",
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

  -- Warlord
  WARLORD_WORKER = {
    name = "npc_dota_creature_troll_worker",
    spell = "srts_train_troll_worker",
    category = "unit",
    max = MAX_WORKER_COUNT,
    pages = {
      PAGE_MAIN = {
	"HARVEST_LUMBER_WORKER",
	"TRANSFER_LUMBER",
	"REPAIR_BUILDING",
	"PAGE_MENU_CONSTRUCTION_BASIC",
	"PAGE_MENU_CONSTRUCTION_ADVANCED"
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
	"EMPTY_FILLER",
	"EMPTY_FILLER",
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
    req = {"ARMORY_DIRE"},
    pages = {
      PAGE_MAIN = {
	 "SIEGE_DAMAGE"
      },
      HIDDEN = {
	"UNIT"
      }
    }
  }
}
