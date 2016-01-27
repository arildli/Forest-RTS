
require("tech_spells")

if not defs then
   print("ERROR: table 'defs' not found!")
   return
end

-- Constants
MAX_WORKER_COUNT = 10

-- Hero names --
COMMANDER = "npc_dota_hero_legion_commander"
FURION = "npc_dota_hero_furion"
GEOMANCER = "npc_dota_hero_meepo"
KING_OF_THE_DEAD = "npc_dota_hero_skeleton_king"
WARLORD = "npc_dota_hero_troll_warlord"

---------------------------------------------------------------------------
-- Returns a copied version of the table.
-- 
-- Taken from http://lua-users.org/wiki/CopyTable
---------------------------------------------------------------------------
function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

---------------------------------------------------------------------------
-- Returns a copied version of the table with the 
-- PAGE_MAIN set to a new value.
---------------------------------------------------------------------------
function CopyWithNewMain(originalTable, pageMainTable)
  local copy = deepcopy(originalTable)
  copy["pages"]["PAGE_MAIN"] = pageMainTable
  return copy
end

---------------------------------------------------------------------------
-- Adds the common abilities that are not construction
-- spells to the table of each hero.
---------------------------------------------------------------------------
function AddCommonAbilities()
   for herokey,herotable in pairs(tech) do
      if herokey ~= "COMMON" then
	 for k,v in pairs(tech["COMMON"]) do
	    herotable[k] = v
	 end
      end
   end
end



