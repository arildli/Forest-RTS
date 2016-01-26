


require('tech_def')



if not TechTree then
   TechTree = {}
   TechTree.__index = TechTree
end

function TechTree:new(o)
   o = o or {}
   setmetatable(o, self)
   SIMPLETECHTREE_REFERENCE = o
   return o
end

print("[TechTree] Creating Tech Tree Structure...")

--[==[

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



print("[TechTree] Done!")

]==]

---------------------------------------------------------------------------
-- Init the tech tree for the hero.
--- * hero: The unit to init the tech tree for.
---------------------------------------------------------------------------
function TechTree:InitTechTree(hero)
   if not hero then
      -- Crash
      hero:GetUnitName()
   end
   if not TechTree:IsHero(hero) then
      print_simple_tech_tree("TechTree:InitTechTree", "hero was not a hero! ("..hero:GetUnitName()..")!")
   end

   -- Init tables for unit.
   hero.TT = {
      unitCount = {},
      buildings = {},
      units = {},
      abilityLevels = {}
   }


   --					-----| UnitCount table |-----


   ---------------------------------------------------------------------------
   -- Returns the total number of units.
   ---------------------------------------------------------------------------
   function hero:GetUnitCount()
      return hero.TT.unitCount
   end

   ---------------------------------------------------------------------------
   -- Returns the count of units with 'name' as unitName.
   ---------------------------------------------------------------------------
   function hero:GetUnitCountFor(name)
      return hero.TT.unitCount[name]
   end

   ---------------------------------------------------------------------------
   -- Sets the count of units with 'name' as unitName.
   ---------------------------------------------------------------------------
   function hero:SetUnitCountFor(name, value)
      if name and value then
	 hero.TT.unitCount[name] = value
      else
	 -- Crash
	 print(name.." "..value)
      end
   end

   ---------------------------------------------------------------------------
   -- Increments the count of units with 'name' as unitName.
   ---------------------------------------------------------------------------
   function hero:IncUnitCountFor(name)
      if name then
	 if not hero.TT.unitCount[name] then
	    hero.TT.unitCount[name] = 0
	 end
	 hero.TT.unitCount[name] = hero.TT.unitCount[name] + 1
	 return hero.TT.unitCount[name]
      else
	 -- Crash
	 print("IncUnitCountFor: "..name)
      end
   end

   ---------------------------------------------------------------------------
   -- Decrements the count of units with 'name' as unitName.
   ---------------------------------------------------------------------------
   function hero:DecUnitCountFor(name)
      if name then
	 if not hero.TT.unitCount[name] then
	    hero.TT.unitCount[name] = 0
	 end
	 hero.TT.unitCount[name] = hero.TT.unitCount[name] - 1
	 return hero.TT.unitCount[name]
      else
	 -- Crash
	 print("DecUnitCountFor: "..name)
      end
   end


   --					-----| Buildings and Units tables |-----


   ---------------------------------------------------------------------------
   -- Gets the ability level for the entities with the
   -- specified name.
   ---------------------------------------------------------------------------
   function hero:GetAbilityLevelFor(name)
      local level = hero.TT.abilityLevels[name]
      if level then
	 return level
      else
	 print("Note: hero did not have ability level for "..name.."!")
	 return 1
      end
   end

   ---------------------------------------------------------------------------
   -- Sets the ability level for the entities with the
   -- specified name.
   ---------------------------------------------------------------------------
   function hero:SetAbilityLevelFor(name, level)
      hero.TT.abilityLevels[name] = level
   end


   --					-----| Buildings and Units tables |-----


   ---------------------------------------------------------------------------
   -- Get the table with handles to all the buildings of the hero.
   ---------------------------------------------------------------------------
   function hero:GetBuildings()
      return hero.TT.buildings
   end

   ---------------------------------------------------------------------------
   -- Get the table with handles to all the units of the hero.
   ---------------------------------------------------------------------------
   function hero:GetUnits()
      return hero.TT.units
   end

   ---------------------------------------------------------------------------
   -- Add the building handle to the building table.
   ---------------------------------------------------------------------------
   function hero:AddBuilding(building)
      if building then
	 table.insert(hero.TT.buildings, building)
      else
	 -- Crash
	 unit:GetUnitName()
      end
   end

   ---------------------------------------------------------------------------
   -- Add the unit handle to the unit table.
   ---------------------------------------------------------------------------
   function hero:AddUnit(unit)
      if unit then
	 table.insert(hero.TT.units, unit)
      else
	 -- Crash
	 unit:GetUnitName()
      end
   end

   ---------------------------------------------------------------------------
   -- Remove the building from the building table by index.
   ---------------------------------------------------------------------------
   function hero:RemoveBuildingByIndex(index)
      if index then
	 table.remove(hero.TT.buildings, index)
      else
	 -- Crash
	 print(index)
      end
   end

   ---------------------------------------------------------------------------
   -- Remove the unit from the unit table by index.
   ---------------------------------------------------------------------------
   function hero:RemoveUnitByIndex(index)
      if index then
	 table.remove(hero.TT.units, index)
      else
	 -- Crash
	 print(index)
      end
   end

   ---------------------------------------------------------------------------
   -- Remove the reference to the building from the building table.
   ---------------------------------------------------------------------------
   function hero:RemoveBuilding(building)
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
   -- Remove the reference to unit from the unit table.
   ---------------------------------------------------------------------------
   function hero:RemoveUnit(unit)
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
   -- Print the count of units and buildings for the owner of that unit.
   ---------------------------------------------------------------------------
   function hero:PrintUnitCount()
      local player = unit:GetOwner()
      local playerID = player:GetPlayerID()
      local playerHero = GetPlayerHero(playerID)

      if DEBUG_SIMPLE_TECH_TREE then
	 print("\n------------------")
	 print("Printing unit count for "..playerID..":")
	 print("------------------")
	 for index,count in pairs(playerHero.TT._unitCount) do
	    if index ~= "none" then
	       print(index..": "..count)
	    end
	 end
	 print("------------------")
      end
   end
   ---------------------------------------------------------------------------
   TechTree:RemoveDescriptionSpells(hero)

   local heroName = hero:GetUnitName()

   TechTree:ReadTechDef(hero)

   -- Update tech tree.
   TechTree:UpdateTechTree(hero, nil, "init")

   -- Set current page to the main one.
   GoToPage(hero, "PAGE_MAIN")
