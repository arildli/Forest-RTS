


if SimpleTechTree == nil then
   SimpleTechTree = {}
   SimpleTechTree.__index = SimpleTechTree
end



function SimpleTechTree:new(o)
   o = o or {}
   setmetatable(o, self)
   SIMPLETECHTREE_REFERENCE = o
   return o
end



print("[SimpleTechTree] Creating Tech Tree Structure...")



--[[ PAGE NUMBERS ]]--
ABILITY_PAGE_MAIN = 1
ABILITY_PAGE_CONSTRUCTION_1 = 21
ABILITY_PAGE_CONSTRUCTION_2 = 22

--[[ HERO NAMES ]]--
COMMANDER = "npc_dota_hero_legion_commander"
FURION = "npc_dota_hero_furion"
GEOMANCER = "npc_dota_hero_meepo"
KING_OF_THE_DEAD = "npc_dota_hero_skeleton_king"
WARLORD = "npc_dota_hero_troll_warlord"



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


--[[ SPELLS ]]--

-- Common



UNREACHABLE = {}
UNREACHABLE["name"] = "none"
UNREACHABLE["spell"] = ""
UNREACHABLE["req"] = {EMPTY_FILLER}
UNREACHABLE["category"] = "spell"
SPELLS[UNREACHABLE["spell"]] = UNREACHABLE

EMPTY_FILLER = {}
EMPTY_FILLER["name"] = "none"
EMPTY_FILLER["spell"] = "srts_empty_filler"
EMPTY_FILLER["req"] = {UNREACHABLE}
EMPTY_FILLER["category"] = "spell"
SPELLS[EMPTY_FILLER["spell"]] = EMPTY_FILLER

PAGE_MAIN = {}
PAGE_MAIN["name"] = "none"
PAGE_MAIN["spell"] = "srts_menu_main"
PAGE_MAIN["req"] = {}
PAGE_MAIN["category"] = "spell"
SPELLS[PAGE_MAIN["spell"]] = PAGE_MAIN

HARVEST_LUMBER = {}
HARVEST_LUMBER["name"] = "none"
HARVEST_LUMBER["spell"] = "srts_harvest_lumber"
HARVEST_LUMBER["req"] = {}
HARVEST_LUMBER["category"] = "spell"
SPELLS[HARVEST_LUMBER["spell"]] = HARVEST_LUMBER

TRANSFER_LUMBER = {}
TRANSFER_LUMBER["name"] = "none"
TRANSFER_LUMBER["spell"] = "srts_transfer_lumber"
TRANSFER_LUMBER["req"] = {}
TRANSFER_LUMBER["category"] = "spell"
SPELLS[TRANSFER_LUMBER["spell"]] = TRANSFER_LUMBER

HARVEST_LUMBER_WORKER = {}
HARVEST_LUMBER_WORKER["name"] = "none"
HARVEST_LUMBER_WORKER["spell"] = "srts_harvest_lumber_worker"
HARVEST_LUMBER_WORKER["req"] = {}
HARVEST_LUMBER_WORKER["category"] = "spell"
SPELLS[HARVEST_LUMBER_WORKER["spell"]] = HARVEST_LUMBER_WORKER

PAGE_MENU_CONSTRUCTION_1 = {}
PAGE_MENU_CONSTRUCTION_1["name"] = "none"
PAGE_MENU_CONSTRUCTION_1["spell"] = "srts_menu_construction_1"
PAGE_MENU_CONSTRUCTION_1["req"] = {}
PAGE_MENU_CONSTRUCTION_1["category"] = "spell"
SPELLS[PAGE_MENU_CONSTRUCTION_1["spell"]] = PAGE_MENU_CONSTRUCTION_1

PAGE_MENU_CONSTRUCTION_2 = {}
PAGE_MENU_CONSTRUCTION_2["name"] = "none"
PAGE_MENU_CONSTRUCTION_2["spell"] = "srts_menu_construction_2"
PAGE_MENU_CONSTRUCTION_2["req"] = {}
PAGE_MENU_CONSTRUCTION_2["category"] = "spell"
SPELLS[PAGE_MENU_CONSTRUCTION_2["spell"]] = PAGE_MENU_CONSTRUCTION_2



-- Buildings



-- Common

MAIN_BUILDING = {}
MAIN_BUILDING["name"] = "npc_dota_building_main_tent_small"
MAIN_BUILDING["spell"] = "srts_construct_main_building"
MAIN_BUILDING["req"] = {}
MAIN_BUILDING["maximum"] = 1
MAIN_BUILDING["category"] = "building"
MAX_COUNT[MAIN_BUILDING["name"]] = MAIN_BUILDING["maximum"]
SPELLS[MAIN_BUILDING["spell"]] = MAIN_BUILDING

WATCH_TOWER = {}
WATCH_TOWER["name"] = "npc_dota_building_watch_tower"
WATCH_TOWER["spell"] = "srts_construct_watch_tower"
WATCH_TOWER["req"] = {MAIN_BUILDING}
WATCH_TOWER["category"] = "building"
SPELLS[WATCH_TOWER["spell"]] = WATCH_TOWER

WOODEN_WALL = {}
WOODEN_WALL["name"] = "npc_dota_building_wooden_wall"
WOODEN_WALL["spell"] = "srts_construct_wooden_wall"
WOODEN_WALL["req"] = {MAIN_BUILDING}
WOODEN_WALL["category"] = "building"
SPELLS[WOODEN_WALL["spell"]] = WOODEN_WALL

MARKET = {}
MARKET["name"] = "npc_dota_building_market"
MARKET["spell"] = "srts_construct_market"
MARKET["req"] = {MAIN_BUILDING}
MARKET["category"] = "building"
SPELLS[MARKET["spell"]] = MARKET

GOLD_MINE = {}
GOLD_MINE["name"] = "npc_dota_building_gold_mine"
GOLD_MINE["spell"] = "srts_construct_gold_mine"
GOLD_MINE["req"] = {MAIN_BUILDING}
GOLD_MINE["maximum"] = 1
GOLD_MINE["category"] = "building"
MAX_COUNT[GOLD_MINE["name"]] = GOLD_MINE["maximum"]
SPELLS[GOLD_MINE["spell"]] = GOLD_MINE

