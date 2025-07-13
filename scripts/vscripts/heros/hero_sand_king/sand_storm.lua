sand_storm=class({})

LinkLuaModifier("modifier_sand_storm", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_inv", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_cd", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_debuff", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_1", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
function sand_storm:IsHiddenWhenStolen() 
    return false 
end

function sand_storm:IsStealable() 
    return true 
end

function sand_storm:IsRefreshable() 			
    return true 
end

function sand_storm:GetIntrinsicModifierName() 
    return "modifier_sand_storm_1" 
end

function sand_storm:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
    EmitSoundOn( "Ability.SandKing_SandStorm.start", caster )
    ProjectileManager:ProjectileDodge(caster)
	if caster.storm~=nil then
		caster.storm:Destroy()		
		caster.storm=nil
	end
   caster.storm = CreateModifierThinker(caster, self, "modifier_sand_storm", {duration=self:GetSpecialValueFor("duration")}, casterpos, caster:GetTeamNumber(), false)
end

modifier_sand_storm_1=class({})

function modifier_sand_storm_1:IsHidden() 				
    return true 
end

function modifier_sand_storm_1:IsPurgable() 				
    return false 
end

function modifier_sand_storm_1:IsPurgeException() 		
    return false 
end

function modifier_sand_storm_1:OnCreated(tg)
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    if not IsServer() then
        return
    end
    --self:StartIntervalThink(10)
end
--[[
function modifier_sand_storm_1:OnIntervalThink()
    if self.caster:IsAlive() and not self.parent:IsIllusion() and self.ability:GetAutoCastState() and self.caster:TG_HasTalent("special_bonus_sand_king_5") then
        CreateModifierThinker(self.caster, self.ability, "modifier_sand_storm", {duration=5},self.caster:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
    end
end]]

modifier_sand_storm=class({})

function modifier_sand_storm:IsHidden() 				
    return true 
end

function modifier_sand_storm:IsPurgable() 				
    return false 
end

function modifier_sand_storm:IsPurgeException() 		
    return false 
end
--[[
function modifier_sand_storm:IsAura()
    return true
 end
 
 function modifier_sand_storm:GetAuraDuration() 
    return 0 
 end
 
 function modifier_sand_storm:GetModifierAura() 
    return "modifier_sand_storm_inv" 
 end
 
 function modifier_sand_storm:GetAuraRadius() 
    return self.ability:GetSpecialValueFor("sand_storm_radius")
 end
 
 function modifier_sand_storm:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end
 
 function modifier_sand_storm:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 end
 
 function modifier_sand_storm:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO 
 end
]]
function modifier_sand_storm:OnCreated(tg)
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.pos=self.caster:GetAbsOrigin()
    self.damage_tick_rate=self.ability:GetSpecialValueFor("damage_tick_rate")
    self.sand_storm_radius=self.ability:GetSpecialValueFor("sand_storm_radius")+self.caster:GetCastRangeBonus()
    self.sand_storm_damage=self.ability:GetSpecialValueFor("sand_storm_damage")
    if not IsServer() then
        return
    end
	self.Knockback ={
                    should_stun = 0.25,
                    knockback_duration = 0.25,
                    duration = 0.25,
                    knockback_distance = 0,
                    knockback_height = 300,
                }
	self.damageTable= 
	{
		attacker = self.caster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	}
    EmitSoundOn( "Ability.SandKing_SandStorm.loop", self.parent )
    self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(self.fx, 0,self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.fx, 1, Vector(self.sand_storm_radius, self.sand_storm_radius, self.sand_storm_radius))
    self:AddParticle(self.fx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(self.damage_tick_rate)
	
	--吸入
	if self.ability:GetAutoCastState() then
		local targets = FindUnitsInRadius(
                self.team,
                self.pos,
                nil,
                600,
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST,
                false)
				if #targets>0 then
                    for _, target in pairs(targets) do
						if not target:HasModifier("modifier_fountain_aura_buff") then 
							FindClearSpaceForUnit(target, self.pos, true)
						end
					end   
				end
	end
	
            
end

function modifier_sand_storm:OnIntervalThink()
	if (self.caster:GetAbsOrigin()-self.pos):Length2D()<self.sand_storm_radius then
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_inv", {duration=1.2})
	end
    if self.caster:HasModifier("modifier_sand_storm_inv") then
	if self.caster:TG_HasTalent("special_bonus_sand_king_5") then
		for tr = 0,6 do
			local newpos =RotatePosition(self.pos,QAngle(0, tr*60, 0), self.pos + self.caster:GetForwardVector():Normalized() * self.sand_storm_radius/3)
					local pos_end = GetRandomPosition2D(newpos,self.sand_storm_radius/3)
					local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm_burrowstrike_field_explosion.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
					ParticleManager:SetParticleControl(fx, 0, pos_end)
					ParticleManager:SetParticleControl(fx, 1, pos_end)
					ParticleManager:ReleaseParticleIndex(fx)
					local enemys = FindUnitsInRadius(
					self.team,
					pos_end,
					nil,
					120+self.caster:GetCastRangeBonus()*0.15,
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_CLOSEST,
					false)
					
					for _, enemy in pairs(enemys) do
						self.Knockback.center_x =  enemy:GetAbsOrigin().x
						self.Knockback.center_y =  enemy:GetAbsOrigin().y
						self.Knockback.center_z =  enemy:GetAbsOrigin().z
						enemy:AddNewModifier(self.caster,self:GetAbility(), "modifier_knockback", self.Knockback)
						self.damageTable.victim = enemy
						self.damageTable.damage = 500
						ApplyDamage(self.damageTable)
					 end
		end
	end
		local radius = math.min(1000,self.sand_storm_radius)
        local targets = FindUnitsInRadius(
                self.team,
                self.pos,
                nil,
                radius,
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST,
                false)
            if #targets>0 then
                    for _, target in pairs(targets) do
									self.damageTable.victim = target
									self.damageTable.damage = self.sand_storm_damage
                                    ApplyDamage(self.damageTable)

                                target:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_debuff", {duration=self.fade_delay})
                            end
            end
    end
end

function modifier_sand_storm:OnDestroy()
    if not IsServer() then
        return
    end
		self.caster.storm=nil
        StopSoundOn("Ability.SandKing_SandStorm.loop", self.parent)
end

modifier_sand_storm_inv=class({})

function modifier_sand_storm_inv:IsHidden() 				
    return false 
end

function modifier_sand_storm_inv:IsPurgable() 				
    return false 
end

function modifier_sand_storm_inv:IsPurgeException() 		
    return false 
end

function modifier_sand_storm_inv:DeclareFunctions()
	return 
    {
        MODIFIER_EVENT_ON_ATTACK, 
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_START
    }
end

function modifier_sand_storm_inv:OnCreated(tg)
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.fade_delay=self.ability:GetSpecialValueFor("fade_delay")
    self.hp=self.ability:GetSpecialValueFor("hp")+self.caster:TG_GetTalentValue("special_bonus_sand_king_2")
    if not IsServer() then
        return
    end
end

function modifier_sand_storm_inv:OnAttack(tg)
	if not IsServer() then
		return
	end
	if tg.attacker == self.parent then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_cd", {duration=self.fade_delay})
	end
end

function modifier_sand_storm_inv:OnAbilityStart(tg)
	if not IsServer() then
		return
	end
	if tg.unit == self.parent then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_cd", {duration=self.fade_delay})
	end
end

function modifier_sand_storm_inv:GetModifierInvisibilityLevel() 
    if self.parent:HasModifier("modifier_sand_storm_cd") then
        return 0
    else 
        return 1
    end 
end

function modifier_sand_storm_inv:GetModifierHealthRegenPercentage() 
    return self.hp
end


function modifier_sand_storm_inv:CheckState()
   if self.parent:HasModifier("modifier_sand_storm_cd") then
        return {}
    else 
        return 
        {
            [MODIFIER_STATE_INVISIBLE] = true, 
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        }
    end 
end



modifier_sand_storm_cd=class({})

function modifier_sand_storm_cd:IsHidden() 				
    return true 
end

function modifier_sand_storm_cd:IsPurgable() 				
    return false 
end

function modifier_sand_storm_cd:IsPurgeException() 		
    return false 
end

modifier_sand_storm_debuff=class({})

function modifier_sand_storm_debuff:IsHidden() 				
    return true 
end

function modifier_sand_storm_debuff:IsPurgable() 				
    return false 
end

function modifier_sand_storm_debuff:IsPurgeException() 		
    return false 
end