
item_imba_greatwyrm_plate = class({})
LinkLuaModifier("modifier_imba_greatwyrm_plate_passive", "ting/items/item_greatwyrm_plate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active", "ting/items/item_greatwyrm_plate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active_cd", "ting/items/item_greatwyrm_plate", LUA_MODIFIER_MOTION_NONE)
function item_imba_greatwyrm_plate:GetIntrinsicModifierName() return "modifier_imba_greatwyrm_plate_passive" end

function item_imba_greatwyrm_plate:OnSpellStart()
	local caster = self:GetCaster()
	local duration= self:GetSpecialValueFor("duration")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("active_radius"),0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if #heroes>0 then
		for _, hero in pairs(heroes) do
			if hero:IsRealHero() then
				hero:AddNewModifier(caster, self, "modifier_item_greatwyrm_plate_active", {duration =duration})
			end
		end
	end
end

--飞龙被动
modifier_imba_greatwyrm_plate_passive = class({})

function modifier_imba_greatwyrm_plate_passive:IsDebuff()			return false end
function modifier_imba_greatwyrm_plate_passive:AllowIllusionDuplicate()			return false end
function modifier_imba_greatwyrm_plate_passive:IsHidden() 			return false end
function modifier_imba_greatwyrm_plate_passive:IsPurgable() 		return false end
function modifier_imba_greatwyrm_plate_passive:IsPurgeException() 	return false end
function modifier_imba_greatwyrm_plate_passive:GetTexture() return "item_greatwyrm_plate_0" end
function modifier_imba_greatwyrm_plate_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_greatwyrm_plate_passive:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end

function modifier_imba_greatwyrm_plate_passive:GetModifierHealthBonus() return self.hp end
function modifier_imba_greatwyrm_plate_passive:GetModifierConstantHealthRegen() return self.hp_re end
function modifier_imba_greatwyrm_plate_passive:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_imba_greatwyrm_plate_passive:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		if self:GetParent():IsSilenced() or self:GetParent():PassivesDisabled() then
				 return  self.reduce
		end
	end
end
function modifier_imba_greatwyrm_plate_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.count = 1
	self.hp = self:GetAbility():GetSpecialValueFor("hp")
	self.hp_re = self:GetAbility():GetSpecialValueFor("hp_re")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.reduce = self:GetAbility():GetSpecialValueFor("reduce")*-1
end




--飞龙主动
modifier_item_greatwyrm_plate_active = class({})

function modifier_item_greatwyrm_plate_active:IsDebuff()			return false end
function modifier_item_greatwyrm_plate_active:AllowIllusionDuplicate()			return false end
function modifier_item_greatwyrm_plate_active:IsHidden() 			return false end
function modifier_item_greatwyrm_plate_active:IsPurgable() 			return false end
function modifier_item_greatwyrm_plate_active:IsPurgeException() 	return false end
function modifier_item_greatwyrm_plate_active:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_item_greatwyrm_plate_active:GetTexture() return "item_greatwyrm_plate_0" end
function modifier_item_greatwyrm_plate_active:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_item_greatwyrm_plate_active:OnCreated()
	if self:GetAbility() == nil then return end
	self.armor = self:GetAbility():GetSpecialValueFor("armor_all")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

modifier_item_greatwyrm_plate_active_cd = class({})
function modifier_item_greatwyrm_plate_active_cd:IsHidden() 			return false end
function modifier_item_greatwyrm_plate_active_cd:IsPurgable() 			return false end
function modifier_item_greatwyrm_plate_active_cd:IsPurgeException() 	return false end
function modifier_item_greatwyrm_plate_active_cd:RemoveOnDeath()		return false end
function modifier_item_greatwyrm_plate_active_cd:GetTexture() return "item_greatwyrm_plate_0" end
