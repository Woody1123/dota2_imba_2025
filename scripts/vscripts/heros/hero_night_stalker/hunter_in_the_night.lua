hunter_in_the_night=class({})
LinkLuaModifier("modifier_hunter_in_the_night", "heros/hero_night_stalker/hunter_in_the_night.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hunter_in_the_night_ch", "heros/hero_night_stalker/hunter_in_the_night.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hunter_in_the_night_fly",  "heros/hero_night_stalker/hunter_in_the_night.lua", LUA_MODIFIER_MOTION_NONE)
function hunter_in_the_night:IsHiddenWhenStolen()
    return false
end

function hunter_in_the_night:IsStealable()
    return false
end

function hunter_in_the_night:GetIntrinsicModifierName()
    return "modifier_hunter_in_the_night"
end


function hunter_in_the_night:CastFilterResult()
    if not self:GetCaster():HasModifier("modifier_hunter_in_the_night_fly") then
        return UF_FAIL_CUSTOM
	end
end

function hunter_in_the_night:GetCustomCastError()
    return "需要开启大招才能使用"
end


function hunter_in_the_night:OnSpellStart()
    self:GetCaster():EmitSound("TG.roar")
	
end


function hunter_in_the_night:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()
    if bInterrupted then
        caster:StopSound("TG.roar")
        caster:Interrupt()
        caster:Stop()
    else
        local dur=self:GetSpecialValueFor("dur")
        local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if targets~=nil then
            for _, target in pairs(targets) do
                if target~= caster and target:IsRealHero()then
                target:AddNewModifier( caster, self, "modifier_hunter_in_the_night_ch", {duration=dur} )
                    if caster:HasScepter() and caster:HasAbility( "crippling_fear" ) then
                        local AB=caster:FindAbilityByName( "crippling_fear"  )
                             if AB then
                                    if AB:GetLevel()>=1 then
                                        local rd=AB:GetSpecialValueFor("rd")
                                        target:AddNewModifier( caster, self, "modifier_crippling_fear", {duration=dur/2,rd=rd/2} )
                                    end
                             end
                    end
                end
			end
		end
    end
end




modifier_hunter_in_the_night=modifier_hunter_in_the_night or class({})

function modifier_hunter_in_the_night:IsPassive()
	return true
end

function modifier_hunter_in_the_night:IsPurgable()
    return false
end

function modifier_hunter_in_the_night:IsPurgeException()
    return false
end

function modifier_hunter_in_the_night:AllowIllusionDuplicate()
    return false
end

function modifier_hunter_in_the_night:OnCreated()
	if self:GetAbility() == nil then return end
	if not IsServer() then
		return
    end
    self:StartIntervalThink(1)
end

function modifier_hunter_in_the_night:OnIntervalThink()

    if not IsServer() then
		return
    end
    if self:GetParent():IsAlive() then
        if not GameRules:IsDaytime()  or GameRules:IsNightstalkerNight() then
            if self:GetParent():GetModelName()=="models/heroes/nightstalker/nightstalker.vmdl" then
                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
                ParticleManager:ReleaseParticleIndex(pfx)
                local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_loadout.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
                ParticleManager:ReleaseParticleIndex(pfx2)
                self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_hunter_in_the_night_ch", {} )
                end
				if not self:GetParent():HasModifier("modifier_hunter_in_the_night_fly") then
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hunter_in_the_night_fly", {duration = 60})
				end
        else
                if self:GetParent():GetModelName()=="models/heroes/nightstalker/nightstalker_night.vmdl" then
                    self:GetParent():RemoveModifierByName("modifier_hunter_in_the_night_ch")
                end
				self:GetParent():RemoveModifierByName("modifier_hunter_in_the_night_fly")
        end
    end
end

function modifier_hunter_in_the_night:OnAttackLanded(tg)
    if not IsServer() then
		return
	end

    if tg.attacker == self:GetParent() and (not GameRules:IsDaytime()  or GameRules:IsNightstalkerNight() ) then
        if tg.target:IsBuilding() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
            return
        end
        local dam=tg.attacker:GetNightTimeVisionRange()*(self:GetAbility():GetSpecialValueFor("dam")+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_7")) *0.01
        local damage= {
            victim = tg.target,
            attacker = tg.attacker,
            damage =dam,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags =DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            ability = self:GetAbility(),
            }
            ApplyDamage(damage)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, tg.target, dam, nil)
			
    end
