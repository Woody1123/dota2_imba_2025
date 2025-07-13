hammer_of_purity=class({})

LinkLuaModifier("modifier_hammer_of_purity_debuff", "heros/hero_omniknight/hammer_of_purity.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hammer_of_purity_pa", "heros/hero_omniknight/hammer_of_purity.lua", LUA_MODIFIER_MOTION_NONE)
function hammer_of_purity:GetIntrinsicModifierName() return "modifier_hammer_of_purity_pa" end
function hammer_of_purity:IsHiddenWhenStolen()
    return false
end

function hammer_of_purity:IsStealable()
    return true
end


function hammer_of_purity:IsRefreshable()
    return true
end

function hammer_of_purity:OnSpellStart()
	self.caster	= self:GetCaster()
	self.duration =	self:GetSpecialValueFor("duration")
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local caster_location	= self.caster:GetAbsOrigin()
	local target			= self:GetCursorTarget()
	local info1 = 
			{
				Target = target,
				Source = self.caster,
				Ability = self,	
				EffectName = "particles/units/heroes/hero_omniknight/omniknight_hammer_of_purity_projectile.vpcf",
				iMoveSpeed = 1500,
				vSourceLoc= self.caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,	
			}
		if target ~= nil then
			ProjectileManager:CreateTrackingProjectile(info1)
		end
end

function hammer_of_purity:OnProjectileHit(target, location)
	if target and self  then
		local caster = self:GetCaster()
		
		if target:IsMagicImmune() and not caster:IsMagicImmune() then return end
		if target:TriggerSpellAbsorb(self) then return nil end
		

		EmitSoundOn("Hero_Omniknight.HammerOfPurity.Target", target)
		local damage =  self:GetSpecialValueFor("damage") + caster:GetBaseDamageMax()*self:GetSpecialValueFor("damage_att")*0.01	
		if target:IsMagicImmune() then
			damage = damage/2
		end
		local damageTable=
							{
								attacker = caster,
								damage_type = DAMAGE_TYPE_PURE,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
								ability =  self.ability,
								victim = target,
								damage = damage
							}
		target:AddNewModifier_RS(caster,self,"modifier_hammer_of_purity_debuff",{duration =self:GetSpecialValueFor("duration")})
		 ApplyDamage(damageTable)		
		if caster:TG_HasTalent("special_bonus_omniknight_5") then
		caster:Heal(damage,caster)
		SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,damage, nil)
		end
	end 
end
modifier_hammer_of_purity_debuff=class({})

function modifier_hammer_of_purity_debuff:IsPurgable()
    return true
end

function modifier_hammer_of_purity_debuff:IsHidden()
    return false
end

function modifier_hammer_of_purity_debuff:IsDebuff()
    return true
end

function modifier_hammer_of_purity_debuff:DeclareFunctions()
    return
     {
         MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		 MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        }
end

function modifier_hammer_of_purity_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.move
end

function modifier_hammer_of_purity_debuff:GetModifierDamageOutgoing_Percentage()
    return self.nerf
end
function modifier_hammer_of_purity_debuff:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_overhead_debuff.vpcf"
end


function modifier_hammer_of_purity_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hammer_of_purity_debuff:OnCreated(tg)
	if self:GetAbility() == nil then return end
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
	if self.ability ~= nil then
		self.move = self.ability:GetSpecialValueFor("slow")*-1
		self.nerf = self.ability:GetSpecialValueFor("dam_nerf")*-1
	end
end




modifier_hammer_of_purity_pa = class({})

function modifier_hammer_of_purity_pa:IsDebuff()
    return false
end

function modifier_hammer_of_purity_pa:IsHidden()
    return true
end

function modifier_hammer_of_purity_pa:IsPurgable()
    return false
end

function modifier_hammer_of_purity_pa:IsPurgeException()
    return false
end

function modifier_hammer_of_purity_pa:DeclareFunctions()
    return
     {
         MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
end
function modifier_hammer_of_purity_pa:OnCreated()
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end

function modifier_hammer_of_purity_pa:OnAttackLanded(tg)
	if not IsServer() then
			return
	end
    if self.ability and tg.attacker==self.parent and not self.parent:PassivesDisabled() and tg.target:IsAlive() and not self.parent:IsIllusion() and not tg.target:IsBuilding() then 
				if tg.target:IsMagicImmune() and not tg.attacker:IsMagicImmune() then return end
                if PseudoRandom:RollPseudoRandom(self.ability, self.ability:GetSpecialValueFor("chance")) then
				
				local info1 = 
							{
								Target = tg.target, 
								Source = self.parent,
								Ability = self.ability,	
								EffectName = "particles/units/heroes/hero_omniknight/omniknight_hammer_of_purity_projectile.vpcf",
								iMoveSpeed = 1500,
								vSourceLoc= self.parent:GetAbsOrigin(),
								bDrawsOnMinimap = false,
								bDodgeable = true,
								bIsAttack = false,
								bVisibleToEnemies = true,
								bReplaceExisting = false,
								bProvidesVision = false,	
							}
						if tg.target ~= nil then
							ProjectileManager:CreateTrackingProjectile(info1)
						end
                end
    end
end

