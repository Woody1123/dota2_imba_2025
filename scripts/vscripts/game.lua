

--------------------------------------------------------------------------
-->游戏内部设置
--------------------------------------------------------------------------

CDOTA_PlayerResource.key = "test"
CDOTA_PlayerResource.wr_key = "test"

if IsDedicatedServer()  then
      CDOTA_PlayerResource.key = GetDedicatedServerKeyV2("new-imba")
      CDOTA_PlayerResource.wr_key="WR-"..tostring(CDOTA_PlayerResource.key)
end

if CDOTA_PlayerResource.address == nil then
	  CDOTA_PlayerResource.address ="https://dota2new-imba-default-rtdb.asia-southeast1.firebasedatabase.app/"..tostring(CDOTA_PlayerResource.key).."/"
end

if CDOTA_PlayerResource.wr_address == nil then
	  CDOTA_PlayerResource.wr_address ="https://dota2new-imba-default-rtdb.asia-southeast1.firebasedatabase.app/"..tostring(CDOTA_PlayerResource.wr_key).."/"
end

if CDOTA_PlayerResource.HeroWR==nil  then
  CDOTA_PlayerResource.HeroWR={}
end

--超级兵
CDOTAGameRules.IS_SUPER_CREEP=false
SUPER_CREEP_HP=10000
SUPER_CREEP_ATT=450
SUPER_CREEP_SP=50

--法术圣剑
SPELL_AMP_RAPIER_1 = 0.7
SPELL_AMP_RAPIER_3 = 2.0
SPELL_AMP_RAPIER_SUPER = 2.0

--是否启用抗性
RS_Switch=true

--人头提示
KILL_TIPS=true

--FV团队
GAME_LOSE_TEAM=nil
GAME_WIN_TEAM=nil

--出生延迟
SPAWN_TIME=5

--大决战
PVP=false
PVP_NUM=0

if BOT_GOOOD==nil  then
	BOT_GOOOD = {}
end

if BOT_BAD==nil  then
	BOT_BAD = {}
end


--额外工资
ExtraGold=20 --7
--人头
KILLSNUM=233
if GetMapName() == "10v10mid" then
  KILLSNUM =233
end


--老将眼奖励
Veteran_WARD = 1000

Hero_KEG=70 --150

Threshold_KEG=500

Perc_KEG=0.02

Neutral_KEG=4.2

Creep_KEG= 4.2  --3.8

Shared_G=1.1

Outpost_XP=1.2

--AI图的数据--
AI_HERO_TABLE = {
"npc_dota_hero_dragon_knight",
"npc_dota_hero_viper",
"npc_dota_hero_skeleton_king",
"npc_dota_hero_axe",
"npc_dota_hero_chaos_knight",
"npc_dota_hero_drow_ranger",
"npc_dota_hero_zuus",
"npc_dota_hero_monkey_king",
"npc_dota_hero_leshrac",
"npc_dota_hero_juggernaut",
"npc_dota_hero_phantom_assassin",
"npc_dota_hero_slardar",
"npc_dota_hero_ancient_apparition",
"npc_dota_hero_skywrath_mage",
"npc_dota_hero_omniknight",
"npc_dota_hero_winter_wyvern",

}
AI_MODE = false
AI_START = false
AI_HERO = {}	--ai英雄表
AI_LV = 1
AI_HERO_lv = {5,10,15,20,25,30,35,40,45,50}	--ai的等级该干什么事的表
SPAWN_TIME_AI = 18	--ai图出生延迟
AI_PUSH_GOOD = {Vector(1700,1700,128),Vector(2800,2800,128),Vector(4200,4200,256)}		--天辉ai的推进路线等级
AI_PUSH_BAD = {Vector(-1700,-1700,128),Vector(-2800,-2800,128),Vector(-4200,-4200,256)}			--夜宴的
PUSH_LEVEL = 1
AI_TOWER_MIN_LEVEL = 8

----------------------------------------------------------------------------------------------------------------------------------
--10V10中路的数据
IMBA_RUNE = {DOTA_RUNE_DOUBLEDAMAGE,DOTA_RUNE_HASTE,DOTA_RUNE_INVISIBILITY,DOTA_RUNE_REGENERATION,DOTA_RUNE_SHIELD}
IMBA_RUNE_MODIFIER = {
"modifier_rune_haste",
"modifier_rune_invis",
"modifier_rune_doubledamage",
"modifier_rune_shield",
}
GOODGUYS = Vector(-4200,-4200,256)
GOODGUYS_HOME = Vector(-6000,-6000,256)
BADGUYS = Vector(4200,4200,256)
BADGUYS_HOME = Vector(6000,00,256)
--投票奖励-------
VOTE_FIGHTER = {}
VOTE_LIMIT = 7
VOTE_FUN_LIMIT = 12
--肉山位置
ROSHAN_POS=Vector(-2814, 2316, 232)

--G
GOOD_POS=Vector(-7000,-6500, 608)

--D
BAD_POS=Vector(6912, 6336, 608)

--中心位置
C_POS=Vector(-500,-300,0)


--肉山
CDOTA_PlayerResource.ROSHAN=nil

--玩家
if CDOTA_PlayerResource.TG_HERO==nil  then
	  CDOTA_PlayerResource.TG_HERO = {}
end

--玩家信使
if CDOTA_PlayerResource.TG_COURIER==nil  then
	  CDOTA_PlayerResource.TG_COURIER = {}
