item_imba_bloodstone=class({})

LinkLuaModifier("modifier_item_imba_bloodstone_buff", "items/item_imba_bloodstone.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_bloodstone:GetIntrinsicModifierName()
    return "modifier_item_imba_bloodstone_buff"
end

modifier_item_imba_bloodstone_buff=class({})



function modifier_item_imba_bloodstone_buff:IsPurgable()
    return false
end

function modifier_item_imba_bloodstone_buff:IsPurgeException()
    return false
end

function modifier_item_imba_bloodstone_buff:RemoveOnDeath()
    return false
end

function modifier_item_imba_bloodstone_buff:IsPermanent()
    return true
end

function modifier_item_imba_bloodstone_buff:AllowIllusionDuplicate()
    return false
end
function modifier_item_imba_bloodstone_buff:IsDebuff()	
    return  false
end
function modifier_item_imba_bloodstone_buff:IsHidden()
    return false
end


function modifier_item_imba_bloodstone_buff:OnCreated()
    self.caster=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.asp= self.ability:GetSpecialValueFor("asp")
    self.int= self.ability:GetSpecialValueFor("int")
    self.bonus_health= self.ability:GetSpecialValueFor("bonus_health")
    self.bonus_mana= self.ability:GetSpecialValueFor("bonus_mana")
    self.bonus_mana_regen= self.ability:GetSpecialValueFor("mana_regen")
	if self.caster.BLOODSTONE_MINI == nil then
		self.caster.BLOODSTONE_MINI = 0 
	end
	if IsServer() then
		self:SetStackCount(self.caster.BLOODSTONE_MINI)
	end
end

function modifier_item_imba_bloodstone_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_EVENT_ON_DEATH,
        

    }
end
function modifier_item_imba_bloodstone_buff:OnHeroKilled(tg) 
    if  tg.attacker == self:GetParent()  then
        self.caster.BLOODSTONE_MINI = self.caster.BLOODSTONE_MINI + 1
		self:SetStackCount(self.caster.BLOODSTONE_MINI)
	end
end
function modifier_item_imba_bloodstone_buff:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_imba_bloodstone_buff:GetModifierManaBonus()
    return self.bonus_mana
end

function modifier_item_imba_bloodstone_buff:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_item_imba_bloodstone_buff:GetModifierSpellAmplify_Percentage()
	return self.asp+self:GetStackCount()
end
function modifier_item_imba_bloodstone_buff:GetModifierBonusStats_Intellect()
	return self.int
end
function modifier_item_imba_bloodstone_buff:OnDeath(tg)
    if tg.unit==self:GetParent() and not self:GetParent():IsIllusion() then
		self.caster.BLOODSTONE_MINI = math.max(self.caster.BLOODSTONE_MINI - 1 ,0)
		self:SetStackCount(self.caster.BLOODSTONE_MINI)
    end
end