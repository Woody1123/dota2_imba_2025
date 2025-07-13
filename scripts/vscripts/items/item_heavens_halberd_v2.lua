item_heavens_halberd_v2=class({})

LinkLuaModifier("modifier_item_heavens_halberd_v2_pa", "items/item_heavens_halberd_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heavens_halberd_v2_debuff", "items/item_heavens_halberd_v2.lua", LUA_MODIFIER_MOTION_NONE)
function item_heavens_halberd_v2:GetIntrinsicModifierName()
    return "modifier_item_heavens_halberd_v2_pa"
end

function item_heavens_halberd_v2:OnSpellStart()
    local target=self:GetCursorTarget()
    local caster=self:GetCaster()
    if  target:TG_TriggerSpellAbsorb(self) then
		return
    end
    local dur=target:IsRangedAttacker() and self:GetSpecialValueFor("disarm_range") or self:GetSpecialValueFor("disarm_melee")
    target:AddNewModifier(caster, self, "modifier_item_heavens_halberd_v2_debuff", {duration=dur})
end

modifier_item_heavens_halberd_v2_pa= class({})

function modifier_item_heavens_halberd_v2_pa:GetTexture()
    return "item_heavens_halberd"
end

function modifier_item_heavens_halberd_v2_pa:IsHidden()
    return true
end

function modifier_item_heavens_halberd_v2_pa:IsPurgable()
    return false
end

function modifier_item_heavens_halberd_v2_pa:IsPurgeException()
    return false
end


function modifier_item_heavens_halberd_v2_pa:AllowIllusionDuplicate()
    return false
end


function modifier_item_heavens_halberd_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        --MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
   }
end


function modifier_item_heavens_halberd_v2_pa:OnCreated()
	if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()
	self.parent = self:GetParent()
    self.bonus_evasion=self.ability:GetSpecialValueFor("bonus_evasion")
    self.bonus_strength=self.ability:GetSpecialValueFor("bonus_strength")
    self.hp_regen_amp=self.ability:GetSpecialValueFor("hp_regen_amp")
    self.attch=self.ability:GetSpecialValueFor("attch")
    self.disarm=self.ability:GetSpecialValueFor("disarm")
	self.death_dur  = self.ability:GetSpecialValueFor("death_dur")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.res = self.ability:GetSpecialValueFor("res")
end

function modifier_item_heavens_halberd_v2_pa:GetModifierEvasion_Constant()
    return  self.bonus_evasion
 end

function modifier_item_heavens_halberd_v2_pa:GetModifierBonusStats_Strength()
    return  self.bonus_strength
end

function modifier_item_heavens_halberd_v2_pa:GetModifierHPRegenAmplify_Percentage()
    return self.hp_regen_amp
end

function modifier_item_heavens_halberd_v2_pa:GetModifierHealAmplify_PercentageTarget()
    return self.hp_regen_amp
end
function modifier_item_heavens_halberd_v2_pa:GetModifierHealAmplify_PercentageTarget()
    return self.hp_regen_amp
end
function modifier_item_heavens_halberd_v2_pa:GetModifierStatusResistanceStacking()
    return self.res
end

function modifier_item_heavens_halberd_v2_pa:OnDeath(keys)
	if not IsServer() then return end
	if keys.unit == self.parent then 
	if self.parent:IsIllusion() then
		self.death_dur = self.death_dur/2
	end
    if  not keys.attacker:TG_TriggerSpellAbsorb(self.ability) then
		keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_item_heavens_halberd_v2_debuff", {duration = self.death_dur})
    end	
	
	local enemies = FindUnitsInRadius(
				self.parent:GetTeamNumber(), 
				self.parent:GetAbsOrigin(), 
				nil, 
				self.radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
		for _, enemy in pairs(enemies) do	
			if enemy then
				if  not enemy:TG_TriggerSpellAbsorb(self.ability) then
					enemy:AddNewModifier(self.parent, self.ability, "modifier_item_heavens_halberd_v2_debuff", {duration = self.death_dur})
				end	
			end
		end
	end
end

--[[
function modifier_item_heavens_halberd_v2_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self:GetParent() and not tg.attacker:IsIllusion() and not tg.target:IsBuilding() and RollPseudoRandomPercentage(self.attch,0,self:GetAbility()) and  not tg.target:IsDisarmed() and  not tg.target:IsMagicImmune() then
        tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_heavens_halberd_v2_debuff", {duration=self.disarm})
    end
end]]



modifier_item_heavens_halberd_v2_debuff=class({})

function modifier_item_heavens_halberd_v2_debuff:GetTexture()
    return "item_heavens_halberd"
end

function modifier_item_heavens_halberd_v2_debuff:IsDebuff()
    return true
end

function modifier_item_heavens_halberd_v2_debuff:IsHidden()
    return false
end

function modifier_item_heavens_halberd_v2_debuff:IsPurgable()
    return false
end

function modifier_item_heavens_halberd_v2_debuff:IsPurgeException()
    return false
end

function modifier_item_heavens_halberd_v2_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_heavens_halberd_v2_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_item_heavens_halberd_v2_debuff:RemoveOnDeath()
    return true
end

function modifier_item_heavens_halberd_v2_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
end
function modifier_item_heavens_halberd_v2_debuff:OnCreated()
	if self:GetAbility()~=nil then
		if IsServer() then
			self:GetParent():EmitSound("DOTA_Item.HeavensHalberd.Activate")
		end
	end
end
	
    