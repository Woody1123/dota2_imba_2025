item_imba_rapier_cursed = class({})

LinkLuaModifier("modifier_imba_rapier_super_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_vision", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_unique_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_rapier_magic_unique_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_rapier_cursed:GetIntrinsicModifierName() return "modifier_imba_rapier_super_passive" end

function item_imba_rapier_cursed:OnOwnerDied()
	local caster=self:GetCaster()
	if (not caster:IsTrueHero() and not caster:IsIllusion()) or not caster:IsReincarnating() then
		caster:DropItemAtPositionImmediate(self, caster:GetAbsOrigin())
		local pos = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
		pos = RotatePosition(caster:GetAbsOrigin(), QAngle(0, RandomInt(0, 360), 0), pos)
		self:LaunchLoot(false, 250, 0.5, pos,nil)
		Notifications:BottomToAll({hero=self:GetPurchaser():GetUnitName(), duration=5.0, class="NotificationMessage"})
		Notifications:BottomToAll({text="#"..self:GetPurchaser():GetUnitName(), continue=true})
		Notifications:BottomToAll({text="掉落了", continue=true})
		Notifications:BottomToAll({text="#DOTA_Tooltip_ability_"..self:GetName(), continue=true})
		self:SetPurchaser(nil)
	--	local rapier_cursed = CreateItem("item_imba_rapier_cursed", nil, nil)
	--	if rapier_cursed then
	--		CreateItemOnPositionSync(caster:GetAbsOrigin()+caster:GetUpVector()*100, rapier_cursed)
		--end
		for i = 2, 3 do
		AddFOWViewer(i,caster:GetAbsOrigin(), 300,7, false)
		end
		--CreateModifierThinker(nil, self, "modifier_imba_rapier_vision", {}, self:GetAbsOrigin(), DOTA_TEAM_NEUTRALS, false)
	end
end

modifier_imba_rapier_super_passive = class({})

function modifier_imba_rapier_super_passive:IsDebuff()			return false end
function modifier_imba_rapier_super_passive:IsHidden() 			return true end
function modifier_imba_rapier_super_passive:IsPurgable() 		return false end
function modifier_imba_rapier_super_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_super_passive:AllowIllusionDuplicate() 	return false end

function modifier_imba_rapier_super_passive:DeclareFunctions() 
return 
		{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		} end
		
function modifier_imba_rapier_super_passive:GetModifierIncomingDamageConstant(keys)
		local reduce = 0.5
		if self.parent:HasModifier("modifier_dfinv") then
			reduce = -0.8
		end
		return -keys.damage*reduce*(1+self:GetStackCount()*0.05)
end

function modifier_imba_rapier_super_passive:GetModifierSpellAmplify_Percentage()
		return self.in_fountain  and 0 or 140*(1+self:GetStackCount()*self.hope_per)
end

function modifier_imba_rapier_super_passive:OnDeath(keys)
	if IsServer() and keys.unit~=self.parent and keys.unit:IsRealHero() then
		if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then
				self.hope = self.hope + 1
				self:SetStackCount(self.hope)
		end
	end
end

function modifier_imba_rapier_super_passive:OnRespawn(keys)
	if IsServer() then

		if  keys.unit~=self.parent and keys.unit:IsRealHero() then
			if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then
				self.hope = self.hope - 1
				self:SetStackCount(self.hope)
			end
		end
	end
end

function modifier_imba_rapier_super_passive:OnTakeDamage(tg)
    if IsServer() then
	
        if tg.attacker==self.parent and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
            local hp=tg.original_damage*0.35*(1+self:GetStackCount()*0.05)
            self.parent:Heal(hp, self:GetAbility())
            SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,hp, nil)
        end
		
    end
end

function modifier_imba_rapier_super_passive:GetModifierPreAttack_BonusDamage()
	return 888*(1+self:GetStackCount()*self.hope_per)
end


function modifier_imba_rapier_super_passive:OnCreated()
	if self:GetAbility() == nil then return end
	if self:GetAbility() then
		self.parent = self:GetParent()
		self.time_to_double= 0
		self.base_corruption=self:GetAbility():GetSpecialValueFor("base_corruption")
		self.hope_per = 0.05
		self.hope = 0
		self.in_fountain = false
	end
	if IsServer() then
			for i=1, #CDOTA_PlayerResource.TG_HERO do
				if CDOTA_PlayerResource.TG_HERO[i] then
					local hero = CDOTA_PlayerResource.TG_HERO[i] 
					if hero~= nil and  not hero:IsAlive() then
						self.hope = self.hope + 1
						self:SetStackCount(self.hope)
					end
				end
			end
			local pfx = ParticleManager:CreateParticle("particles/tgp/items/rapier_super/rapier_super_buff_m.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW   , self:GetParent())
			ParticleManager:SetParticleControl(pfx,0,self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx,1,Vector(200,0,0))
			self:AddParticle(pfx, false, false, 15, false, true)
		self:StartIntervalThink(0.3)
	end
end

function modifier_imba_rapier_super_passive:OnIntervalThink()
	if not IsServer() then return end
	self.time_to_double = self.time_to_double + 1
	if self.parent:HasModifier("modifier_fountain_aura_buff") then
		self.in_fountain = true
		else
		self.in_fountain = false
	end
	local dmg_pct = self.time_to_double*0.0018
	local dmg = math.floor(self:GetParent():GetMaxHealth() * dmg_pct*0.01)
	self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - dmg))
	if (self.time_to_double > 90) then
		self.parent:AddNewModifier(self.parent,self,"modifier_imba_rapier_vision",{duration = 0.4})
	end
