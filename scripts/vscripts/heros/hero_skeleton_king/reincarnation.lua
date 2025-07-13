reincarnation=class({})
LinkLuaModifier("modifier_reincarnation", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_sp", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_buff", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_attsp", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_ghost", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_ghost_cd", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
function reincarnation:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if target==caster or not target:IsRealHero() or not Is_Chinese_TG(caster,target)  then
		return UF_FAIL_CUSTOM
	end
end

function reincarnation:GetCustomCastErrorTarget(target)
        return "无法对其使用"
end

function reincarnation:GetCastRange()
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_6") then
        return 800
    else
        return 0
    end
end

function reincarnation:GetManaCost(iLevel)
    if self:GetCaster():Has_Aghanims_Shard() then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function reincarnation:GetBehavior()
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_6") then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    else
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
end

function reincarnation:GetIntrinsicModifierName()
    return "modifier_reincarnation"
end

function reincarnation:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
    caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW ,target)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    if target~=caster then
        target:AddNewModifier(caster, self, "modifier_reincarnation", {duration=30})
    end
end


modifier_reincarnation = class({})

function modifier_reincarnation:IsHidden()
    if self:GetParent()== self:GetCaster() then
        return true
    else
        return false
    end
end

function modifier_reincarnation:IsPurgable()
    return false
end

function modifier_reincarnation:IsPurgeException()
     return false
end

function modifier_reincarnation:AllowIllusionDuplicate()
    return false
end

function modifier_reincarnation:DeclareFunctions()
    return
     {
         MODIFIER_PROPERTY_REINCARNATION,
         MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_DAMAGE_CALCULATED,	
    }
end
--[[
function modifier_reincarnation:OnDamageCalculated(keys)
	if IsServer() then
            if self.parent==self.caster and self.parent==keys.target and keys.target:HasScepter() and not self.ab:IsCooldownReady() and self.cd==false then
			if self.parent:GetHealth()-keys.damage<=100 then
					keys.target:AddNewModifier( keys.target, self:GetAbility(), "modifier_reincarnation_ghost", {duration=7})
					keys.target:AddNewModifier( keys.target, self:GetAbility(), "modifier_reincarnation_attsp", {duration=7})
					self:StartIntervalThink(7.5)
					self.cd = true
				  end
            end
	end
end]]

function modifier_reincarnation:OnCreated() 	
	if self:GetAbility() == nil then return end
	
	if IsServer() then
		self.cd = false
		self.ab = self:GetParent():FindAbilityByName("reincarnation")
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
	end
end
function modifier_reincarnation:OnIntervalThink() 	
	self.cd = false
		print(self.cd)
		print("计时器")
	--print("132")
	self:StartIntervalThink(-1)
end

function modifier_reincarnation:ReincarnateTime()
    if not IsServer() then
        return
    end
	if (self:GetAbility():IsCooldownReady() and  self:GetAbility():IsOwnersManaEnough()) or self:GetParent()~=self:GetCaster() then
        self:GetParent():EmitSound("Hero_SkeletonKing.Reincarnate")
        self:GetAbility():UseResources(true,false,  false, true)
            local AB=self:GetCaster():FindAbilityByName("vampiric_aura")
            if AB~=nil and AB:GetLevel()>0 then
                AB:EndCooldown()
            end

            local AB1=self:GetCaster():FindAbilityByName("hellfire_blast")
            if AB1~=nil and AB1:GetLevel()>0 then
                AB1:EndCooldown()
            end

        if self:GetParent()==self:GetCaster() then
            Timers:CreateTimer(4.1, function()
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_reincarnation_attsp", {duration=self:GetAbility():GetSpecialValueFor("dur2")})
                return nil
            end)
        end
        return self:GetAbility():GetSpecialValueFor("reincarnate_time")
	else
		return nil
	end
end

function modifier_reincarnation:OnDeath(tg)
	if IsServer() then
        if tg.unit == self:GetParent() and not self:GetParent():IsIllusion() then
		local a = self.cd
		print(a)
		print("死亡")
            local heros = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),
                self:GetParent():GetAbsOrigin(),
                nil,
                self:GetAbility():GetSpecialValueFor("slow_radius"),
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false)
                if #heros>0 then
                    for _, hero in pairs(heros) do
                        if hero:IsAlive() and hero:IsRealHero() then
                            hero:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_reincarnation_sp", {duration=self:GetAbility():GetSpecialValueFor("slow_duration")})
                        end
                    end
                end

        end
    end
