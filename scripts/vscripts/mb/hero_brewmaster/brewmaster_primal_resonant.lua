---------------------------------------------------------------------
----------------     BREWMASTER PRIMAL RESONANT   -------------------
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

imba_brewmaster_primal_resonant = class({})

LinkLuaModifier("modifier_imba_brewmaster_earth_spell_immunity","mb/hero_brewmaster/brewmaster_primal_resonant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire_dash_fist","mb/hero_brewmaster/brewmaster_primal_resonant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire_dash_fist_buff","mb/hero_brewmaster/brewmaster_primal_resonant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_void_astral_pulse","mb/hero_brewmaster/brewmaster_primal_resonant.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_primal_resonant:IsHiddenWhenStolen() 		return false end
function imba_brewmaster_primal_resonant:IsRefreshable() 			return true end
function imba_brewmaster_primal_resonant:IsStealable() 			return false end
function imba_brewmaster_primal_resonant:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil)
		--返回对应技能图标
		for k,v in pairs(SHARD_TEXTURE_TYPE) do
		    if v[1] == split_type then
		        return SHARD_TEXTURE_TYPE[k][2]
		    end
		end
	end
	return "brewmaster_earth_spell_immunity"
end
--魔晶
--brewmaster_void_astral_pulse --2021 8 22 by MysticBug-------
function imba_brewmaster_primal_resonant:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	local caster=self:GetCaster()
	if self:GetCaster():Has_Aghanims_Shard() then 
        TG_Set_Scepter(caster,false,math.max(math.floor(math.min(caster:GetLevel(),18)/6),1),"imba_brewmaster_primal_resonant")
    else
        TG_Set_Scepter(caster,true,math.max(math.floor(math.min(caster:GetLevel(),18)/6),1),"imba_brewmaster_primal_resonant")
    end
	---------------------------------------------------------------
end

function imba_brewmaster_primal_resonant:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	--Sound
	caster:EmitSound("Brewmaster_Void.Pulse")
	return true
end

function imba_brewmaster_primal_resonant:OnUpgrade()
	if not self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then
		self:GetCaster():AddNewModifierWhenPossible(self:GetCaster(), self, "modifier_imba_brewmaster_primal_split_switch", {})
	end
	local caster = self:GetCaster()
	local primal_split_switch = caster:FindAbilityByName("imba_brewmaster_primal_split_switch")
	if primal_split_switch then 
		primal_split_switch:SetLevel(self:GetLevel())
	end
end

function imba_brewmaster_primal_resonant:OnSpellStart()
	local caster             = self:GetCaster()
	local duration           = self:GetSpecialValueFor("duration")
	local wind_walk_duration = self:GetSpecialValueFor("wind_walk_duration")
	--check type 
	if caster:HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local shard_type = math.max(caster:GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil),1)
		--添加对应技能mod
		for k,v in pairs(SHARD_TYPE) do
		    if v[1] == shard_type then
		    	caster:AddNewModifier(
		    			caster, -- player source
		    			self, -- ability source
		    			SHARD_TYPE[k][2], -- modifier name
		    			{ duration = (shard_type == ENUM_STORM and wind_walk_duration or duration) } -- kv
		    		)
		    end
		end
	end
end

---------------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_EARTH_SPELL_IMMUNITY    -------
---------------------------------------------------------------------

modifier_imba_brewmaster_earth_spell_immunity = class({})

function modifier_imba_brewmaster_earth_spell_immunity:IsHidden() 		return false end
function modifier_imba_brewmaster_earth_spell_immunity:IsPurgable() 	return false end
function modifier_imba_brewmaster_earth_spell_immunity:IsPurgeException() return false end
function modifier_imba_brewmaster_earth_spell_immunity:OnCreated()  
	if IsServer() then  self:GetCaster():EmitSound("Brewmaster_Earth.Attack") end
end
function modifier_imba_brewmaster_earth_spell_immunity:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_EARTH][2] end
function modifier_imba_brewmaster_earth_spell_immunity:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf" end
function modifier_imba_brewmaster_earth_spell_immunity:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_brewmaster_earth_spell_immunity:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end

---------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_FIRE_DASH_FIST    -------
---------------------------------------------------------------

modifier_imba_brewmaster_fire_dash_fist = class({})

function modifier_imba_brewmaster_fire_dash_fist:IsDebuff()			return false end
function modifier_imba_brewmaster_fire_dash_fist:IsHidden() 		return true end
function modifier_imba_brewmaster_fire_dash_fist:IsPurgable() 		return false end
function modifier_imba_brewmaster_fire_dash_fist:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire_dash_fist:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_FIRE][2] end
function modifier_imba_brewmaster_fire_dash_fist:OnCreated() 
	if IsServer() then
		self.ability              = self:GetAbility()
		self.caster               = self.ability:GetCaster()
		self.parent               = self:GetParent()
		self.fire_attack_interval = self.ability:GetSpecialValueFor("fire_attack_interval")
		self.fire_radius          = self.ability:GetSpecialValueFor("radius")
		self:SpellFireOfFist()
	end
