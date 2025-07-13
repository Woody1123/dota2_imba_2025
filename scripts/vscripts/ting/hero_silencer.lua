imba_silencer_glaives_of_wisdom = class({})
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom", "ting/hero_silencer", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom_buff", "ting/hero_silencer", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom_debuff", "ting/hero_silencer", LUA_MODIFIER_MOTION_NONE) 
function imba_silencer_glaives_of_wisdom:IsHiddenWhenStolen() 		return false end
function imba_silencer_glaives_of_wisdom:IsRefreshable() 			return true end
function imba_silencer_glaives_of_wisdom:IsStealable() 				return true end
function imba_silencer_glaives_of_wisdom:GetIntrinsicModifierName() return "modifier_imba_silencer_glaives_of_wisdom" end
function imba_silencer_glaives_of_wisdom:OnProjectileHit(target, location)
	if not target or target:IsMagicImmune() then
		return
	end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_silencer_glaives_of_wisdom")
	if mod then
		mod:dam(target,0)
	end
end

modifier_imba_silencer_glaives_of_wisdom = class({})

function modifier_imba_silencer_glaives_of_wisdom:IsDebuff()			return false end
function modifier_imba_silencer_glaives_of_wisdom:IsHidden() 
	return false
end		
function modifier_imba_silencer_glaives_of_wisdom:IsPurgable() 		return false end
function modifier_imba_silencer_glaives_of_wisdom:IsPurgeException() 	return false end
function modifier_imba_silencer_glaives_of_wisdom:DeclareFunctions() --,MODIFIER_EVENT_ON_ATTACK,MODIFIER_EVENT_ON_ATTACK_RECORD,MODIFIER_EVENT_ON_ORDER
	return	{MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_HERO_KILLED,MODIFIER_PROPERTY_PROJECTILE_NAME,} 
end
function modifier_imba_silencer_glaives_of_wisdom:GetModifierProjectileName()
    return  "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end


function modifier_imba_silencer_glaives_of_wisdom:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if not IsServer() then return end
		self.damagetable = ({
			attacker = self.parent, 
			ability = self.ab, 
			damage_type = self.ab:GetAbilityDamageType(),})
	self:SetStackCount(0)
end


function modifier_imba_silencer_glaives_of_wisdom:OnAttackLanded(keys)
	if IsServer() then		
		if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() or keys.target:IsOther() or not keys.target:IsAlive() then return  end
		if keys.attacker == self.parent and self.ab:GetAutoCastState() and 
		not self.parent:IsSilenced() and self.caster:GetMana()>50 and
		not self.parent:IsIllusion() and not keys.target:IsBuilding() then 
			if (keys.target:IsHero() and keys.target:GetBaseIntellect()<self.caster:GetBaseIntellect()*0.25) then
				keys.target:AddNewModifier(self.caster,self.ab,"modifier_silence",{duration = 0.5})
			end	
			if keys.target:IsMagicImmune() then
				if keys.target:IsSilenced() then
					self:dam(keys.target,1)
				end
			else
			self:dam(keys.target,1)
			end
			--keys.target:AddNewModifier(keys.attacker,self.ab,"modifier_imba_silencer_glaives_of_wisdom_debuff", {duration =self.duration_sc})		
		end
		end	
end