end

modifier_reincarnation_sp = class({})

function modifier_reincarnation_sp:IsDebuff()
    return true
end

function modifier_reincarnation_sp:IsHidden()
    return false
end

function modifier_reincarnation_sp:IsPurgable()
    return true
end

function modifier_reincarnation_sp:IsPurgeException()
    return true
end

function modifier_reincarnation_sp:GetEffectName()
    return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
end

function modifier_reincarnation_sp:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_reincarnation_sp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_reincarnation_sp:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed
end

function modifier_reincarnation_sp:GetModifierAttackSpeedBonus_Constant()
    return self.attackslow
end

function modifier_reincarnation_sp:OnCreated()
	if self:GetAbility() == nil then return end
   self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
   self.attackslow = self:GetAbility():GetSpecialValueFor("attackslow")
end

modifier_reincarnation_buff=class({})

function modifier_reincarnation_buff:IsDebuff()
    return false
end

function modifier_reincarnation_buff:IsHidden()
    return true
end

function modifier_reincarnation_buff:IsPurgable()
    return false
end

function modifier_reincarnation_buff:IsPurgeException()
    return false
end

modifier_reincarnation_attsp=class({})

function modifier_reincarnation_attsp:IsDebuff()
    return false
end

function modifier_reincarnation_attsp:IsHidden()
    return false
end

function modifier_reincarnation_attsp:IsPurgable()
    return false
end

function modifier_reincarnation_attsp:IsPurgeException()
    return false
end

function modifier_reincarnation_attsp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
end

function modifier_reincarnation_attsp:GetModifierStatusResistanceStacking() 
	return self.resistance
end
function modifier_reincarnation_attsp:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attsp")
end
function modifier_reincarnation_attsp:OnCreated()
	if self:GetAbility()==nil then return end
	self.resistance = self:GetAbility():GetSpecialValueFor("resistance")
	self.attsp = self:GetAbility():GetSpecialValueFor("attsp")
end
modifier_reincarnation_ghost=class({})
function modifier_reincarnation_ghost:IsPurgable()return false
end
function modifier_reincarnation_ghost:IsPurgeException()return false
end
function modifier_reincarnation_ghost:GetStatusEffectName()return "particles/tgp/king/status_effect_ghost.vpcf"
end
function modifier_reincarnation_ghost:IsDebuff() return false end

function modifier_reincarnation_ghost:OnCreated()
    if IsServer() then
        --print(self:GetCaster())
        self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_reincarnation_ghost_cd", {duration=8})
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_reincarnation_attsp", {duration=6})
		 self:GetParent():Purge(false, true, false, true, true)
		local ab = self:GetParent():FindAbilityByName("vampiric_aura")
		if ab and ab:GetLevel() > 0 then
			self:GetParent():AddNewModifier( self:GetParent(), ab,"modifier_vampiric_aura_buff3",{duration = 6})
		end
--[[
        if self:GetCaster() then
            self.attacker=self:GetCaster()
        else
            self.attacker=self:GetParent()
        end]]
    end
end

function modifier_reincarnation_ghost:StatusEffectPriority()return 4
end
function modifier_reincarnation_ghost:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MIN_HEALTH,	
	}
end
function modifier_reincarnation_ghost:GetDisableHealing()return 1
end
function modifier_reincarnation_ghost:GetMinHealth()return 1
end
function modifier_reincarnation_ghost:GetAbsoluteNoDamageMagical()return 1
end
function modifier_reincarnation_ghost:GetAbsoluteNoDamagePhysical()return 1
end
function modifier_reincarnation_ghost:GetAbsoluteNoDamagePure()return 1
end
function modifier_reincarnation_ghost:OnDestroy()
        if IsServer() then
			if self:GetParent().killer ~= nil then
				self:GetParent():Kill(self:GetAbility(), self:GetParent().killer)
				else
				self:GetParent():Kill(self:GetAbility(), self:GetParent())
			end
        end
end

modifier_reincarnation_ghost_cd=class({})

function modifier_reincarnation_ghost_cd:IsHidden()
    return true
end

function modifier_reincarnation_ghost_cd:IsPurgable()return false
end
function modifier_reincarnation_ghost_cd:IsPurgeException()return false
end