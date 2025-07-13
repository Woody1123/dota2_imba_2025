item_imba_omega_ruby = class({})

LinkLuaModifier("modifier_imba_omega_ruby_passive", "ting/items/item_omega_ruby", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_omega_ruby_buff", "ting/items/item_omega_ruby", LUA_MODIFIER_MOTION_NONE)

function item_imba_omega_ruby:GetIntrinsicModifierName() return "modifier_imba_omega_ruby_passive" end

function item_imba_omega_ruby:OnSpellStart()
	local caster = self:GetCaster()
	local pos= caster:GetAbsOrigin()
	local duration = self:GetSpecialValueFor("duration")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	
	caster:RemoveModifierByName("modifier_item_monkey_king_bar")
	caster:AddNewModifier(caster, self, "modifier_item_imba_omega_ruby_buff", {duration = duration})
	
end

modifier_imba_omega_ruby_passive = class({})

function modifier_imba_omega_ruby_passive:IsDebuff()			return false end
function modifier_imba_omega_ruby_passive:IsHidden() 			return true end
function modifier_imba_omega_ruby_passive:IsPurgable() 		return false end
function modifier_imba_omega_ruby_passive:IsPurgeException() 	return false end
function modifier_imba_omega_ruby_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_omega_ruby_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.miss = self.ab:GetSpecialValueFor("miss")
	self.cri = self.ab:GetSpecialValueFor("cri")
	self.mod = nil
	if IsServer() then
		self.mod = self:GetParent():FindModifierByName("modifier_player")
		if self.mod ~=nil then
			self.mod.cri = self.mod.cri + self.cri
		end
		
	end
end

function modifier_imba_omega_ruby_passive:OnDestroy()
	if IsServer() then
		if self.mod~=nil then
			self.mod.cri = self.mod.cri-self.cri
		end
	end
end

function modifier_imba_omega_ruby_passive:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE,} end
function modifier_imba_omega_ruby_passive:GetModifierMiss_Percentage()
    return self.miss
end


modifier_item_imba_omega_ruby_buff = class({})

function modifier_item_imba_omega_ruby_buff:IsDebuff()			return false end
function modifier_item_imba_omega_ruby_buff:IsHidden() 			return false end
function modifier_item_imba_omega_ruby_buff:IsPurgable() 		return false end
function modifier_item_imba_omega_ruby_buff:RemoveOnDeath() 	return false end
function modifier_item_imba_omega_ruby_buff:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = false} end
function modifier_item_imba_omega_ruby_buff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA + 999 end
function modifier_item_imba_omega_ruby_buff:OnCreated()
	if self:GetAbility() == nil then   
		return  
	end 
	self.parent = self:GetParent()
	
	if IsServer() then  
		self:StartIntervalThink(0.5) 
	end

end
function modifier_item_imba_omega_ruby_buff:OnIntervalThink()
    if not IsServer() then
        return
    end
	if not self.parent:IsAlive() then
		self:SetDuration(4,true)
	end
end

function modifier_item_imba_omega_ruby_buff:OnDestroy()
	if IsServer() then
		if self.parent:HasModifier("modifier_item_monkey_king_bar_v2_pa") then
			local ab = self.parent:FindModifierByName("modifier_item_monkey_king_bar_v2_pa"):GetAbility()
			if ab then
				self.parent:AddNewModifier(self.parent,ab,"modifier_item_monkey_king_bar",{duration = 3600})
			end
		end
	end
end
function modifier_item_imba_omega_ruby_buff:GetTexture() return "item_omega_ruby" end