-- Radiant
BARRACKS_RADIANT = {}
BARRACKS_RADIANT["name"] = "npc_dota_building_barracks_radiant"
BARRACKS_RADIANT["spell"] = "srts_construct_barracks_radiant"
BARRACKS_RADIANT["req"] = {MAIN_BUILDING}
BARRACKS_RADIANT["category"] = "building"
SPELLS[BARRACKS_RADIANT["spell"]] = BARRACKS_RADIANT

HEALING_CRYSTAL_RADIANT = {}
HEALING_CRYSTAL_RADIANT["name"] = "npc_dota_building_crystal_radiant"
HEALING_CRYSTAL_RADIANT["spell"] = "srts_construct_crystal_radiant"
HEALING_CRYSTAL_RADIANT["req"] = {MAIN_BUILDING, BARRACKS_RADIANT}
HEALING_CRYSTAL_RADIANT["category"] = "building"
SPELLS[HEALING_CRYSTAL_RADIANT["spell"]] = HEALING_CRYSTAL_RADIANT

ARMORY_RADIANT = {}
ARMORY_RADIANT["name"] = "npc_dota_building_armory"
ARMORY_RADIANT["spell"] = "srts_construct_armory_radiant"
ARMORY_RADIANT["req"] = {MAIN_BUILDING, BARRACKS_RADIANT}
ARMORY_RADIANT["category"] = "building"
SPELLS[ARMORY_RADIANT["spell"]] = ARMORY_RADIANT

-- Dire
BARRACKS_DIRE = {}
BARRACKS_DIRE["name"] = "npc_dota_building_barracks_dire"
BARRACKS_DIRE["spell"] = "srts_construct_barracks_dire"
BARRACKS_DIRE["req"] = {MAIN_BUILDING}
BARRACKS_DIRE["category"] = "building"
SPELLS[BARRACKS_DIRE["spell"]] = BARRACKS_DIRE

HEALING_CRYSTAL_DIRE = {}
HEALING_CRYSTAL_DIRE["name"] = "npc_dota_building_crystal_dire"
HEALING_CRYSTAL_DIRE["spell"] = "srts_construct_crystal_dire"
HEALING_CRYSTAL_DIRE["req"] = {MAIN_BUILDING, BARRACKS_DIRE}
HEALING_CRYSTAL_DIRE["category"] = "building"
SPELLS[HEALING_CRYSTAL_DIRE["spell"]] = HEALING_CRYSTAL_DIRE

ARMORY_DIRE = {}
ARMORY_DIRE["name"] = "npc_dota_building_armory"
ARMORY_DIRE["spell"] = "srts_construct_armory_dire"
ARMORY_DIRE["req"] = {MAIN_BUILDING, BARRACKS_DIRE}
ARMORY_DIRE["category"] = "building"
SPELLS[ARMORY_DIRE["spell"]] = ARMORY_DIRE





--[[ TRAINING SPELLS ]]--



-- Common

COMMON_BUILDING = {
   name = "none",
   spell = "srts_ability_building",
   req = {},
   category = "spell"
}

COMMON_DELIVERY_POINT = {
   name = "none",
   spell = "srts_ability_delivery_point",
   req = {},
   category = "spell"
}

COMMON_UNIT = {
   name = "none",
   spell = "srts_ability_unit",
   req = {},
   category = "spell"
}

COMMON_TRAIN_WORKER = {
   name = "npc_dota_creature_worker",
   spell = "srts_train_worker",
   req = {},
   maximum = MAX_WORKER_COUNT,
   category = "unit"
}
MAX_COUNT[COMMON_TRAIN_WORKER["name"]] = COMMON_TRAIN_WORKER["maximum"]

COMMON_GLOBAL_SPEED_AURA = {
   name = "none",
   spell = "srts_global_speed_aura",
   req = {},
   category = "spell"
}

COMMON_CRYSTAL_AURA = {
   name = "none",
   spell = "srts_crystal_aura",
   req = {},
   category = "spell"
}

COMMON_SELL_LUMBER_SMALL = {
   name = "none",
   spell = "srts_sell_lumber_small",
   req = {},
   category = "spell"
}

COMMON_REPAIR_BUILDING = {
   name = "none",
   spell = "srts_repair_building",
   req = {},
   category = "spell"
}

COMMON_PERIODIC_MINE_GOLD = {
   name = "none",
   spell = "srts_periodic_mine_gold",
   req = {},
   category = "spell"
}

COMMON_ENTER_TOWER = {
   name = "none",
   spell = "srts_enter_tower",
   req = {},
   category = "spell"
}



SPELLS[COMMON_BUILDING["spell"]] = COMMON_BUILDING
SPELLS[COMMON_UNIT["spell"]] = COMMON_UNIT
SPELLS[COMMON_TRAIN_WORKER["spell"]] = COMMON_TRAIN_WORKER
SPELLS[COMMON_GLOBAL_SPEED_AURA["spell"]] = COMMON_GLOBAL_SPEED_AURA
SPELLS[COMMON_CRYSTAL_AURA["spell"]] = COMMON_CRYSTAL_AURA
SPELLS[COMMON_SELL_LUMBER_SMALL["spell"]] = COMMON_SELL_LUMBER_SMALL
SPELLS[COMMON_REPAIR_BUILDING["spell"]] = COMMON_REPAIR_BUILDING
SPELLS[COMMON_PERIODIC_MINE_GOLD["spell"]] = COMMON_PERIODIC_MINE_GOLD
SPELLS[COMMON_ENTER_TOWER["spell"]] = COMMON_ENTER_TOWER

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

WARLORD_TRAINING_SPELLS =
   {COMMON_BUILDING,
    COMMON_UNIT,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_CRYSTAL_AURA,
    COMMON_SELL_LUMBER_SMALL,
    COMMON_REPAIR_BUILDING,
    COMMON_PERIODIC_MINE_GOLD,
    COMMON_ENTER_TOWER,
    WARLORD_WORKER,
    WARLORD_FIGHTER,
    WARLORD_AXE_THROWER,
    WARLORD_CATAPULT}

SPELLS[WARLORD_WORKER["spell"]] = WARLORD_WORKER
SPELLS[WARLORD_FIGHTER["spell"]] = WARLORD_FIGHTER
SPELLS[WARLORD_AXE_THROWER["spell"]] = WARLORD_AXE_THROWER
SPELLS[WARLORD_CATAPULT["spell"]] = WARLORD_CATAPULT





--[[ BUILDING SPELLS ]]--

-- Radiant

