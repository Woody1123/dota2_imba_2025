
item_imba_mjollnir_ex = class({})

LinkLuaModifier("modifier_imba_mjollnir_ex_passive", "ting/items/item_imba_mjollnir_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mjollnir_ex_unique", "ting/items/item_imba_mjollnir_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_ex_shield", "ting/items/item_imba_mjollnir_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_ex_slow", "ting/items/item_imba_mjollnir_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_ex_cooldown", "ting/items/item_imba_mjollnir_ex", LUA_MODIFIER_MOTION_NONE)

function item_imba_mjollnir_ex:GetIntrinsicModifierName() return "modifier_imba_mjollnir_ex_passive" end

function item_imba_mjollnir_ex:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:RemoveModifierByName("modifier_item_imba_mjollnir_ex_shield")
	target:AddNewModifier(caster, self, "modifier_item_imba_mjollnir_ex_shield", {duration = self:GetSpecialValueFor("static_duration")})
	target:EmitSound("DOTA_Item.Mjollnir.Activate")
	--print(target:HasInventory())
end

modifier_imba_mjollnir_ex_passive = class({})

function modifier_imba_mjollnir_ex_passive:IsDebuff()			return false end
function modifier_imba_mjollnir_ex_passive:IsHidden() 			return true end
function modifier_imba_mjollnir_ex_passive:IsPurgable() 		return false end
function modifier_imba_mjollnir_ex_passive:IsPurgeException() 	return false end
function modifier_imba_mjollnir_ex_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_ex_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_mjollnir_ex_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_mjollnir_ex_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_mjollnir_ex_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end

function modifier_imba_mjollnir_ex_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.bonus_damage=self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_as=self:GetAbility():GetSpecialValueFor("bonus_as")
	--self:SetMaelStromParticle()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_mjollnir_ex_unique", {})
	end
end

function modifier_imba_mjollnir_ex_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_mjollnir_ex_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_mjollnir_ex_unique")
	end
end

modifier_imba_mjollnir_ex_unique = class({})

function modifier_imba_mjollnir_ex_unique:IsDebuff()			return false end
function modifier_imba_mjollnir_ex_unique:IsHidden() 			return true end
function modifier_imba_mjollnir_ex_unique:IsPurgable() 		return false end
function modifier_imba_mjollnir_ex_unique:IsPurgeException() 	return false end
function modifier_imba_mjollnir_ex_unique:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_ex_unique:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_ATTACK_FAIL,} end

function modifier_imba_mjollnir_ex_unique:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	--self:SetMaelStromParticle()
	self.ability = self:GetAbility()
	self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
	self.mjollnir_cooldown = self.ability:GetSpecialValueFor("mjollnir_cooldown")
	self.bounce_damage = self.ability:GetSpecialValueFor("bounce_damage")
	self.radius = self.ability:GetSpecialValueFor("bounce_radius")
	self.damage_att_per = self.ability:GetSpecialValueFor("damage_att_per")*0.01
	self.damage_att_per_ranged = self.ability:GetSpecialValueFor("damage_att_per_ranged")*0.01
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		}
end

function modifier_imba_mjollnir_ex_unique:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or not keys.target:IsAlive() then
		return
	end--
	if PseudoRandom:RollPseudoRandom(self.ability,self.proc_chance) and not self:GetParent():HasModifier("modifier_item_imba_mjollnir_ex_cooldown") then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
		self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_item_imba_mjollnir_ex_cooldown", {duration = self.mjollnir_cooldown})
		self.damageTable.damage=self.bounce_damage
			local units = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				keys.target:GetAbsOrigin(),
				nil,
				self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,
				false)
		local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin())
		Timers:CreateTimer(0.05, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
							end)	
			for _,unit in pairs(units) do
				self.damageTable.victim = unit
				ApplyDamage(self.damageTable)
			end
	end
