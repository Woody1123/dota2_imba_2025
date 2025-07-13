item_imba_heavens_ex = class({})
LinkLuaModifier("modifier_imba_heavens_ex_passive", "ting/items/item_imba_heavens_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heavens_ex_disarm", "ting/items/item_imba_heavens_ex", LUA_MODIFIER_MOTION_NONE)


function item_imba_heavens_ex:GetIntrinsicModifierName()
	return "modifier_imba_heavens_ex_passive"
end



function item_imba_heavens_ex:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("dur")
	if target:IsRangedAttacker() then
		duration = self:GetSpecialValueFor("dur_ranged")
	end
	if  target:TG_TriggerSpellAbsorb(self) then
		return
    end
	target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
	target:AddNewModifier(caster,self,"modifier_imba_heavens_ex_disarm",{duration = duration})
end



modifier_imba_heavens_ex_passive = class({})
function modifier_imba_heavens_ex_passive:IsDebuff()			return false end
function modifier_imba_heavens_ex_passive:IsHidden() 			return true end
function modifier_imba_heavens_ex_passive:IsPurgable() 		return false end
function modifier_imba_heavens_ex_passive:IsPurgeException() 	return false end
function modifier_imba_heavens_ex_passive:GetModifierBonusStats_Strength() return self.str end

function modifier_imba_heavens_ex_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.ability=self:GetAbility()
	self.parent = self:GetParent()
    self.str=self.ability:GetSpecialValueFor("str") or 0
    self.resitance=self.ability:GetSpecialValueFor("resitance") or 0
    self.eva=self.ability:GetSpecialValueFor("eva") or 0
    self.heal=self.ability:GetSpecialValueFor("heal") or 0
	self.dur_pa = self.ability:GetSpecialValueFor("dur_pa") or 0
	self.chance = self.ability:GetSpecialValueFor("chance") or 0
end

function modifier_imba_heavens_ex_passive:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_imba_heavens_ex_passive:GetModifierStatusResistanceStacking() return self.resitance end
function modifier_imba_heavens_ex_passive:GetModifierEvasion_Constant() return self.eva end
function modifier_imba_heavens_ex_passive:GetModifierHPRegenAmplify_Percentage()
	return self.heal
end

function modifier_imba_heavens_ex_passive:GetModifierLifestealRegenAmplify_Percentage ()
	return self.heal
end

function modifier_imba_heavens_ex_passive:GetModifierBonusStats_Strength()
    return  self.str
end

function modifier_imba_heavens_ex_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target == self:GetParent() and keys.attacker:IsHero() and not keys.target:IsMagicImmune()  then
		if PseudoRandom:RollPseudoRandom(self.ability, self.chance) then
			if keys.target:IsAlive() then
				keys.target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
				keys.target:AddNewModifier(keys.target,self.ability,"modifier_imba_heavens_ex_disarm",{duration = self.dur_pa})
			end
			if keys.attacker:IsAlive() then
				keys.attacker:AddNewModifier(keys.target,self.ability,"modifier_imba_heavens_ex_disarm",{duration = self.dur_pa})
			end		
		end
	end	
end

modifier_imba_heavens_ex_disarm = class({})
function modifier_imba_heavens_ex_disarm:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_imba_heavens_ex_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_imba_heavens_ex_disarm:IsPurgable() return false end
function modifier_imba_heavens_ex_disarm:IsPurgeException() return false end
function modifier_imba_heavens_ex_disarm:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end



