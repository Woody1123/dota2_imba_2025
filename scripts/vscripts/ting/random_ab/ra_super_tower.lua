ra_super_tower = class({})
LinkLuaModifier("modifier_ra_super_tower_pa", "ting/random_ab/ra_super_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ra_super_tower_buff", "ting/random_ab/ra_super_tower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ra_super_tower_stack", "ting/random_ab/ra_super_tower", LUA_MODIFIER_MOTION_NONE)
function ra_super_tower:GetIntrinsicModifierName() return "modifier_ra_super_tower_pa" end
function ra_super_tower:IsHiddenWhenStolen() 		return false end
function ra_super_tower:IsStealable() return false end



modifier_ra_super_tower_pa=class({})
function modifier_ra_super_tower_pa:IsHidden() return false end
function modifier_ra_super_tower_pa:IsPurgable() return false end
function modifier_ra_super_tower_pa:IsPurgeException() return false end
function modifier_ra_super_tower_pa:RemoveOnDeath() return false end
function modifier_ra_super_tower_pa:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_ra_super_tower_pa:OnCreated()
	if self:GetAbility()==nil then return end
	self.ab = self:GetAbility()
	self.intv = 120--self.ab:GetSpecialValueFor("time")
	self.stack = 2--self.ab:GetSpecialValueFor("stack")	
	if IsServer() then
		self.parent = self:GetParent()
		
		self.tower = {}
		if not CDOTAGameRules.TOWER then
			return
		end
		
		for aa=1,#CDOTAGameRules.TOWER do

			if Is_Chinese_TG(CDOTAGameRules.TOWER[aa],self.parent) and  not string.find(CDOTAGameRules.TOWER[aa]:GetName(), "tower4") then 
				table.insert(self.tower,CDOTAGameRules.TOWER[aa])
			end
		end
		--self.pfx = ParticleManager:CreateParticle("particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura_print.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		---ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
		--ParticleManager:SetParticleControl(self.pfx, 1, self.parent:GetAbsOrigin())
		--self:AddParticle(self.pfx, false, false, 15, false, false)
		self:OnIntervalThink()
		self:StartIntervalThink(self.intv)
   end
end

function modifier_ra_super_tower_pa:OnIntervalThink()
	if not IsServer() then return end
	for aa=1,#self.tower do
		if self.tower[aa] then 
			local mod = self.tower[aa]:AddNewModifier(self.parent,self.ab,"modifier_ra_super_tower_buff",{duration = -1})
			if mod then 
				self.tower[aa]:RemoveAllModifiersOfName("modifier_ra_super_tower_stack")
				mod.hero = {}
				mod:SetStackCount(self.stack)
			end
		end
	end	
end
function modifier_ra_super_tower_pa:OnDeath(keys)
	if not IsServer() then return end
	if keys.unit and keys.unit:IsBuilding() and Is_Chinese_TG(keys.unit,self.parent) then
		local t_name = keys.unit:GetName()
		local tab_t = {}
		for t=1,#self.tower do
			if self.tower[t]:GetName() ~= t_name then
				table.insert(tab_t,self.tower[t])
			end
		end
		self.tower = tab_t
	end
end


modifier_ra_super_tower_buff = class({})
function modifier_ra_super_tower_buff:IsDebuff()			return false end
function modifier_ra_super_tower_buff:IsHidden() 			return false end
function modifier_ra_super_tower_buff:IsPurgable() 		return false end
function modifier_ra_super_tower_buff:IsPurgeException() 	return false end

function modifier_ra_super_tower_buff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_ra_super_tower_buff:GetModifierPhysicalArmorBonus() return 100000 end
function modifier_ra_super_tower_buff:OnCreated()
	self.hero = {}
	self.parent = self:GetParent()
	
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300,300,300))
	self:AddParticle(pfx, false, false, 15, false, false)
end

function modifier_ra_super_tower_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self.parent  or not keys.attacker:IS_TrueHero_TG() then
		return
	end
	if Is_DATA_TG(self.hero,keys.attacker) then 
		return 
	end 
	table.insert(self.hero,keys.attacker)
	self.parent:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_ra_super_tower_stack",{duration = -1})
	self:SetStackCount(self:GetStackCount() - 1)
	if self:GetStackCount() == 0 then
		self:Destroy()
	end	
end


modifier_ra_super_tower_stack = class({})
function modifier_ra_super_tower_stack:IsDebuff()			return true end
function modifier_ra_super_tower_stack:IsHidden() 			return false end
function modifier_ra_super_tower_stack:IsPurgable() 		return false end
function modifier_ra_super_tower_stack:IsPurgeException() 	return false end
function modifier_ra_super_tower_stack:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end
function modifier_ra_super_tower_stack:GetTexture() return self:GetCaster():GetName() 	end