end

--肉山死亡次数
if CDOTA_PlayerResource.ROSHAN_DIE==nil  then
	  CDOTA_PlayerResource.ROSHAN_DIE = 0
end

--投射物
if CDOTA_PlayerResource.Projectile==nil  then
	  CDOTA_PlayerResource.Projectile = {}
end

--秒退
CDOTA_PlayerResource.ABANDONED_GOOD = 0
CDOTA_PlayerResource.ABANDONED_BAD = 0



--数据
if CDOTA_PlayerResource.NET_DATA == nil then
	  CDOTA_PlayerResource.NET_DATA = {}
end

if CDOTA_PlayerResource.RD_SK == nil then
	  CDOTA_PlayerResource.RD_SK = {}
end


if CDOTAGameRules.IMBA_FOUNTAIN == nil then
	  CDOTAGameRules.IMBA_FOUNTAIN = {}
end

if CDOTAGameRules.TOWER == nil then
	  CDOTAGameRules.TOWER = {}
end

if GameRules.dummy == nil then
	  GameRules.dummy = {}
end

GameRules.QuitG = {}
GameRules.QuitB = {}
----------------------------------------------------------------------------------------------------------------------------------


--赛艇甲
Shield_TABLE={ "item_imba_vanguard","item_imba_crimson_guard" ,"item_imba_greatwyrm_plate"}

--艇辉耀
Radiance_TABLE={ "item_imba_radiance","item_imba_splendid" }

GODTOWERKILLED = 0
BADTOWERKILLED = 0


----------------------------------------------------------------------------------------------------------------------------------
--中立野怪表
NEATRUAL_CREEP_TABLE = {
	"npc_dota_neutral_mud_golem_split",
	"npc_dota_neutral_ogre_mauler",
	"npc_dota_neutral_ogre_magi",
	"npc_dota_neutral_giant_wolf",
	"npc_dota_neutral_alpha_wolf",
	"npc_dota_neutral_wildkin",
	"npc_dota_neutral_enraged_wildkin",
	"npc_dota_neutral_satyr_soulstealer",
	"npc_dota_neutral_satyr_hellcaller",
	"npc_dota_neutral_jungle_stalker",
	"npc_dota_neutral_elder_jungle_stalker",
	"npc_dota_neutral_prowler_acolyte",
	"npc_dota_neutral_prowler_shaman",
	"npc_dota_neutral_rock_golem",
	"npc_dota_neutral_granite_golem",
	"npc_dota_neutral_ice_shaman",
	"npc_dota_neutral_frostbitten_golem",
	"npc_dota_neutral_big_thunder_lizard",
	"npc_dota_neutral_small_thunder_lizard",
	"npc_dota_neutral_gnoll_assassin",
	"npc_dota_neutral_ghost",
	"npc_dota_wraith_ghost",
	"npc_dota_neutral_dark_troll",
	"npc_dota_neutral_dark_troll_warlord",
	"npc_dota_neutral_satyr_trickster",
	"npc_dota_neutral_forest_troll_berserker",
	"npc_dota_neutral_forest_troll_high_priest",
	"npc_dota_neutral_harpy_scout",
	"npc_dota_neutral_harpy_storm",
	"npc_dota_neutral_black_drake",
	"npc_dota_neutral_black_dragon",
}


