
require("tech_spells")

if not defs then
    print("ERROR: table 'defs' not found!")
    return
end

-- Hero names --
COMMANDER = "npc_dota_hero_legion_commander"
FURION = "npc_dota_hero_furion"
BREWMASTER = "npc_dota_hero_brewmaster"
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
            tech[herotable.heroname] = herotable
            for k,v in pairs(tech["COMMON"]) do
                herotable[k] = v
            end
        end
    end
end

function IsHeroConst(heroname)
    local cases = {
        COMMANDER = true,
        FURION = true,
        BREWMASTER = true,
        GEOMANCER = true,
        KING_OF_THE_DEAD = true,
        WARLORD = true
    }
    return cases[heroname] or false
end

---------------------------------------------------------------------------
-- Returns the constant for the specified hero.
---------------------------------------------------------------------------
function GetHeroConst(heroname)
    local cases = {
        [COMMANDER]        = "COMMANDER",
        [FURION]           = "FURION",
        [BREWMASTER]       = "BREWMASTER",
        [GEOMANCER]        = "GEOMANCER",
        [KING_OF_THE_DEAD] = "KING_OF_THE_DEAD",
        [WARLORD]          = "WARLORD"
    }
    return cases[heroname]
end

---------------------------------------------------------------------------
-- Returns the tech[heroname].
---------------------------------------------------------------------------
function GetHeroTable(heroname)
    local heroConst = GetHeroConst(heroname)
    return tech[heroConst]
end

function GetConstFor(unitName, heroname)
    local heroConst = GetHeroConst(heroname)
    for constant,entry in pairs(entities[heroConst]) do
        if entry.name == unitName then
            return constant
        end
    end
end

---------------------------------------------------------------------------
-- Returns the struct for a specific unit from 'tech'.
---------------------------------------------------------------------------
function GetUnitStructFromTech(unitName, heroname)
    local unitStruct = tech[heroname][unitName]
    if unitStruct then
        return unitStruct
    end

    print("Note: Didn't find '"..unitName.."' by constant, searching through entries...")
    for key,entry in pairs(tech[heroname]) do
        if key ~= "heroname" and key ~= "heropages" then
            if entry.name == unitName then
                unitStruct = entry
                print("Found '"..unitStruct.name.."' though search.")
                return unitStruct
            end
        end
    end
end

---------------------------------------------------------------------------
-- Returns the struct for a specific unit.
---------------------------------------------------------------------------
function GetUnitStructFor(unitType, heroname)
    if not IsHeroConst(heroname) then
        heroname = GetHeroConst(heroname)
    end
    return entities[heroname][unitType]
end

---------------------------------------------------------------------------
-- Returns the struct for a specific building.
---------------------------------------------------------------------------
function GetBuildingStructFor(buildingType, heroname)
    return GetUnitStructFor(buildingType, heroname)
end