end
function modifier_imba_brewmaster_fire_dash_fist:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_fire_dash_fist:SpellFireOfFist()
	if not IsServer() then return end
	--kv 
	local pos     = self.caster:GetAbsOrigin()
	local team    = self.caster:GetTeamNumber()
	local cur_pos = pos + self.caster:GetForwardVector() * self.fire_radius
	local fpos    = pos + TG_Direction(cur_pos,pos) * self.fire_radius
	local stack   = 1
	local heroes  = {}
    local op = {}
    --Brewmaster_Fire.Attack
    EmitSoundOn("Hero_EmberSpirit.SleightOfFist.Cast", self.caster)  
    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pf, 0,cur_pos)
    ParticleManager:SetParticleControl(pf, 1,fpos)
    ParticleManager:ReleaseParticleIndex(pf)   
    --line 
    heroes = FindUnitsInLine(team,pos,fpos,self.caster,250,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    if #heroes>0 then 
    	self.ability:SetActivated(false) 
        local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pf1, 0, pos)
        ParticleManager:SetParticleControlForward(pf1, 1, self.caster:GetForwardVector())
        ParticleManager:SetParticleControl(pf1, 62, Vector(10, 0, 0))
        for a=1,#heroes do
            op[a] = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, heroes[a])
            ParticleManager:SetParticleControl( op[a], 0, heroes[a]:GetAbsOrigin())
        end
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_fire_dash_fist_buff", {})
        Timers:CreateTimer(0, function()
            if  heroes~=nil and stack<=#heroes then 
                if heroes[stack]~=nil and heroes[stack]:IsAlive() then 
					local tpos  = heroes[stack]:GetAbsOrigin()
					local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
                    ParticleManager:SetParticleControl(trail, 0,self.caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(trail, 1,tpos)
                    ParticleManager:ReleaseParticleIndex(trail)   
                    if  not self.caster:HasModifier("modifier_activate_fire_remnant") then 
                        self.caster:SetAbsOrigin(tpos)
                    end
                    self.caster:PerformAttack(heroes[stack], false, true, true, false, false, false, false)
                    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroes[stack])
                    ParticleManager:SetParticleControl(pf, 0,tpos)
                    ParticleManager:ReleaseParticleIndex(pf)       
                        if op[stack]~=nil then 
                            ParticleManager:DestroyParticle(op[stack], false)
                            ParticleManager:ReleaseParticleIndex(op[stack])
                        end
                end
                stack=stack+1
            else 
                self:EndFireOfFist(op,pf1) 
                FindClearSpaceForUnit(self.caster, pos, true)
                return nil 
            end 
                return self.caster:HasModifier("modifier_activate_fire_remnant") and 0 or self.fire_attack_interval
        end
        )
    end 
end

function modifier_imba_brewmaster_fire_dash_fist:EndFireOfFist(op,pf1) 			
    if op~=nil then 
        for a=1,#op do
            ParticleManager:DestroyParticle(op[a], false)
            ParticleManager:ReleaseParticleIndex(op[a])
        end
    end
    if self.caster:HasModifier("modifier_imba_brewmaster_fire_dash_fist_buff") then 
        self.caster:RemoveModifierByName("modifier_imba_brewmaster_fire_dash_fist_buff")
    end 
    if  pf1~=nil then 
        ParticleManager:DestroyParticle(pf1, false)
        ParticleManager:ReleaseParticleIndex(pf1)
    end 
end

------------------------------------------------------------------
modifier_imba_brewmaster_fire_dash_fist_buff=class({})

function modifier_imba_brewmaster_fire_dash_fist_buff:IsHidden() 			return true end
function modifier_imba_brewmaster_fire_dash_fist_buff:IsPurgable() 			return false end
function modifier_imba_brewmaster_fire_dash_fist_buff:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire_dash_fist_buff:CheckState() 
    return 
    {
		[MODIFIER_STATE_INVULNERABLE]                    = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION]               = true, 
		[MODIFIER_STATE_CANNOT_MISS]                     = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR]                   = true, 
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
    } 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    } 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:OnCreated()	
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
end

function modifier_imba_brewmaster_fire_dash_fist_buff:OnDestroy()	
    if IsServer() then    
        self.ability:SetActivated(true)
    end 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:GetModifierIgnoreCastAngle() return 1 end

------------------------------------------------------------------
-------      modifier_imba_brewmaster_void_astral_pulse    -------
------------------------------------------------------------------

modifier_imba_brewmaster_void_astral_pulse = class({})

function modifier_imba_brewmaster_void_astral_pulse:IsDebuff()			return false end
function modifier_imba_brewmaster_void_astral_pulse:IsHidden() 			return false end
function modifier_imba_brewmaster_void_astral_pulse:IsPurgable() 		return false end
function modifier_imba_brewmaster_void_astral_pulse:IsPurgeException() 	return false end
function modifier_imba_brewmaster_void_astral_pulse:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_VOID][2] end
function modifier_imba_brewmaster_void_astral_pulse:OnCreated() 
	if IsServer() then
		self.ability              = self:GetAbility()
		self.caster               = self.ability:GetCaster()
		self.parent               = self:GetParent()
		self.void_slow 			  = self.ability:GetSpecialValueFor("slow")
		self.void_radius          = self.ability:GetSpecialValueFor("radius")
		self.void_duration        = self.ability:GetSpecialValueFor("duration")
		--PFX
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_POINT_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.void_radius*3, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle) 
		--AOE 
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.void_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				enemy:AddNewModifier_RS(self.caster, self.ability, "modifier_brewmaster_void_astral_pulse", {duration = self.void_duration })
				self.caster:PerformAttack(enemy, false, false, true, false, false, false, false)
		    end	
		end
	end
end
function modifier_imba_brewmaster_void_astral_pulse:OnRefresh()
	self:OnCreated()
end