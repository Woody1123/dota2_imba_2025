chilling_touch= class({})

LinkLuaModifier("modifier_chilling_touch_att", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chilling_touch_debuff", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chilling_touch_f", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)

function chilling_touch:GetIntrinsicModifierName()
    return "modifier_chilling_touch_att"
end

function chilling_touch:GetManaCost(iLevel)
    if self:GetCaster():HasScepter() then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function chilling_touch:OnSpellStart()

		local pos = self:GetCursorPosition() 
		local caster = self:GetCaster()
		if not caster:Has_Aghanims_Shard() then
			return
		end
		local dis = self:GetAutoCastState() and self:GetSpecialValueFor("dis")+caster:GetCastRangeBonus() or caster:Script_GetAttackRange()
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
				local Projectile =
				{
					Ability = self,
					EffectName = "particles/tgp/maiden_crystal/snowball_m.vpcf",
					vSpawnOrigin =caster:GetAbsOrigin(),
					fDistance = dis,
					fStartRadius = 250,
					fEndRadius = 250,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					vVelocity = direction*800,
					bProvidesVision = true,
					iVisionRadius=300,
					iVisionTeamNumber=caster:GetTeamNumber(),
					ExtraData = {dir_x = direction.x,dir_y = direction.y,dir_z = direction.z,dis=dis}
				}
				ProjectileManager:CreateLinearProjectile(Projectile)
end

function chilling_touch:OnProjectileHit_ExtraData(target, location,kv)
    	local caster = self:GetCaster()
        if not target then
            return
        end
			local Knockback={
				should_stun = not target:IsMagicImmune(),
				knockback_duration = target:IsMagicImmune() and 0.75 or 1.5,
				duration = target:IsMagicImmune() and 0.75 or 1.5,
				knockback_height=100,
				knockback_distance=600,
			}
			if kv.dir_x then
				local dir = Vector(kv.dir_x,kv.dir_y,kv.dir_z)
				local dis = math.max(30,kv.dis - (target:GetAbsOrigin()-caster:GetAbsOrigin()):Length2D())
				if target:IsMagicImmune() then
					dis = dis/2
				end
				Knockback.knockback_height = 0
                Knockback.knockback_distance = dis
                Knockback.center_x = target:GetAbsOrigin().x-dir.x
                Knockback.center_y = target:GetAbsOrigin().y-dir.y
                Knockback.center_z = target:GetAbsOrigin().z
				target:AddNewModifier_RS(caster,self, "modifier_knockback", Knockback)
			end
end
modifier_chilling_touch_att=class({})

function modifier_chilling_touch_att:IsPassive()
	return true
end

function modifier_chilling_touch_att:IsPurgable()
    return false
end

function modifier_chilling_touch_att:IsPurgeException()
    return false
end

function modifier_chilling_touch_att:IsHidden()
    return true
end



function modifier_chilling_touch_att:GetModifierProjectileName()
    if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not self:GetAbility():IsOwnersManaEnough() then
        return ""
    end
    return  "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end


function modifier_chilling_touch_att:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_PROJECTILE_NAME,
    --MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end

function modifier_chilling_touch_att:GetModifierProjectileSpeedBonus()
	return 800
end


function modifier_chilling_touch_att:OnCreated()
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.ATTR=self:GetAbility():GetSpecialValueFor("attr")
    self.DAM=self:GetAbility():GetSpecialValueFor("dam")
    self.dur=self:GetAbility():GetSpecialValueFor("slowtime")
end

function modifier_chilling_touch_att:OnRefresh()
   self:OnCreated()
end


function modifier_chilling_touch_att:GetModifierAttackRangeBonus()
    return self.ATTR+self:GetParent():TG_GetTalentValue("special_bonus_ancient_apparition_4")
end



function modifier_chilling_touch_att:OnAttackLanded(tg)
    if self.parent:PassivesDisabled() or self.parent:IsIllusion()  or tg.target:IsBuilding() or not self.ability:IsCooldownReady() then
            return
    end

    if not IsServer() then
        return
	end

    if tg.attacker == self:GetParent() then
        if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not self:GetAbility():IsOwnersManaEnough() then
            return
        end
        self:GetAbility():UseResources(true,false,false, false)
        local dam=self.DAM+self:GetParent():TG_GetTalentValue("special_bonus_ancient_apparition_3")*self:GetParent():GetIntellect(false)
        if tg.target:IsBuilding() then
                dam=self:GetParent():Has_Aghanims_Shard() or dam*0.2 and dam*0.1
            else
                local critr=self:GetAbility():GetSpecialValueFor("critr")+self:GetParent():TG_GetTalentValue("special_bonus_ancient_apparition_5")/100
                dam=(self:GetParent():HasModifier("modifier_cold_feet_buff") or self:GetParent():HasModifier("modifier_ice_blast_buff")) and dam*(critr) or dam
        end

        --如果没有魔免且没有天赋则上减速BUFF
        if not tg.target:IsMagicImmune()  then
            tg.target:AddNewModifier_RS(caster, ability, "modifier_paralyzed", {duration = self.dur})
            --tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chilling_touch_f", {duration=self.dur})
        elseif self:GetParent():TG_HasTalent("special_bonus_ancient_apparition_7") then
            tg.target:AddNewModifier_RS(caster, ability, "modifier_paralyzed", {duration = self.dur/2})
            --tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chilling_touch_f", {duration=self.dur/2})
        end




		local damage= {
            victim = tg.target,
            attacker = self:GetParent(),
            damage = dam,
            --damage_type = self:GetCaster():TG_HasTalent("special_bonus_ancient_apparition_7") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            }
        ApplyDamage(damage)
		EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Target", tg.target)
	end
end


--modifier_chilling_touch_f=class({})
--
--function modifier_chilling_touch_f:IsPurgable()
--    return true
--end
--
--function modifier_chilling_touch_f:IsPurgeException()
--    return true
--end
--
--function modifier_chilling_touch_f:IsHidden()
--    return false
--end
--
--function modifier_chilling_touch_f:IsDebuff()
--    return true
--end
--
--function modifier_chilling_touch_f:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
--
--
--function modifier_chilling_touch_f:GetModifierMoveSpeedBonus_Percentage()
--    if self:GetParent():IsMagicImmune() then
--        return -50
--    end
--    return -100
--end

--function modifier_chilling_touch_f:CheckState()
--    return
--    {
--        [MODIFIER_STATE_FROZEN] = true,
--        [MODIFIER_STATE_STUNNED]=true,
--        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED]=true,
--    }
--end
