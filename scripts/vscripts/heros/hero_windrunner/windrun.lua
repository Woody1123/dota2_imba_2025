windrun=windrun or class({})
LinkLuaModifier("modifier_windrun_buff", "heros/hero_windrunner/windrun.lua", LUA_MODIFIER_MOTION_NONE)
function windrun:IsHiddenWhenStolen()
    return false
end

function windrun:IsStealable()
    return true
end

function windrun:IsRefreshable()
    return true
end

function windrun:OnSpellStart()
    self.caster=self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")+self.caster:TG_GetTalentValue("special_bonus_windrunner_4")
    if  self.caster:IsAlive() then
        EmitSoundOn("Ability.Windrun",  self.caster)
        self.caster:AddNewModifier( self.caster, self, "modifier_windrun_buff", {duration=dur})
        if  self.caster:TG_HasTalent("special_bonus_windrunner_3") then
            self.caster:AddNewModifier( self.caster, self, "modifier_invisible", {duration=dur})
        end
    end
end



modifier_windrun_buff=modifier_windrun_buff or class({})

function modifier_windrun_buff:IsPurgable()
    return true
end

function modifier_windrun_buff:IsPurgeException()
    return true
end

function modifier_windrun_buff:IsHidden()
    return false
end

function modifier_windrun_buff:RemoveOnDeath()
	return true
end


function modifier_windrun_buff:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end


function modifier_windrun_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_windrun_buff:OnCreated( )
    if self:GetAbility() == nil  then
        return
    end
    self.sp=self:GetAbility():GetSpecialValueFor("sp")
    self.rd=self:GetAbility():GetSpecialValueFor("rd")
    if not IsServer() then
      return
    end
   self:StartIntervalThink(1)
end

function modifier_windrun_buff:OnIntervalThink()
        local heros = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			self:GetParent(),
            self.rd,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false )
		if #heros > 0 then
			for _,hero in pairs(heros) do
				if not hero:IsMagicImmune()  then
					local dis = math.max(400 - (self:GetParent():GetAbsOrigin() - hero:GetAbsOrigin()):Length2D(), 50)
					local Knockback ={
					  should_stun = 0.3, --打断
					  knockback_duration = 0.3, --击退时间 减去不能动的时间就是太空步的时间
					  duration = 0.3, --不能动的时间
					  knockback_height = 100,	--击退高度
					  knockback_distance = dis,
					  center_x =  self:GetParent():GetAbsOrigin().x,	--施法者为中心
					  center_y =  self:GetParent():GetAbsOrigin().y,
					  center_z =  self:GetParent():GetAbsOrigin().z,
						}	
					hero:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_knockback", Knockback)  --白牛的击退	
				end
			end
		end
end

function modifier_windrun_buff:CheckState()
    if self:GetParent():TG_HasTalent("special_bonus_windrunner_7") then
        return
        {
              [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        }
    end
    return {}
end


function modifier_windrun_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_DODGE_PROJECTILE,
	}
end

function modifier_windrun_buff:GetModifierDodgeProjectile()
    if RollPseudoRandomPercentage(25,0,self:GetParent()) then
        return 1
    else
        return 0
    end
end

function modifier_windrun_buff:GetActivityTranslationModifiers()
    return  "windrun"
end


function modifier_windrun_buff:GetModifierMoveSpeedBonus_Percentage()
    return  self.sp
end

function modifier_windrun_buff:GetModifierEvasion_Constant()
    return   100
end

function modifier_windrun_buff:GetModifierMoveSpeed_Limit()
    return 9999
end

function modifier_windrun_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_windrun_buff:GetModifierAvoidDamage(tg)
    if self:GetParent():TG_HasTalent("special_bonus_windrunner_8") then
        if PseudoRandom:RollPseudoRandom(self:GetAbility(), 25) then
            return 1
        else
            return 0
        end
    end
    return 0
end
