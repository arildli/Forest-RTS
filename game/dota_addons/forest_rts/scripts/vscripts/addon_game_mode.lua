print("Welcome to Forest RTS!")

if CustomGameMode == nil then
	_G.CustomGameMode = class({})
end

require('statcollection/init')
require('other/utilities')
--require('upgrades')
require('other/mechanics')
require('orders')

require('libraries/timers')
require('libraries/popups')
require('libraries/notifications')



hero_names = {
    "bane",
    "beastmaster",
    "brewmaster",
    "centaur",
    "clinkz",
    "dragon_knight",
    "enchantress",
    "leshrac",
    "lina",
    "meepo",
    "pugna",
    "skeletonking",
    "sniper",
    "techies",
    "treant",
    "tuskarr",
    "warlord",
    "windrunner",
    "witchdoctor"    
}



---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )
	print("Precache starting...")


	-- BuildingHelper Precaches
	PrecacheItemByNameSync("item_apply_modifiers", context)
	-- Model ghost and grid particles
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_gravelmaw/", context)

	-- Dropped item model
	PrecacheResource("model", "models/chest_worlddrop.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf", context)

	-- Fire projectile
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_base_attack.vpcf", context)

	-- Searing Arrows
	PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf", context)

	-- Liquid Fire
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff_light.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", context)

    -- Satyr Spellweaver particles and sounds
    PrecacheResource("particle", "particles/neutral_fx/satyr_trickster_projectile.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context)
    PrecacheResource("particle", "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", context)
    PrecacheResource("particle", "particles/status_fx/status_effect_slardar_amp_damage.vpcf", context)

	-- Soldiers
	--PrecacheResource("model", "models/creeps/lane_creeps/creep_good_melee/creep_good_melee.vmdl", context)
	--PrecacheResource("model", "models/creeps/lane_creeps/creep_good_ranged/creep_good_ranged.vmdl", context)
	PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl", context)
	PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl", context)


	-- Hero items
	PrecacheResource("model", "models/items/dragon_knight/shield_timedragon.vmdl", context)

    PrecacheResource("model", "models/props_gameplay/tpscroll01.vmdl", context)
    PrecacheResource("particle", "particles/generic_gameplay/dropped_item.vpcf", context)
    PrecacheResource("particle", "particles/items2_fx/mekanism.vpcf", context)
    
    PrecacheResource("model", "models/props_gameplay/cheese.vmdl", context)

	-- Buildings
	   -- Watch Tower
	PrecacheResource("model", "models/props_structures/wooden_sentry_tower001.vmdl", context)
    PrecacheResource("model", "models/watch_tower/watch_tower.vmdl", context)
	   -- Wooden Wall
	PrecacheResource("model", "models/props_debris/spike_fence_fx_b.vmdl", context)
    PrecacheResource("model", "models/wooden_wall/wooden_wall.vmdl", context)
       -- Guard Tower
    PrecacheResource("model", "models/props_structures/tower_good.vmdl", context)
    PrecacheResource("particle", "particles/units/heroes/hero_tinker/tinker_base_attack.vpcf", context)
	   -- Temporary Mining Crystal
	PrecacheResource("model", "models/props_structures/good_base_wall006.vmdl", context)
    --PrecacheResource("model", "models/moonwell/moonwell.vmdl", context)
	   -- Main Tent
	--PrecacheResource("model", "models/main_tent/main_tent.vmdl", context)
	PrecacheResource("model", "models/props_structures/tent_dk_small.vmdl", context)
    PrecacheResource("model", "models/main_tent/main_tent.vmdl", context)
	   -- Good Barracks
	PrecacheResource("model", "models/props_structures/good_barracks_melee001.vmdl", context)
    PrecacheResource("model", "models/barracks_radiant/barracks_radiant.vmdl", context)
      -- Good Barracks Ranged
    PrecacheResource("model", "models/barracks_ranged_radiant/barracks_ranged_radiant.vmdl", context)
	   -- Evil Barracks
	PrecacheResource("model", "models/props_structures/bad_barracks001_melee.vmdl", context)
    PrecacheResource("model", "models/barracks_dire/barracks_dire.vmdl", context)
      -- Evil Barracks Ranged
    PrecacheResource("model", "models/barracks_ranged_dire/barracks_ranged_dire.vmdl", context)
	   -- Market
	PrecacheResource("model", "models/props_structures/sideshop_radiant002.vmdl", context)
    PrecacheResource("model", "models/marked/market.vmdl", context)
	   -- Armory
	PrecacheResource("model", "models/props_structures/tent_dk_med.vmdl", context)
    PrecacheResource("model", "models/armory/armory.vmdl", context)
	   -- Moonwell
	PrecacheResource("model", "models/props_structures/good_statue008.vmdl", context)
    PrecacheResource("model", "models/moonwell/moonwell.vmdl", context)
	   -- Unholy Spire
	PrecacheResource("model", "models/props_structures/bad_column001.vmdl", context)
    PrecacheResource("model", "models/unholy_spire/unholy_spire.vmdl", context)
    --[=[
    --]=]
	   -- Gold Mine
	PrecacheResource("model", "models/mine/mine.vmdl", context)




	-- Midas Particle
	PrecacheResource("particle", "particles/items2_fx/hand_of_midas_b.vpcf", context)

	-- Watch Tower Arrow
	PrecacheResource("particle", "particles/units/heroes/hero_mirana/mirana_base_attack.vpcf", context)

	-- Healing Aura Particle
	PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_heal_aura.vpcf", context)

	-- Main Tent Upgrade Particle
	PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant_lvl2.vpcf", context)

	-- Building Destruction
	PrecacheResource("particle", "particles/base_destruction_fx/gensmoke.vpcf", context)
	PrecacheResource("particle", "particles/world_destruction_fx/base_statue_destruction_generic_c.vpcf", context)
	PrecacheResource("particle", "particles/dire_fx/fire_barracks.vpcf", context)

    -- Moonwell Overhead Effect
    PrecacheResource("particle", "particles/radiant_fx/good_barracks_melee001_amb.vpcf", context)



	-- Props
	   -- Barrel
	PrecacheResource("model", "models/props_debris/barrel002.vmdl", context)
	   -- Chest
	PrecacheResource("model", "models/props_debris/merchant_debris_chest001.vmdl", context)
	   -- Stash
	PrecacheResource("model", "models/props_debris/secret_shop001.vmdl", context)
	   -- Weapon Rack
	PrecacheResource("model", "models/props_structures/weapon_rack_00.vmdl", context)
	   -- Banner Radiant
	PrecacheResource("model", "models/props_teams/banner_radiant.vmdl", context)
	   -- Banner Dire
	PrecacheResource("model", "models/props_teams/banner_dire_small.vmdl", context)
       -- Banner Tintable
    PrecacheResource("model", "models/props_teams/banner_tintable.vmdl", context)




	-- Units and their items



	-- Common

	-- Worker
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl", context)

    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)

	-- Catapults
	PrecacheResource("model", "models/creeps/lane_creeps/creep_good_siege/creep_good_siege.vmdl", context)
	PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl", context)

	PrecacheResource("particle", "particles/base_attacks/ranged_siege_good.vpcf", context)
	PrecacheResource("particle", "particles/base_attacks/ranged_siege_bad.vpcf", context)

    

	-- Commander

	-- Worker
	PrecacheResource("model", "models/heroes/beastmaster/beastmaster.vmdl", context)

	PrecacheResource("model", "models/heroes/beastmaster/beastmaster_weapon.vmdl", context)

	-- Footman
	PrecacheResource("model", "models/heroes/dragon_knight/dragon_knight.vmdl", context)

	PrecacheResource("model", "models/items/dragon_knight/shield_timedragon.vmdl", context)
	PrecacheResource("model", "models/items/dragon_knight/skirt_timedragon.vmdl", context)
	PrecacheResource("model", "models/items/dragon_knight/pauldrons_timedragon.vmdl", context)
	PrecacheResource("model", "models/items/dragon_knight/helmet_timedragon.vmdl", context)
	PrecacheResource("model", "models/items/dragon_knight/bracers_timedragon.vmdl", context)
	PrecacheResource("model", "models/items/dragon_knight/weapon_dragonmaw.vmdl", context)

	-- Gunner
	PrecacheResource("model", "models/heroes/sniper/sniper.vmdl", context)

	PrecacheResource("model", "models/items/sniper/snipers_grandfather_rifle_3/snipers_grandfather_rifle_3.vmdl", context)
	PrecacheResource("model", "models/items/sniper/sharpshooter_arms/sharpshooter_arms.vmdl", context)
	PrecacheResource("model", "models/items/sniper/sharpshooter_shoulder/sharpshooter_shoulder.vmdl", context)
	PrecacheResource("model", "models/items/sniper/sharpshooter_cloak/sharpshooter_cloak.vmdl", context)
	PrecacheResource("model", "models/items/sniper/sharpshooter_stache/sharpshooter_stache.vmdl", context)

	PrecacheResource("particle", "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf", context)

	-- Sorceress
	PrecacheResource("model", "models/heroes/lina/lina.vmdl", context)

	PrecacheResource("model", "models/items/lina/migrant_blaze_arms/migrant_blaze_arms.vmdl", context)
	PrecacheResource("model", "models/items/lina/migrant_blaze_belt/migrant_blaze_belt.vmdl", context)
	PrecacheResource("model", "models/items/lina/migrant_blaze_head/migrant_blaze_head.vmdl", context)
	PrecacheResource("model", "models/items/lina/migrant_blaze_neck/migrant_blaze_neck.vmdl", context)

    PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_death.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_ambient_hand_r.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_ambient_hand_l.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_slow.vpcf", context)

    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)



	-- Furion

	-- Worker
	PrecacheResource("model", "models/items/furion/treant/father_treant/father_treant.vmdl", context)

    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)

	-- Treant Warrior
	PrecacheResource("model", "models/heroes/furion/treant.vmdl", context)

	PrecacheResource("model", "models/items/ursa/savage_bracer.vmdl", context)

	-- Dryad
	PrecacheResource("model", "models/heroes/enchantress/enchantress.vmdl", context)

	PrecacheResource("model", "models/items/enchantress/anuxi_summer_arms/anuxi_summer_arms.vmdl", context)
	PrecacheResource("model", "models/items/enchantress/anuxi_summer_head/anuxi_summer_head.vmdl", context)
	PrecacheResource("model", "models/items/enchantress/anuxi_summer_shoulder/anuxi_summer_shoulder.vmdl", context)
	PrecacheResource("model", "models/items/enchantress/anuxi_summer_skirt/anuxi_summer_skirt.vmdl", context)
	PrecacheResource("model", "models/items/enchantress/anuxi_summer_spear/anuxi_summer_spear.vmdl", context)

	PrecacheResource("particle" ,"particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf", context)

	-- Tormented Soul
	PrecacheResource("model", "models/heroes/leshrac/leshrac.vmdl", context)

	PrecacheResource("model", "models/items/leshrac/aboundedroots_thornsofsundering/aboundedroots_thornsofsundering.vmdl", context)
	PrecacheResource("model", "models/items/leshrac/horns_thornsofsundering/horns_thornsofsundering.vmdl", context)
	PrecacheResource("model", "models/items/leshrac/pauldronsofsundering/pauldronsofsundering.vmdl", context)
	PrecacheResource("model", "models/items/leshrac/tailofsundering/tailofsundering.vmdl", context)

	PrecacheResource("particle", "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor_regen.vpcf", context)

    -- Skirmisher
    PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_centaur_med/n_creep_centaur_med.vmdl", context)



    -- Brewmaster

    -- Worker
    PrecacheResource("model", "models/heroes/brewmaster/brewmaster_earthspirit.vmdl", context)

    -- Bruiser
    PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl", context)

    -- Frostmage
    PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_ogre_lrg/n_creep_ogre_lrg.vmdl", context)
    PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_base_attack.vpcf", context)
    PrecacheResource("particle", "particles/status_fx/status_effect_frost_lich.vpcf", context)



	-- Geomancer

	-- Worker
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl", context)

	-- Guard
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_b/n_creep_kobold_b.vmdl", context)

	-- Flame Thrower
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_frost.vmdl", context)

    -- Spellweaver
    PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_satyr_b/n_creep_satyr_b.vmdl", context)

    -- Wolf
    PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_worg_large/n_creep_worg_large.vmdl", context)


	-- King of the Dead

	-- Worker
	PrecacheResource("model", "models/heroes/undying/undying_minion.vmdl", context)

	-- Warrior
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl", context)

	-- Archer
	PrecacheResource("model", "models/heroes/clinkz/clinkz.vmdl", context)

	PrecacheResource("model", "models/heroes/clinkz/clinkz_head.vmdl", context)
	PrecacheResource("model", "models/heroes/clinkz/clinkz_bow.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/clinkz_skeleton_hands/clinkz_skeleton_hands.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/guard/guard.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/justpicsnothingmnew/justpicsnothingmnew.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/clinkzhead/clinkzhead.vmdl", context)

	PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf", context)

	-- Mage
	PrecacheResource("model", "models/heroes/pugna/pugna.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_arms/oblivion_headmaster_arms.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_back/oblivion_headmaster_back.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_belt/oblivion_headmaster_belt.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_helm/oblivion_headmaster_helm.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_shoulders/oblivion_headmaster_shoulders.vmdl", context)
	PrecacheResource("model", "models/items/pugna/oblivion_headmaster_wand/oblivion_headmaster_wand.vmdl", context)

	PrecacheResource("particle", "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_pugna/pugna_base_attack.vpcf", context)

    -- Bane Elemental
    PrecacheResource("model", "models/heroes/bane/bane.vmdl", context)
    PrecacheResource("model", "models/heroes/bane/bane_head.vmdl", context)
    PrecacheResource("model", "models/heroes/bane/bane_shoulders.vmdl", context)

    PrecacheResource("particle", "particles/units/heroes/hero_bane/bane_projectile.vpcf", context)




	-- Warlord

	-- Worker
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_high_priest.vmdl", context)

	-- Guard
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_berserker.vmdl", context)

	-- Axe Thrower
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_troll_dark_a/n_creep_troll_dark_a.vmdl", context)

	-- Troll Elder
	PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_troll_dark_b/n_creep_troll_dark_b.vmdl", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)

	PrecacheResource("particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/mask_of_madness.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context)



    -- Neutral

    -- Archer
    PrecacheResource("model", "models/heroes/windrunner/windrunner.vmdl", context)

    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_back/deadly_feather_swing_back.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_head/deadly_feather_swing_head.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_offhand/deadly_feather_swing_offhand.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_shoulder/deadly_feather_swing_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_weapon/deadly_feather_swing_weapon.vmdl", context)
    --PrecacheResource("model", "models/items/windrunner/zkbackreimp/zkbackreimp.vmdl", context)
    --PrecacheResource("model", "models/items/windrunner/naturebow.vmdl", context)
    --PrecacheResource("model", "models/items/windrunner/zkpads/zkpads.vmdl", context)
    --PrecacheResource("model", "models/items/windrunner/zarukina_protector_hair/zarukina_protector_hair.vmdl", context)

    PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf", context)

    -- Brute
    PrecacheResource("model", "models/items/beastmaster/red_talon_arms/red_talon_arms.vmdl", context)
    PrecacheResource("model", "models/items/beastmaster/red_talon_belt/red_talon_belt.vmdl", context)
    PrecacheResource("model", "models/items/beastmaster/red_talon_head/red_talon_head.vmdl", context)
    PrecacheResource("model", "models/items/beastmaster/red_talon_shoulder/red_talon_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/beastmaster/red_talon_weapon/red_talon_weapon.vmdl", context)



    -- Barbarians

    -- Scout
    PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor.vmdl", context)
    PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor_bag.vmdl", context) --95
    PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor_belt.vmdl", context) --96
    PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor_head.vmdl", context) --94
    PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor_staff.vmdl", context) --97

    PrecacheResource("particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf", context)

    -- Axe Fighter
    PrecacheResource("model", "models/items/beastmaster/fotw_arms/fotw_arms.vmdl", context) -- 6250
    PrecacheResource("model", "models/items/beastmaster/fotw_belt/fotw_belt.vmdl", context) -- 6255
    PrecacheResource("model", "models/items/beastmaster/fotw_head/fotw_head.vmdl", context) -- 6254
    PrecacheResource("model", "models/items/beastmaster/fotw_shoulders/fotw_shoulders.vmdl", context) -- 6253
    PrecacheResource("model", "models/items/beastmaster/fotw_weapon/fotw_weapon.vmdl", context) -- 6252

    -- Raider
    PrecacheResource("model", "models/heroes/tuskarr/tuskarr.vmdl", context)
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_axe/frostiron_raider_axe.vmdl", context) -- 5009
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_back/frostiron_raider_back.vmdl", context) -- 5010
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_cape/frostiron_raider_cape.vmdl", context) -- 5011
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_fist/frostiron_raider_fist.vmdl", context) -- 5012
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_helm/frostiron_raider_helm.vmdl", context) -- 5013
    PrecacheResource("model", "models/items/tuskarr/frostiron_raider_tusks/frostiron_raider_tusks.vmdl", context) -- 5014

    -- Archer
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_back/deadly_feather_swing_back.vmdl", context) -- 8257
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_head/deadly_feather_swing_head.vmdl", context) -- 8252
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_offhand/deadly_feather_swing_offhand.vmdl", context) -- 8261
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_shoulder/deadly_feather_swing_shoulder.vmdl", context) -- 8263
    PrecacheResource("model", "models/items/windrunner/deadly_feather_swing_weapon/deadly_feather_swing_weapon.vmdl", context) -- 8254

    -- Sound files
    for _,name in ipairs(hero_names) do
        local file_name = "soundevents/game_sounds_heroes/game_sounds_" .. name .. ".vsndevts"
        PrecacheResource("soundfile", file_name, context)
    end

	print("Precache done!")
end

function Activate()
	GameRules.SimpleRTSGameMode = SimpleRTSGameMode:new()
	GameRules.SimpleRTSGameMode:InitGameMode()
end



--[[


RequireFiles =
{
    "internal/util",
    "gamemode",
    "libraries/timers",
    "libraries/physics",
    "libraries/projectiles",
    "libraries/notifications",
    "libraries/animations",
    "libraries/attachments",

    "internal/gamemode",
    "internal/events",

    "settings",
    "events",

    -- FlappyDota
    "util",
    "FlappyHero",
    "orders",
    "pillars",
    "abilities",
    "popups",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
}

Resources =
{
    -- ****** particle_folder ******
    ["particle_folder"] = "",
    ["particle_folder"] = "",
    ["particle_folder"] = "",
    ["particle_folder"] = "",
    -- ****** particle ******
    ["particle"] = "particles/items2_fx/phase_boots.vpcf",
    ["particle"] = "particles/items_fx/immunity_sphere_buff.vpcf",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    ["particle"] = "",
    -- ****** model ******
    ["model"] = "",
    ["model"] = "",
    ["model"] = "",
    ["model"] = "",
    ["model"] = "",
    ["model"] = "",
    -- ****** unit ******
    ["unit"] = "",
    ["unit"] = "",
    ["unit"] = "",
    ["unit"] = "",
    ["unit"] = "",
    ["unit"] = "",
    -- ****** item ******
    ["item"] = "",
    ["item"] = "",
    ["item"] = "",
    -- ****** soundfile ******
    ["soundfile"] = "soundevents/game_sounds_custom.vsndevts",
    ["soundfile"] = "soundevents/game_sounds_ui.vsndevts",
    ["soundfile"] = "",
    ["soundfile"] = "",
    ["soundfile"] = "",
    ["soundfile"] = "",
}

for _, requireFile in pairs(RequireFiles) do
    if requireFile ~= "" then
        require(requireFile)
    end
end

function Precache( context )
    for resourceType, resource in pairs(Resources) do
        if resource ~= "" then
            if resourceType == "model" then
                PrecacheModel(resource, context)
            elseif resourceType == "unit" then
                PrecacheUnitByNameSync(resource, context)
            elseif resourceType == "item" then
                PrecacheItemByNameSync(resource, context)
            else
                PrecacheResource(resourceType, resource, context)
            end
        end
    end
end

-- Create the game mode when we activate
function Activate()
    GameRules.GameMode = GameMode()
    GameRules.GameMode:InitGameMode()
end

]]--



















--[[
-- Load Stat collection (statcollection should be available from any script scope)
require('lib.statcollection')
statcollection.addStats({
	modID = 'f80936eabbb70043c658c7e6ed9f5246' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})

-- Load the options module (GDSOptions should now be available from the global scope)
require('lib.optionsmodule')
GDSOptions.setup('f80936eabbb70043c658c7e6ed9f5246', function(err, options)  -- Your modID goes here, GET THIS FROM http://getdotastats.com/#d2mods__my_mods
    -- Check for an error
    if err then
        print('Something went wrong and we got no options: '..err)
        return
    end

    -- Success, store options as you please
    print('THIS IS INSIDE YOUR CALLBACK! YAY!')

    -- This is a test to print a select few options
    local toTest = {
        test = true,
        test2 = true,
        modID = true,
        steamID = true
    }
    for k,v in pairs(toTest) do
        print(k..' = '..GDSOptions.getOption(k, 'doesnt exist'))
    end
end)

print( "stat collection loaded." )]]