end

function modifier_hunter_in_the_night:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_hunter_in_the_night:GetModifierMoveSpeedBonus_Percentage()
        if self:GetParent():PassivesDisabled() then
            return 0
        end
        return self:GetAbility():GetSpecialValueFor("sp")+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_4")
end

function modifier_hunter_in_the_night:GetModifierAttackSpeedBonus_Constant()
        if self:GetParent():PassivesDisabled() then
            return 0
        end
        return self:GetAbility():GetSpecialValueFor("attsp")+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_3")
end


modifier_hunter_in_the_night_fly = modifier_hunter_in_the_night_fly or class({})
function modifier_hunter_in_the_night_fly:IsHidden()
    return true
end

function modifier_hunter_in_the_night_fly:IsPurgable()
    return false
end

function modifier_hunter_in_the_night_fly:IsPurgeException()
        return false
end
function modifier_hunter_in_the_night_fly:RemoveOnDeath()
    return true
end

function modifier_hunter_in_the_night_fly:GetEffectName()
    return   "particles/units/heroes/hero_night_stalker/nightstalker_dark_buff.vpcf"

   end

function modifier_hunter_in_the_night_fly:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hunter_in_the_night_fly:OnCreated()
	if self:GetAbility() == nil then return end

	if not IsServer() then
		return
    end

    local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_night_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(pfx, false, false, 20, false, false)
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_bats.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl(pfx2, 0,self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx2, 2,self:GetParent():GetAbsOrigin())
    self:AddParticle(pfx2, false, false, 20, false, false)
end

function modifier_hunter_in_the_night_fly:OnDestroy()
    if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
    end
end

function modifier_hunter_in_the_night_fly:CheckState()
    return{[MODIFIER_STATE_FLYING] = true}
end

function modifier_hunter_in_the_night_fly:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
    }
end

function modifier_hunter_in_the_night_fly:GetActivityTranslationModifiers()
    return "hunter_night"
end

function modifier_hunter_in_the_night_fly:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function modifier_hunter_in_the_night_fly:GetOverrideAnimationWeight()
    return 1
end

modifier_hunter_in_the_night_ch = class({})

function modifier_hunter_in_the_night_ch:IsHidden()
	if self:GetParent()==self:GetCaster() then
        return true
    else
        return false
    end
end

function modifier_hunter_in_the_night_ch:IsPurgable()
    return false
end

function modifier_hunter_in_the_night_ch:IsPurgeException()
    return false
end

function modifier_hunter_in_the_night_ch:OnCreated()
	if self:GetAbility() == nil then return end
    self.sp = self:GetAbility():GetSpecialValueFor("sp")
    self.attsp = self:GetAbility():GetSpecialValueFor("attsp")
    if not IsServer() then
		return
    end
    self.m2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_tail_night.vmdl"})
    self.m2:SetParent(self:GetParent(), nil)
    self.m2:FollowEntity(self:GetParent(), true)
    self.m3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_wings_night.vmdl"})
    self.m3 :SetParent(self:GetParent(), nil)
    self.m3 :FollowEntity(self:GetParent(), true)
end

function modifier_hunter_in_the_night_ch:OnRefresh()
    self:OnDestroy()
    self:OnCreated()
end

function modifier_hunter_in_the_night_ch:OnDestroy()

    if  IsServer() then
	    self.m2:RemoveSelf()
        self.m3:RemoveSelf()
    end
end

function modifier_hunter_in_the_night_ch:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end



function modifier_hunter_in_the_night_ch:GetModifierModelChange()
    return  "models/heroes/nightstalker/nightstalker_night.vmdl"
end

function modifier_hunter_in_the_night_ch:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent()~=self:GetCaster() then
        return self.sp
    else
        return 0
    end
end

function modifier_hunter_in_the_night_ch:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent()~=self:GetCaster() then
        return self.attsp
    else
        return 0
    end
end