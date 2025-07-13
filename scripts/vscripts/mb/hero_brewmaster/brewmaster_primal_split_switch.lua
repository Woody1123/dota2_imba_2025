---------------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_PRIMAL_SPLIT_SWITCH     -------
---------------------------------------------------------------------
ENUM_EARTH = 1
ENUM_STORM = 2
ENUM_FIRE  = 3
ENUM_VOID  = 4

SPLIT_TYPE = {
	{ENUM_EARTH,"modifier_imba_brewmaster_earth"},
	{ENUM_STORM,"modifier_imba_brewmaster_storm"},
	{ENUM_FIRE,"modifier_imba_brewmaster_fire"},
	{ENUM_VOID,"modifier_imba_brewmaster_void"}
}

TEXTURE_TYPE = {
	{ENUM_EARTH,"brewmaster_earth_pulverize"},
	{ENUM_STORM,"brewmaster_storm_cyclone"},
	{ENUM_FIRE,"ember_spirit_sleight_of_fist"},
	{ENUM_VOID,"void_spirit_resonant_pulse"}
}

SHARD_TYPE = {
	{ENUM_EARTH,"modifier_imba_brewmaster_earth_spell_immunity"},
	{ENUM_STORM,"modifier_brewmaster_storm_wind_walk"},
	{ENUM_FIRE,"modifier_imba_brewmaster_fire_dash_fist"},
	{ENUM_VOID,"modifier_imba_brewmaster_void_astral_pulse"}
}

SHARD_TEXTURE_TYPE = {
	{ENUM_EARTH,"brewmaster_earth_spell_immunity"},
	{ENUM_STORM,"brewmaster_storm_wind_walk"},
	{ENUM_FIRE,"brewmaster_fire_permanent_immolation"},
	{ENUM_VOID,"brewmaster_void_astral_pulse"}
}

LinkLuaModifier("modifier_imba_brewmaster_primal_split_switch","mb/hero_brewmaster/brewmaster_primal_split_switch.lua", LUA_MODIFIER_MOTION_NONE)

--分裂选择
modifier_imba_brewmaster_primal_split_switch = class({})

function modifier_imba_brewmaster_primal_split_switch:IsDebuff()			return false end
function modifier_imba_brewmaster_primal_split_switch:IsHidden() 			return false end
function modifier_imba_brewmaster_primal_split_switch:IsPurgable() 			return false end
function modifier_imba_brewmaster_primal_split_switch:IsPurgeException() 	return false end
function modifier_imba_brewmaster_primal_split_switch:RemoveOnDeath() 		return false end
function modifier_imba_brewmaster_primal_split_switch:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE} end
function modifier_imba_brewmaster_primal_split_switch:GetModifierModelChange() return self.model_name end
function modifier_imba_brewmaster_primal_split_switch:GetStatusEffectName()	return self.model_effect end
function modifier_imba_brewmaster_primal_split_switch:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_brewmaster_primal_split_switch:OnCreated() 
	self.effect_table = {
		{"models/heroes/brewmaster/brewmaster_earthspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf"}, --earth
		{"models/heroes/brewmaster/brewmaster_windspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf"}, --wind 
		{"models/heroes/brewmaster/brewmaster_firespirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf"}, --fire 
		{"models/heroes/brewmaster/brewmaster_voidspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf"} --void  		
	}
	self.model_name = self.effect_table[math.max(self:GetStackCount(),1)][1]
	self.model_effect = self.effect_table[math.max(self:GetStackCount(),1)][2]
	self:SetStackCount(1)
end

function modifier_imba_brewmaster_primal_split_switch:OnRefresh() 
	self.model_name = self.effect_table[math.max(self:GetStackCount(),1)][1]
	self.model_effect = self.effect_table[math.max(self:GetStackCount(),1)][2]
end

---------------------------------------------------------------------
----------------     BREWMASTER PRIMAL SPLIT SWITCH   ---------------
---------------------------------------------------------------------
imba_brewmaster_primal_split_switch = class({})

function imba_brewmaster_primal_split_switch:IsHiddenWhenStolen() 	return false end
function imba_brewmaster_primal_split_switch:IsRefreshable() 		return false end
function imba_brewmaster_primal_split_switch:IsStealable() 			return false end
function imba_brewmaster_primal_split_switch:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	--SwitchAbility
	if caster:HasModifier("modifier_imba_brewmaster_primal_split_switch") then
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil) 	
		split_type = split_type + 1
		if split_type > ( caster:HasScepter() and ENUM_VOID or ENUM_FIRE) then 
			split_type = ENUM_EARTH
		end
		caster:SetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil, split_type)
		caster:FindModifierByName("modifier_imba_brewmaster_primal_split_switch"):OnRefresh()
	else
		caster:AddNewModifierWhenPossible(caster, self, "modifier_imba_brewmaster_primal_split_switch", {})
		caster:SetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil, 1)
	end
end