-- Apparently the entities table fucks up the tech table, so it
-- has to go elsewhere...
entities = {
    COMMANDER = {
        WORKER = unitdefs.COMMANDER_WORKER,
        MELEE = unitdefs.COMMANDER_FOOTMAN,
        RANGED = unitdefs.COMMANDER_GUNNER,
        SIEGE = unitdefs.COMMANDER_CATAPULT,
        CASTER = unitdefs.COMMANDER_SORCERESS,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_RADIANT,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_RADIANT,
        ARMORY = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_RADIANT,
        MARKET = buildefs.MARKET
    },
    FURION = {
        WORKER = unitdefs.FURION_WORKER,
        MELEE = unitdefs.FURION_WARRIOR,
        RANGED = unitdefs.FURION_DRYAD,
        SIEGE = unitdefs.FURION_CATAPULT,
        CASTER = unitdefs.FURION_TORMENTED_SOUL,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_RADIANT,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_RADIANT,
        ARMORY = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_RADIANT,
        MARKET = buildefs.MARKET
    },
    BREWMASTER = {
        WORKER = unitdefs.BREWMASTER_WORKER,
        MELEE = unitdefs.BREWMASTER_WARRIOR,
        RANGED = unitdefs.BREWMASTER_FROSTMAGE,
        SIEGE = unitdefs.BREWMASTER_CATAPULT,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_RADIANT,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_RADIANT,
        ARMORY = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_RADIANT,
        MARKET = buildefs.MARKET
    },
    GEOMANCER = {
        WORKER = unitdefs.GEOMANCER_WORKER,
        MELEE = unitdefs.GEOMANCER_SPEARMAN,
        RANGED = unitdefs.GEOMANCER_FLAME_THROWER,
        SIEGE = unitdefs.GEOMANCER_CATAPULT,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_DIRE,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_DIRE,
        ARMORY = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_DIRE,
        MARKET = buildefs.MARKET
    },
    KING_OF_THE_DEAD = {
        WORKER = unitdefs.KING_OF_THE_DEAD_WORKER,
        MELEE = unitdefs.KING_OF_THE_DEAD_WARRIOR,
        RANGED = unitdefs.KING_OF_THE_DEAD_ARCHER,
        SIEGE = unitdefs.KING_OF_THE_DEAD_CATAPULT,
        CASTER = unitdefs.KING_OF_THE_DEAD_CASTER,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_DIRE,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_DIRE,
        ARMORY = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_DIRE,
        MARKET = buildefs.MARKET
    },
    WARLORD = {
        WORKER = unitdefs.WARLORD_WORKER,
        MELEE = unitdefs.WARLORD_FIGHTER,
        RANGED = unitdefs.WARLORD_AXE_THROWER,
        SIEGE = unitdefs.WARLORD_CATAPULT,
        CASTER = unitdefs.WARLORD_ELDER,

        TENT_SMALL = buildefs.TENT_SMALL,
        TENT_LARGE = buildefs.TENT_LARGE,
        GOLD_MINE = buildefs.GOLD_MINE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        BARRACKS = buildefs.BARRACKS_DIRE,
        BARRACKS_ADVANCED = buildefs.BARRACKS_ADVANCED_DIRE,
        ARMORY = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL = buildefs.HEALING_CRYSTAL_DIRE,
        MARKET = buildefs.MARKET
    }
}

function InitEntitiesTable()
    for heroname,ents in pairs(entities) do
        for constant,entry in pairs(ents) do
            ents[entry.name] = entry
        end
    end
end
InitEntitiesTable()

entities[COMMANDER] = entities["COMMANDER"]
entities[FURION] = entities["FURION"]
entities[GEOMANCER] = entities["GEOMANCER"]
entities[KING_OF_THE_DEAD] = entities["KING_OF_THE_DEAD"]
entities[WARLORD] = entities["WARLORD"]
entities[BREWMASTER] = entities["BREWMASTER"]

