
item_dragon_shield = class({})
LinkLuaModifier("modifier_dragon_shield_passive", "ting/items/item_dragon_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_shield_active", "ting/items/item_dragon_shield", LUA_MODIFIER_MOTION_NONE)
function item_dragon_shield:GetIntrinsicModifierName() return "modifier_dragon_shield_passive" end
function item_dragon_shield:IsRefreshable()
	return false
end
function item_dragon_shield:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration= self:GetSpecialValueFor("duration")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	caster:AddNewModifier(caster,self,"modifier_rune_shield",{duration = duration})
end


--飞龙被动
modifier_dragon_shield_passive = class({})

function modifier_dragon_shield_passive:IsDebuff()			return false end
function modifier_dragon_shield_passive:AllowIllusionDuplicate()			return false end
function modifier_dragon_shield_passive:IsHidden() 			return true end
function modifier_dragon_shield_passive:IsPurgable() 		return false end
function modifier_dragon_shield_passive:IsPurgeException() 	return false end
function modifier_dragon_shield_passive:GetTexture() return "item_greatwyrm_plate_0" end
function modifier_dragon_shield_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_dragon_shield_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT} end
function modifier_dragon_shield_passive:GetModifierHealthBonus() return self.hp end
function modifier_dragon_shield_passive:GetModifierConstantHealthRegen() return self.hp_re end
function modifier_dragon_shield_passive:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_dragon_shield_passive:GetModifierConstantManaRegen() return self.mp_re end	
function modifier_dragon_shield_passive:GetModifierPhysical_ConstantBlock(keys)
	if self:GetAbility()==nil or keys.target ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	return keys.damage*self.reduce
end
function modifier_dragon_shield_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.count = 1
	self.hp = self:GetAbility():GetSpecialValueFor("hp")
	self.hp_re = self:GetAbility():GetSpecialValueFor("hp_re")
	self.mp_re = self:GetAbility():GetSpecialValueFor("mp_re")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.reduce = self:GetAbility():GetSpecialValueFor("block")*0.01
end
function modifier_dragon_shield_passive:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_rune_shield")
	end
end