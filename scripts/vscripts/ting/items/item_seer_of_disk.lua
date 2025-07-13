item_imba_seer_of_disk = class({})
LinkLuaModifier("modifier_seer_of_disk_passive", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic_cd", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seer_vision", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seer_vision_think", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_seer_of_disk_buff", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)

function item_imba_seer_of_disk:GetIntrinsicModifierName() return "modifier_seer_of_disk_passive" end
function item_imba_seer_of_disk:GetAOERadius() return 600 end
function item_imba_seer_of_disk:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration_1 = self:GetSpecialValueFor("duration_1")
	local radius = self:GetSpecialValueFor("radius")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local target = CreateModifierThinker(caster, self, "modifier_seer_vision_think", {duration = duration_1+0.5}, pos, caster:GetTeamNumber(), false)
	AddFOWViewer(caster:GetTeamNumber(), pos, radius,duration_1 , false)	
end
modifier_seer_vision_think = class({})

function modifier_seer_vision_think:IsDebuff()			return true end
function modifier_seer_vision_think:IsHidden() 			return false end
function modifier_seer_vision_think:IsPurgable() 		return true end
function modifier_seer_vision_think:IsPurgeException() 	return true end
function modifier_seer_vision_think:OnCreated()
	if self:GetAbility() == nil then return end
	self.parent = self:GetParent()
	self.ab = self:GetAbility()
	self.radius = self.ab:GetSpecialValueFor("radius")
	self.duration = self.ab:GetSpecialValueFor("duration_2")
	if IsServer() then
		self.particle4	= ParticleManager:CreateParticle("particles/items/disk/disk_pfx0.vpcf", PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(self.particle4, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle4, 1, Vector(self.radius, self.radius, 0))
		self:OnIntervalThink()
		self:StartIntervalThink(0.3)
	end
end
function modifier_seer_vision_think:OnIntervalThink()
	if IsServer() then
	local enemy = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,e in pairs(enemy)  do
			if e:IsInvisible() or e:HasModifier("modifier_seer_vision") then
				e:AddNewModifier(self.parent, self.ab, "modifier_seer_vision", {duration = self.duration})
			end
		end
	end
end

function modifier_seer_vision_think:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle4, true)
	end
end

modifier_seer_vision = class({})

function modifier_seer_vision:IsDebuff()			return true end
function modifier_seer_vision:IsHidden() 			return false end
function modifier_seer_vision:IsPurgable() 		return false end
function modifier_seer_vision:IsPurgeException() 	return false end
function modifier_seer_vision:GetTexture()			return "item_seer_of_disk" end
function modifier_seer_vision:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_seer_vision:GetModifierMoveSpeedBonus_Percentage() return	self.movespeed	end
function modifier_seer_vision:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true,[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_seer_vision:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_seer_vision:OnCreated()
	if self:GetAbility() == nil then return end
	self.parent = self:GetParent()
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_sparks.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end



modifier_relic_cd = class({})
function modifier_relic_cd:IsDebuff()			return true end
function modifier_relic_cd:IsHidden() 			return false end
function modifier_relic_cd:IsPurgable() 		return false end
function modifier_relic_cd:IsPurgeException() 	return false end
function modifier_relic_cd:RemoveOnDeath() 	return false end
function modifier_relic_cd:GetTexture()			return "item_seer_of_disk" end




modifier_seer_of_disk_passive = class({})
LinkLuaModifier("modifier_relic_cd", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
function modifier_seer_of_disk_passive:IsDebuff()			return false end
function modifier_seer_of_disk_passive:IsHidden() 			return true end
function modifier_seer_of_disk_passive:IsPurgable() 		return false end
function modifier_seer_of_disk_passive:IsPurgeException() 	return false end
function modifier_seer_of_disk_passive:AllowIllusionDuplicate()
    return false
end
function modifier_seer_of_disk_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATUS_RESISTANCE,MODIFIER_PROPERTY_MANA_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,} end
function modifier_seer_of_disk_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.hp_l= self.ab:GetSpecialValueFor("hp_l")
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.cd_duration = self.ab:GetSpecialValueFor("cd_duration")
	self.hp = self.ab:GetSpecialValueFor("hp")
	self.mp = self.ab:GetSpecialValueFor("mp")
	self.stat = self.ab:GetSpecialValueFor("stat")
	self.cd = false
end

function modifier_seer_of_disk_passive:OnIntervalThink() 	
	self.cd = false
	--print("132")
	self:StartIntervalThink(-1)
end

function modifier_seer_of_disk_passive:GetModifierHealthBonus() 			return self.hp end
function modifier_seer_of_disk_passive:GetModifierManaBonus() 			return self.mp end
function modifier_seer_of_disk_passive:GetModifierStatusResistance() 			return self.stat end
function modifier_seer_of_disk_passive:GetModifierIncomingDamageConstant(keys) 
		if not IsServer() then return end
		if not self.parent:IsIllusion() and not self.cd  and self.ab  and keys.target:GetHealth() - keys.damage <=self.hp_l and keys.attacker:IsHero() then
				keys.target:AddNewModifier( keys.target, self:GetAbility(), "modifier_imba_seer_of_disk_buff", {duration=self.duration})
				keys.target:AddNewModifier( keys.target, self:GetAbility(), "modifier_relic_cd", {duration=self.cd_duration})
				keys.target:EmitSound("DOTA_Item.ComboBreaker")   --sounds/items/combo_breaker.vsnd
				self:StartIntervalThink(self.cd_duration)
				self.cd = true
			return -keys.damage-100
		end
		return 0
end

modifier_imba_seer_of_disk_buff = class({})
function modifier_imba_seer_of_disk_buff:IsDebuff()			return false end
function modifier_imba_seer_of_disk_buff:IsHidden() 			return false end
function modifier_imba_seer_of_disk_buff:IsPurgable() 		return true end
function modifier_imba_seer_of_disk_buff:RemoveOnDeath() 	return true end
function modifier_imba_seer_of_disk_buff:GetTexture()			return "item_seer_of_disk" end
function modifier_imba_seer_of_disk_buff:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    } 
end
function modifier_imba_seer_of_disk_buff:GetModifierDamageOutgoing_Percentage()
	return -100
end

function modifier_imba_seer_of_disk_buff:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_seer_of_disk_buff:OnCreated()
	if self:GetAbility() == nil then return end
	self.parent = self:GetParent()
	if IsServer() and not self.particle then
		self.parent:Purge(false, true, false, true, true)
		self.particle = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
		--ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 4, Vector(self.parent:GetModelRadius() * 1.1,0,0))
	end
end

function modifier_imba_seer_of_disk_buff:OnDestroy()
	if IsServer() and self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end
item_imba_crown = class({})
LinkLuaModifier("modifier_item_king_passive", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
function item_imba_crown:GetIntrinsicModifierName() return "modifier_item_king_passive" end
function item_imba_crown:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")
	    local pfx = ParticleManager:CreateParticle("particles/items/disk/disk_pfx_7.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_item_dustofappearance",{duration = self:GetSpecialValueFor("duration")})
	end

end

modifier_item_king_passive = class({})
function modifier_item_king_passive:IsDebuff()			return false end
function modifier_item_king_passive:IsHidden() 			return true end
function modifier_item_king_passive:IsPurgable() 		return false end
function modifier_item_king_passive:IsPurgeException() 	return false end
function modifier_item_king_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
end
function modifier_item_king_passive:OnDestroy()
	self.bonus_all_stats = nil
	self.hp = nil
end
function modifier_item_king_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
function modifier_item_king_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierHealthBonus() return self.hp end
