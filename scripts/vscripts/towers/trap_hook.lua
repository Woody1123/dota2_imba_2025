trap_hook=class({})
LinkLuaModifier("modifier_trap_hook_move", "towers/trap_hook.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function trap_hook:OnSpellStart(team)

	      self.wh=150

      self.vision_radius=150
      self.auto=false
	  
	  self.caster=self:GetCaster()
	  self.team = team or 1
	  local num=3 
	  local angle= -30 
	  local hooksp=1200
	  local cpos=self.caster:GetAbsOrigin()
	  local epos=self:GetCursorPosition()
	  local dir=cpos==epos and  TG_Direction(epos+Vector(1,1,0),cpos) or TG_Direction(epos,cpos)
	  for a=1, num do
     
            local pos=RotatePosition(cpos, QAngle(0, angle, 0), cpos + dir * 1000)
            local dir1=(pos - cpos):Normalized() dir1.z = 0.0
            local dis1= 1800
            local tpos=cpos + dir1* dis1
			local p = self.caster:GetAbsOrigin()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", PATTACH_CUSTOMORIGIN, nil)
				
				--ParticleManager:SetParticleControlEnt(pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "nozzle", p, true)
				ParticleManager:SetParticleControl(pfx, 0, p)
				ParticleManager:SetParticleControl(pfx, 1, self.caster:GetAbsOrigin() + dir1 * dis1)
				ParticleManager:SetParticleControl(pfx, 2, Vector(hooksp, 0, 0))
				ParticleManager:SetParticleControl(pfx, 3, Vector(3, 0, 0))
				ParticleManager:SetParticleControlEnt(pfx, 7, self.caster, PATTACH_INVALID, nil, self.caster:GetAbsOrigin(), true)
    local projectileTable =
	{
		--EffectName ="particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		Ability = self,
		vSpawnOrigin =cpos,
		vVelocity =dir1*hooksp,
		fDistance =dis1,
		fStartRadius = 150,
		fEndRadius = 150,
		Source = self.caster,
		TreeBehavior = PROJECTILES_NOTHING,
		bCutTrees = true,
		bTreeFullCollision = false,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bProvidesVision = false,
		ExtraData={hs=hooksp,fx=pfx ,hook=a }
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
	 angle=angle+30
	end
end


function trap_hook:OnProjectileHit_ExtraData( hTarget, vLocation,kv ) 

      if hTarget~=nil and (  hTarget == self.caster or hTarget:GetTeamNumber()==self.team or ( (hTarget:IsBoss() or hTarget:IsCreep() ) and Is_Chinese_TG(hTarget,self.caster) )) or kv.fx==nil  then
		return false
	end
      local fx=kv.fx
      local cpos=self.caster:GetAbsOrigin()
		if hTarget  then

			local tpos=hTarget:GetAbsOrigin()
			hTarget:InterruptMotionControllers(true)
			if hTarget:HasModifier("modifier_trap_hook_move") then
						hTarget:RemoveModifierByName("modifier_trap_hook_move")
			end
						
				  EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
				  EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )
				  hTarget:AddNewModifier( self.caster, self, "modifier_trap_hook_move", {fx=fx} )
				hTarget:EmitSound("Hero_Rattletrap.Hookshot.Impact")
				ParticleManager:SetParticleControlEnt(fx, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
				  
				  if  (hTarget:GetTeamNumber() ~= self.caster:GetTeamNumber() ) then
						if not hTarget or not IsValidEntity(hTarget) or not hTarget:IsAlive() then
							  self:HookEnd(vLocation,fx,kv.hs)
						end
				  end
		 
      else		
                 self:HookEnd(vLocation,fx,kv.hs)
	end
				return true
end

function trap_hook:HookEnd(vLocation,fx,hs)
				
					ParticleManager:SetParticleControlEnt( fx, 1, self.caster, PATTACH_POINT_FOLLOW, "nozzle", self.caster:GetAbsOrigin()+Vector( 0, 0, 96 ), true);
					ParticleManager:SetParticleControl( fx, 4, Vector( 0, 0, 0 ) )
					ParticleManager:SetParticleControl( fx, 5, Vector( 1, 0, 0 ) )
					--print(TG_Distance(self.caster:GetAbsOrigin(),vLocation)/hs*2)
                  Timers:CreateTimer(TG_Distance(self.caster:GetAbsOrigin(),vLocation)/hs*2, function()
                        if fx then
                              ParticleManager:DestroyParticle( fx, false )
                              ParticleManager:ReleaseParticleIndex(  fx )
                        end
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )

                        return nil
                  end)
end
modifier_trap_hook_move=class({})
function modifier_trap_hook_move:IsHidden()return true
end
function modifier_trap_hook_move:IsDebuff()return true
end
function modifier_trap_hook_move:IsPurgable()return false
end
function modifier_trap_hook_move:IsPurgeException()return false
end
function modifier_trap_hook_move:RemoveOnDeath()return false
end
function modifier_trap_hook_move:GetMotionPriority()return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_trap_hook_move:OnCreated( tg )
	if self:GetAbility() == nil then return end
      self.ability=self:GetAbility()
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
	if IsServer() then
            self.FX=tg.fx
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
            self:StartIntervalThink(FrameTime())
	end
end
function modifier_trap_hook_move:CheckState()
	return
      {
		[MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_PROVIDES_VISION] = true,

	}
end
function modifier_trap_hook_move:DeclareFunctions()
	return
       {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_trap_hook_move:GetOverrideAnimation( )
	return ACT_DOTA_FLAIL
end
function modifier_trap_hook_move:GetModifierProvidesFOWVision( )
	return 1
end
function modifier_trap_hook_move:OnIntervalThink( )
           if IsValidEntity(self.caster) and IsValidEntity(self.parent) then
                        local pos = (self.caster:GetAbsOrigin()-self.parent:GetAbsOrigin())
                        self.parent:SetAbsOrigin( self.parent:GetAbsOrigin() +pos:Normalized()* (1800 / (1.0 / FrameTime())) )
                        if   pos:Length2D() < 150 then
                              if self.FX then
                                    ParticleManager:DestroyParticle( self.FX, true )
                                    ParticleManager:ReleaseParticleIndex(self.FX)
                              end
                                    FindClearSpaceForUnit(self.parent,self.parent:GetAbsOrigin(), false )
                                    self:Destroy()
                                    return
                        end
            end
end
function modifier_trap_hook_move:UpdateHorizontalMotion( me, dt )
end
function modifier_trap_hook_move:OnHorizontalMotionInterrupted()
	if IsServer() then
                  if self.FX then
			      ParticleManager:SetParticleControlEnt( self.FX, 1, self.caster, PATTACH_POINT_FOLLOW, "nozzle", self.caster:GetAbsOrigin()+Vector( 0, 0, 96 ), true )
			end
                  self:Destroy()
	end
end
function modifier_trap_hook_move:OnDestroy()
	if IsServer() then
				self.parent:RemoveHorizontalMotionController(self)
                        if self.caster and self.caster:IsHero() then
                              local hHook =self.caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
                              if hHook ~= nil then
                                    hHook:RemoveEffects( EF_NODRAW )
                              end
                        end
                        StopSoundOn( "Hero_Pudge.AttackHookRetract", self.parent )
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                        self:SetDuration(0,true)
	end
end