-- Tech tree definitions --
tech = {
  -- Common abilities
  COMMON = {
    -- Common
    EMPTY_FILLER = defs.EMPTY_FILLER,
    BUILDING = defs.BUILDING,
    UNIT = defs.UNIT,
    ENTER_BUILDING = defs.ENTER_BUILDING,
    LEAVE_BUILDING = defs.LEAVE_BUILDING,
    REPAIR_BUILDING = defs.REPAIR_BUILDING,
    GLOBAL_SPEED_AURA = defs.GLOBAL_SPEED_AURA,
    CRYSTAL_AURA = defs.CRYSTAL_AURA,
    HARVEST_LUMBER_HERO = defs.HARVEST_LUMBER_HERO,
    HARVEST_LUMBER_WORKER = defs.HARVEST_LUMBER_WORKER,
    TRANSFER_LUMBER = defs.TRANSFER_LUMBER,
    SELL_LUMBER_SMALL = defs.SELL_LUMBER_SMALL,
    DELIVERY_POINT = defs.DELIVERY_POINT,
    PERIODIC_MINE_GOLD = defs.PERIODIC_MINE_GOLD,
    PAGE_MAIN = defs.PAGE_MAIN,
    PAGE_MENU_CONSTRUCTION_BASIC = defs.PAGE_MENU_CONSTRUCTION_BASIC,
    PAGE_MENU_CONSTRUCTION_ADVANCED = defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
  }


  -- Radiant
  COMMANDER = {
    heroname = COMMANDER,

    heropages = {
      PAGE_MAIN = {
	defs.HARVEST_LUMBER_HERO,
	defs.TRANSFER_LUMBER,
	defs.PAGE_MENU_CONSTRUCTION_BASIC,
	defs.PAGE_MENU_CONSTRUCTION_ADVANCED
      },
      PAGE_MENU_CONSTRUCTION_BASIC = {
	defs.TENT_SMALL,
	defs.GOLD_MINE,
	defs.BARRACKS_RADIANT,
	defs.WATCH_TOWER,
	defs.WOODEN_WALL,
	defs.PAGE_MAIN
      },
      PAGE_MENU_CONSTRUCTION_ADVANCED = {
	defs.MARKET,
	defs.HEALING_CRYSTAL_RADIANT,
	defs.ARMORY_RADIANT,
	defs.EMPTY_FILLER,
	defs.EMPTY_FILLER,
	defs.PAGE_MAIN
      }
    },
    
    -- Unit and building spells
    HEADSHOT = defs.HEADSHOT,
    
    COMMANDER_WORKER = defs.COMMANDER_WORKER,
    COMMANDER_FOOTMAN = defs.COMMANDER_FOOTMAN,
    COMMANDER_GUNNER = defs.COMMANDER_GUNNER,
    COMMANDER_CATAPULT = defs.COMMANDER_CATAPULT,

    -- Buildings
    TENT_SMALL = CopyWithNewMain(defs.TENT_SMALL, {
				   defs.COMMANDER_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    TENT_LARGE = CopyWithNewMain(defs.TENT_LARGE, {
				   defs.COMMANDER_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    BARRACKS_RADIANT = CopyWithNewMain(defs.BARRACKS_RADIANT, {
					 defs.COMMANDER_FOOTMAN,
					 defs.COMMANDER_GUNNER,
					 defs.COMMANDER_CATAPULT
    }),
    ARMORY_RADIANT = defs.ARMORY_RADIANT,
    HEALING_CRYSTAL_RADIANT = defs.HEALING_CRYSTAL_RADIANT,
    WATCH_TOWER = defs.WATCH_TOWER,
    WOODEN_WALL = defs.WOODEN_WALL,
    MARKET = defs.MARKET,
    GOLD_MINE = defs.GOLD_MINE
  },
  

  FURION = {
    heroname = FURION,
    
    heropages = {
      PAGE_MAIN = {
	defs.HARVEST_LUMBER_HERO,
	defs.TRANSFER_LUMBER,
	defs.PAGE_MENU_CONSTRUCTION_BASIC,
	defs.PAGE_MENU_CONSTRUCTION_ADVANCED
      },
      PAGE_MENU_CONSTRUCTION_BASIC = {
	defs.TENT_SMALL,
	defs.GOLD_MINE,
	defs.BARRACKS_RADIANT,
	defs.WATCH_TOWER,
	defs.WOODEN_WALL,
	defs.PAGE_MAIN
      },
      PAGE_MENU_CONSTRUCTION_ADVANCED = {
	defs.MARKET,
	defs.HEALING_CRYSTAL_RADIANT,
	defs.ARMORY_RADIANT,
	defs.EMPTY_FILLER,
	defs.EMPTY_FILLER,
	defs.PAGE_MAIN
      }
    },

    -- Unit and building spells
    REGENERATIVE_BARK = defs.REGENERATIVE_BARK,
    ENVENOMED_SPEARS = defs.ENVENOMED_SPEARS,

    FURION_WORKER = defs.FURION_WORKER,
    FURION_WARRIOR = defs.FURION_WARRIOR,
    FURION_DRYAD = defs.FURION_DRYAD,
    FURION_CATAPULT = defs.FURION_CATAPULT,

    -- Buildings
    TENT_SMALL = CopyWithNewMain(defs.TENT_SMALL, {
				   defs.FURION_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    TENT_LARGE = CopyWithNewMain(defs.TENT_LARGE, {
				   defs.FURION_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    BARRACKS_RADIANT = CopyWithNewMain(defs.BARRACKS_RADIANT, {
					 defs.FURION_WARRIOR,
					 defs.FURION_DRYAD,
					 defs.FURION_CATAPULT
    }),
    ARMORY_RADIANT = defs.ARMORY_RADIANT,
    HEALING_CRYSTAL_RADIANT = defs.HEALING_CRYSTAL_RADIANT,
    WATCH_TOWER = defs.WATCH_TOWER,
    WOODEN_WALL = defs.WOODEN_WALL,
    MARKET = defs.MARKET,
    GOLD_MINE = defs.GOLD_MINE
  },


  -- Dire
  GEOMANCER = {
    heroname = GEOMANCER,

    heropages = {
      PAGE_MAIN = {
	defs.HARVEST_LUMBER_HERO,
	defs.TRANSFER_LUMBER,
	defs.PAGE_MENU_CONSTRUCTION_BASIC,
	defs.PAGE_MENU_CONSTRUCTION_ADVANCED
      },
      PAGE_MENU_CONSTRUCTION_BASIC = {
	defs.TENT_SMALL,
	defs.GOLD_MINE,
	defs.BARRACKS_DIRE,
	defs.WATCH_TOWER,
	defs.WOODEN_WALL,
	defs.PAGE_MAIN
      },
      PAGE_MENU_CONSTRUCTION_ADVANCED = {
	defs.MARKET,
	defs.HEALING_CRYSTAL_DIRE,
	defs.ARMORY_DIRE,
	defs.EMPTY_FILLER,
	defs.EMPTY_FILLER,
	defs.PAGE_MAIN
      }
    },

    -- Unit and building spells
    LONG_WEAPON = defs.LONG_WEAPON,
    IGNITE = defs.IGNITE,

    GEOMANCER_WORKER = defs.GEOMANCER_WORKER,
    GEOMANCER_SPEARMAN = defs.GEOMANCER_SPEARMAN,
    GEOMANCER_FLAME_THROWER = defs.GEOMANCER_FLAME_THROWER,
    GEOMANCER_CATAPULT = defs.GEOMANCER_CATAPULT,

    -- Buildings
    TENT_SMALL = CopyWithNewMain(defs.TENT_SMALL, {
				   defs.GEOMANCER_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    TENT_LARGE = CopyWithNewMain(defs.TENT_LARGE, {
				   defs.GEOMANCER_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    BARRACKS_DIRE = CopyWithNewMain(defs.BARRACKS_DIRE, {
				      defs.GEOMANCER_SPEARMAN,
				      defs.GEOMANCER_FLAME_THROWER,
				      defs.GEOMANCER_CATAPULT
    }),
    ARMORY_DIRE = defs.ARMORY_DIRE,
    HEALING_CRYSTAL_DIRE = defs.HEALING_CRYSTAL_DIRE,
    WATCH_TOWER = defs.WATCH_TOWER,
    WOODEN_WALL = defs.WOODEN_WALL,
    MARKET = defs.MARKET,
    GOLD_MINE = defs.GOLD_MINE
  },
  

  KING_OF_THE_DEAD = {
    heroname = KING_OF_THE_DEAD,
    
    heropages = {
      PAGE_MAIN = {
	defs.HARVEST_LUMBER_HERO,
	defs.TRANSFER_LUMBER,
	defs.PAGE_MENU_CONSTRUCTION_BASIC,
	defs.PAGE_MENU_CONSTRUCTION_ADVANCED
      },
      PAGE_MENU_CONSTRUCTION_BASIC = {
	defs.TENT_SMALL,
	defs.GOLD_MINE,
	defs.BARRACKS_DIRE,
	defs.WATCH_TOWER,
	defs.WOODEN_WALL,
	defs.PAGE_MAIN
      },
      PAGE_MENU_CONSTRUCTION_ADVANCED = {
	defs.MARKET,
	defs.HEALING_CRYSTAL_DIRE,
	defs.ARMORY_DIRE,
	defs.EMPTY_FILLER,
	defs.EMPTY_FILLER,
	defs.PAGE_MAIN
      }
    },

    -- Unit and building spells
    UNDEAD_STRENGTH = defs.UNDEAD_STRENGTH,
    BURNING_ARROWS = defs.BURNING_ARROWS,

    KING_OF_THE_DEAD_WORKER = defs.KING_OF_THE_DEAD_WORKER,
    KING_OF_THE_DEAD_WARRIOR = defs.KING_OF_THE_DEAD_WARRIOR,
    KING_OF_THE_DEAD_ARCHER = defs.KING_OF_THE_DEAD_ARCHER,
    KING_OF_THE_DEAD_CATAPULT = defs.KING_OF_THE_DEAD_CATAPULT,

    -- Buildings
    TENT_SMALL = CopyWithNewMain(defs.TENT_SMALL, {
				   defs.KING_OF_THE_DEAD_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    TENT_LARGE = CopyWithNewMain(defs.TENT_LARGE, {
				   defs.KING_OF_THE_DEAD_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    BARRACKS_DIRE = CopyWithNewMain(defs.BARRACKS_DIRE, {
				      defs.KING_OF_THE_DEAD_WARRIOR,
				      defs.KING_OF_THE_DEAD_ARCHER,
				      defs.KING_OF_THE_DEAD_CATAPULT
    }),
    ARMORY_DIRE = defs.ARMORY_DIRE,
    HEALING_CRYSTAL_DIRE = defs.HEALING_CRYSTAL_DIRE,
    WATCH_TOWER = defs.WATCH_TOWER,
    WOODEN_WALL = defs.WOODEN_WALL,
    MARKET = defs.MARKET,
    GOLD_MINE = defs.GOLD_MINE
  },
  

  WARLORD = {
    heroname = WARLORD,

    heropages = {
      PAGE_MAIN = {
	defs.HARVEST_LUMBER_HERO,
	defs.TRANSFER_LUMBER,
	defs.PAGE_MENU_CONSTRUCTION_BASIC,
	defs.PAGE_MENU_CONSTRUCTION_ADVANCED
      },
      PAGE_MENU_CONSTRUCTION_BASIC = {
	defs.TENT_SMALL,
	defs.GOLD_MINE,
	defs.BARRACKS_DIRE,
	defs.WATCH_TOWER,
	defs.WOODEN_WALL,
	defs.PAGE_MAIN
      },
      PAGE_MENU_CONSTRUCTION_ADVANCED = {
	defs.MARKET,
	defs.HEALING_CRYSTAL_DIRE,
	defs.ARMORY_DIRE,
	defs.EMPTY_FILLER,
	defs.EMPTY_FILLER,
	defs.PAGE_MAIN
      }
    },

    -- Unit and building spells
    HATRED = defs.HATRED,

    WARLORD_WORKER = defs.WARLORD_WORKER,
    WARLORD_FIGHTER = defs.WARLORD_FIGHTER,
    WARLORD_AXE_THROWER = defs.WARLORD_AXE_THROWER,
    WARLORD_CATAPULT = defs.WARLORD_CATAPULT,

    -- Buildings
    TENT_SMALL = CopyWithNewMain(defs.TENT_SMALL, {
				   defs.WARLORD_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    TENT_LARGE = CopyWithNewMain(defs.TENT_LARGE, {
				   defs.WARLORD_WORKER,
				   defs.GLOBAL_SPEED_AURA,
				   defs.DELIVERY_POINT
    }),
    BARRACKS_DIRE = CopyWithNewMain(defs.BARRACKS_DIRE, {
				      defs.WARLORD_FIGHTER,
				      defs.WARLORD_AXE_THROWER,
				      defs.WARLORD_CATAPULT
    }),
    ARMORY_DIRE = defs.ARMORY_DIRE,
    HEALING_CRYSTAL_DIRE = defs.HEALING_CRYSTAL_DIRE,
    WATCH_TOWER = defs.WATCH_TOWER,
    WOODEN_WALL = defs.WOODEN_WALL,
    MARKET = defs.MARKET,
    GOLD_MINE = defs.GOLD_MINE
  }
}



-- Improve the tech table for easier usage.
AddCommonAbilities()