end
function modifier_imba_mjollnir_ex_unique:OnAttackFail(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end  
	EmitSoundOn("Hero_razor.lightning", keys.target)
	local pos = keys.target:GetAbsOrigin()
	local particleName = "particles/econ/items/razor/razor_arcana/razor_arcana_alt_run_lightning_strike.vpcf"		
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,pos.z+500))
		ParticleManager:ReleaseParticleIndex(pfx)
	local damage = math.min(keys.attacker:GetAverageTrueAttackDamage(keys.attacker)*1.5,keys.damage)*self.damage_att_per_ranged
	if not keys.attacker:IsRangedAttacker() then
		damage = math.min(keys.attacker:GetAverageTrueAttackDamage(keys.attacker)*1.5,keys.damage)*self.damage_att_per
		keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_imba_stunned",{duration = 0.05})
	end
	--print("att:"..tostring(keys.attacker:GetAttackDamage()))
	--print("true_att:"..tostring(keys.attacker:GetAverageTrueAttackDamage(keys.attacker)))
	--print("da:"..damage)
	--print("key:"..keys.damage)
	self.damageTable.damage = damage
	self.damageTable.victim = keys.target
	ApplyDamage(self.damageTable)
end


modifier_item_imba_mjollnir_ex_shield = class({})

function modifier_item_imba_mjollnir_ex_shield:IsDebuff()			return false end
function modifier_item_imba_mjollnir_ex_shield:IsHidden() 			return false end
function modifier_item_imba_mjollnir_ex_shield:IsPurgable() 		return true end
function modifier_item_imba_mjollnir_ex_shield:IsPurgeException() 	return true end
function modifier_item_imba_mjollnir_ex_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_item_imba_mjollnir_ex_shield:StatusEffectPriority() return 15 end
function modifier_item_imba_mjollnir_ex_shield:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ability = self:GetAbility()
--	self:SetMaelStromParticle()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
	end
end
function modifier_item_imba_mjollnir_ex_shield:OnDestroy()
--	self.chain_pfx = nil
--	self.shield_pfx = nil
--	self.color = nil
	if IsServer() then
		self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
	end
end
function modifier_item_imba_mjollnir_ex_shield:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_item_imba_mjollnir_ex_shield:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or not self:IsHeroDamage(keys.attacker, keys.damage) then
		return
	end
	self:SetStackCount(self:GetStackCount() + 1)
	if self:GetStackCount() >= self.ability:GetSpecialValueFor("static_proc_count") then
		self:SetStackCount(0)
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("static_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
		for _, enemy in pairs(enemies) do
			local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield_arc_01.vpcf", PATTACH_POINT_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			local change = RandomFloat(1.0, 2.0)
			ParticleManager:SetParticleControl(pfx, 2, Vector(RandomFloat(1.0, 2.0),RandomFloat(1.0, 2.0),RandomFloat(1.0, 2.0)))
		--	ParticleManager:SetParticleControl(pfx, 15, self.color)
			ParticleManager:ReleaseParticleIndex(pfx)
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = self.ability:GetSpecialValueFor("static_damage"), ability = self.ability, damage_type = DAMAGE_TYPE_PURE})
			enemy:AddNewModifier_RS(self:GetCaster(), self.ability, "modifier_item_imba_mjollnir_ex_slow", {duration = self.ability:GetSpecialValueFor("static_slow_duration")})
		end
	end
end

function modifier_item_imba_mjollnir_ex_shield:IsHeroDamage(attacker, damage)
	if damage > 0 then
		if attacker:IsBoss() or attacker:IsControllableByAnyPlayer() or attacker:GetName() == "npc_dota_shadowshaman_serpentward" then
			return true
		else
			return false
		end
	end
end

modifier_item_imba_mjollnir_ex_slow = class({})

function modifier_item_imba_mjollnir_ex_slow:IsDebuff()			return true end
function modifier_item_imba_mjollnir_ex_slow:IsHidden() 			return false end
function modifier_item_imba_mjollnir_ex_slow:IsPurgable() 			return true end
function modifier_item_imba_mjollnir_ex_slow:IsPurgeException() 	return true end
function modifier_item_imba_mjollnir_ex_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_imba_mjollnir_ex_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("static_slow")) end
function modifier_item_imba_mjollnir_ex_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("static_slow")) end

modifier_item_imba_mjollnir_ex_cooldown = class({})
function modifier_item_imba_mjollnir_ex_cooldown:IsDebuff()			return false end
function modifier_item_imba_mjollnir_ex_cooldown:IsHidden() 			return true end
function modifier_item_imba_mjollnir_ex_cooldown:IsPurgable() 			return false end
function modifier_item_imba_mjollnir_ex_cooldown:IsPurgeException() 	return false end