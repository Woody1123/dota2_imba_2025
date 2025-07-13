item_imba_linken = class({})
LinkLuaModifier("modifier_item_imba_linken_passive", "ting/items/item_linken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_linken_buff", "ting/items/item_linken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_linken_buff_other", "ting/items/item_linken", LUA_MODIFIER_MOTION_NONE)
function item_imba_linken:GetIntrinsicModifierName() return "modifier_item_imba_linken_passive" end


function item_imba_linken:OnSpellStart()
    local caster=self:GetCaster()
	local target=self:GetCursorTarget()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Cast",caster)
	target:EmitSound("DOTA_Item.LinkensSphere.Activate")
    target=target==nil and caster or target
	target:AddNewModifier(caster, self, "modifier_item_imba_linken_buff_other", {duration = self:GetSpecialValueFor("duration_other")})
end

modifier_item_imba_linken_passive = class({})
function modifier_item_imba_linken_passive:IsDebuff()			return false end
function modifier_item_imba_linken_passive:IsHidden() 			return true end
function modifier_item_imba_linken_passive:IsPurgable() 		return false end
function modifier_item_imba_linken_passive:IsPurgeException() 	return false end
function modifier_item_imba_linken_passive:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ABSORB_SPELL,
	} 
end
function modifier_item_imba_linken_passive:OnCreated()
	if self:GetAbility() == nil then return end
	local ab = self:GetAbility() 
	self.hp_re = ab:GetSpecialValueFor("hp_re")
	self.mp_re = ab:GetSpecialValueFor("mana_re")
	self.stat = ab:GetSpecialValueFor("stat")
	self.damage = ab:GetSpecialValueFor("damage")
	self.duration = ab:GetSpecialValueFor("duration")
end

function modifier_item_imba_linken_passive:GetModifierConstantManaRegen() return self.mp_re end	
function modifier_item_imba_linken_passive:GetModifierConstantHealthRegen() return self.hp_re end
function modifier_item_imba_linken_passive:GetModifierBonusStats_Intellect() return self.stat end
function modifier_item_imba_linken_passive:GetModifierBonusStats_Agility() return self.stat end
function modifier_item_imba_linken_passive:GetModifierBonusStats_Strength() return self.stat end
function modifier_item_imba_linken_passive:GetModifierPreAttack_BonusDamage() return self.damage end
function modifier_item_imba_linken_passive:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	
	if Is_Chinese_TG(keys.ability:GetCaster(), self:GetParent()) then
		return 0
	end	
	if not self:GetAbility():IsCooldownReady() then 
		return 0 
	end
	self:GetAbility():UseResources(false,false,false,true)
	local fx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(fx, 1,Vector(120,0,0))
	self:AddParticle(fx, false, false, 1, false, false)
	self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_item_imba_linken_buff",{duration = self.duration})
	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
	return 1
end




modifier_item_imba_linken_buff = class({})
function modifier_item_imba_linken_buff:IsDebuff()					return false end
function modifier_item_imba_linken_buff:IsHidden() 					return false end
function modifier_item_imba_linken_buff:IsPurgable() 				return false end
function modifier_item_imba_linken_buff:IsPurgeException() 			return false end
function modifier_item_imba_linken_buff:DeclareFunctions() return {MODIFIER_PROPERTY_ABSORB_SPELL} end
function modifier_item_imba_linken_buff:CheckState()
		return {
			[MODIFIER_STATE_UNSELECTABLE]	= true
		}
end
function modifier_item_imba_linken_buff:GetTexture() 		return "item_imba_linken" end

modifier_item_imba_linken_buff_other = class({})
function modifier_item_imba_linken_buff_other:IsDebuff()					return false end
function modifier_item_imba_linken_buff_other:IsHidden() 					return false end
function modifier_item_imba_linken_buff_other:IsPurgable() 				return false end
function modifier_item_imba_linken_buff_other:IsPurgeException() 			return false end
function modifier_item_imba_linken_buff_other:DeclareFunctions() return {MODIFIER_PROPERTY_ABSORB_SPELL} end
function modifier_item_imba_linken_buff_other:GetTexture() 		return "item_imba_linken" end

function modifier_item_imba_linken_buff_other:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self.ab = self:GetAbility()
		self.parent = self:GetParent()
		self.duration = self.ab:GetSpecialValueFor("duration")	
		local fx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere_buff.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(fx, 1,Vector(120,0,0))
		self:AddParticle(fx, false, false, 1, false, false)
	end
end

function modifier_item_imba_linken_buff_other:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	if Is_Chinese_TG(keys.ability:GetCaster(), self:GetParent()) then
		return 0
	end	
	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
	self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_item_imba_linken_buff",{duration = self.duration})
	self:Destroy()
	return 1
end