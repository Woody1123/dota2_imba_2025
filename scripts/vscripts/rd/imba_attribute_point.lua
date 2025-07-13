imba_attribute_point=class({})
LinkLuaModifier("modifier_imba_attribute_point_pass", "rd/imba_attribute_point.lua", LUA_MODIFIER_MOTION_NONE)


function imba_attribute_point:GetIntrinsicModifierName()
    return "modifier_imba_attribute_point_pass"
end



modifier_imba_attribute_point_pass=class({})
function modifier_imba_attribute_point_pass:IsPassive()
	return true
end

function modifier_imba_attribute_point_pass:IsPurgable()
    return false
end

function modifier_imba_attribute_point_pass:IsPurgeException()
    return false
end

function modifier_imba_attribute_point_pass:IsHidden()
    return true
end

function modifier_imba_attribute_point_pass:OnCreated()

    self.move_speed=self:GetAbility():GetSpecialValueFor("move_speed")
    self.spell_Amplify=self:GetAbility():GetSpecialValueFor("spell_Amplify")
    self.mag_res=self:GetAbility():GetSpecialValueFor("mag_res")
end

function modifier_imba_attribute_point_pass:OnRefresh()
    self:OnCreated()
end

function modifier_imba_attribute_point_pass:AllowIllusionDuplicate()
        return false
end

function modifier_imba_attribute_point_pass:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
	}
end

function modifier_imba_attribute_point_pass:GetModifierBonusStats_Strength()
    return self:GetParent():GetLevel()
end

function modifier_imba_attribute_point_pass:GetModifierBonusStats_Agility()
return self:GetParent():GetLevel()
end

function modifier_imba_attribute_point_pass:GetModifierBonusStats_Intellect()
    return self:GetParent():GetLevel()
end


function modifier_imba_attribute_point_pass:GetModifierMoveSpeedBonus_Percentage()
    return self:GetParent():GetAgility()*self.move_speed
end

function modifier_imba_attribute_point_pass:GetModifierSpellAmplify_PercentageUnique()
    return self:GetParent():GetIntellect(false)*self.spell_Amplify
end

function modifier_imba_attribute_point_pass:GetModifierMagicalResistanceBonus()
    return self:GetParent():GetStrength()*self.mag_res
end