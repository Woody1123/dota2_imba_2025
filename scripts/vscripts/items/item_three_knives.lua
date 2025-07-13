item_three_knives=class({})

LinkLuaModifier("modifier_item_three_knives_buff", "items/item_three_knives.lua", LUA_MODIFIER_MOTION_NONE)

function item_three_knives:GetIntrinsicModifierName()
    return "modifier_item_three_knives_buff"
end

function item_three_knives:GetAbilityTextureName() return (self:GetLevel()==2 and "trident_png" or "three_knives") end
function item_three_knives:OnSpellStart()
	local gold = self:GetSpecialValueFor("gold")
		if self:GetCaster():GetGold()>=gold and self:GetLevel()~=2 then
			EmitSoundOn("DOTA_Item.HavocHammer.Cast", self:GetCaster())
			PlayerResource:ModifyGold(self:GetCaster():GetPlayerOwnerID(), gold*-1, false, DOTA_ModifyGold_Unspecified)
			self:SetLevel(2)
			local mod = self:GetParent():FindModifierByName("modifier_item_three_knives_buff")
			mod:OnCreated()	
		end
end
modifier_item_three_knives_buff=class({})

function modifier_item_three_knives_buff:IsPassive()
    return true
end

function modifier_item_three_knives_buff:IsHidden()
    return true
end

function modifier_item_three_knives_buff:IsPurgable()
    return false
end

function modifier_item_three_knives_buff:IsPurgeException()
    return false
end

function modifier_item_three_knives_buff:AllowIllusionDuplicate()
    return false
end


function modifier_item_three_knives_buff:OnCreated()
    self.caster=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
	
    self.ability=self:GetAbility()
    self.all= self.ability:GetSpecialValueFor("all")
    self.all_rs= self.ability:GetSpecialValueFor("all_rs")
    self.all_heal= self.ability:GetSpecialValueFor("all_heal")
    self.all_sp= self.ability:GetSpecialValueFor("all_sp")
    self.all_attsp= self.ability:GetSpecialValueFor("all_attsp")
    self.all_spell= self.ability:GetSpecialValueFor("all_spell")
    self.all_mana= self.ability:GetSpecialValueFor("all_mana")
	self.magic_att = self.ability:GetSpecialValueFor("magic_att")
    self.mana= self.ability:GetSpecialValueFor("mana")
	
end

function modifier_item_three_knives_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,

    }
end
function modifier_item_three_knives_buff:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not self:GetParent():IsIllusion() and not keys.target:IsBuilding()  then
		return self.magic_att
	end
end	
function modifier_item_three_knives_buff:GetModifierBonusStats_Strength()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierBonusStats_Intellect()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierBonusStats_Agility()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierStatusResistanceStacking()
    return  self.all_rs
end

function modifier_item_three_knives_buff:GetModifierHealAmplify_PercentageTarget()
    return self.all_heal
end

function modifier_item_three_knives_buff:GetModifierHPRegenAmplify_Percentage()
    return self.all_heal
end


function modifier_item_three_knives_buff:GetModifierAttackSpeedBonus_Constant()
    return self.all_attsp
end


function modifier_item_three_knives_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.all_sp
end


function modifier_item_three_knives_buff:GetModifierSpellAmplify_Percentage()
    return self.all_spell
end


function modifier_item_three_knives_buff:GetModifierMPRegenAmplify_Percentage()
    return self.all_mana
end