end

function modifier_imba_rapier_super_passive:OnDestroy()

end

modifier_imba_rapier_vision = class({})

function modifier_imba_rapier_vision:IsDebuff()			return false end
function modifier_imba_rapier_vision:IsHidden() 			return true end
function modifier_imba_rapier_vision:IsPurgable() 		return false end
function modifier_imba_rapier_vision:IsPurgeException() 	return false end
function modifier_imba_rapier_vision:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,} end
function modifier_imba_rapier_vision:GetModifierProvidesFOWVision()			return 1 end

item_imba_rapier = class({})
LinkLuaModifier("modifier_imba_rapier_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_magic_debuff", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
function item_imba_rapier:GetIntrinsicModifierName() return "modifier_imba_rapier_passive" end
modifier_imba_rapier_passive = class({})

function modifier_imba_rapier_passive:IsDebuff()			return false end
function modifier_imba_rapier_passive:IsHidden() 			return true end
function modifier_imba_rapier_passive:IsPurgable() 		return false end
function modifier_imba_rapier_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_passive:AllowIllusionDuplicate() 	return false end
function modifier_imba_rapier_passive:OnCreated()
	if IsServer() then
		--self:GetParent():SetBaseMagicalResistanceValue(0)
	end
end
function modifier_imba_rapier_passive:DeclareFunctions() 
return 
		{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_HERO_KILLED,
		}
end	
function modifier_imba_rapier_passive:GetModifierPreAttack_BonusDamage()
	return 666
end

function modifier_imba_rapier_passive:GetModifierMagicalResistanceBonus()
	return -88
end

function modifier_imba_rapier_passive:OnDestroy()
	if IsServer() then
		--self:GetParent():SetBaseMagicalResistanceValue(25)
	end
end

function modifier_imba_rapier_passive:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsRealHero() or keys.reincarnate then
		return
	end
	self:GetParent():AddNewModifier(keys.target,self:GetAbility(),"modifier_imba_rapier_magic_debuff",{duration = 7})
	self:GetParent():RemoveModifierByName("modifier_smoke_of_deceit")
end

item_imba_rapier_magic = class({})
LinkLuaModifier("modifier_imba_rapier_magic_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_magic_debuff", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
function item_imba_rapier_magic:GetIntrinsicModifierName() return "modifier_imba_rapier_magic_passive" end
modifier_imba_rapier_magic_passive = class({})
function modifier_imba_rapier_magic_passive:IsDebuff()			return false end
function modifier_imba_rapier_magic_passive:IsHidden() 			return true end
function modifier_imba_rapier_magic_passive:IsPurgable() 		return false end
function modifier_imba_rapier_magic_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_magic_passive:AllowIllusionDuplicate() 	return false end
function modifier_imba_rapier_magic_passive:DeclareFunctions() 
	return 
		{		
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_HERO_KILLED,
		} end
		
function modifier_imba_rapier_magic_passive:GetModifierSpellAmplify_Percentage()
	return self:GetParent():IsInvulnerable() and 0 or 70
end
function modifier_imba_rapier_magic_passive:GetModifierPhysicalArmorBonus()
	return -70
end
function modifier_imba_rapier_magic_passive:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsRealHero() or keys.reincarnate then
		return
	end
	self:GetParent():AddNewModifier(keys.target,self:GetAbility(),"modifier_imba_rapier_magic_debuff",{duration = 7})
	self:GetParent():RemoveModifierByName("modifier_smoke_of_deceit")
end

modifier_imba_rapier_magic_debuff = class({})
function modifier_imba_rapier_magic_debuff:IsDebuff()	return true end
function modifier_imba_rapier_magic_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_rapier_magic_debuff:RemoveOnDeath() return true end
function modifier_imba_rapier_magic_debuff:IsHidden() return false end
function modifier_imba_rapier_magic_debuff:IsPurgable() return false end
function modifier_imba_rapier_magic_debuff:IsPurgeException() return false end
function modifier_imba_rapier_magic_debuff:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_imba_rapier_magic_debuff:DeclareFunctions() return  {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_rapier_magic_debuff:GetModifierProvidesFOWVision() return 1 end