end


--					-----| Init Helper Methods |-----


---------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------
function TechTree:ReadTechDef(ownerHero)
   -- Crash
   if not ownerHero:IsRealHero() then print(ownerHero) end
   if not defs then print(defs.abc) end

   local heroName = ownerHero:GetUnitName()
   ownerHero.TT.techDef = tech[heroName]
   ownerHero._spells = {}

   local owner = ownerHero:GetOwner()
   TechTree:AddPlayerMethods(ownerHero, owner)

   -- Set ability pages for the unit.
   for key,page in pairs(tech[heroName].heropages) do
      InitAbilityPage(ownerHero, key, page)
   end

   -- Set ability levels and unitCount for the player.
   for key,value in pairs(ownerHero.TT.techDef) do
      if key ~= "heroname" and key ~= "heropages" then
	 local cat = value.category
	 if cat == "unit" or cat == "building" then
	    ownerHero:SetUnitCountFor(value.name, 0)
	 elseif value.category == "spell" then
	    ownerHero:SetUnitCountFor(value.spell, 0)
	 end
	 ownerHero:SetAbilityLevelFor(value.spell, 0)
	 
	 if value.req then
	    print("\nLooking at reqs for "..value.spell.." (#req: "..#value.req.."):")
	    for k,v in pairs(value.req) do
	       if v.category then
		  print("\tSinglechoice:")
		  print("\t\t"..v.name)
	       else  -- Note
		  print("\tMultichoice (#v = "..#v.."):")
		  for i,v2 in pairs(v) do
		     print("\t\t"..i..": "..v2.name)
		  end
	       end
	    end
	 end

	 local curSpellName = value.spell
	 ownerHero._spells[curSpellName] = value
	 --table.insert(ownerHero._spells, value)
      end
   end

   -- Set more keys for easier usage.
   for k,v in pairs(ownerHero.TT.techDef) do
      if k ~= "heropages" and k ~= "heroname" then
	 ownerHero.TT.techDef[v.spell] = v
	 local cat = v.category
	 if cat == "unit" or cat == "building" then
	    ownerHero.TT.techDef[v.name] = v
	 end
      end
   end
end

--[=[
-- Put all spells of the unit into unit._spells.
function TechTree:MergeSpells(unit)
   if not unit then
      print("TechTree:MergeSpells\tunit was nil!")
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
end]=]

---------------------------------------------------------------------------
-- Removes all the description spells of the hero.
--- * hero: The hero to work with.
---------------------------------------------------------------------------
function TechTree:RemoveDescriptionSpells(hero)
   for i=0,6 do
      local curAbility = hero:GetAbilityByIndex(i)
      if curAbility then
	 local curAbilityName = curAbility:GetAbilityName()
	 hero:RemoveAbility(curAbilityName)
      end
   end
end


--					-----| On Training or Death |-----


---------------------------------------------------------------------------
-- Adds useful methods to the newly training unit or 
-- constructed building.
--- * entity: The entity to add methods to.
---------------------------------------------------------------------------
function TechTree:AddPlayerMethods(entity, owner)
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
-- Returns all the abilityPages for the unit.
--- * unit: The unit to get the pages for.
--- * ownerHero: The hero of the owning player.
---------------------------------------------------------------------------
function TechTree:GetAbilityPagesForUnit(unit, ownerHero)
   if unit:IsRealHero() then 
      return unit.TT.techDef.heropages 
   end
   local unitName = unit:GetUnitName()
   return ownerHero.TT.techDef[unitName].pages
end

---------------------------------------------------------------------------
-- Makes sure to unlearn the construction spell of a building if the max
-- has been met at construction start.
--- * unit: The unit whose construction just started.
--- * spellname: Name of the spell used to create the building.
---------------------------------------------------------------------------
function TechTree:RegisterConstruction(unit, spellname)
   if not unit then
      -- Crash
      print("IsBuilding: "..tostring(IsBuilding))
      print(unit)
   end

   unit._finished = false
   local ownerHero = unit:GetOwnerPlayer()
   local unitName = unit:GetUnitName()
   local newUnitCount = ownerHero:GetUnitCountFor(unitName) + 1
   local maxUnitCount = TechTree:GetMaxCountFor(unitName, ownerHero)
   ownerHero:IncUnitCountFor(unitName)
   if newUnitCount >= maxUnitCount then
      ownerHero:SetAbilityLevelFor(spellname, 0)
      TechTree:UpdateSpellsAllEntities(ownerHero)
   end
end

---------------------------------------------------------------------------
-- Adds the abilities of an entity, setting them to level 0.
--- * entity: The entity to learn abilities.
---------------------------------------------------------------------------
function TechTree:AddAbilitiesToEntity(entity)
   local ownerHero = entity:GetOwnerHero()
   local heroName = ownerHero:GetUnitName()
   local entityName = entity:GetUnitName()
   local abilities = TechTree:GetAbilityPagesForUnit(entity, ownerHero)
   for pageName,page in pairs(abilities) do
      InitAbilityPage(entity, pageName, page)
   end
   GoToPage(entity, "PAGE_MAIN")
end

---------------------------------------------------------------------------
-- Add or removes a unit from the tables upon construction/training or
-- destruction/termination.
--- * unit: The unit that was either constructed/trained or killed/destroyed.
--- * state: Should be true if construction/training, false if killed/destroyed.
---------------------------------------------------------------------------
function TechTree:RegisterIncident(unit, state)
   if not unit then print("TechTree:RegisterIncident: unit was nil!"); return end
   -- Don't want this to trigger if state is fales
   if state == nil then	print("TechTree:RegisterIncident: state was nil!"); return end

   local isBuilding = IsBuilding(unit)
   local unitName = unit:GetUnitName()
   local ownerHero = unit:GetOwnerHero()
   local oldUnitCount = ownerHero:GetUnitCountFor(unitName) or 0
   local wasUnfinished = false

   -- On creation.
   if state == true then
      if isBuilding == true then
	 oldUnitCount = oldUnitCount - 1
	 ownerHero:AddBuilding(unit)
	 if unit._finished == false then
	    unit._finished = true
	    --ownerHero:IncUnitCountFor(unitName)
	 else
	    print("\n\tWARNING: UNIT._FINISHED WAS TRUE!\n")
	 end
      else
	 ownerHero:AddUnit(unit)
	 ownerHero:IncUnitCountFor(unitName)
      end

      -- On death.
   elseif state == false then
      if isBuilding == true then
	 ownerHero:RemoveBuilding(unit)
	 ownerHero:DecUnitCountFor(unitName)
	 --if unit._finished == true then
	 --else
	 if unit.finished == false then
	    --print("Note: building was destroyed before finished...")
	    wasUnfinished = true
	    unit._interrupted = true
	 end
      else
	 ownerHero:RemoveUnit(unit)
	 ownerHero:DecUnitCountFor(unitName)
      end
   end

   local needsUpdate = false
   local maxUnitCount = TechTree:GetMaxCountFor(unitName, ownerHero)
   local newUnitCount = ownerHero:GetUnitCountFor(unitName)

   if maxUnitCount then
      if (oldUnitCount >= maxUnitCount and newUnitCount < maxUnitCount) or
	 (oldUnitCount < maxUnitCount and newUnitCount >= maxUnitCount) or
      wasUnfinished then

	 --print("\tUpdate triggered by maxUnitCount or wasUnfinished!")
	 needsUpdate = true
      end
   elseif (oldUnitCount == 0 and newUnitCount > 0) or
   (oldUnitCount > 0 and newUnitCount == 0) then

      --print("\t\tUpdate triggered by unitCount entering or leaving 0!")
      needsUpdate = true
   end

   if needsUpdate == true then
      print("Note: Needed update!")
      TechTree:UpdateTechTree(ownerHero, unit, state)
   end
end


--					-----| Update Methods |-----


---------------------------------------------------------------------------
-- Update the level on all the spells of all entities of
-- a player.
--- * ownerHero: The hero of the player.
---------------------------------------------------------------------------
function TechTree:UpdateSpellsAllEntities(ownerHero)
   ownerHero = ownerHero or entity:GetOwnerHero()
   
   -- Update entities.
   TechTree:UpdateSpellsForHero(ownerHero)
   for _,building in pairs(ownerHero:GetBuildings()) do
      TechTree:UpdateSpellsForEntity(building, ownerHero)
   end
   for _,unit in pairs(ownerHero:GetUnits()) do 
      TechTree:UpdateSpellsForEntity(unit, ownerHero)
   end
end

---------------------------------------------------------------------------
-- Wrapper function for heroes.
---------------------------------------------------------------------------
function TechTree:UpdateSpellsForHero(ownerHero) 
   TechTree:UpdateSpellsForEntity(ownerHero, ownerHero)
end

---------------------------------------------------------------------------
-- Updates all the spells for the given entity.
---------------------------------------------------------------------------
function TechTree:UpdateSpellsForEntity(entity, ownerHero)
   if entity:IsRealHero() then
      ownerHero = entity
   else
      ownerHero = ownerHero or entity:GetOwnerHero()
   end

   for i=0,6 do
      local curAbility = entity:GetAbilityByIndex(i)
      if curAbility and not curAbility:IsNull() then
	 local curAbilityName = curAbility:GetAbilityName()
	 local level = ownerHero:GetAbilityLevelFor(curAbilityName)
	 
	 if not level then
	    curAbility:SetLevel(1)
	 else
	    curAbility:SetLevel(level)
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
function TechTree:UpdateTechTree(hero, building, action)
   if hero and TechTree:IsHero(hero) == false then
      -- Crash
      print(nil)
      return false
   end
   if not building and action == "init" then
      print("\nTechTree:UpdateTechTree: Initing tech tree...")
   elseif not building then
      print("\nTechTree:UpdateTechTree: building was nil!")
      return false
   elseif action == nil then
      print("\nTechTree:UpdateTechTree: action was nil!")
      return false
   end

   local playerID = hero:GetOwnerID()
   print("[TechTree] Updating tech tree for player with ID "..playerID.."!")

   local heroName = hero:GetUnitName()
   local buildingName
   if building then
      building = building:GetUnitName()
   end
   if not hero.TT then
      print("ERROR: hero did have have hero.TT! This most likely means TechTree:InitTechTree(hero) hasn't been called yet!")
      return false
   end
   local needsUpdate = true

   -- Check through all the spells.
   for i,curSpell in pairs(hero._spells) do
      local curSpellName = curSpell.spell					-- Name of the current spell.

      local printThis = false
      --local printThis = true
      if curSpell.category ~= "spell" then
	 printThis = true
	 print("Looking at spell "..curSpellName) -- Note
      end

      local curUnitName = curSpell.name or "none"			-- Name of the unit or building produced.
      local curUnitCount = "-"								-- Count of the unit or building produced.
      local curUnitMax = curSpell.max						-- Max count of the unit or building produced.

      -- Count the number of units or buildings of this type if training or construction spell.
      if curUnitName ~= "none" then
	 curUnitCount = hero:GetUnitCountFor(curUnitName)
	 if not curUnitCount then
	    hero:SetUnitCountFor(curUnitName, 0)
	    curUnitCount = 0
	 end
      end

      -- Check if all reqs for the spell are met.
      local unlock = true
      if curUnitMax and curUnitCount >= curUnitMax then
	 if printThis then
	    print("\t"..curSpellName.." reached max...")  -- Note
	 end
	 --print(curSpellName.." hit the max limit. Unlock = false...")
	 unlock = false
      else
	 if not curSpell["req"] then
	    --print(curSpellName.." didn't have any reqs. Unlock = true")
	    if printThis then
	       print("\tNo reqs! Unlocked")  -- Note
	    end
	    unlock = true
	 else
	    if printThis then
	       print("\tLooking at reqs:")  -- Note
	    end

	    -- Check requirements table for current spells if it
	    -- has one.
	    for _,curReq in ipairs(curSpell["req"]) do
	       unlock = true
	       
	       if printThis then
		  if curReq.name then
		     print("\t\tcurReq.name: "..curReq.name)  -- Note
		  else
		     print("\t\tNote: curReq did NOT have .name.")		     
		  end
	       end

	       -- Old way of checking current requirement.
	       if type(curReq) == "table" and curReq["category"] then
		  local curReqName = curReq["name"] or "none"
		  local curReqCount = hero:GetUnitCountFor(curReqName) or 0

		  if printThis then
		     print("\t\t"..curReqName.." with count "..curReqCount.." and cat "..curReq["category"])  -- Note
		  end

		  if not curReqCount or curReqCount <= 0 then
		     unlock = false
		     if printThis then
			print("\t\t\t"..curReqName.." was missing! Locked...")  -- Note
		     end
		     break
		  else
		     if printThis then
			print("\t\t\t"..curReqName.." was met.")  -- Note
		     end
		  end
	       else   -- New way! Looking at ..., curReq, ... or ..., {curOption1, curOption2}, ...
		  -- Insert the current req or table with choosable reqs into a new one.
		  local curReqTable = {}

		  if printThis then
		     print("\t\tNote: Req new way!")  -- Note
		  end

		  if type(curReq) == "table" then   -- One among several options must be met.

		     if printThis then
			print("\t\treq table WITHOUT category (Length = "..#curReq.."):")
			for k,v in pairs(curReq) do
			   print("\t\t\t\tKey: "..k.."\tValue.spell: "..v.spell)  -- Note
			end
		     end

		     for _,curReqName in ipairs(curReq) do
			
			if printThis then
			   print("\t\tOr-req "..curReqName)  -- Note
			end
		  
			table.insert(curReqTable, curReqName)
		     end
		  else
		     if printThis then
			print("\t\tSINGLE Or-req "..curReqName)  -- Note
		     end

		     table.insert(curReqTable, curReqName)
		  end

		  -- Check if one of the options for the current req has not been met.
		  local oneOptionMet = false

		  if printThis then
		     print("\t\t# Length of curReqTable: "..#curReqTable)  -- Note
		  end

		  for _,curReqName in ipairs(curReqTable) do
		     local curReqCount = hero:GetUnitCountFor(curReqName)
		     if curReqCount and curReqCount > 0 then
			if printThis then
			   print("\t\t\t"..curReqName.." met! Unlocked")  -- Note
			end

			oneOptionMet = true
			break
		     else

			if printThis then
			   print("\t\t\t"..curReqName.." NOT met with count "..tostring(curReqCount).."!")  -- Note
			end
		     end
		  end
		  
		  -- Stop if neither of the options for the current req has been met.
		  if not oneOptionMet then
		     if printThis then
			print("\t\t\tNeither reqs met! Locked...")  -- Note
		     end
		     unlock = false
		     break
		  end
	       end
	    end
	 end
      end
      
      -- Set spell level.
      --if not buildingName or not buildingName ~= MAIN_BUILDING["name"] then
      if unlock == true then
	 --hero._abilityLevels[curSpellName] = 1
	 if printThis then
	    print("--- Unlocked "..curSpellName)  -- Note
	 end
	 hero:SetAbilityLevelFor(curSpellName, 1)
      elseif unlock == false then
	 --hero._abilityLevels[curSpellName] = 0
	 if printThis then
	    print("--- Locked "..curSpellName)  -- Note
	 end
	 hero:SetAbilityLevelFor(curSpellName, 0)
      else
	 print("TechTree:UpdateTechTree: unlock was neither true nor false!-----------------")
      end
      --end

      if printThis then
	 print()  -- Note
      end

      --local curSpellLevel = hero._abilityLevels[curSpellName]
      local curSpellLevel = hero:GetAbilityLevelFor(curSpellName)
      --if curUnitCount ~= "-" then
--	 print_simple_tech_tree("UpdateTechTree", "Count: "..curUnitCount.." \tLevel: "..curSpellLevel.."\tSpell: "..curSpellName.."\t\tName: "..curUnitName)
      --end
   end

   print("Updating all spells.")
   TechTree:PrintAbilityLevels(hero:GetOwnerPlayer())
   DEBUG_SIMPLE_TECH_TREE = true
   TechTree:UpdateSpellsAllEntities(hero)

   print_simple_tech_tree("UpdateTechTree", "\n\tTech tree update done!")
end





--					-----| On Creation and Death |----





--					-----| Update Spells |-----




--[=[
-- Update the level on all spells owned by all units and buildings of the hero.
function TechTree:UpdateSpells(hero)
   if not hero then
      print("TechTree:UpdateSpells\tunit was nil!")
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
	       print("TechTree:UpdateSpells\t(buildings) curAbilityName was nil!")
	    else
	       --print("(buildings) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       if DEBUG_SIMPLE_TECH_TREE == true then
		  print("TechTree:UpdateSpells\t(buildings) level was nil!")
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
	       print("TechTree:UpdateSpells\t(units) curAbilityName was nil!")
	    else
	       --print("(units) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       --print("TechTree:UpdateSpells\t(units) level was nil! curAbilityName: "..curAbilityName)
	    else
	       curAbility:SetLevel(level)
	       --print_simple_tech_tree("UpdateSpells", "Set level to "..level.."!")
	    end
	 end
      end
   end

   TechTree:UpdateSpellsHeroOnly(hero)
end



-- Update the level on all the current spells on the hero.
function TechTree:UpdateSpellsHeroOnly(unit)
   -- Update hero.
   for i=0,6 do
      local curAbility = unit:GetAbilityByIndex(i)
      if curAbility ~= nil and not curAbility:IsNull() then
	 local curAbilityName = curAbility:GetAbilityName()
	 if not curAbilityName then
	    print("TechTree:UpdateSpells\t(hero) curAbilityName was nil!")
	 else
	    --print("(hero) "..curAbilityName)
	 end
	 local level = unit._abilityLevels[curAbilityName]
	 if not level then
	    --print("TechTree:UpdateSpells\t(hero) level was nil for hero!")
	 else
	    curAbility:SetLevel(level)
	    --print_simple_tech_tree("UpdateSpells", "Set level to "..level.."!")
	 end
      end
   end
end



---------------------------------------------------------------------------
-- Update the level on all the spells of a single unit or building.
--function TechTree:UpdateSpellsOneUnit(hero, unit)
---------------------------------------------------------------------------
function TechTree:UpdateSpellsAllEntities(ownerHero)
   ownerHero = ownerHero or entity:GetOwnerHero()
   
   -- Update entities.
   for _,entity in pairs(ownerHero:GetBuildings()) do
      TechTree:UpdateSpellsForEntity(entity, ownerHero)
      for i=0,6 do
	 local curAbility = building:GetAbilityByIndex(i)
	 if curAbility ~= nil and not curAbility:IsNull() then
	    local curAbilityName = curAbility:GetAbilityName()
	    if not curAbilityName then
	       print("TechTree:UpdateSpellsOneUnit\t(buildings) curAbilityName was nil!")
	    else
	       --print("(buildings) "..curAbilityName)
	    end
	    local level = hero._abilityLevels[curAbilityName]
	    if not level then
	       --print("TechTree:UpdateSpellsOneUnit\t(buildings) level was nil!")
	    else
	       --print("It's all fine!")
	       curAbility:SetLevel(level)
	    end
	 end
      end
   end
end]=]



--					-----| Utility |-----





---------------------------------------------------------------------------
-- Prints the ability levels for the hero.
--- * player: The player whose ability levels to print.
---------------------------------------------------------------------------
function TechTree:PrintAbilityLevels(player)
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

   for key,curSpell in pairs(hero.TT.techDef) do
      if key ~= "heropages" and key ~= "heroname" then
	 local category = curSpell.category
	 local found = false
	 for _,v in pairs(spells[category]) do
	    if v == curSpell then
	       found = true
	       break
	    end
	 end
	 if not found then
	    if category then
	       table.insert(spells[category], curSpell)
	    else
	       print("TechTree:PrintAbilityLevels: invalid category found!")
	    end
	 end
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
   for _,curSpell in pairs(spells.building) do
      local spellLevel = hero:GetAbilityLevelFor(curSpell.spell) or "nil"
      local unitName = curSpell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(unitName) or "-"
      print(string.format("%35s    %d      %3s     %s", curSpell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
   print("")
   print("							-----| Units |-----							  ")
   print("")
   print("            Spell Name             | Level | Count | Name")
   print("---------------------------------------------------------------------------")
   for _,curSpell in pairs(spells.unit) do
      local spellLevel = hero:GetAbilityLevelFor(curSpell.spell) or "nil"
      local unitName = curSpell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(unitName) or "-"
      print(string.format("%35s    %d      %3s     %s", curSpell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
   print("")
   print("							-----| Spells |-----							  ")
   print("")
   print("            Spell Name             | Level | Count | Name")
   print("---------------------------------------------------------------------------")
   for _,curSpell in pairs(spells.spell) do
      local spellLevel = hero:GetAbilityLevelFor(curSpell.spell) or "nil"
      local unitName = curSpell.name
      if not unitName or unitName == "none" then unitName = "-" end
      local unitCount = hero:GetUnitCountFor(unitName) or "-"
      print(string.format("%35s    %d      %3s     %s", curSpell.spell, spellLevel, unitCount, unitName))
   end
   print("---------------------------------------------------------------------------")
end



---------------------------------------------------------------------------
-- Returns the max count for the building or unit with the specified
-- unit or building name if it has a max count, nil otherwise.
--- * name: The name of the unit or building to get the max count for.
--- * ownerHero: The hero of the caller.
---------------------------------------------------------------------------
function TechTree:GetMaxCountFor(name, ownerHero)
   if not ownerHero.TT.techDef[name] then
      print("ownerHero.TT.techDef["..name.."] was nil!")
   end
   return ownerHero.TT.techDef[name].max
end



---------------------------------------------------------------------------
-- Returns true if the unit is a hero.
--- * unit: The unit to check.
---------------------------------------------------------------------------
function TechTree:IsHero(unit)
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
