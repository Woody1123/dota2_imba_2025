ra_tome_of_knowledge = class({})
LinkLuaModifier("modifier_ra_tome_of_knowledge_pa", "ting/random_ab/ra_tome_of_knowledge", LUA_MODIFIER_MOTION_NONE)
function ra_tome_of_knowledge:GetIntrinsicModifierName() return "modifier_ra_tome_of_knowledge_pa" end
function ra_tome_of_knowledge:IsHiddenWhenStolen() 		return false end
function ra_tome_of_knowledge:IsStealable() return false end

function ra_tome_of_knowledge:OnHeroLevelUp()
	local level = self:GetCaster():GetLevel()
	if level == 6 or level == 11 or level == 18 then
		self:GetCaster():AddItemByName("item_tome_of_knowledge")
	end
end

--被动回蓝
modifier_ra_tome_of_knowledge_pa=class({})
function modifier_ra_tome_of_knowledge_pa:IsHidden() return false end
function modifier_ra_tome_of_knowledge_pa:IsPurgable() return false end
function modifier_ra_tome_of_knowledge_pa:IsPurgeException() return false end
function modifier_ra_tome_of_knowledge_pa:RemoveOnDeath() return false end
function modifier_ra_tome_of_knowledge_pa:GetModifierPhysicalArmorBonus() 
	return self:GetStackCount()
end

function modifier_ra_tome_of_knowledge_pa:GetModifierMagicalResistanceBonus() 
	return self:GetStackCount()
end

function modifier_ra_tome_of_knowledge_pa:DeclareFunctions() 
	return 
	{	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		 MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_ra_tome_of_knowledge_pa:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()  
	self.parent = self:GetParent()
	self.level = 30--self.ab:GetSpecialValueFor("level")
	if IsServer() then
		if not self.parent:IsIllusion() then
			self.parent:AddItemByName("item_tome_of_knowledge")
		end
	end
end

function modifier_ra_tome_of_knowledge_pa:OnDeath(tg)
    if not IsServer() then
        return
    end
	
    if tg.unit == self.parent and not self.parent:IsIllusion() then
		self.parent:AddExperience( self.parent:GetLevel()*self.level , DOTA_ModifyXP_Unspecified, false, false )
        self:SetStackCount(self:GetStackCount()+1)
        
    end
end
