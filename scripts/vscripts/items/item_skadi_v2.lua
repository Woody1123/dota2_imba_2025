item_skadi_v2 = class({})

LinkLuaModifier("modifier_item_skadi_v2_pa", "items/item_skadi_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_v2_slow", "items/item_skadi_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_v2_stun", "items/item_skadi_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_skadi_v2:GetIntrinsicModifierName()
    return "modifier_item_skadi_v2_pa"
end

function item_skadi_v2:OnSpellStart()
	local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local radius = self:GetSpecialValueFor("rd")
    local dur = self:GetSpecialValueFor("rdt")
    caster:EmitSound("Hero_Crystal.CrystalNova.Cast")
    local fx = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(fx, 0, pos)
    ParticleManager:SetParticleControl(fx, 3, pos+caster:GetUpVector()*200)
	ParticleManager:ReleaseParticleIndex(fx)

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for _, target in pairs(enemies) do
		if (target:IsMagicImmune() and target:GetMoveSpeedModifier(target:GetBaseMoveSpeed(), true)>550) or not target:IsMagicImmune() then
			duration = dur
			if target:GetMoveSpeedModifier(target:GetBaseMoveSpeed(), true)>550 then
				duration = dur
				else
				duration =  dur - math.floor((pos - target:GetAbsOrigin()):Length2D()/400)
			end
            target:EmitSound("DOTA_Item.MeteorHammer.Cast")
            target:AddNewModifier_RS(caster, self,"modifier_item_skadi_v2_stun",{duration=duration})
        end
	end
end



modifier_item_skadi_v2_stun =class({})

function modifier_item_skadi_v2_stun:IsDebuff()
        return true
    end

function modifier_item_skadi_v2_stun:IsHidden()
        return false
    end

function modifier_item_skadi_v2_stun:IsPurgable()
        return true
    end

function modifier_item_skadi_v2_stun:IsPurgeException()
        return true
    end


function modifier_item_skadi_v2_stun:GetEffectName()
    return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_item_skadi_v2_stun:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_skadi_v2_stun:OnCreated()
	if self:GetAbility() == nil then return end
    if IsServer() then
    ApplyDamage({
            victim =  self:GetParent(),
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = self:GetCaster():GetPrimaryStatValue(),
            damage_type = DAMAGE_TYPE_PURE
        })
    end
end



function modifier_item_skadi_v2_stun:CheckState()
    return
    {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_TETHERED] = true,
		
    }
end
function modifier_item_skadi_v2_stun:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end
function modifier_item_skadi_v2_stun:GetDisableHealing()return 1
end
modifier_item_skadi_v2_pa = class({})


function modifier_item_skadi_v2_pa:IsHidden()
    return true
end

function modifier_item_skadi_v2_pa:IsPurgable()
    return false
end

function modifier_item_skadi_v2_pa:IsPurgeException()
    return false
end

function modifier_item_skadi_v2_pa:RemoveOnDeath()
    return self:GetParent():IsIllusion()
end

function modifier_item_skadi_v2_pa:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_skadi_v2_pa:GetModifierProjectileName()
    return  "particles/items2_fx/skadi_projectile.vpcf"
end

function modifier_item_skadi_v2_pa:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.duration=self:GetAbility():GetSpecialValueFor("spt")
    self.stats=self:GetAbility():GetSpecialValueFor("stats")
end

function modifier_item_skadi_v2_pa:OnTakeDamage(tg)
	if not IsServer() then
		return
	end
    if (tg.attacker == self:GetParent() or tg.attacker:GetOwner() == self:GetParent()) and tg.unit:IsAlive() then
        if self:GetParent():IsIllusion() or tg.unit:IsBuilding() or tg.unit:IsOther() or  Is_Chinese_TG(tg.unit, self:GetParent()) or (tg.damage<50 and tg.damage_category ~= 1) then
            return
        end
        --if not tg.unit:IsMagicImmune() then
        if self:GetParent():HasItemInInventory("item_three_knives") or self:GetCaster():HasItemInInventory("item_four_knives") then
            self.duration=3
        end

        local modifier = tg.unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_skadi_v2_slow",{duration=self.duration})
		if  tg.unit:GetName() == "npc_dota_miniboss"  then return end
        if tg.damage_category==1 then  --如果攻击类型是攻击
            modifier:SetStackCount(1)
        end
        --end
	end
end

function modifier_item_skadi_v2_pa:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end
function modifier_item_skadi_v2_pa:GetModifierBonusStats_Intellect()
    return  self.stats
end

function modifier_item_skadi_v2_pa:GetModifierBonusStats_Agility()
    return  self.stats
end

function modifier_item_skadi_v2_pa:GetModifierBonusStats_Strength()
    return  self.stats
end


modifier_item_skadi_v2_slow=class({})

function modifier_item_skadi_v2_slow:IsDebuff()
    return true
end

function modifier_item_skadi_v2_slow:IsHidden()
    return false
end

function modifier_item_skadi_v2_slow:IsPurgable()
    return true
end

function modifier_item_skadi_v2_slow:IsPurgeException()
    return true
end

function modifier_item_skadi_v2_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_item_skadi_v2_slow:StatusEffectPriority()
    return 10
end

function modifier_item_skadi_v2_slow:RemoveOnDeath()
    return true
end

function modifier_item_skadi_v2_slow:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.MoveSpeed=self:GetAbility():GetSpecialValueFor("MoveSpeed") or 0
    self.AttackSpeed=self:GetAbility():GetSpecialValueFor("AttackSpeed") or 0
    self.TurnRate=self:GetAbility():GetSpecialValueFor("TurnRate") or 0
    self.Casttime=self:GetAbility():GetSpecialValueFor("Casttime") or 0
end

function modifier_item_skadi_v2_slow:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
    }
end

function modifier_item_skadi_v2_slow:GetModifierHealAmplify_PercentageTarget() --治疗减少
    if self:GetStackCount() > 0 then
			return self:GetAbility():GetSpecialValueFor("HealReduction")*0.6
		else
			return 0
	end
end

function modifier_item_skadi_v2_slow:GetModifierHPRegenAmplify_Percentage()  --恢复减少
    if self:GetStackCount() > 0 then
			return self:GetAbility():GetSpecialValueFor("HealReduction")
		else
			return 0
	end
end


function modifier_item_skadi_v2_slow:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():IsRangedAttacker() then
        return self.MoveSpeed*2*(self:GetStackCount()+1)
    end
    return self.MoveSpeed*(self:GetStackCount()+1)
end

function modifier_item_skadi_v2_slow:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent():IsRangedAttacker() then
        return self.AttackSpeed*2*(self:GetStackCount()+1)
    end
    return self.AttackSpeed*(self:GetStackCount()+1)
end

function modifier_item_skadi_v2_slow:GetModifierTurnRate_Percentage()
    if self:GetParent():IsRangedAttacker() then
        return self.TurnRate*2*(self:GetStackCount()+1)
    end
    return self.TurnRate*(self:GetStackCount()+1)
end

function modifier_item_skadi_v2_slow:GetModifierPercentageCasttime()
	if self:GetParent():IsMagicImmune() then return 0 end
    if self:GetParent():IsRangedAttacker() then
        return self.Casttime*2*(self:GetStackCount()+1)
    end
    return self.Casttime*(self:GetStackCount()+1)
end