-- Commander
HERO_SPELLS_FOR_BUILDINGS[COMMANDER][MAIN_BUILDING["name"]] =
   {COMMANDER_WORKER,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][BARRACKS_RADIANT["name"]] =
   {COMMANDER_FOOTMAN,
    COMMANDER_GUNNER,
    COMMANDER_CATAPULT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][WATCH_TOWER["name"]] =
   {COMMON_ENTER_TOWER,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][WOODEN_WALL["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][HEALING_CRYSTAL_RADIANT["name"]] =
   {COMMON_CRYSTAL_AURA,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][MARKET["name"]] =
   {COMMON_SELL_LUMBER_SMALL,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][ARMORY_RADIANT["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[COMMANDER][GOLD_MINE["name"]] =
   {COMMON_PERIODIC_MINE_GOLD,
    COMMON_BUILDING}



-- Furion
HERO_SPELLS_FOR_BUILDINGS[FURION][MAIN_BUILDING["name"]] =
   {FURION_WORKER,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][BARRACKS_RADIANT["name"]] =
   {FURION_WARRIOR,
    FURION_DRYAD,
    FURION_CATAPULT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][WATCH_TOWER["name"]] =
   {COMMON_ENTER_TOWER,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][WOODEN_WALL["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][HEALING_CRYSTAL_RADIANT["name"]] =
   {COMMON_CRYSTAL_AURA,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][MARKET["name"]] =
   {COMMON_SELL_LUMBER_SMALL,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][ARMORY_RADIANT["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[FURION][GOLD_MINE["name"]] =
   {COMMON_PERIODIC_MINE_GOLD,
    COMMON_BUILDING}



-- Dire

-- Geomancer
HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][MAIN_BUILDING["name"]] =
   {GEOMANCER_WORKER,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][BARRACKS_DIRE["name"]] =
   {GEOMANCER_SPEARMAN,
    GEOMANCER_FLAME_THROWER,
    GEOMANCER_CATAPULT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][WATCH_TOWER["name"]] =
   {COMMON_ENTER_TOWER,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][WOODEN_WALL["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][HEALING_CRYSTAL_DIRE["name"]] =
   {COMMON_CRYSTAL_AURA,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][MARKET["name"]] =
   {COMMON_SELL_LUMBER_SMALL,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][ARMORY_DIRE["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[GEOMANCER][GOLD_MINE["name"]] =
   {COMMON_PERIODIC_MINE_GOLD,
    COMMON_BUILDING}



-- King of the Dead
HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][MAIN_BUILDING["name"]] =
   {KING_OF_THE_DEAD_WORKER,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][BARRACKS_DIRE["name"]] =
   {KING_OF_THE_DEAD_WARRIOR,
    KING_OF_THE_DEAD_ARCHER,
    KING_OF_THE_DEAD_CATAPULT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][WATCH_TOWER["name"]] =
   {COMMON_ENTER_TOWER,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][WOODEN_WALL["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][HEALING_CRYSTAL_DIRE["name"]] =
   {COMMON_CRYSTAL_AURA,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][MARKET["name"]] =
   {COMMON_SELL_LUMBER_SMALL,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][ARMORY_DIRE["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[KING_OF_THE_DEAD][GOLD_MINE["name"]] =
   {COMMON_PERIODIC_MINE_GOLD,
    COMMON_BUILDING}




-- Warlord
HERO_SPELLS_FOR_BUILDINGS[WARLORD][MAIN_BUILDING["name"]] =
   {WARLORD_WORKER,
    COMMON_GLOBAL_SPEED_AURA,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][BARRACKS_DIRE["name"]] =
   {WARLORD_FIGHTER,
    WARLORD_AXE_THROWER,
    WARLORD_CATAPULT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][WATCH_TOWER["name"]] =
   {COMMON_ENTER_TOWER,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][WOODEN_WALL["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][HEALING_CRYSTAL_DIRE["name"]] =
   {COMMON_CRYSTAL_AURA,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][MARKET["name"]] =
   {COMMON_SELL_LUMBER_SMALL,
    COMMON_DELIVERY_POINT,
    COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][ARMORY_DIRE["name"]] =
   {COMMON_BUILDING}

HERO_SPELLS_FOR_BUILDINGS[WARLORD][GOLD_MINE["name"]] =
   {COMMON_PERIODIC_MINE_GOLD,
    COMMON_BUILDING}





--[[ ABILITY PAGES ]]--

COMMON_PAGE_MAIN =
   {HARVEST_LUMBER,
    TRANSFER_LUMBER,
    PAGE_MENU_CONSTRUCTION_1,
    PAGE_MENU_CONSTRUCTION_2}

-- Radiant

-- Commander
COMMANDER_BUILDING_SPELLS =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_RADIANT,
    WATCH_TOWER,
    WOODEN_WALL,
    HEALING_CRYSTAL_RADIANT,
    MARKET,
    ARMORY_RADIANT}

COMMANDER_PAGE_CONSTRUCTION_1 =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_RADIANT,
    WATCH_TOWER,
    WOODEN_WALL,
    PAGE_MAIN}

COMMANDER_PAGE_CONSTRUCTION_2 =
   {MARKET,
    HEALING_CRYSTAL_RADIANT,
    ARMORY_RADIANT,
    EMPTY_FILLER,
    EMPTY_FILLER,
    PAGE_MAIN}

-- Furion
FURION_BUILDING_SPELLS =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_RADIANT,
    WATCH_TOWER,
    WOODEN_WALL,
    HEALING_CRYSTAL_RADIANT,
    MARKET,
    ARMORY_RADIANT}

FURION_PAGE_CONSTRUCTION_1 =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_RADIANT,
    WATCH_TOWER,
    WOODEN_WALL,
    PAGE_MAIN}

FURION_PAGE_CONSTRUCTION_2 =
   {MARKET,
    HEALING_CRYSTAL_RADIANT,
    ARMORY_RADIANT,
    EMPTY_FILLER,
    EMPTY_FILLER,
    PAGE_MAIN}

-- Dire

-- Geomancer
GEOMANCER_BUILDING_SPELLS =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    HEALING_CRYSTAL_DIRE,
    MARKET,
    ARMORY_DIRE}

GEOMANCER_PAGE_CONSTRUCTION_1 =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    PAGE_MAIN}

GEOMANCER_PAGE_CONSTRUCTION_2 =
   {MARKET,
    HEALING_CRYSTAL_DIRE,
    ARMORY_DIRE,
    EMPTY_FILLER,
    EMPTY_FILLER,
    PAGE_MAIN}

-- King of the Dead
KING_OF_THE_DEAD_BUILDING_SPELLS =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    HEALING_CRYSTAL_DIRE,
    MARKET,
    ARMORY_DIRE}

KING_OF_THE_DEAD_PAGE_CONSTRUCTION_1 =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    PAGE_MAIN}

KING_OF_THE_DEAD_PAGE_CONSTRUCTION_2 =
   {MARKET,
    HEALING_CRYSTAL_DIRE,
    ARMORY_DIRE,
    EMPTY_FILLER,
    EMPTY_FILLER,
    PAGE_MAIN}

-- Warlord
WARLORD_BUILDING_SPELLS =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    HEALING_CRYSTAL_DIRE,
    MARKET,
    ARMORY_DIRE}

WARLORD_PAGE_CONSTRUCTION_1 =
   {MAIN_BUILDING,
    GOLD_MINE,
    BARRACKS_DIRE,
    WATCH_TOWER,
    WOODEN_WALL,
    PAGE_MAIN}

WARLORD_PAGE_CONSTRUCTION_2 =
   {MARKET,
    HEALING_CRYSTAL_DIRE,
    ARMORY_DIRE,
    EMPTY_FILLER,
    EMPTY_FILLER,
    PAGE_MAIN}



--[[ FILL 'ABILITY_PAGES' ]]--

-- Setup ABILITY_PAGE_MAIN.
ABILITY_PAGES[COMMANDER][ABILITY_PAGE_MAIN] = COMMON_PAGE_MAIN
ABILITY_PAGES[FURION][ABILITY_PAGE_MAIN] = COMMON_PAGE_MAIN
ABILITY_PAGES[GEOMANCER][ABILITY_PAGE_MAIN] = COMMON_PAGE_MAIN
ABILITY_PAGES[KING_OF_THE_DEAD][ABILITY_PAGE_MAIN] = COMMON_PAGE_MAIN
ABILITY_PAGES[WARLORD][ABILITY_PAGE_MAIN] = COMMON_PAGE_MAIN

-- Setup ABILITY_PAGE_CONSTRUCTION_1
ABILITY_PAGES[COMMANDER][ABILITY_PAGE_CONSTRUCTION_1] = COMMANDER_PAGE_CONSTRUCTION_1
ABILITY_PAGES[FURION][ABILITY_PAGE_CONSTRUCTION_1] = FURION_PAGE_CONSTRUCTION_1
ABILITY_PAGES[GEOMANCER][ABILITY_PAGE_CONSTRUCTION_1] = GEOMANCER_PAGE_CONSTRUCTION_1
ABILITY_PAGES[KING_OF_THE_DEAD][ABILITY_PAGE_CONSTRUCTION_1] = KING_OF_THE_DEAD_PAGE_CONSTRUCTION_1
ABILITY_PAGES[WARLORD][ABILITY_PAGE_CONSTRUCTION_1] = WARLORD_PAGE_CONSTRUCTION_1

-- Setup ABILITY_PAGE_CONSTRUCTION_2
ABILITY_PAGES[COMMANDER][ABILITY_PAGE_CONSTRUCTION_2] = COMMANDER_PAGE_CONSTRUCTION_2
ABILITY_PAGES[FURION][ABILITY_PAGE_CONSTRUCTION_2] = FURION_PAGE_CONSTRUCTION_2
ABILITY_PAGES[GEOMANCER][ABILITY_PAGE_CONSTRUCTION_2] = GEOMANCER_PAGE_CONSTRUCTION_2
ABILITY_PAGES[KING_OF_THE_DEAD][ABILITY_PAGE_CONSTRUCTION_2] = KING_OF_THE_DEAD_PAGE_CONSTRUCTION_2
ABILITY_PAGES[WARLORD][ABILITY_PAGE_CONSTRUCTION_2] = WARLORD_PAGE_CONSTRUCTION_2



--[[ FILL HERO_TRAINING_SPELLS ]]--
HERO_TRAINING_SPELLS[COMMANDER] = COMMANDER_TRAINING_SPELLS
HERO_TRAINING_SPELLS[FURION] = FURION_TRAINING_SPELLS
HERO_TRAINING_SPELLS[GEOMANCER] = GEOMANCER_TRAINING_SPELLS
HERO_TRAINING_SPELLS[KING_OF_THE_DEAD] = KING_OF_THE_DEAD_TRAINING_SPELLS
HERO_TRAINING_SPELLS[WARLORD] = WARLORD_TRAINING_SPELLS



print("[SimpleTechTree] Done!")



---------------------------------------------------------------------------
-- Init the tech tree for the hero.
--
--	* hero: The unit to init the tech tree for.
--
---------------------------------------------------------------------------
function SimpleTechTree:InitTechTree(hero)

   if not hero then
      print_simple_tech_tree("SimpleTechTree:InitTechTree", "hero was nil!")
      return
   end
   if SimpleTechTree:IsHero(hero) == false then
      print_simple_tech_tree("SimpleTechTree:InitTechTree", "hero was not a hero! ("..hero:GetUnitName()..")!")
      return false
   end

   -- Init tables for unit.
   hero.STT = {}
   hero.STT.unitCount = {}
   hero.STT.buildings = {}
   hero.STT.units = {}



   --					-----| UnitCount table |-----



   ---------------------------------------------------------------------------
   -- Returns hero.STT.unitCount.
   ---------------------------------------------------------------------------
   function hero:GetUnitCount()

      return hero.STT.unitCount or 0
   end

   ---------------------------------------------------------------------------
   -- Returns hero.STT.unitCount[name].
   ---------------------------------------------------------------------------
   function hero:GetUnitCountFor(name)

      if name then
	 return hero.STT.unitCount[name] or 0
      else
	 print("hero:GetUnitCountFor: name was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Sets hero.STT.unitCount[name] = value.
   ---------------------------------------------------------------------------
   function hero:SetUnitCountFor(name, value)

      print("\t\tname: "..name)
      if name and value then
	 hero.STT.unitCount[name] = value
      else
	 print("hero:SetUnitCountFor: name and/or value was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Sets hero.STT.unitCount[name] += 1.
   ---------------------------------------------------------------------------
   function hero:IncUnitCountFor(name)

      if name then
	 if not hero.STT.unitCount[name] then
	    hero.STT.unitCount[name] = 0
	 end
	 hero.STT.unitCount[name] = hero.STT.unitCount[name] + 1
	 return hero.STT.unitCount[name]
      else
	 print("hero:IncUnitCountFor: name was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Sets hero.STT.unitCount[name] -= 1.
   ---------------------------------------------------------------------------
   function hero:DecUnitCountFor(name)

      if name then
	 if not hero.STT.unitCount[name] then
	    hero.STT.unitCount[name] = 0
	 end
	 hero.STT.unitCount[name] = hero.STT.unitCount[name] - 1
	 return hero.STT.unitCount[name]
      else
	 print("hero:DecUnitCountFor: name was nil!")
      end
   end



   --					-----| Buildings and Units tables |-----



   ---------------------------------------------------------------------------
   -- Returns hero.STT.buildings.
   ---------------------------------------------------------------------------
   function hero:GetBuildings()

      return hero.STT.buildings
   end

   ---------------------------------------------------------------------------
   -- Returns hero.STT.units.
   ---------------------------------------------------------------------------
   function hero:GetUnits()

      return hero.STT.units
   end

   ---------------------------------------------------------------------------
   -- Adds the building to hero.STT.buildings.
   ---------------------------------------------------------------------------
   function hero:AddBuilding(building)

      if building then
	 table.insert(hero.STT.buildings, building)
      else
	 print("hero:AddBuilding: building was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Adds the unit to hero.STT.units.
   ---------------------------------------------------------------------------
   function hero:AddUnit(unit)

      if unit then
	 table.insert(hero.STT.units, unit)
      else
	 print("hero:AddUnit: unit was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Removes hero.STT.buildings[index].
   ---------------------------------------------------------------------------
   function hero:RemoveBuildingByIndex(index)

      if index then
	 table.remove(hero.STT.buildings, index)
      else
	 print("hero:RemoveBuildingByIndex: index was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Removes hero.STT.units[index].
   ---------------------------------------------------------------------------
   function hero:RemoveUnitByIndex(index)

      if index then
	 table.remove(hero.STT.units, index)
      else
	 print("Hero:RemoveUnitByIndex: index was nil!")
      end
   end

   ---------------------------------------------------------------------------
   -- Removes the reference to the specified building from .buildings.
   ---------------------------------------------------------------------------
   function hero:RemoveBuilding(building)

      if not building then
	 print("Hero:RemoveBuilding: building was nil!")
	 return false
      end

      local index = -1
      for k,v in pairs(hero:GetBuildings()) do
	 if v == building then
	    index = k
	    break
	 end
      end
      if index ~= -1 then
	 hero:RemoveBuildingByIndex(index)
	 return true
      end
      return false
   end

   ---------------------------------------------------------------------------
   -- Removes the reference to the specified unit from .units.
   ---------------------------------------------------------------------------
   function hero:RemoveUnit(unit)

      if not unit then
	 print("Hero:RemoveUnit: unit was nil!")
	 return false
      end

      local index = -1
      for k,v in pairs(hero:GetUnits()) do
	 if v == unit then
	    index = k
	    break
	 end
      end
      if index ~= -1 then
	 hero:RemoveUnitByIndex(index)
	 return true
      end
      return false
   end

   ---------------------------------------------------------------------------
   -- Prints the count of units and buildings for the owner of that unit.
   ---------------------------------------------------------------------------
   function hero:PrintUnitCount()

      local player = unit:GetOwner()
      local playerID = player:GetPlayerID()
      local playerHero = GetPlayerHero(playerID)

      if DEBUG_SIMPLE_TECH_TREE then

	 print("\n------------------")
	 print("Printing unit count for "..playerID..":")
	 print("------------------")
	 for index,count in pairs(playerHero.STT._unitCount) do
	    if index ~= "none" then
	       print(index..": "..count)
	    end
	 end
	 print("------------------")
      end
   end

   local heroName = hero:GetUnitName()

   SimpleTechTree:RemoveDescriptionSpells(hero)

   -- Set ability pages for the unit.
   InitAbilityPage(hero, ABILITY_PAGE_MAIN, ABILITY_PAGES[heroName][ABILITY_PAGE_MAIN])
   InitAbilityPage(hero, ABILITY_PAGE_CONSTRUCTION_1, ABILITY_PAGES[heroName][ABILITY_PAGE_CONSTRUCTION_1])
   InitAbilityPage(hero, ABILITY_PAGE_CONSTRUCTION_2, ABILITY_PAGES[heroName][ABILITY_PAGE_CONSTRUCTION_2])

   -- Set training spells for the unit.
   hero._trainingSpells = HERO_TRAINING_SPELLS[heroName]

   -- Copy all spells into unit._spells.
   SimpleTechTree:MergeSpells(hero)
   SimpleTechTree:PrintAbilityLevels(hero:GetOwner())

   -- Update tech tree.
   SimpleTechTree:UpdateTechTree(hero, nil, "init")

   -- Set current page to the main one.
   GoToPage(hero, ABILITY_PAGE_MAIN)
end



---------------------------------------------------------------------------
-- Removes all the description spells of the hero.
--
--	* hero: The hero to work with.
--
---------------------------------------------------------------------------
function SimpleTechTree:RemoveDescriptionSpells(hero)
   for i=0,6 do
      local curAbility = hero:GetAbilityByIndex(i)
      if curAbility then
	 local curAbilityName = curAbility:GetAbilityName()
	 hero:RemoveAbility(curAbilityName)
      end
   end
end



---------------------------------------------------------------------------
-- Adds the abilities of a building, setting them to level 0.
--
--	* building: The building to work with.
--
---------------------------------------------------------------------------
function SimpleTechTree:AddAbilitiesToBuilding(building)

   if not building then
      print("SimpleTechTree:AddAbilitiesToBuilding\tbuilding was nil!")
      return
   end

   local owner = building:GetOwner()
   local playerID = owner:GetPlayerID()
   local playerHero = GetPlayerHero(playerID)
   local heroName = playerHero:GetUnitName()
   local buildingName = building:GetUnitName()
   local abilities = HERO_SPELLS_FOR_BUILDINGS[heroName][buildingName]
   if not abilities then
      print("SimpleTechTree:AddAbilitiesToBuilding\tabilities was nil!")
      return
   end

   -- Adds all the abilities for the building with level 0.
   for i=1, 6 do

      local curNewAbility = abilities[i]
      if curNewAbility then

	 local curNewAbilityName = curNewAbility["spell"]
	 building:AddAbility(curNewAbilityName)
	 if building:HasAbility(curNewAbilityName) then
	    local curAbilityToLevel = building:FindAbilityByName(curNewAbilityName)
	    curAbilityToLevel:SetLevel(0)
	 else
	    print("AddAbilitiesToBuilding: Building did not keep "..curNewAbilityName.."!")
	 end
      end
   end
end



---------------------------------------------------------------------------
-- Updates the tech tree if necessary. action is true if construction,
-- false if destruction.
--
--	* hero: The hero of the player that owns the building.
--	* building: The building that triggered the call of this function.
--	* action: Specifies whether the call was called by a construction
--		or destruction of a building or unit, or even just an init.
--
---------------------------------------------------------------------------
function SimpleTechTree:UpdateTechTree(hero, building, action)

   if hero and SimpleTechTree:IsHero(hero) == false then
      print("SimpleTechTree:UpdateTechTree: unit was not a hero!")
      return false
   end
   if not building and action == "init" then
      print("\nSimpleTechTree:UpdateTechTree: Initing tech tree...")
   elseif not building then
      print("\nSimpleTechTree:UpdateTechTree: building was nil!")
      return false
   elseif action == nil then
      print("\nSimpleTechTree:UpdateTechTree: action was nil!")
      return false
   end

   local player = hero:GetOwner()
   if not player then
      print("SimpleTechTree:UpdateTechTree: Couldn't get owner of building!")
      return false
   end
   local playerID = player:GetPlayerID()

   -- Try to get hero if that parameter was nil.
   if not hero then
      print("SimpleTechTree:UpdateTechTree: hero was nil!")
      hero = GetPlayerHero(ownerID)
      if not hero then
	 print("SimpleTechTree:UpdateTechTree: Couldn't get hero for building!")
	 return false
      end
   end

   print("[SimpleTechTree] Updating tech tree for player with ID "..playerID.."!")

   local heroName = hero:GetUnitName()
   local buildingName
   if building then
      building = building:GetUnitName()
   end
   if not hero.STT then
      print("ERROR: hero did have have hero.STT! This most likely means SimpleTechTree:InitTechTree(hero) hasn't been called yet!")
      return false
   end
   local needsUpdate = true

   -- Check through all the spells.
   for i,curSpell in pairs(hero._spells) do
      local curSpellName = curSpell["spell"]					-- Name of the current spell.
      local curUnitName = curSpell["name"] or "none"			-- Name of the unit or building produced.
      local curUnitCount = "-"								-- Count of the unit or building produced.
      local curUnitMax = curSpell["maximum"]						-- Max count of the unit or building produced.

      -- Count the number of units or buildings of this type if training or construction spell.
      if curUnitName and curUnitName ~= "none" then
	 curUnitCount = hero:GetUnitCountFor(curUnitName)
	 if not curUnitCount then
	    hero:SetUnitCountFor(curUnitName, 0)
	    curUnitCount = 0
	 end
      end

      -- Check if all reqs for the spell are met.
      local unlock = true
      if curUnitMax and curUnitCount >= curUnitMax then
	 unlock = false
      else
	 for _,curReq in ipairs(curSpell["req"]) do
	    unlock = true
	    -- Old way of checking current requirement.
	    if type(curReq) == "table" and curReq["category"] then
	       local curReqName = curReq["name"]
	       local curReqCount = hero:GetUnitCountFor(curReqName)
	       if not curReqCount or curReqCount <= 0 then
		  unlock = false
		  break
	       end
	    else   -- New way! Looking at ..., curReq, ... or ..., {curOption1, curOption2}, ...
	       -- Insert the current req or table with choosable reqs into a new one.
	       local curReqTable = {}
	       if type(curReq) == "table" then   -- One among several options must be met.
		  for _,curReqName in ipairs(curReq) do
		     table.insert(curReqTable, curReqName)
		  end
	       else
		  table.insert(curReqTable, curReqName)
	       end

	       -- Check if one of the options for the current req has not been met.
	       local oneOptionMet = false
	       for _,curReqName in ipairs(curReqTable) do
		  local curReqCount = hero:GetUnitCountFor(curReqName)
		  if curReqCount and curReqCount > 0 then
		     oneOptionMet = true
		     break
		  end
	       end

	       -- Stop if neither of the options for the current req has been met.
	       if not oneOptionMet then
		  unlock = false
		  break
	       end
	    end
	 end
      end

      -- Set spell level.
      if not buildingName or not buildingName ~= MAIN_BUILDING["name"] then

	 if unlock == true then
	    hero._abilityLevels[curSpellName] = 1
	 elseif unlock == false then
	    hero._abilityLevels[curSpellName] = 0
	 else
	    print("SimpleTechTree:UpdateTechTree: unlock was neither true nor false!-----------------")
	 end
      end

      --local curSpellLevel = hero._abilityLevels[curSpellName]
      --print_simple_tech_tree("UpdateTechTree", "Count: "..curUnitCount.." \tLevel: "..curSpellLevel.."\tSpell: "..curSpellName.."\t\tName: "..curUnitName)
   end

   SimpleTechTree:UpdateSpells(hero)

   -- Print building count.
   local player = hero:GetOwner()
   SimpleTechTree:PrintAbilityLevels(player)

   print_simple_tech_tree("UpdateTechTree", "\n\tTech tree update done!")
end





--					-----| On Creation and Death |-----





---------------------------------------------------------------------------
-- Adds useful methods to the newly training unit or 
-- constructed building.
--- * entity: The entity to add methods to.
---------------------------------------------------------------------------
function SimpleTechTree:AddPlayerMethods(entity, owner)
   local ownerID = owner:GetPlayerID()
   local ownerHero = GetPlayerHero(ownerID)

   entity._ownerPlayer = owner
   entity._ownerPlayerID = ownerID
   entity._ownerHero = ownerHero
      
   -- Get the player object of the owner.
   function entity:GetOwnerPlayer()
      return entity._ownerPlayer or entity:GetOwner()
   end
   
   -- Get the player id of the owner.
   function entity:GetOwnerID()
      return entity._ownerPlayerID or entity:GetOwner():GetPlayerID()
   end
   
   -- Get the hero of the owner.
   function entity:GetOwnerHero()
      return entity._ownerHero or GetPlayerHero(entity:GetOwner():GetPlayerID())
   end
end



---------------------------------------------------------------------------
-- Makes sure to unlearn the construction spell of a building if the max
-- has been met at construction start.
--
--	* unit: The unit whose construction just started.
--	* spellname: Name of the spell used to create the building.
--
---------------------------------------------------------------------------
function SimpleTechTree:RegisterConstruction(unit, spellname)

   if not unit then
      print("SimpleTechTree:RegisterConstruction: unit was nil!")
      return
   end
   if IsBuilding(unit) == false then
      print("SimpleTechTree:RegisterConstruction: unit was not a building!")
      return
   end

   unit._finished = false
   local owner = unit:GetOwner()
   local unitName = unit:GetUnitName()
   local newUnitCount = owner:GetUnitCountFor(unitName) + 1
   local maxUnitCount = SimpleTechTree:GetMaxCountFor(unitName)
   if maxUnitCount and newUnitCount >= maxUnitCount then

      local ability = UnitHasAbility(owner, spellname)
      if ability then
	 ability:SetLevel(0)
      end
   end
end



---------------------------------------------------------------------------
-- Add or removes a unit from the tables upon construction/training or
-- destruction/termination.
--
--	* unit: The unit that was either constructed/trained or killed/destroyed.
--	* state: Should be true if construction/training, false if killed/destroyed.
--
---------------------------------------------------------------------------
function SimpleTechTree:RegisterIncident(unit, state)

   if not unit then
      print("SimpleTechTree:RegisterIncident: unit was nil!")
      return
   end
   if state == nil then		-- Don't want this to trigger if state is false
      print("SimpleTechTree:RegisterIncident: state was nil!")
      return
   end

   local isBuilding = IsBuilding(unit)
   local unitName = unit:GetUnitName()
   local owner = unit:GetOwner() or unit._owner
   if not owner then
      print("SimpleTechTree:RegisterIncident: Couldn't get owner of unit!")
      return
   end
   local ownerID = owner:GetPlayerID()
   local hero = GetPlayerHero(ownerID)
   if not hero then
      print("SimpleTechTree:RegisterIncident: Couldn't get player hero!")
      return
   end
   local oldUnitCount = hero:GetUnitCountFor(unitName) or 0
   local wasUnfinished = false

   -- On creation.
   if state == true then
      if isBuilding == true then
	 hero:AddBuilding(unit)
	 if unit._finished == false then
	    unit._finished = true
	    hero:IncUnitCountFor(unitName)
	 else
	    print("\n\tWARNING: UNIT._FINISHED WAS TRUE!\n")
	 end
      else
	 hero:AddUnit(unit)
	 hero:IncUnitCountFor(unitName)
      end

      -- On death.
   elseif state == false then
      if isBuilding == true then
	 hero:RemoveBuilding(unit)
	 if unit._finished == true then
	    hero:DecUnitCountFor(unitName)
	 else
	    --print("Note: building was destroyed before finished...")
	    wasUnfinished = true
	    unit._interrupted = true
	 end
      else
	 hero:RemoveUnit(unit)
	 hero:DecUnitCountFor(unitName)
      end
   end

   local needsUpdate = false
   local maxUnitCount = SimpleTechTree:GetMaxCountFor(unitName)
   local newUnitCount = hero:GetUnitCountFor(unitName)

   if maxUnitCount then
      if (oldUnitCount >= maxUnitCount and newUnitCount < maxUnitCount) or
	 (oldUnitCount < maxUnitCount and newUnitCount >= maxUnitCount) or
      wasUnfinished == true then

	 --print("\tUpdate triggered by maxUnitCount or wasUnfinished!")
	 needsUpdate = true
      end
   elseif (oldUnitCount == 0 and newUnitCount > 0) or
   (oldUnitCount > 0 and newUnitCount == 0) then

      --print("\t\tUpdate triggered by unitCount entering or leaving 0!")
      needsUpdate = true
   end

   if needsUpdate == true then
      SimpleTechTree:UpdateTechTree(hero, unit, state)
   end
end





--					-----| Update Spells |-----





-- Update the level on all spells owned by all units and buildings of the hero.
function SimpleTechTree:UpdateSpells(hero)
   if not hero then
      print("SimpleTechTree:UpdateSpells\tunit was nil!")
      return
   end

   if DEBUG_SIMPLE_TECH_TREE == true then
      print_simple_tech_tree("UpdateSpells", "\n\tUpdating the spells!")
   end

   -- Update buildings.
   for _,building in pairs(hero:GetBuildings()) do
      for i=0,6 do
	 local curAbility = building:GetAbilityByIndex(i)
	 if curAbility ~= nil and not curAbility:IsNull() then
	    local curAbilityName = curAbility:GetAbilityName()
	    if not curAbilityName then
	       print("SimpleTechTree:UpdateSpells\t(buildings) curAbilityName was nil!")
	    else
	       --print("(buildings) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       if DEBUG_SIMPLE_TECH_TREE == true then
		  print("SimpleTechTree:UpdateSpells\t(buildings) level was nil!")
	       end
	    else
	       curAbility:SetLevel(level)
	       --print_simple_tech_tree("UpdateSpells", "Set level to "..level.."!")
	    end
	 end
      end
   end

   -- Update units.
   for _,unit in pairs(hero:GetUnits()) do
      for i=0,6 do
	 local curAbility = unit:GetAbilityByIndex(i)
	 if curAbility ~= nil and not curAbility:IsNull() then
	    local curAbilityName = curAbility:GetAbilityName()
	    if not curAbilityName then
	       print("SimpleTechTree:UpdateSpells\t(units) curAbilityName was nil!")
	    else
	       --print("(units) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       --print("SimpleTechTree:UpdateSpells\t(units) level was nil! curAbilityName: "..curAbilityName)
	    else
	       curAbility:SetLevel(level)
	       --print_simple_tech_tree("UpdateSpells", "Set level to "..level.."!")
	    end
	 end
      end
   end

   SimpleTechTree:UpdateSpellsHeroOnly(hero)
end



-- Update the level on all the current spells on the hero.
function SimpleTechTree:UpdateSpellsHeroOnly(unit)
   -- Update hero.
   for i=0,6 do
      local curAbility = unit:GetAbilityByIndex(i)
      if curAbility ~= nil and not curAbility:IsNull() then
	 local curAbilityName = curAbility:GetAbilityName()
	 if not curAbilityName then
	    print("SimpleTechTree:UpdateSpells\t(hero) curAbilityName was nil!")
	 else
	    --print("(hero) "..curAbilityName)
	 end
	 local level = unit._abilityLevels[curAbilityName]
	 if not level then
	    --print("SimpleTechTree:UpdateSpells\t(hero) level was nil for hero!")
	 else
	    curAbility:SetLevel(level)
	    --print_simple_tech_tree("UpdateSpells", "Set level to "..level.."!")
	 end
      end
   end
end



-- Update the level on all the spells of a single unit or building.
function SimpleTechTree:UpdateSpellsOneUnit(hero, unit)
   if not hero or not unit then
      print("SimpleTechTree:UpdateSpellsOneUnit\thero or unit was nil!")
      return
   end
   
   -- This will currently only work for buildings.
   if not IsCustomBuilding(unit) then
      print("SimpleTechTree:UpdateSpellsOneUnit: Spell currently only works for buildings!")
      return
   end
   
   -- Update buildings.
   for _,building in pairs(hero:GetBuildings()) do
      for i=0,6 do
	 local curAbility = building:GetAbilityByIndex(i)
	 if curAbility ~= nil and not curAbility:IsNull() then
	    local curAbilityName = curAbility:GetAbilityName()
	    if not curAbilityName then
	       print("SimpleTechTree:UpdateSpellsOneUnit\t(buildings) curAbilityName was nil!")
	    else
	       --print("(buildings) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       --print("SimpleTechTree:UpdateSpellsOneUnit\t(buildings) level was nil!")
	    else
	       --print("It's all fine!")
	       curAbility:SetLevel(level)
	    end
	 end
      end
   end
end



-- Put all spells of the unit into unit._spells.
function SimpleTechTree:MergeSpells(unit)
   if not unit then
      print("SimpleTechTree:MergeSpells\tunit was nil!")
      return
   end

   --print("\n---------------------------------------------------------------------------")
   print_simple_tech_tree("MergeSpells", "\nMerging spells...")
   --print("---------------------------------------------------------------------------")


   -- READ
   -- Remember to init ability level of all the ability page spells.


   local spells = {}
   for pageNumber,page in pairs(unit._abilityPages) do
      if page then
	 for key,spell in pairs(page) do
	    local curSpellName = spell["spell"]
	    local curName = spell["name"]
	    spells[curSpellName] = spell
	    unit._abilityLevels[curSpellName] = 0
	    local curBuildingName = curName
	    unit:SetUnitCountFor(curBuildingName, 0)

	    print_simple_tech_tree("MergeSpells", "PageNumber: "..pageNumber.."\tKey: "..key.."\tSpell: "..spell["spell"])
	 end
      end
   end
   for key,spell in pairs(unit._trainingSpells) do
      if spell then
	 local curSpellName = spell["spell"]
	 local curName = spell["name"]
	 spells[curSpellName] = spell
	 unit._abilityLevels[curSpellName] = 0
	 local curUnitName = curName
	 unit:SetUnitCountFor(curUnitName, 0)

	 print_simple_tech_tree("MergeSpells", "Key: "..key.."\tSpell: "..spell["spell"])
      end
   end
   unit._spells = spells
   --print("---------------------------------------------------------------------------\n")
end





--					-----| Utility |-----





---------------------------------------------------------------------------
-- Prints the ability levels for the hero.
--
--	* player: The player whose ability levels to print.
--
---------------------------------------------------------------------------
function SimpleTechTree:PrintAbilityLevels(player)

   if not player then
      print("SimpleTechTree:PrintAbilityLevels\tplayer was nil!")
      return
   end
   if DEBUG_SIMPLE_TECH_TREE ~= true then
      return
   end

   local playerID = player:GetPlayerID()
   local hero = GetPlayerHero(playerID)

   local spells = {
      building = {},
      unit = {},
      spell = {}
   }

   for spellName,level in pairs(hero._abilityLevels) do
      local curSpell = SPELLS[spellName]
      local category = curSpell.category
      if category and spells[category] then
	 table.insert(spells[category], curSpell)
      else
	 print("SimpleTechTree:PrintAbilityLevels: invalid category found ("..category..")!")
      end
   end

   print("---------------------------------------------------------------------------")
   print("PrintAbilityLevels for player with ID "..playerID..":")
   print("---------------------------------------------------------------------------")
   print("")
   print("							-----| Buildings |-----							  ")
   print("")
   print("            Spell Name             | Level | Count | Name")
   print("---------------------------------------------------------------------------")
   for _,spell in pairs(spells.building) do
      local spellLevel = hero._abilityLevels[spell.spell] or 0
      local unitName = spell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(spell.name) or "-"
      print(string.format("%35s    %d      %3s     %s", spell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
   print("")
   print("							-----| Units |-----							  ")
   print("")
   print("            Spell Name             | Level | Count | Name")
   print("---------------------------------------------------------------------------")
   for _,spell in pairs(spells.unit) do
      local spellLevel = hero._abilityLevels[spell.spell] or 0
      local unitName = spell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(spell.name) or "-"
      print(string.format("%35s    %d      %3s     %s", spell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
   print("")
   print("							-----| Spells |-----							  ")
   print("")
   print("            Spell Name             | Level | Count | Name")
   print("---------------------------------------------------------------------------")
   for _,spell in pairs(spells.spell) do
      local spellLevel = hero._abilityLevels[spell.spell] or 0
      local unitName = spell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(spell.name) or "-"
      print(string.format("%35s    %d      %3s     %s", spell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
end



---------------------------------------------------------------------------
-- Returns the max count for the building or unit with the specified
-- unit or building name if it has a max count, nil otherwise.
--
--	* name: The name of the unit or building to get the max count for.
--
---------------------------------------------------------------------------
function SimpleTechTree:GetMaxCountFor(name)

   if not name then
      print("SimpleTechTree:GetMaxCountFor: name was nil!")
      return
   end
   local maxCount = MAX_COUNT[name]
   if maxCount then
      return maxCount
   end
end



---------------------------------------------------------------------------
-- Returns true if the unit is a hero.
--
--	* unit: The unit to check.
--
---------------------------------------------------------------------------
function SimpleTechTree:IsHero(unit)

   local heroName = unit:GetUnitName()
   if heroName == COMMANDER or heroName == FURION or heroName == GEOMANCER or heroName == KING_OF_THE_DEAD or heroName == WARLORD then
      return true
   else
      return false
   end
end



---------------------------------------------------------------------------
-- Print text if debug mode is on.
--
--	* funcName: The name of the function calling this.
--	* text: The text to print after funcName.
--
---------------------------------------------------------------------------
function print_simple_tech_tree(funcName, text)

   if DEBUG_SIMPLE_TECH_TREE == true then
      print("AbilityPages:"..funcName.."\t"..text)
   end
end