--防御塔技能
TOWER_ABILITY_TABLE1=
{
	"tower1_att",
	"tower1_def",
	"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE2=
{
	"tower2_damage",
  "tower2_disarm",
	--"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE3=
{
	"tower3_fastatt",
  "tower3_laser",
	--"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE4=
{
--	"tower4_blood",
  "tower4_stun",
  "tower2_damage",
	--"tower1_watchtower",
	"tower1_med",
}

----------------------------------------------------------------------------------------------------------------------------------
--[[
--旺旺大礼包
Gift_ITEM=
{	
  "item_ward_sentry",
  "item_ward_observer",
  "item_pool_blink",
  "item_boots",
  "item_bracer",
  "item_null_talisman",
  "item_wraith_band",
  "item_blades_of_attack",
  "item_infused_raindrop",
  "item_ring_of_basilius",
  "item_urn_of_shadows",
  --"item_tome_of_knowledge",
}
]]
Gift_ITEM=
{	
  "item_ward_sentry",
  "item_tome_of_knowledge",
  "item_eyes",
  "item_hensin",
  "item_imba_soul_of_truth",
  "item_rd_book",
}
----------------------------------------------------------------------------------------------------------------------------------


--无法触发大晕锤的被动技能
NOT_Abyssal_Blade=
{
  "imba_slardar_bash",
  "imba_faceless_void_time_lock",
  "oldtroll_fervor",
  "greater_bash",
}


----------------------------------------------------------------------------------------------------------------------------------


--买活随机符文
RUNE_RD=
{
  "modifier_rune_regen_tg",
  "modifier_rune_haste_tg",
  "modifier_rune_invis_tg",
  "modifier_rune_doubledamage_tg",
  --"modifier_rune_arcane_tg",
}


----------------------------------------------------------------------------------------------------------------------------------


--不计算抗性的DEBUFF
NOT_RS_DEBUFF=
{
  "modifier_item_heavens_halberd_v2_debuff"
}

----------------------------------------------------------------------------------------------------------------------------------


--不移除的MODIFIER
NOT_MODIFIER_BUFF=
{
  "modifier_invoker_ice_wall_up",
  "modifier_invoker_up",
  "modifier_data_cd",
  "modifier_gnm",
  "modifier_gold",
  "modifier_player",
  "modifier_sk_cd",
  "modifier_witch_doctor_up",
}


----------------------------------------------------------------------------------------------------------------------------------

--去除目标的不死buff
KILL_MODIFIER_TABLE= {
  "modifier_refraction_buff1","modifier_false_promise_buff","modifier_false_promise_buff2","modifier_supernova_buff2","modifier_c_return_buff",
  "modifier_imba_shallow_grave","modifier_aphotic_shield","modifier_flesh_heap_buff",
  "modifier_troll_warlord_battle_trance"--"modifier_reincarnation_ghost"
}


----------------------------------------------------------------------------------------------------------------------------------

--👊
Female_HERO=
{
  "npc_dota_hero_vengefulspirit","npc_dota_hero_templar_assassin","npc_dota_hero_enchantress","npc_dota_hero_phantom_assassin","npc_dota_hero_naga_siren" ,
  "npc_dota_hero_crystal_maiden","npc_dota_hero_windrunner","npc_dota_hero_medusa","npc_dota_hero_drow_ranger","npc_dota_hero_puck","npc_dota_hero_lina" ,
  "npc_dota_hero_mirana","npc_dota_hero_queenofpain","npc_dota_hero_dark_willow","npc_dota_hero_death_prophet","npc_dota_hero_legion_commander",
  "npc_dota_hero_snapfire",	"npc_dota_hero_dawnbreaker" ,"npc_dota_hero_winter_wyvern" ,"npc_dota_hero_luna","npc_dota_hero_spectre"
}


----------------------------------------------------------------------------------------------------------------------------------

--随机技能1号表
RandomAbility=
{
  -- "multishot","axe_sprint","berserkers_call","counter_helix","double_edge","dragon_blood","dragon_tail","searing_chains",
  -- "rocket_barrage","blade_dance","torrent","howl","mystic_snake","crippling_fear","essence_aura","purification","fortunes_end","shackleshot",
  -- "powershot","poison_nova","storm_bolt","slug","hellfire_blast","shock","caustic_finale","icarus_dive","phantom_strike","malefice","stifling_dagger",
  -- "epicenter","refraction","wave_of_silence","corrosive_skin","nethertoxin","plague_ward","venomous_gale","warcry","sniper_roll","burrowstrike",
  -- "imba_rattletrap_battery_assault","guardian_angel","sanity_eclipse","boundless_strike","shapeshift","healing_ward","midnight_pulse","seriously_punch",
  -- "ion_shell","culling_blade","ice_vortex","ice_blast","imba_storm_spirit_electric_vortex","imba_storm_spirit_ball_lightning","grenade","echo_stomp",
  -- "guided_missile","imba_bounty_hunter_shuriken_toss","imba_chaos_knight_chaos_bolt","imba_chaos_knight_chaos_strike","imba_lina_dragon_slave","imba_lina_light_strike_array",
  -- "imba_razor_plasma_field","oldsky_aseal","imba_leshrac_pulse_nova","aghsfort_mars_spear","imba_mirana_arrow","imba_mirana_leap","hoof_stomp","breathe_fire",
  -- "sleight_of_fist","song_of_the_siren","voodoo","decay","windrun","bulldoze","charge_of_darkness","greater_bash","dual_breath","ice_path","macropyre",
  -- "toss_","wdnmd","shell_","money", "mount","dog", "gamble", "thunderstorm","deerskin","des_build","fight","kill_trees","reduce","laser_turret","counterattack",
  -- "tower","aphotic_shield","death_coil","frostmourne","purification_new","guardian_angel_new","imba_queenofpain_blink","imba_queenofpain_shadow_strike","imba_queenofpain_scream_of_pain",
  -- "imba_queenofpain_sonic_wave","imba_huskar_inner_fire","imba_huskar_burning_spear","imba_huskar_berserkers_blood","polymerization","forbid","deception",
  -- "mother_love", "tp_tp", "assembly","brain_sap","enfeeble","nightmare",
  -- "imba_tiny_grow","imba_tiny_avalanche","imba_treant_natures_grasp","imba_light_radiant_bind","imba_light_blinding_light","imba_luna_lucent_beam",
  -- "imba_luna_lunar_blessing", "imba_spectre_desolate","imba_phantom_lancer_spirit_lance","prot","flesh_heap","dismember","mountain","shockwave",
  -- "imba_phantom_lancer_doppelwalk","imba_phantom_lancer_phantom_edge","imba_bristleback_viscous_nasal_goo","imba_bristleback_quill_spray","empower",
  -- "unstable_concoction_throw","winters_curse","splinter_blast",
  -- "pangolier_swashbuckle","tidehunter_anchor_smash","rattletrap_hookshot", "earthshaker_aftershock","queenofpain_blink",
  -- "shadow_shaman_voodoo",  "faceless_void_time_walk","dark_troll_warlord_ensnare","polar_furbolg_ursa_warrior_thunder_clap","centaur_khan_war_stomp","roshan_spell_block",
  -- "roshan_slam","hoodwink_scurry","filler_ability","necronomicon_archer_aoe","satyr_hellcaller_shockwave","victory","fiery_soul","laguna_blade","supernova",
  -- "ra_mango_tree","ra_flask","ra_clarity","ra_cheese","ra_greater_crit","ra_hand_of_midas","ra_roll_out","ra_tome_of_knowledge","ra_bloodstone","imba_nyx_assassin_mana_burn","vampiric_aura","ensnare"
  -- ,"rip_tide","imba_uproar",
  -- --"rubick_arcane_supremacy",
  -- "imba_attribute_point"
  --[["droiyan","traitor""truce","flak_cannon","seer_vacuum","ra_tome_of_knowledge","ra_super_tower",chilling_touch,
 "imba_ogre_magi_multicast","imba_dazzle_weave","meat_hook","arctic_burn","coup_de_grace","pudge_flesh_heap","warlock_rain_of_chaos"]]
 "silencer_curse_of_the_silent","silencer_last_word","silencer_global_silence", --沉默
 "cold_embrace","winters_curse", "winter_wyvern_winters_curse","winter_wyvern_cold_embrace",--冰龙 --"winter_wyvern_arctic_burn"
 "unstable_concoction_throw","alchemist_acid_spray","alchemist_unstable_concoction","alchemist_chemical_rage","alchemist_goblins_greed",--炼金
 "empower","magnataur_empower","shockwave","magnataur_reverse_polarity","magnataur_skewer",--猛犸
 "brain_sap","nightmare","bane_fiends_grip","fiends_grip","bane_enfeeble","bane_brain_sap","bane_nightmare","bane_fiends_grip",--祸乱之源
 "magic_missile","nether_swap","vengefulspirit_magic_missile","vengefulspirit_wave_of_terror","vengefulspirit_nether_swap",--vs
 --土猫
 "abaddon_aphotic_shield","abaddon_frostmourne","aphotic_shield","frostmourne",--亚巴顿
 "ice_path","dual_breath","macropyre","jakiro_dual_breath","jakiro_ice_path","jakiro_macropyre",--双头龙
 "charge_of_darkness","bulldoze","nether_strike","greater_bash","spirit_breaker_charge_of_darkness","spirit_breaker_bulldoze",--白牛
 "frost_arrows","wave_of_silence","multishot","marksmanship",--"drow_ranger_marksmanship",--小黑
 "burrowstrike","caustic_finale",--沙王
 "poison_attack","corrosive_skin","nethertoxin","viper_strike",--viper
 "sprout",--先知
 "essence_aura","sanity_eclipse","arcane_orb","astral_imprisonment",--黑鸟
 "mana_shield","stone_gaze","mystic_snake",--美杜莎
 --"feral_impulse",--狼人
 "dragon_tail","dragon_blood","elder_dragon_form",--龙骑士
 "searing_chains",--"sleight_of_fist",火猫
 "imba_storm_spirit_electric_vortex","imba_storm_spirit_ball_lightning",--蓝猫
 --chen
 "poison_sting","poison_nova","plague_ward",--剧毒
 "dlnec_reaper","dlnec_haura","dlnec_dpulse",--nec
 "slug","grenade","sniper_take_aim",--火枪
 "tidebringer", "ghostship",--船长
 "natural_order_spirit",--大牛
 "rocket_barrage","guided_missile","flak_cannon","call_down",--飞机
 "blade_dance","blade_fury",--剑圣 //20230121
 "fortunes_end",--"fates_edict","purifying_flames","false_promise",--神谕
 "icarus_dive","supernova",--凤凰
 "ice_vortex",--"chilling_touch","ice_blast",--冰魂
 "impetus","untouchable",--小鹿
 "warcry",--seven
 "malefice","enigma_black_hole",--谜团
 "shock","voodoo","shackles","serpent_ward",--小y
 "hoof_stomp","double_edge","c_return",--人马
 "ensnare",--"rip_tide","song_of_the_siren","mirror_image",--小娜迦
 "crystal_nova","frostbite","crystal_maiden_frostbite",--"brilliance_aura","freezing_field",--冰女
 "berserkers_call","counter_helix","axe_berserkers_call","axe_battle_hunger","axe_counter_helix","culling_blade","axe_culling_blade",--虎王
 "crippling_fear","hunter_in_the_night",--夜魔
 "jingu_mastery",--"untransform",--大圣
 "shackleshot","windrun",--风行
 "imba_bounty_hunter_shuriken_toss","imba_bounty_hunter_jinada","imba_bounty_hunter_wind_walk",--"imba_bounty_hunter_track",--赏金
 --"seer_vacuum","ion_shell","surge","seriously_punch",--兔子
 --"tinker_laser",--tk
 "refraction",--"meld","psi_blades",--ta 
 --"imba_puck_phase_shift","imba_puck_dream_coil",--puck
 "imba_chaos_knight_chaos_bolt","imba_chaos_knight_chaos_strike","chaos_knight_chaos_strike",--混沌
 "light_strike_array","fiery_soul","laguna_blade","imba_lina_laguna_blade",--lina
 "meat_hook","flesh_heap","pudge_flesh_heap",--屠夫
 "decay",--"flesh_golem",--尸王
 "purification_new","repel","guardian_angel_new","guardian_angel",--全能
 "troll_warlord_battle_trance",--巨魔 "oldtroll_fervor",
 "hellfire_blast","mortal_strike",--"vampiric_aura","reincarnation",--骷髅王
 "oldsky_abolt","oldsky_cshot","oldsky_aseal","oldsky_mflare",--天怒
 "imba_leshrac_pulse_nova",--拉席克
 "mars_bulwark",--"aghsfort_mars_spear","dlmars_rebuke","dlmars_bulwark","mars_arena_of_blood",--马尔斯
"imba_abyssal_underlord_pit_of_malice","imba_abyssal_underlord_atrophy_aura",--大屁股
 --"imba_disruptor_thunder_strike","imba_disruptor_glimpse","imba_disruptor_kinetic_field",--萨尔
 "imba_mirana_starfall","imba_mirana_leap","imba_mirana_arrow","imba_mirana_moonlight_shadow",--白虎
 --"imba_queenofpain_blink","imba_queenofpain_sonic_wave",--女王
 --"techies_sticky_bomb","techies_reactive_tazer","techies_suicide","techies_land_mines",--炸弹人
 "imba_antimage_blink","antimage_mana_break","antimage_blink",--敌法师
 --"imba_batrider_sticky_napalm","imba_batrider_flamebreak","imba_batrider_firefly","imba_batrider_flaming_lasso",--蝙蝠
 "imba_dazzle_poison_touch","imba_dazzle_shallow_grave","imba_dazzle_shadow_wave",--"dazzle_good_juju",--戴泽
 "doom_bringer_infernal_blade",--"imba_doom_bringer_scorched_earth","imba_doom_bringer_infernal_blade","imba_doom_bringer_doom",--doom
 --"imba_beastmaster_wild_axes","imba_beastmaster_inner_beast","imba_beastmaster_primal_roar",--兽王
 "bloodseeker_rupture",--"bloodseeker_thirst",--"imba_bloodseeker_bloodrage","imba_bloodseeker_blood_bath","imba_bloodseeker_thirst","imba_bloodseeker_rupture",--血魔
 --"bloodseeker_bloodrage","bloodseeker_blood_bath","bloodseeker_thirst","bloodseeker_rupture",--蜘蛛
  "imba_clinkz_strafe_searing_arrows","imba_clinkz_burning_army","imba_clinkz_wind_walk","imba_clinkz_death_pact",--小骷髅
  "imba_dawnbreaker_fire_wreath","imba_dawnbreaker_celestial_hammer","imba_dawnbreaker_luminosity","imba_dawnbreaker_solar_guardian",--锤妹
  -- "imba_earthshaker_fissure","imba_earthshaker_enchant_totem","imba_earthshaker_aftershock","imba_earthshaker_stars_aura","imba_earthshaker_echo_slam",--小牛
  "imba_grimstroke_dark_artistry",--"imba_grimstroke_ink_creature","imba_grimstroke_spirit_walk",--"imba_grimstroke_soul_chain",--墨客
 -- "imba_hoodwink_acorn_shot","imba_hoodwink_bushwhack","imba_hoodwink_scurry","imba_hoodwink_sharpshooter",--小松鼠
  "imba_life_stealer_rage","imba_life_stealer_feast","imba_lifestealer_open_wounds",--小狗
 -- "imba_marci_grapple","imba_marci_companion_run","imba_marci_guardian","imba_marci_swing","imba_marci_unleash",--马西
 -- "imba_ogre_magi_fireblast_ignite","imba_ogre_mag i_focus","imba_ogre_magi_Bloodlust",--蓝胖
  --"imba_pangolier_swashbuckle","imba_pangolier_shield_crash","imba_pangolier_lucky_shot","imba_pangolier_gyroshell",--滚滚
  "phantom_assassin_coup_de_grace","phantom_assassin_stifling_dagger","phantom_assassin_phantom_strike",--幻刺
  --"imba_phantom_lancer_spirit_lance","imba_phantom_lancer_doppelwalk","imba_phantom_lancer_phantom_edge","imba_phantom_lancer_juxtapose",--幻影长矛手
  --"imba_shadow_demon_disruption","imba_shadow_demon_soul_catcher","imba_shadow_demon_shadow_poison","imba_shadow_demon_demonic_purge",--毒狗
   "imba_shredder_whirling_death","imba_shredder_timber_chain","imba_shredder_reactive_armor",--"imba_shredder_chakram",--伐木机
  --"imba_snapfire_scatterblast","imba_snapfire_firesnap_cookie","imba_snapfire_lil_shredder","imba_snapfire_mortimer_kisses",--老奶奶
  --"imba_spectre_spectral_dagger","imba_spectre_desolate","imba_spectre_dispersion","imba_spectre_splitting_dagger","imba_spectre_haunt",--ug
  --"imba_terrorblade_reflection","terrorblade_conjure_image","imba_terrorblade_metamorphosis","imba_terrorblade_sunder",--tb
  --"imba_void_spirit_aether_remnant","imba_void_spirit_dissimilate","imba_void_spirit_resonant_pulse","imba_void_spirit_astral_step",--紫猫
  "weaver_geminate_attack","shukuchi",-- "imba_weaver_the_swarm","imba_weaver_shukuchi","imba_weaver_geminate_attack",--蚂蚁
  --"imba_wisp_tether",--小精灵
  --"imba_brewmaster_thunder_clap","imba_brewmaster_cinder_brew","imba_brewmaster_drunken_brawler",--酒仙
  --"imba_dark_willow_bramble_maze","imba_dark_willow_shadow_realm","imba_dark_willow_cursed_crown",--小仙女
  --"imba_death_prophet_carrion_swarm","imba_death_prophet_silence","imba_death_prophet_spirit_siphon","imba_death_prophet_exorcism",--dp
  "imba_faceless_void_time_walk","faceless_void_time_walk","faceless_void_chronosphere",--虚空
  "imba_legion_commander_overwhelming_odds","imba_legion_commander_press_the_attack","imba_legion_commander_moment_of_courage","imba_legion_commander_duel","legion_commander_duel",--军团
  "imba_lion_earth_spike","imba_lion_hex","imba_lion_finger_of_death",--"imba_lion_mana_drain",--lion
  "morphling_morph_str","morphling_waveform",--"imba_morphling_waveform",--水人
  --"imba_nevermore_necromastery","imba_nevermore_dark_lord",--sf
  "imba_nyx_assassin_mana_burn","nyx_assassin_spiked_carapace",--"imba_nyx_assassin_spiked_carapace",--小强
  "pugna_decrepify",--"imba_pugna_nether_blast","pugna_nether_ward",--骨法
  "slardar_bash",--大鱼
  "slark_dark_pact","slark_essence_shift",--小鱼
  "imba_tidehunter_gush","imba_tidehunter_kraken_shell","imba_tidehunter_anchor_smash","imba_tidehunter_ravage",--抄袭
  "imba_ursa_earthshock","imba_ursa_overpower","imba_ursa_enrage",--熊战士
  --"imba_bristleback_viscous_nasal_goo","imba_bristleback_quill_spray","imba_bristleback_bristleback","imba_bristleback_warpath",--刚被
  "imba_huskar_burning_spear","imba_huskar_berserkers_blood",--"imba_huskar_life_break","imba_huskar_inner_fire",--哈斯卡
  "imba_lich_chain_frost",--lich
  -- "imba_luna_lucent_beam","imba_luna_moon_glaive","imba_luna_lunar_blessing",--luna
  --"imba_razor_eye_of_the_storm",--电魂
  "imba_tiny_grow",--小小
  "imba_treant_living_armor",--"imba_treant_natures_guise",--大树
  "witch_doctor_death_ward","witch_doctor_paralyzing_cask","witch_doctor_voodoo_switcheroo",--巫医  
  --"muerta_pierce_the_veil","muerta_dead_shot",--"muerta_the_calling",--英灵
  --"ra_mango_tree",
  --"ra_flask",
  "ra_clarity",
 -- "ra_cheese",
  "ra_greater_crit",
  --"ra_hand_of_midas",
  "ra_roll_out",
  "ra_tome_of_knowledge",
  --"ra_bloodstone",
  "toss_",
  "wdnmd",
  "shell_",
  --"money", 
  --"mount",
  "dog", 
  "gamble", 
  "thunderstorm",
  --"deerskin",
 -- "des_build",
  "fight",
 -- "kill_trees",
  "reduce",
 --"laser_turret",
  --"counterattack"
}


--随机技能被动表
RandomAbility2=
  {
  "phantom_assassin_coup_de_grace",
  "slark_essence_shift",
  "morphling_morph_str",
  "chaos_knight_chaos_strike",
  "doom_bringer_infernal_blade",
  "imba_huskar_berserkers_blood",
   "ra_branches",
    --"filler_ability",
   "roshan_spell_block",
   -- "necronomicon_archer_aoe",
    "imba_shredder_reactive_armor",
    --"dragon_knight_dragon_blood",
    --"huskar_burning_spear",
    --"bounty_hunter_jinada",
    --"ursa_fury_swipes",
    "ogre_magi_bloodlust",
    --"troll_warlord_fervor",
    "c_return","centaur_return",
    --"pangolier_heartpiercer",
    "life_stealer_feast",
    "earthshaker_aftershock",
    "sven_great_cleave",
    "razor_eye_of_the_storm",
   -- "crystal_maiden_brilliance_aura",
    "kunkka_tidebringer",
    "tiny_grow",
    "sniper_headshot",
    --"beastmaster_inner_beast",
    "dragon_knight_elder_dragon_form",
    "huskar_berserkers_blood",
    --"antimage_mana_break",
   -- "axe_counter_helix",
   -- "abaddon_frostmourne",
   -- "jakiro_liquid_fire",
    --"luna_lunar_blessing",
   -- "beastmaster_boar_poison",
 --   "nevermore_dark_lord",
    "storm_spirit_overload",

      "greater_bash",
     -- "tower1_watchtower",
      "blade_dance",
      "chilling_touch",
      "untouchable",
      "rip_tide",
     -- "psi_blades",
      "counter_helix",
      "natural_order_spirit",
      "impetus",
      "feral_impulse",
      --"focusfire",
      "corrosive_skin",
      "poison_sting",
      --"blur",
      "divine_favor",
      "hunter_in_the_night",
      "poison_attack",
      --"degen_aura",
      "imba_storm_spirit_overload",
      "dlzuus_al",
     -- "oldtroll_fervor",
      "wdnmd",
      "polymerization",
     -- "tower",
      "counterattack",
      --"laser_turret",
      "reduce",
      --"kill_trees",
      --"victory",
      "fight",
     -- "des_build",
      "deerskin",
      "gamble",
      "dog",
      "money",
     -- "mount",
      --"truce",
      ---"traitor",
      "deception",
      "mother_love",
      --"droiyan",
      --"assembly",
       "imba_tiny_grow",
       "imba_luna_lunar_blessing",
      "imba_phantom_lancer_phantom_edge",
      "imba_bristleback_warpath",
      "fiery_soul"
	   --[[ "imba_ogre_magi_multicast","imba_dazzle_weave","meat_hook","arctic_burn","coup_de_grace","pudge_flesh_heap",]]
  }


----随机被动表英雄
RandomAbilityHero=
{
  "npc_dota_hero_rubick",
  "npc_dota_hero_snapfire",
  "npc_dota_hero_monkey_king",
  "npc_dota_hero_spectre",
  "npc_dota_hero_kunkka",
  "npc_dota_hero_templar_assassin",
  "npc_dota_hero_nevermore",
  "npc_dota_hero_phoenix",
  "npc_dota_hero_techies",
  "npc_dota_hero_doom_bringer",
  "npc_dota_hero_undying",
  "npc_dota_hero_pudge",
  "npc_dota_hero_rattletrap",
  "npc_dota_hero_dazzle",
  "npc_dota_hero_invoker",
  "npc_dota_hero_visage",
  "npc_dota_hero_tusk",
  --"npc_dota_hero_faceless_void",
  "npc_dota_hero_morphling",
  "npc_dota_hero_medusa",
  "npc_dota_hero_tiny",
  "npc_dota_hero_earth_spirit",
  "npc_dota_hero_hoodwink",
  "npc_dota_hero_vengefulspirit",
  "npc_dota_hero_treant",
  "npc_dota_hero_shredder",
  "npc_dota_hero_brewmaster",
  "hero_phantom_assassin"
}



----------------------------------------------------------------------------------------------------------------------------------


--TK不刷新的技能物品
NOT_RS_ITEM_TK=
{
  "item_bkb",
  "item_bkbs",
  "item_hand_of_god",
  "item_red_cape",
  "item_skadi_v2",
  "item_hand_of_midas",
  "item_sphere",
  "item_necronomicon",
  "item_necronomicon2",
  "item_necronomicon3",
  "item_tome_of_knowledge",
  "item_refresher",
  "item_meteor_hammer",
  "item_titan_hammer",
  "item_helm_of_the_dominator",
  "item_aeon_disk",
  "item_siege",
  "item_sphere",
  "item_manta_v2",
  "item_glimmer_cape",
  "item_imba_orb",
  "item_laojie",
  "item_imba_seer_of_disk",
  "item_imba_relic_chip",
  "item_greaves_v2",
  "item_four_knives",
  "item_gem",
  "item_pirate_hat",
  "item_seer_stone",
 
}


--TK3技能随机的技能
TK_RD=
{
"omniknight_purification",
"omniknight_repel",  --原版全能套
"beastmaster_wild_axes",
"double_edge",
"imba_rattletrap_battery_assault",   --胡，发条弹片
"imba_rattletrap_power_cogs",
"imba_rattletrap_rocket_flare",
"imba_life_stealer_rage",
"imba_lifestealer_open_wounds",
"abyssal_underlord_firestorm",
"abyssal_underlord_pit_of_malice",
"tiny_avalanche",
"tiny_toss",
"pudge_meat_hook", --原版屠夫钩
"berserkers_call",
"axe_sprint",
"imba_slardar_sprint",
"imba_slardar_slithereen_crush",
"storm_bolt",
"warcry",
"torrent",
"void",
"crippling_fear",
"imba_doom_bringer_devour",
"treant_natures_grasp",
"treant_leech_seed",
"treant_living_armor",
"sandking_burrowstrike",
"sandking_sand_storm",
"chaos_knight_chaos_bolt",
"imba_tidehunter_gush",
"alchemist_acid_spray",
"alchemist_unstable_concoction",
"lycan_summon_wolves",
"lycan_feral_impulse",
"mars_spear",
"imba_snapfire_scatterblast",
"imba_snapfire_firesnap_cookie",
"imba_snapfire_lil_shredder",    --胡，老奶奶连射
"imba_brewmaster_thunder_clap",
"dragon_knight_breathe_fire",
"dragon_knight_dragon_tail",
"magnataur_shockwave",
"magnataur_empower",
"magnataur_skewer", --                          力量结束
"clinkz_wind_walk",
"viper_nethertoxin",
"razor_plasma_field",
"venomancer_venomous_gale",
"riki_smoke_screen",
"riki_tricks_of_the_trade",
"nyx_assassin_impale",
"nyx_assassin_mana_burn",
"nyx_assassin_spiked_carapace",--胡，原版小强皮
"vengefulspirit_magic_missile",
"vengefulspirit_wave_of_terror",
"stifling_dagger",
"spectre_spectral_dagger",
"antimage_blink",    --胡，原版敌法跳
"antimage_spell_shield",
"slark_dark_pact",
"slark_pounce",
"ursa_earthshock",
"ursa_overpower",
"h_exp",
"rocket_barrage",
"mirana_arrow",
"mirana_leap",
"mirana_starfall",
"medusa_mystic_snake",
"faceless_void_time_walk",
"faceless_void_time_lock",
"bloodseeker_blood_bath",
"imba_bounty_hunter_shuriken_toss",
"imba_bounty_hunter_wind_walk",  --胡，赏金隐身
"luna_lucent_beam",
"furion_teleportation", --胡，原版先知传送
"skywrath_mage_arcane_bolt",
"skywrath_mage_concussive_shot", --胡，原版天怒光蛋
"skywrath_mage_ancient_seal",
"grimstroke_dark_artistry",
"grimstroke_ink_creature",
"grimstroke_spirit_walk",
"dlzuus_ts", --胡，宙斯雷枪
"witch_doctor_paralyzing_cask",
"witch_doctor_maledict",
"imba_pugna_nether_blast",
"imba_pugna_decrepify",   --胡，原版骨法衰老
"disruptor_thunder_strike",
"disruptor_glimpse",
"disruptor_kinetic_field",
"dazzle_poison_touch",
"dazzle_shadow_wave",
"leshrac_split_earth",
"leshrac_diabolic_edict",    --胡，老鹿爆
"leshrac_lightning_storm",
"shadow_demon_soul_catcher",
"voodoo",    --胡，小T变羊
"warlock_fatal_bonds",
"warlock_shadow_word",
"warlock_upheaval",
"jakiro_dual_breath",
"jakiro_ice_path",
"obsidian_destroyer_astral_imprisonment",    --胡，原版黑鸟星体禁锢
"queenofpain_shadow_strike",
--"queenofpain_blink", --胡，原版女王跳
"queenofpain_scream_of_pain",
"necrolyte_death_pulse",
"necrolyte_sadist",
"bane_enfeeble",
"bane_brain_sap",
"bane_nightmare",
"lina_dragon_slave",
"lina_light_strike_array",
"lina_fiery_soul",
"lion_impale",
"lion_voodoo",  --胡，原版莱恩羊
"lion_mana_drain",
"imba_batrider_firefly", --胡，蝙蝠飞
"cold_feet",
"ice_vortex",
--"imba_dark_willow_shadow_realm", --天胡，小仙女变黑
"storm_spirit_electric_vortex",
"storm_spirit_static_remnant",
"windrun",
"imba_ogre_magi_focus",  --胡，蓝胖献祭
"imba_ogre_magi_Bloodlust",  --胡，蓝胖嗜血
"bunny_hop",
"surge" --                                                智力结束
}

TK_RD_funny={
  "imba_ogre_magi_multicast",
   --"phantom_assassin_blur",
   "super_meat",
  "rubick_arcane_supremacy",
}
--娱乐池子

RandomAbility_funny=
{
  "imba_ogre_magi_multicast",  --多重施法
  --  "coup_de_grace",  --恩赐解脱
  --"imba_dazzle_weave",  --暗影编织术
  --"arctic_burn",  --严寒灼烧
  --"super_polymerization",  --超融合
   "super_meat",  --D2护盾
  "rubick_arcane_supremacy",  --奥术至尊
  --"phantom_assassin_blur",  --模糊
  "imba_slark_essence_shift",  --能量转移
  -- "meat_hook",  --肉钩
  -- "flesh_heap",  --腐肉堆积
  "winter_wyvern_arctic_burn",  --冰龙飞
  --"ra_powanfa",  --公平决斗
  --"sniper_take_aim",  --瞄准
  -- "imba_dawnbreaker_luminosity",  --熠熠生辉
  -- "feral_impulse",  --野性驱使
  -- "psi_blades",  --太妹之刃
  
}
local date = GetSystemDate()
local day =string.sub(date,4,5)
RandomAbility_normal=RandomAbility
RandomAbility2_normal=RandomAbility2
TK_RD_normal=TK_RD
if day =="08"or day =="18" or day =="28" then
  RandomAbility2=RandomAbility_funny
  RandomAbility=RandomAbility_funny
  TK_RD=TK_RD_funny
end


----------------------------------------------------------------------------------------------------------------------------------

Neutral_EX={
  "item_desolator_2",--寂灭
  "item_penta_edged_sword", --五峰
  "item_pirate_hat",	--海盗帽
  "item_grove_bow",		--森林弓
  "item_timeless_relic", --永恒遗物
  "item_spell_prism",	--法术棱镜
  "item_seer_stone",	--先哲石
  "item_giants_ring",	--巨人戒
  "item_mirror_shield", --神镜盾
  "item_apex",			--极
  "item_force_field",   --秘术师铠甲
  "item_ninja_gear",    --忍者用具
  "item_book_of_shadows", --暗影法典
  "item_force_boots", 	--原力鞋
  --"item_ex_machina",	--机械心
  --"item_trickster_cloak",	--隐身斗篷
  --"item_ceremonial_robe",	--祭礼长袍
  --"item_possessed_mask",	--缚魂面具
  --"item_defiant_shell",		--不羁甲壳
  --"item_nemesis_curse",--天诛
  --"item_unwavering_condition",--坚毅之件
  --"item_doubloon",--双面币
  "item_paladin_sword",--骑士剑
  -- "item_ballista",--弩炮
  --"item_vindicators_axe",--正义之斧
  --"item_ogre_seal_totem"--食人魔海豹图腾
  "item_avianas_feather",--艾薇那之羽
  "item_elven_tunic",--精灵外衣
  "item_titan_sliver",--巨神残铁
  "item_safety_bubble",--安全泡泡
  
  
    "item_pogo_stick",	--玩具
}

NOT_RS_SK={
  "stampede",
  "hand_of_god",
  "black_hole",
  "macropyre",
  "omni_slash",
  "ghostship",
  "guardian_angel_new",
  "grenade",
  "poison_nova",
  "serpent_ward",
  "silencer_global_silence",
  "imba_tidehunter_ravage",
  "darkness",
  "imba_faceless_void_chronosphere"
  --"muerta_pierce_the_veil"
  
}

----------------------------------------------------------------------------------------------------------------------------------

HIDE_BUFF_Wearables=
{
    "modifier_elder_dragon_form",
    "modifier_polymerization",
    "modifier_item_hensin_buff"
}