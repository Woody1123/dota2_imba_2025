macropyre=class({})
LinkLuaModifier("modifier_macropyre_debuff", "heros/hero_jakiro/macropyre.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_thinker", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_thinker_debuff", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
function macropyre:IsHiddenWhenStolen()
    return false
end

function macropyre:IsStealable()
    return true
end

function macropyre:IsRefreshable()
    return true
end

function macropyre:OnSpellStart()
    local caster = self:GetCaster()
    local cpos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
    local team = caster:GetTeamNumber()
    self.dir=TG_Direction(pos,cpos)
    self.dis=TG_Distance(pos,cpos)
	self.pos = pos
	self.cast_range = self:GetSpecialValueFor("cast_range")
    local dur = self:GetSpecialValueFor("duration")
    local path_radius=self:GetSpecialValueFor("path_radius")
    local pos1 = RotatePosition(pos, QAngle(0, 60, 0), pos + self.dir * 300)
    local pos2 = RotatePosition(pos, QAngle(0, -60, 0), pos + self.dir * 300)
    CreateModifierThinker(caster, self, "modifier_macropyre_debuff", {duration=dur}, pos1, team, false)
    CreateModifierThinker(caster, self, "modifier_macropyre_debuff", {duration=dur}, pos2, team, false)
	
	if caster:HasScepter() then
		CreateModifierThinker(caster, self, "modifier_imba_ice_path_thinker", {duration =dur,dir_x = self.dir.x,dir_y=self.dir.y,dir_z = self.dir.z,dis = self.cast_range}, pos1, caster:GetTeamNumber(), false)	
		CreateModifierThinker(caster, self, "modifier_imba_ice_path_thinker", {duration =dur,dir_x = self.dir.x,dir_y=self.dir.y,dir_z = self.dir.z,dis = self.cast_range}, pos2, caster:GetTeamNumber(), false)
	end
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	if self:GetSpecialValueFor("talent_7") then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
    local pp =
    {
        EffectName ="particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
        Ability = self,
        vSpawnOrigin =cpos,
        vVelocity =caster:GetForwardVector()*2000,
        fDistance =self.cast_range+self.dis,
        fStartRadius = 500,
        fEndRadius = 500,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = flag,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
    }
    ProjectileManager:CreateLinearProjectile( pp )
    EmitSoundOn("Hero_Jakiro.Macropyre.Cast", caster)
end


function macropyre:OnProjectileThink_ExtraData(vLocation, table)
	GridNav:DestroyTreesAroundPoint(vLocation,300,false)
end

function macropyre:OnProjectileHit_ExtraData(target, location, kv)
    local caster = self:GetCaster()
    if target==nil then
        return
    end	
	if self:GetSpecialValueFor("talent_6") ==1 then
		local dis_1 =TG_Distance(caster:GetAbsOrigin(),self.pos+self.dir*self.cast_range/2) 
		local dis_2 = TG_Distance(self.pos+self.dir*self.cast_range/2,target:GetAbsOrigin())
		local dis_3 =TG_Distance(caster:GetAbsOrigin(),target:GetAbsOrigin()) 
		if dis_3 > dis_1 then
			dis_2 = 1
		end
		local Knockback ={
				should_stun = 1,
				knockback_duration = 1,
				duration = 1,
				knockback_distance = dis_2,
				knockback_height = 0,
				center_x =  target:GetAbsOrigin().x-self.dir.x,
				center_y =  target:GetAbsOrigin().y-self.dir.y,
				center_z =  target:GetAbsOrigin().z
			}
			 target:AddNewModifier(self:GetCaster(),self, "modifier_knockback", Knockback)
	end
	local hp = self:GetSpecialValueFor("hp")
	local damageTable = {
		attacker = caster,
        victim = target	,
        damage = target:GetMaxHealth()*hp*0.01,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self,
		}
    ApplyDamage(damageTable)
end

modifier_macropyre_debuff=class({})

function modifier_macropyre_debuff:IsPurgable()
    return false
end

function modifier_macropyre_debuff:IsPurgeException()
    return false
end

function modifier_macropyre_debuff:IsHidden()
    return true
end

function modifier_macropyre_debuff:OnCreated()
     if self:GetAbility() == nil  then return 0 end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    self.stpos=self.parent:GetAbsOrigin()
    self.cast_range=self.ability:GetSpecialValueFor("cast_range")
    self.path_radius=self.ability:GetSpecialValueFor("path_radius")
    self.damage=self.ability:GetSpecialValueFor("damage")+self.caster:GetIntellect(false)*self.ability:GetSpecialValueFor("dmg_int")
    self.burn_interval=self.ability:GetSpecialValueFor("burn_interval")
    self.dmg=self.ability:GetSpecialValueFor("dmg")
	self.flag = DOTA_UNIT_TARGET_FLAG_NONE
	if self.ability:GetSpecialValueFor("talent_7") then
		self.flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
    if IsServer() then
        self.damageTable = {
            attacker = self.parent,
            damage = self.caster:HasScepter() and self.dmg+self.damage  or self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
        }
        self.root=true
        self.dir=self.caster:GetForwardVector()
        self.pos=self.stpos+self.dir*self.cast_range
        self.pfx = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.pfx, 0, self.stpos )
        ParticleManager:SetParticleControl( self.pfx, 1, self.pos)
        ParticleManager:SetParticleControl( self.pfx, 2, Vector(self:GetRemainingTime(),0,0))
        self:AddParticle(self.pfx, false, false, 1, false, false)
        EmitSoundOn("hero_jakiro.macropyre", self.parent)
        self:StartIntervalThink(self.burn_interval)
    end
end

function modifier_macropyre_debuff:OnIntervalThink()
     if self:GetAbility() == nil  then return 0 end
    local heros = FindUnitsInLine(
        self.team,
        self.stpos,
        self.pos,
        self.parent,
        self.path_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        self.flag)
        if heros and #heros>0 then
            for _,target in pairs(heros) do
                    self.damageTable.victim = target
                    ApplyDamage(self.damageTable)
            end
            self.root=false
        end
end
