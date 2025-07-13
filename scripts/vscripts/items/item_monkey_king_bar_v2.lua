item_monkey_king_bar_v2 =class({})

LinkLuaModifier("modifier_item_monkey_king_bar_v2_pa", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_monkey_king_bar_v2_buff", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_monkey_king_bar_v2_debuff", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_monkey_king_bar_v2:GetIntrinsicModifierName()
    return "modifier_item_monkey_king_bar_v2_pa"
end
function item_monkey_king_bar_v2:GetAbilityTextureName() return (self:GetLevel()==3 and "monkey_king_bar_v2_v2" or "monkey_king_bar_v2") end
function item_monkey_king_bar_v2:OnSpellStart()
	local gold = self:GetSpecialValueFor("gold")
		if self:GetCaster():GetGold()>=gold and self:GetLevel()<3 then
			EmitSoundOn("DOTA_Item.HavocHammer.Cast", self:GetCaster())
			PlayerResource:ModifyGold(self:GetCaster():GetPlayerOwnerID(), gold*-1, false, DOTA_ModifyGold_Unspecified)
			self:SetLevel(self:GetLevel()+1)
			local mod = self:GetParent():FindModifierByName("modifier_item_monkey_king_bar_v2_pa")
			mod:OnCreated()	
			self:GetCaster():CalculateGenericBonuses()
		end
end
modifier_item_monkey_king_bar_v2_pa =class({})

function modifier_item_monkey_king_bar_v2_pa:IsHidden()
    return true
end

function modifier_item_monkey_king_bar_v2_pa:IsPurgable()
    return false
end

function modifier_item_monkey_king_bar_v2_pa:IsPurgeException()
    return false
end

function modifier_item_monkey_king_bar_v2_pa:AllowIllusionDuplicate()
    return false
end
function modifier_item_monkey_king_bar_v2_pa:CheckState()
    return {[MODIFIER_STATE_CANNOT_MISS] = true}
end
function modifier_item_monkey_king_bar_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

function modifier_item_monkey_king_bar_v2_pa:GetModifierAttackRangeBonus()
	if self.parent:IsRangedAttacker() then
		return self.att_range*0.5
	end
		return self.att_range
end

function modifier_item_monkey_king_bar_v2_pa:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not self.parent:IsIllusion() and not keys.target:IsBuilding() then
		return self.magic_damage
	end
end

function modifier_item_monkey_king_bar_v2_pa:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end	
    self.ability=self:GetAbility()
    self.asp=self.ability:GetSpecialValueFor("asp")
    self.att=self.ability:GetSpecialValueFor("att")
	self.att_range = self.ability:GetSpecialValueFor("att_range")
	self.magic_damage = self.ability:GetSpecialValueFor("magic_damage")
end

function modifier_item_monkey_king_bar_v2_pa:GetModifierAttackSpeedBonus_Constant()
    return self.asp
end

function modifier_item_monkey_king_bar_v2_pa:GetModifierPreAttack_BonusDamage()
    return self.att
end

