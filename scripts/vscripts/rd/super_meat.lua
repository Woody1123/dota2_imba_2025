super_meat=class({})
LinkLuaModifier("modifier_super_meat_pass", "rd/super_meat.lua", LUA_MODIFIER_MOTION_NONE)


function super_meat:GetIntrinsicModifierName()
    return "modifier_super_meat_pass"
end


modifier_super_meat_pass=class({})
function modifier_super_meat_pass:IsPassive()
	return true
end

function modifier_super_meat_pass:IsPurgable()
    return false
end

function modifier_super_meat_pass:IsPurgeException()
    return false
end

function modifier_super_meat_pass:IsHidden()
    return false
end

function modifier_super_meat_pass:AllowIllusionDuplicate()
        return false
end

function modifier_super_meat_pass:OnCreated()
    self.stack_duration = self:GetAbility():GetSpecialValueFor("stack_duration")
    self.count=self:GetAbility():GetSpecialValueFor("count")
    self.min_count=self:GetAbility():GetSpecialValueFor("min_count")
    self.stack_limit=60--self:GetAbility():GetSpecialValueFor("max_count")
    self.hp=self:GetAbility():GetSpecialValueFor("hp")
    self.armor=self:GetAbility():GetSpecialValueFor("armor")
    self.res=self:GetAbility():GetSpecialValueFor("res")
    self.mag_res=self:GetAbility():GetSpecialValueFor("mag_res")
    if not IsServer() then
        return
    end
    if self:GetAbility() == nil then return end
	
    if self:GetStackCount()<self.min_count then
        self:SetStackCount(self.min_count)
    end
end

function modifier_super_meat_pass:OnRefresh()
        self:OnCreated()
end

function modifier_super_meat_pass:OnIntervalThink()
    if not IsServer() then
		return
	end
    if not self:GetAbility() then
        self:Destroy()
    end
    self:SetStackCount(self.min_count)
    self:StartIntervalThink(-1)
end

function modifier_super_meat_pass:OnTakeDamage(tg)
    if tg.unit==self:GetParent()  and IsHeroDamage(tg.attacker, tg.damage) and  IsEnemy(tg.attacker,self:GetParent())then
        if self:GetStackCount()<60 then
            self:SetStackCount(math.min(self:GetStackCount()+self.count,self:GetParent():GetLevel()+self.min_count))
			self:GetParent():CalculateStatBonus(true)
        else
            self:SetStackCount(self.stack_limit)
        end
        self:StartIntervalThink(self.stack_duration)
    end
end


function modifier_super_meat_pass:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_super_meat_pass:GetModifierHealthBonus()
    return self:GetStackCount()*self.hp
end

function modifier_super_meat_pass:GetModifierPhysicalArmorBonus()
    return self:GetStackCount()*self.armor
end

function modifier_super_meat_pass:GetModifierMagicalResistanceBonus()
    return self:GetStackCount()*self.mag_res
end

function modifier_super_meat_pass:GetModifierStatusResistanceStacking()
    return self:GetStackCount()*self.res
end

