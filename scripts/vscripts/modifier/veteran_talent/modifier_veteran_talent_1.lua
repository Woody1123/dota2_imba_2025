modifier_veteran_talent_1=class({})
function modifier_veteran_talent_1:IsHidden()
    return false
end
function modifier_veteran_talent_1:IsPurgable()
    return false
end
function modifier_veteran_talent_1:IsPurgeException()
    return false
end
function modifier_veteran_talent_1:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_1:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_1:GetTexture()
    return "t_1"
end

function modifier_veteran_talent_1:DeclareFunctions()
    return
    {
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	  MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE ,
	 -- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	  MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,	  
	  MODIFIER_PROPERTY_MODEL_SCALE,
	  MODIFIER_PROPERTY_HEALTH_BONUS,
	  MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	  MODIFIER_PROPERTY_BONUS_DAY_VISION,
	  MODIFIER_PROPERTY_MANA_BONUS,
    }
end

function modifier_veteran_talent_1:GetModifierPercentageRespawnTime() 
	return (self:GetStackCount()>=1 and 0.25 or 0)
end

--function modifier_veteran_talent_1:GetModifierExtraHealthPercentage() return (self:GetStackCount()>= 3 and 30 or 0) end
function modifier_veteran_talent_1:GetModifierBonusStats_Intellect() return self:GetStackCount()*12 end
function modifier_veteran_talent_1:GetModifierBonusStats_Agility() return self:GetStackCount()*12 end
function modifier_veteran_talent_1:GetModifierBonusStats_Strength() return self:GetStackCount()*12 end
--function modifier_veteran_talent_1:GetModifierStatusResistanceStacking() return (self:GetStackCount()>=2 and 30 or 0) end
function modifier_veteran_talent_1:GetModifierModelScale() 
	return self:GetStackCount()>=2 and 60 or 0
end

function modifier_veteran_talent_1:GetBonusNightVision() 
	return self:GetStackCount()>=2 and 300 or 0
end
function modifier_veteran_talent_1:GetBonusDayVision() 
	return self:GetStackCount()>=2 and 300 or 0
end
function modifier_veteran_talent_1:GetModifierPhysicalArmorBonus()
		return self:GetStackCount()>=3 and self:GetParent():GetAgility()*0.058 or 0
end
function modifier_veteran_talent_1:GetModifierMagicalResistanceBonus()
		return self:GetStackCount()>=3 and self:GetParent():GetIntellect(false)*0.035 or 0
end
function modifier_veteran_talent_1:GetModifierHealthBonus()
		return self:GetStackCount()>=3 and self:GetParent():GetStrength()*7 or 0
end
function modifier_veteran_talent_1:GetModifierManaBonus()
		return self:GetStackCount()>=3 and self:GetParent():GetStrength()*4.2 or 0
end