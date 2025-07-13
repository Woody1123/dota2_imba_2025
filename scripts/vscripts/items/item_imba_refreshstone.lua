item_imba_refreshstone=class({})

LinkLuaModifier("modifier_item_imba_refreshstone_buff", "items/item_imba_refreshstone.lua", LUA_MODIFIER_MOTION_NONE)
function item_imba_refreshstone:IsRefreshable()
	return false
end
function item_imba_refreshstone:OnSpellStart()  
    self.caster=self:GetParent()
    local modifier = self.caster:FindModifierByName("modifier_item_imba_refreshstone_buff")
    self.refresh_count= 1
    if modifier and modifier:GetStackCount() >=self.refresh_count then
        self.caster:EmitSound("DOTA_Item.REFRESHER.Activate")
        local pfx= ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN,self.caster)
        ParticleManager:ReleaseParticleIndex( pfx )
        TG_Refresh_AB(self.caster)
        modifier:SetStackCount(modifier:GetStackCount()-self.refresh_count)
		if self.caster.BLOODSTONE ~= nil then
			self.caster.BLOODSTONE = self.caster.BLOODSTONE -1
		end
    end
	self:StartCooldown(self:GetSpecialValueFor("cd"))
end
function item_imba_refreshstone:GetIntrinsicModifierName()
    return "modifier_item_imba_refreshstone_buff"
end

modifier_item_imba_refreshstone_buff=class({})


function modifier_item_imba_refreshstone_buff:IsPassive()
    return true
end

function modifier_item_imba_refreshstone_buff:IsPurgable()
    return false
end

function modifier_item_imba_refreshstone_buff:IsPurgeException()
    return false
end

function modifier_item_imba_refreshstone_buff:RemoveOnDeath()
    return false
end

function modifier_item_imba_refreshstone_buff:IsPermanent()
    return true
end

function modifier_item_imba_refreshstone_buff:AllowIllusionDuplicate()
    return false
end
function modifier_item_imba_refreshstone_buff:IsStealable()
     return false 
end
function modifier_item_imba_refreshstone_buff:OnCreated()
    
    self.caster=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
  	if self.caster.BLOODSTONE == nil then
		self.caster.BLOODSTONE = 0
	end
	if self.caster.BLOODSTONE_MINI~=nil and self.caster.first_bloodstone == nil then
		self.caster.BLOODSTONE = self.caster.BLOODSTONE_MINI+self.caster.BLOODSTONE
		self.caster.BLOODSTONE_MINI = 0
	end
	if self.caster.BLOODSTONE ~= nil and self.caster.first_bloodstone == nil then
		self.caster.BLOODSTONE = self.caster.BLOODSTONE + 3
		self.caster.first_bloodstone = 1
	end
    self.ability=self:GetAbility()
    self.asp= self.ability:GetSpecialValueFor("asp")
    self.int= self.ability:GetSpecialValueFor("int")
    self.bonus_health= self.ability:GetSpecialValueFor("bonus_health")
    self.bonus_mana= self.ability:GetSpecialValueFor("bonus_mana")
    self.bonus_mana_regen = self.ability:GetSpecialValueFor("mana_regen")
    self.cast_range_bonus = self.ability:GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
	self:SetStackCount(self.caster.BLOODSTONE)
	end
    
end

function modifier_item_imba_refreshstone_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }
end


function modifier_item_imba_refreshstone_buff:OnHeroKilled(tg)
    if  tg.attacker == self:GetParent()  then
        self.caster.BLOODSTONE = self.caster.BLOODSTONE + 1
		self:SetStackCount(self.caster.BLOODSTONE)
	end
end
function modifier_item_imba_refreshstone_buff:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_imba_refreshstone_buff:GetModifierCastRangeBonus()
    return self:GetStackCount()*self.cast_range_bonus
  end

function modifier_item_imba_refreshstone_buff:GetModifierManaBonus()
    return self.bonus_mana
end

function modifier_item_imba_refreshstone_buff:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_item_imba_refreshstone_buff:GetModifierSpellAmplify_Percentage()
	return self.asp+self:GetStackCount()*2
end
function modifier_item_imba_refreshstone_buff:GetModifierBonusStats_Intellect()
	return self.int
end