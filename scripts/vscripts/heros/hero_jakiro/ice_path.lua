
ice_path=ice_path or class({})

LinkLuaModifier("modifier_ice_path_debuff", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_thinker", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_thinker_debuff", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_slow", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)


function ice_path:IsHiddenWhenStolen()
    return false
end

function ice_path:IsStealable()
    return true
end

function ice_path:IsRefreshable()
    return true
end

function ice_path:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
	local hpos=caster:GetUpVector()*100
	local dis=self:GetSpecialValueFor("dis")
	local casterposend = casterpos+caster:GetForwardVector()*(dis+self:GetSpecialValueFor("talent_4")*caster:GetCastRangeBonus())
	casterposend.z=0
	local dis=(casterposend-casterpos):Length2D()
	local dir=TG_Direction(casterposend,casterpos)
	if dis<=0 then
		dir=caster:GetForwardVector()
	end
	local wh=self:GetSpecialValueFor("wh")
	local b_count=self:GetSpecialValueFor("b_count")
	local b_i=self:GetSpecialValueFor("b_i")
	local b_dis=self:GetSpecialValueFor("b_dis")
	local b_rd=self:GetSpecialValueFor("b_rd")
	local b_dam=self:GetSpecialValueFor("b_dam")
	local stun=self:GetSpecialValueFor("stun")
	local dam=self:GetSpecialValueFor("dam")
	local duration = self:GetSpecialValueFor("duration")
	EmitSoundOn( "Hero_Jakiro.IcePath", caster )
	
	--local pfx = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf", PATTACH_CUSTOMORIGIN, nil )
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 0, casterpos+hpos )
	ParticleManager:SetParticleControl( pfx, 1, casterposend+hpos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( 1, 0, 1 ))
	ParticleManager:ReleaseParticleIndex( pfx )
	--

	local Projectile=
	{
		Ability = self,
		vSpawnOrigin = casterpos,
		EffectName =nil,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity	=caster:GetForwardVector()*1000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile( Projectile)
	local dis2=0
	local count=b_count
	local num=0

	Timers:CreateTimer(1, function()
		dis2=dis2+b_dis
		num=num+1
		local bpos=casterpos+dir*dis2
		EmitSoundOnLocationWithCaster( bpos, "TG.jkboom", caster )
		local p = ParticleManager:CreateParticle( "particles/econ/events/ti9/high_five/high_five_impact_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( p, 3, bpos )
		ParticleManager:ReleaseParticleIndex( p )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), bpos, nil, b_rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,target in pairs(enemies) do
			local damageTable = {
				victim = target,
				attacker =  self:GetCaster(),
				damage = dam/2,
				damage_type =DAMAGE_TYPE_MAGICAL,
				ability = self,
				}
				ApplyDamage(damageTable)
		end
		if num>=count then
			return nil
		else
			return  b_i
		end
	end
	)
	
	CreateModifierThinker(caster, self, "modifier_imba_ice_path_thinker", {duration =duration,dir_x = dir.x,dir_y=dir.y,dir_z = dir.z,dis = dis}, casterpos, caster:GetTeamNumber(), false)
end

function ice_path:OnProjectileHit_ExtraData(target, location, kv)

	if not target then
		return
	end
	local stun=self:GetSpecialValueFor("stun")
	local dam=self:GetSpecialValueFor("dam")
	if not target:IsMagicImmune() then
		target:AddNewModifier_RS(  self:GetCaster(), self, "modifier_ice_path_debuff", {duration=stun} )
		local damageTable = {
			victim = target,
			attacker =  self:GetCaster(),
			damage = dam,
			damage_type =DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
			ability = self,
			}
			ApplyDamage(damageTable)
	end
end

modifier_imba_ice_path_thinker = class({})

function modifier_imba_ice_path_thinker:OnCreated(tg)
	if IsServer() then
		self.dir = Vector(tg.dir_x,tg.dir_y,tg.dir_z)--ToVector(tg.dir)
		self.dis = tg.dis
		self.start_pos = self:GetParent():GetAbsOrigin()
		self.end_pos = self.start_pos+self.dis*self.dir 
		self.width = 300
		self.pos = self:GetParent():GetAbsOrigin()
		
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf", PATTACH_CUSTOMORIGIN, nil )
	--local pfx2 = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_b.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 0, self.pos + self:GetParent():GetUpVector()*100 )
	ParticleManager:SetParticleControl( pfx, 1, self.end_pos + self:GetParent():GetUpVector()*100)
	ParticleManager:SetParticleControl( pfx, 2, Vector( self:GetDuration(), 0, 0 ) )
	ParticleManager:SetParticleControlEnt(pfx, 9, self:GetCaster(), PATTACH_POINT_FOLLOW ,"attach_attack1", self.pos, true)
	ParticleManager:ReleaseParticleIndex( pfx )
		self:StartIntervalThink(0.5)
	end        
end

function modifier_imba_ice_path_thinker:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local thinker = self:GetParent()
	local ability = self:GetAbility()

	local enemy = FindUnitsInLine(
	caster:GetTeamNumber(),
	self.start_pos,
	self.end_pos,
	thinker,
	250,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_NONE)
	
	for i=1, #enemy do
		if not enemy[i]:IsMagicImmune() then
			enemy[i]:AddNewModifier(caster,self:GetAbility(),"modifier_imba_ice_path_slow",{duration = 0.6})
		end
	end
end
modifier_imba_ice_path_slow = class({})
function modifier_imba_ice_path_slow:IsDebuff()			return true end
function modifier_imba_ice_path_slow:IsHidden() 			return true end
function modifier_imba_ice_path_slow:IsPurgable() 			return true end
function modifier_imba_ice_path_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		}
end
function modifier_imba_ice_path_slow:GetModifierMoveSpeedBonus_Percentage()
	return -80
end

modifier_ice_path_debuff=modifier_ice_path_debuff or class({})
function modifier_ice_path_debuff:IsDebuff()
    return true
end
function modifier_ice_path_debuff:IsPurgable()
    return false
end
function modifier_ice_path_debuff:IsPurgeException()
    return true
end
function modifier_ice_path_debuff:IsHidden()
    return false
end


function modifier_ice_path_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
   end

function modifier_ice_path_debuff:StatusEffectPriority()
   return 100
end

function modifier_ice_path_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_frozen.vpcf"
end

function modifier_ice_path_debuff:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_ice_path_debuff:CheckState()
    return
     {
            [MODIFIER_STATE_FROZEN] = true,
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_SILENCED] = true,
    }
end
