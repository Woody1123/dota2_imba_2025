
item_imba_mjollnir = class({})

LinkLuaModifier("modifier_imba_mjollnir_passive", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mjollnir_unique", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_shield", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_imba_mjollnir_cooldown", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

function item_imba_mjollnir:GetIntrinsicModifierName() return "modifier_imba_mjollnir_passive" end
function item_imba_mjollnir:GetAbilityTextureName() return (self:GetLevel()==2 and "imba_mjollnir_v2" or "imba_mjollnir") end
function item_imba_mjollnir:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasItemInInventory("item_moon_shard") and self:GetLevel()~=2 then
		local item = caster:FindItemInInventory("item_moon_shard")
		if item then
			caster:EmitSound("Item.Maelstrom.Chain_Lightning")
			self:SetLevel(2)
			local mod = self:GetParent():FindModifierByName("modifier_imba_mjollnir_unique")
			mod:OnCreated()	
			item:Destroy()
			else
			
		end
	end
	
end

modifier_imba_mjollnir_passive = class({})

function modifier_imba_mjollnir_passive:IsDebuff()			return false end
function modifier_imba_mjollnir_passive:IsHidden() 			return true end
function modifier_imba_mjollnir_passive:IsPermanent() 		return true end
function modifier_imba_mjollnir_passive:IsPurgable() 		return false end
function modifier_imba_mjollnir_passive:IsPurgeException() 	return false end
function modifier_imba_mjollnir_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_mjollnir_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_mjollnir_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_mjollnir_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end

function modifier_imba_mjollnir_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.bonus_damage=self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_as=self:GetAbility():GetSpecialValueFor("bonus_as")
	--self:SetMaelStromParticle()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_mjollnir_unique", {})
	end
end

function modifier_imba_mjollnir_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_mjollnir_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_mjollnir_unique")
	end
end

modifier_imba_mjollnir_unique = class({})

function modifier_imba_mjollnir_unique:IsDebuff()			return false end
function modifier_imba_mjollnir_unique:IsHidden() 			return true end
function modifier_imba_mjollnir_unique:IsPurgable() 		return false end
function modifier_imba_mjollnir_unique:IsPurgeException() 	return false end
function modifier_imba_mjollnir_unique:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_unique:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_mjollnir_unique:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	--self:SetMaelStromParticle()
	self.ability = self:GetAbility()
	self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
	self.mjollnir_cooldown = self.ability:GetSpecialValueFor("mjollnir_cooldown")
	self.bounce_damage = self.ability:GetSpecialValueFor("bounce_damage")
	self.dur = self.ability:GetSpecialValueFor("duration")
	if IsServer() then
		self.cd = false
		self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
		ability = self:GetAbility(), --Optional.
		}
		Timers:CreateTimer(0.1,function()
			if self:GetParent():HasModifier("modifier_illusions_item_manta_v2") then
				self.proc_chance = self.proc_chance/2
			end		
		return nil
		end)
	end
end
function modifier_imba_mjollnir_unique:OnIntervalThink()
	if IsServer() then
		self.cd = false
		self:StartIntervalThink(-1)
	end
end
function modifier_imba_mjollnir_unique:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsCourier() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end
	
	if PseudoRandom:RollPseudoRandom(self.ability,self.proc_chance) and self.cd == false then--and self.ability:GetCurrentCharges()>0 
		--print(self.proc_chance)
		--self.ability:SetCurrentCharges(self.ability:GetCurrentCharges()-1)
		self.cd = true
		self:StartIntervalThink(0.25)
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
		--self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_item_imba_mjollnir_cooldown", {duration = self.mjollnir_cooldown})
		if self.ability:GetLevel() == 2 then
			self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_item_imba_mjollnir_shield", {duration = self.dur})
		end
		local damage = self.bounce_damage
		local units = {}
		units[#units + 1] = keys.target
		for i, aunit in pairs(units) do
			local units1 = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				aunit:GetAbsOrigin(),
				nil,
				self.ability:GetSpecialValueFor("bounce_radius"),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,
				false)
			if #units1>0 then
			for _, unit1 in pairs(units1) do
				local no_yet = true
				for _, unit in pairs(units) do
					if unit == unit1 or unit1 == self:GetParent() then
						no_yet = false
						break
					end
				end
				if no_yet then
					units[#units + 1] = unit1
					break
				end
			end
			end
		end
		table.insert(units, 1, self:GetParent())
		local num=1
		Timers:CreateTimer(0, function()
			if units~=nil and #units>0 then
				if num<#units then
					units[num+1]:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
					local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield_arc_01.vpcf", PATTACH_POINT_FOLLOW, units[num+1])
					ParticleManager:SetParticleControlEnt(pfx, 0, units[num], PATTACH_POINT_FOLLOW, (units[num] == self:GetCaster() and "attach_attack1" or "attach_hitloc"), units[num]:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, units[num+1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[num+1 >= #units and num or num+1]:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1))
					ParticleManager:ReleaseParticleIndex(pfx)
					self.damageTable.victim = units[num+1]
					self.damageTable.damage = self.ability:GetSpecialValueFor("bounce_damage")
					if num==1 then
					    self.damageTable.damage=  damage +units[num+1]:GetHealth()*0.05 --self.ability:GetSpecialValueFor("damage_per")*units[num+1]:GetHealth()*0.01
						else
						self.damageTable.damage= damage 
					end
					ApplyDamage(self.damageTable)
					num=num+1
					return 0.25
				else
					return nil
				end
			end
		end)
		end
end


modifier_item_imba_mjollnir_cooldown = class({})
function modifier_item_imba_mjollnir_cooldown:IsDebuff()			return false end
function modifier_item_imba_mjollnir_cooldown:IsHidden() 			return false end
function modifier_item_imba_mjollnir_cooldown:IsPurgable() 			return false end
function modifier_item_imba_mjollnir_cooldown:IsPurgeException() 	return false end



modifier_item_imba_mjollnir_shield = class({})

function modifier_item_imba_mjollnir_shield:IsDebuff()			return false end
function modifier_item_imba_mjollnir_shield:IsHidden() 			return false end
function modifier_item_imba_mjollnir_shield:IsPurgable() 		return true end
function modifier_item_imba_mjollnir_shield:IsPurgeException() 	return true end
function modifier_item_imba_mjollnir_shield:GetTexture()			return "item_imba_mjollnir_v2" end
function modifier_item_imba_mjollnir_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_item_imba_mjollnir_shield:StatusEffectPriority() return 15 end
function modifier_item_imba_mjollnir_shield:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE} end
function modifier_item_imba_mjollnir_shield:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()*self.asp end
function modifier_item_imba_mjollnir_shield:GetModifierProcAttack_BonusDamage_Pure() return self:GetStackCount()*self.pure end

function modifier_item_imba_mjollnir_shield:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ability = self:GetAbility()
	self.asp = self.ability:GetSpecialValueFor("asp")
	self.pure = self.ability:GetSpecialValueFor("pure_damage")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
		self:SetStackCount(0)
		self:OnRefresh()
	end
end
function modifier_item_imba_mjollnir_shield:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(10,self:GetStackCount()+1))
	end
end
function modifier_item_imba_mjollnir_shield:OnDestroy()

	if IsServer() then
		self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
	end
end