-- Tech tree definitions --
tech = {
    -- Common abilities
    COMMON = {
        -- Common
        EMPTY_FILLER = defs.EMPTY_FILLER,
        BUILDING = defs.BUILDING,
        TOWER = defs.TOWER,
        UNIT = defs.UNIT,
        PROP = buildefs.PROP,
        ENTER_TOWER = defs.ENTER_TOWER,
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
        PAGE_MENU_PROPS = defs.PAGE_MENU_PROPS,
        UPGRADE_LIGHT_ARMOR = defs.UPGRADE_LIGHT_ARMOR,
        UPGRADE_LIGHT_DAMAGE = defs.UPGRADE_LIGHT_DAMAGE,
        DEMOLISH_BUILDING = defs.DEMOLISH_BUILDING,
        BUY_HEALING_SALVE = defs.BUY_HEALING_SALVE,

        PROP_BARREL = buildefs.PROP_BARREL,
        PROP_CHEST = buildefs.PROP_CHEST,
        PROP_STASH = buildefs.PROP_STASH,
        PROP_WEAPON_RACK = buildefs.PROP_WEAPON_RACK,
        PROP_BANNER_RADIANT = buildefs.PROP_BANNER_RADIANT,
        PROP_BANNER_DIRE = buildefs.PROP_BANNER_DIRE,
        PROP_BANNER_OWNER = buildefs.PROP_BANNER_OWNER
    },


    -- Radiant
    COMMANDER = {
        heroname = COMMANDER,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_RADIANT,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_RADIANT,
                buildefs.ARMORY_RADIANT,
                buildefs.BARRACKS_ADVANCED_RADIANT,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                 buildefs.PROP_BARREL,
                 buildefs.PROP_CHEST,
                 buildefs.PROP_STASH,
                 buildefs.PROP_WEAPON_RACK,
                 buildefs.PROP_BANNER_RADIANT,
                 defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        HEADSHOT = defs.HEADSHOT,
        SNIPER_RIFLE = defs.SNIPER_RIFLE,
        SLOW = defs.SLOW,

        COMMANDER_WORKER = unitdefs.COMMANDER_WORKER,
        COMMANDER_FOOTMAN = unitdefs.COMMANDER_FOOTMAN,
        COMMANDER_GUNNER = unitdefs.COMMANDER_GUNNER,
        COMMANDER_CATAPULT = unitdefs.COMMANDER_CATAPULT,
        COMMANDER_SORCERESS = unitdefs.COMMANDER_SORCERESS,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.COMMANDER_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.COMMANDER_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_RADIANT = CopyWithNewMain(buildefs.BARRACKS_RADIANT, {
            unitdefs.COMMANDER_FOOTMAN,
            unitdefs.COMMANDER_GUNNER,
            unitdefs.COMMANDER_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_RADIANT = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_RADIANT, {
            unitdefs.COMMANDER_SORCERESS,
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_RADIANT = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL_RADIANT = buildefs.HEALING_CRYSTAL_RADIANT,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    },


    FURION = {
        heroname = FURION,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_RADIANT,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_RADIANT,
                buildefs.ARMORY_RADIANT,
                buildefs.BARRACKS_ADVANCED_RADIANT,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                 buildefs.PROP_BARREL,
                 buildefs.PROP_CHEST,
                 buildefs.PROP_STASH,
                 buildefs.PROP_WEAPON_RACK,
                 buildefs.PROP_BANNER_RADIANT,
                 defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        REGENERATIVE_BARK = defs.REGENERATIVE_BARK,
        ENVENOMED_SPEARS = defs.ENVENOMED_SPEARS,
        LIVING_ARMOR = defs.LIVING_ARMOR,

        FURION_WORKER = unitdefs.FURION_WORKER,
        FURION_WARRIOR = unitdefs.FURION_WARRIOR,
        FURION_DRYAD = unitdefs.FURION_DRYAD,
        FURION_CATAPULT = unitdefs.FURION_CATAPULT,
        FURION_TORMENTED_SOUL = unitdefs.FURION_TORMENTED_SOUL,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.FURION_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.FURION_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_RADIANT = CopyWithNewMain(buildefs.BARRACKS_RADIANT, {
            unitdefs.FURION_WARRIOR,
            unitdefs.FURION_DRYAD,
            unitdefs.FURION_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_RADIANT = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_RADIANT, {
            unitdefs.FURION_TORMENTED_SOUL,
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_RADIANT = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL_RADIANT = buildefs.HEALING_CRYSTAL_RADIANT,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    },


    BREWMASTER = {
        heroname = BREWMASTER,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_RADIANT,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_RADIANT,
                buildefs.ARMORY_RADIANT,
                buildefs.BARRACKS_ADVANCED_RADIANT,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                 buildefs.PROP_BARREL,
                 buildefs.PROP_CHEST,
                 buildefs.PROP_STASH,
                 buildefs.PROP_WEAPON_RACK,
                 buildefs.PROP_BANNER_RADIANT,
                 defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        CHILLING_ATTACKS = defs.CHILLING_ATTACKS,

        BREWMASTER_WORKER = unitdefs.BREWMASTER_WORKER,
        BREWMASTER_BRUISER = unitdefs.BREWMASTER_WARRIOR,
        BREWMASTER_FROSTMAGE = unitdefs.BREWMASTER_FROSTMAGE,
        BREWMASTER_CATAPULT = unitdefs.BREWMASTER_CATAPULT,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.BREWMASTER_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.BREWMASTER_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_RADIANT = CopyWithNewMain(buildefs.BARRACKS_RADIANT, {
            unitdefs.BREWMASTER_WARRIOR,
            unitdefs.BREWMASTER_FROSTMAGE,
            unitdefs.BREWMASTER_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_RADIANT = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_RADIANT, {
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_RADIANT = buildefs.ARMORY_RADIANT,
        HEALING_CRYSTAL_RADIANT = buildefs.HEALING_CRYSTAL_RADIANT,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    },


    -- Dire
    GEOMANCER = {
        heroname = GEOMANCER,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_DIRE,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_DIRE,
                buildefs.ARMORY_DIRE,
                buildefs.BARRACKS_ADVANCED_DIRE,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                buildefs.PROP_BARREL,
                buildefs.PROP_CHEST,
                buildefs.PROP_STASH,
                buildefs.PROP_WEAPON_RACK,
                buildefs.PROP_BANNER_DIRE,
                defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        LONG_WEAPON = defs.LONG_WEAPON,
        IGNITE = defs.IGNITE,

        GEOMANCER_WORKER = unitdefs.GEOMANCER_WORKER,
        GEOMANCER_SPEARMAN = unitdefs.GEOMANCER_SPEARMAN,
        GEOMANCER_FLAME_THROWER = unitdefs.GEOMANCER_FLAME_THROWER,
        GEOMANCER_CATAPULT = unitdefs.GEOMANCER_CATAPULT,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.GEOMANCER_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.GEOMANCER_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_DIRE = CopyWithNewMain(buildefs.BARRACKS_DIRE, {
            unitdefs.GEOMANCER_SPEARMAN,
            unitdefs.GEOMANCER_FLAME_THROWER,
            unitdefs.GEOMANCER_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_DIRE = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_DIRE, {
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_DIRE = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL_DIRE = buildefs.HEALING_CRYSTAL_DIRE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    },


    KING_OF_THE_DEAD = {
        heroname = KING_OF_THE_DEAD,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_DIRE,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_DIRE,
                buildefs.ARMORY_DIRE,
                buildefs.BARRACKS_ADVANCED_DIRE,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                buildefs.PROP_BARREL,
                buildefs.PROP_CHEST,
                buildefs.PROP_STASH,
                buildefs.PROP_WEAPON_RACK,
                buildefs.PROP_BANNER_DIRE,
                defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        UNDEAD_STRENGTH = defs.UNDEAD_STRENGTH,
        BURNING_ARROWS = defs.BURNING_ARROWS,
        CURSE = defs.CURSE,

        KING_OF_THE_DEAD_WORKER = unitdefs.KING_OF_THE_DEAD_WORKER,
        KING_OF_THE_DEAD_WARRIOR = unitdefs.KING_OF_THE_DEAD_WARRIOR,
        KING_OF_THE_DEAD_ARCHER = unitdefs.KING_OF_THE_DEAD_ARCHER,
        KING_OF_THE_DEAD_CATAPULT = unitdefs.KING_OF_THE_DEAD_CATAPULT,
        KING_OF_THE_DEAD_CASTER = unitdefs.KING_OF_THE_DEAD_CASTER,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.KING_OF_THE_DEAD_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.KING_OF_THE_DEAD_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_DIRE = CopyWithNewMain(buildefs.BARRACKS_DIRE, {
            unitdefs.KING_OF_THE_DEAD_WARRIOR,
            unitdefs.KING_OF_THE_DEAD_ARCHER,
            unitdefs.KING_OF_THE_DEAD_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_DIRE = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_DIRE, {
            unitdefs.KING_OF_THE_DEAD_CASTER,
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_DIRE = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL_DIRE = buildefs.HEALING_CRYSTAL_DIRE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    },


    WARLORD = {
        heroname = WARLORD,

        heropages = {
            PAGE_MAIN = {
                defs.HARVEST_LUMBER_HERO,
                defs.TRANSFER_LUMBER,
                defs.PAGE_MENU_CONSTRUCTION_BASIC,
                defs.PAGE_MENU_CONSTRUCTION_ADVANCED,
                defs.PAGE_MENU_PROPS
            },
            PAGE_MENU_CONSTRUCTION_BASIC = {
                buildefs.TENT_SMALL,
                buildefs.GOLD_MINE,
                buildefs.BARRACKS_DIRE,
                buildefs.WATCH_TOWER,
                buildefs.WOODEN_WALL,
                defs.PAGE_MAIN
            },
            PAGE_MENU_CONSTRUCTION_ADVANCED = {
                buildefs.MARKET,
                buildefs.HEALING_CRYSTAL_DIRE,
                buildefs.ARMORY_DIRE,
                buildefs.BARRACKS_ADVANCED_DIRE,
                defs.EMPTY_FILLER,
                defs.PAGE_MAIN
            },
            PAGE_MENU_PROPS = {
                 buildefs.PROP_BARREL,
                 buildefs.PROP_CHEST,
                 buildefs.PROP_STASH,
                 buildefs.PROP_WEAPON_RACK,
                 buildefs.PROP_BANNER_DIRE,
                 defs.PAGE_MAIN
            }
        },

        -- Unit and building spells
        HATRED = defs.HATRED,
        FRENZY = defs.FRENZY,

        WARLORD_WORKER = unitdefs.WARLORD_WORKER,
        WARLORD_FIGHTER = unitdefs.WARLORD_FIGHTER,
        WARLORD_AXE_THROWER = unitdefs.WARLORD_AXE_THROWER,
        WARLORD_CATAPULT = unitdefs.WARLORD_CATAPULT,
        WARLORD_ELDER = unitdefs.WARLORD_ELDER,

        -- Buildings
        TENT_SMALL = CopyWithNewMain(buildefs.TENT_SMALL, {
            unitdefs.WARLORD_WORKER,
            buildefs.TENT_LARGE,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        TENT_LARGE = CopyWithNewMain(buildefs.TENT_LARGE, {
            unitdefs.WARLORD_WORKER,
            defs.GLOBAL_SPEED_AURA,
            defs.DELIVERY_POINT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_DIRE = CopyWithNewMain(buildefs.BARRACKS_DIRE, {
            unitdefs.WARLORD_FIGHTER,
            unitdefs.WARLORD_AXE_THROWER,
            unitdefs.WARLORD_CATAPULT,
            defs.DEMOLISH_BUILDING
        }),
        BARRACKS_ADVANCED_DIRE = CopyWithNewMain(buildefs.BARRACKS_ADVANCED_DIRE, {
            unitdefs.WARLORD_ELDER,
            defs.DEMOLISH_BUILDING
        }),
        ARMORY_DIRE = buildefs.ARMORY_DIRE,
        HEALING_CRYSTAL_DIRE = buildefs.HEALING_CRYSTAL_DIRE,
        WATCH_TOWER = buildefs.WATCH_TOWER,
        WOODEN_WALL = buildefs.WOODEN_WALL,
        MARKET = buildefs.MARKET,
        GOLD_MINE = buildefs.GOLD_MINE
    }
}

-- Improve the tech table for easier usage.
AddCommonAbilities()