function modifier_imba_silencer_glaives_of_wisdom:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	if keys.target:IsRealHero() and not keys.reincarnate and not Is_Chinese_TG(keys.target,self.caster) then
		if ((keys.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() < 900  and self.caster:IsAlive() ) or keys.attacker == self.caster then
			self:steal(keys.target)
		end		
	end
end



function modifier_imba_silencer_glaives_of_wisdom:dam(target,cleave)
	if IsServer() and target~=nil then 		
		if self.caster:Has_Aghanims_Shard() then
			self.caster:AddNewModifier(self.caster,self.ab,"modifier_imba_silencer_glaives_of_wisdom_buff",{duration =self.ab:GetSpecialValueFor("int_steal_dur_self")})
			target:AddNewModifier(self.caster,self.ab,"modifier_imba_silencer_glaives_of_wisdom_debuff",{duration = self.ab:GetSpecialValueFor("int_steal_dur_enemy")})
		end
		self.damagetable.victim = target
		self.damagetable.damage = self:GetAbility():GetSpecialValueFor("int_damage")*self.caster:GetIntellect(false)*0.01
		if target:IsMagicImmune() then
			self.damagetable.damage = self.damagetable.damage/2
		end
		SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, self.damagetable.damage, target:GetPlayerOwner())
		ApplyDamage(self.damagetable)
		self.ab:UseResources(true,true,true,false)
		if self.ab:GetSpecialValueFor("bounce_range") > 0 and cleave==1 then
			self:cleave(target)
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:cleave(target)
	if IsServer() and target~=nil then 		
		local heros = FindUnitsInRadius(
                self.caster:GetTeamNumber(),
                target:GetAbsOrigin(),
                nil,
                self.ab:GetSpecialValueFor("bounce_range"),
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST,
                false)
		for _,hero in pairs(heros) do
			if not hero:IsMagicImmune() and hero~=target then
			
				local info =
				{
					Target = hero,
					Source = target,
					Ability = self.ab,
					EffectName = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf",
					iMoveSpeed = 1000,
					vSourceLoc = hero:GetAbsOrigin(),
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = false,
				}
				ProjectileManager:CreateTrackingProjectile(info)
				break
			end
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:steal(target)
	if IsServer() and target~=nil then
	local steal = math.min(self.ab:GetSpecialValueFor("int_steal"),target:GetBaseIntellect())
	self:SetStackCount(self:GetStackCount() + steal)
	self.caster:SetBaseIntellect(self.caster:GetBaseIntellect()+steal)
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_steal_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(pfx1, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx1, 1, Vector(10+steal,0,0))	
	ParticleManager:ReleaseParticleIndex(pfx1)
	target:SetBaseIntellect(target:GetBaseIntellect()-steal)	
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_victim_count.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(10+steal,0,0))	
	ParticleManager:ReleaseParticleIndex(pfx2)
	end
end



modifier_imba_silencer_glaives_of_wisdom_buff = class({})

function modifier_imba_silencer_glaives_of_wisdom_buff:IsDebuff()			return false end
function modifier_imba_silencer_glaives_of_wisdom_buff:IsHidden() 
	return false
end		
function modifier_imba_silencer_glaives_of_wisdom_buff:IsPurgable() 		return false end
function modifier_imba_silencer_glaives_of_wisdom_buff:IsPurgeException() 	return false end
function modifier_imba_silencer_glaives_of_wisdom_buff:DeclareFunctions() --,MODIFIER_EVENT_ON_ATTACK,MODIFIER_EVENT_ON_ATTACK_RECORD,MODIFIER_EVENT_ON_ORDER
	return	{MODIFIER_PROPERTY_STATS_INTELLECT_BONUS} 
end

function modifier_imba_silencer_glaives_of_wisdom_buff:GetModifierBonusStats_Intellect()
	return self:GetStackCount()*4
end

function modifier_imba_silencer_glaives_of_wisdom_buff:OnCreated()
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
	end
end

function modifier_imba_silencer_glaives_of_wisdom_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end
modifier_imba_silencer_glaives_of_wisdom_debuff = class({})

function modifier_imba_silencer_glaives_of_wisdom_debuff:IsDebuff()			return false end
function modifier_imba_silencer_glaives_of_wisdom_debuff:IsHidden() 
	return false
end		
function modifier_imba_silencer_glaives_of_wisdom_debuff:IsPurgable() 		return false end
function modifier_imba_silencer_glaives_of_wisdom_debuff:IsPurgeException() 	return false end
function modifier_imba_silencer_glaives_of_wisdom_debuff:DeclareFunctions() --,MODIFIER_EVENT_ON_ATTACK,MODIFIER_EVENT_ON_ATTACK_RECORD,MODIFIER_EVENT_ON_ORDER
	return	{MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end
function modifier_imba_silencer_glaives_of_wisdom_debuff:GetModifierBonusStats_Intellect()
	return self:GetStackCount()*-4
end

function modifier_imba_silencer_glaives_of_wisdom_debuff:OnCreated()
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
	end
end
function modifier_imba_silencer_glaives_of_wisdom_debuff:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end