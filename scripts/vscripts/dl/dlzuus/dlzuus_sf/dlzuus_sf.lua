dlzuus_sf = class({})

LinkLuaModifier( "modifier_dlzuus_sf_zuus", "dl/dlzuus/dlzuus_sf/modifier_dlzuus_sf_zuus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlzuus_sf_zuus_motion", "dl/dlzuus/dlzuus_sf/dlzuus_sf", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlzuus_sf_zuus_motion", "dl/dlzuus/dlzuus_sf/dlzuus_sf", LUA_MODIFIER_MOTION_NONE )
function dlzuus_sf:GetIntrinsicModifierName()
	return "modifier_dlzuus_sf_zuus"
end

function dlzuus_sf:OnSpellStart()
	if not IsServer() then return end
	self.caster = self:GetCaster()

	local pos = self:GetCursorPosition()
	local direction = (pos - self.caster:GetAbsOrigin()):Normalized()
		direction.z = 0
	local max_distance = self:GetSpecialValueFor("distance")  + self.caster:GetCastRangeBonus()
	local distance = math.min(max_distance, (self.caster:GetAbsOrigin() - pos):Length2D())
	local tralve_duration = 0.3
		EmitSoundOn( "Hero_Zuus.Taunt.Jump", self.caster )


	--self.caster:AddNewModifier(self.caster, self, "imba_marci_3_yidong", {duration = tralve_duration, direction = direction})
	self.caster:AddNewModifier(self.caster, self, "modifier_dlzuus_sf_zuus_motion", {duration = tralve_duration, direction = direction,dis = distance,pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})	


end

modifier_dlzuus_sf_zuus_motion = class({})

function modifier_dlzuus_sf_zuus_motion:IsDebuff()			return false end
function modifier_dlzuus_sf_zuus_motion:IsHidden() 			return true end
function modifier_dlzuus_sf_zuus_motion:IsPurgable() 		return false end
function modifier_dlzuus_sf_zuus_motion:IsPurgeException() 	return false end
function modifier_dlzuus_sf_zuus_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
--function modifier_dlzuus_sf_zuus_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_dlzuus_sf_zuus_motion:GetOverrideAnimation() return  ACT_DOTA_TAUNT end
function modifier_dlzuus_sf_zuus_motion:GetEffectName() return "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf" end
function modifier_dlzuus_sf_zuus_motion:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_dlzuus_sf_zuus_motion:CheckState()
	return {--[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			--[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_TETHERED] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,}
end

function modifier_dlzuus_sf_zuus_motion:IsMotionController() return true end
function modifier_dlzuus_sf_zuus_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_dlzuus_sf_zuus_motion:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_dlzuus_sf_zuus_motion:OnCreated(keys)
	if IsServer() then
		if self:GetAbility()~= nil  then
		
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.impact_radius = self.ability:GetSpecialValueFor("ra")
			self.damage = self.ability:GetSpecialValueFor("int")*self.parent:GetIntellect(false)
			self.pa_dur = self.ability:GetSpecialValueFor("pa_dur")
			self.vision = self.ability:GetSpecialValueFor("vision_ra")
			self.duration = keys.duration
			self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
			self.dis = keys.dis+50
			local dis_t =(self.dis/self.duration)
			self.distance = dis_t*FrameTime()
			self.height = keys.height or self.parent:GetAbsOrigin().z+350
			self.dist_a = 0
			self.damageInfo =
					{
						attacker = self:GetCaster(),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		end
	end
end


function modifier_dlzuus_sf_zuus_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.pos - self.parent:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * distance, nil)
	next_pos.z = next_pos.z - 4 * self.height * motion_progress ^ 2 + 4 * self.height * motion_progress
	self.parent:SetOrigin(next_pos)
end

function modifier_dlzuus_sf_zuus_motion:OnDestroy()
	if IsServer() then

		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
		--FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)

		AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.vision, 4, false)

		CreateModifierThinker(self.parent, self, "modifier_truesight_f", {duration = 4}, self.parent:GetAbsOrigin(),self.parent:GetTeamNumber(), false)
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),self.parent:GetAbsOrigin(), nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
				TG_AddNewModifier_RS(enemy, self.parent, self.ability, "modifier_paralyzed", {duration = self.pa_dur})
				self.damageInfo.victim = enemy
				self.damageInfo.damage = self.damage
				
				local tpos = enemy:GetAbsOrigin() tpos.z=tpos.z+200

				local particle_cast2 = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
				local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil )
				local t0pos = enemy:GetAbsOrigin() t0pos.z = t0pos.z+1000
				ParticleManager:SetParticleControl( effect_cast2, 0, t0pos )
				ParticleManager:SetParticleControl( effect_cast2, 1, tpos )

				local particle_cast3 = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf"
				local effect_cast3 = ParticleManager:CreateParticle( particle_cast3, PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( effect_cast3, 0, tpos )
				ParticleManager:SetParticleControl( effect_cast3, 2, tpos )

				--ParticleManager:ReleaseParticleIndex( effect_cast )
				ParticleManager:ReleaseParticleIndex( effect_cast2 )
				ParticleManager:ReleaseParticleIndex( effect_cast3 )
				EmitSoundOn( "Hero_Zuus.LightningBolt", enemy )
				ApplyDamage( self.damageInfo )
				
			end	
		


	end
end