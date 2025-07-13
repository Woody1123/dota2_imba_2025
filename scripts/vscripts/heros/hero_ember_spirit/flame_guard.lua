flame_guard=class({})

LinkLuaModifier("modifier_flame_guard_pa", "heros/hero_ember_spirit/flame_guard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flame_guard_buff", "heros/hero_ember_spirit/flame_guard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flame_guard_cd", "heros/hero_ember_spirit/flame_guard.lua", LUA_MODIFIER_MOTION_NONE)
function flame_guard:IsHiddenWhenStolen() 		
    return false
end

function flame_guard:IsRefreshable() 			
    return true 
end

function flame_guard:IsStealable() 			
    return true 
end

function flame_guard:GetIntrinsicModifierName() 	
        return "modifier_flame_guard_pa" 
end

function flame_guard:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_EmberSpirit.FlameGuard.Cast", caster)
	caster:RemoveModifierByName("modifier_flame_guard_buff")
    caster:AddNewModifier(caster, self, "modifier_flame_guard_buff", {duration=duration})
end

modifier_flame_guard_pa=class({})

function modifier_flame_guard_pa:IsPassive()			
    return true 
end

function modifier_flame_guard_pa:IsHidden() 			
    return true 
end

function modifier_flame_guard_pa:IsPurgable() 			
    return false 
end

function modifier_flame_guard_pa:IsPurgeException() 	
    return false 
end

function modifier_flame_guard_pa:OnCreated()	
	if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
    self.cd = self.ability:GetSpecialValueFor("cd")
    if IsServer() then
        self:StartIntervalThink(9)
    end  
end

function modifier_flame_guard_pa:OnIntervalThink()	
    EmitSoundOn("Hero_EmberSpirit.FlameGuard.Cast", self.parent)
	self.parent:RemoveModifierByName("modifier_flame_guard_buff")
    self.parent:AddNewModifier( self.parent, self.ability, "modifier_flame_guard_cd", {duration= self.ability:GetSpecialValueFor("cd")})
    self.parent:AddNewModifier( self.parent, self.ability, "modifier_flame_guard_buff", {duration= self.ability:GetSpecialValueFor("duration")})
end

modifier_flame_guard_cd=class({})

function modifier_flame_guard_cd:IsHidden() 			
    return false 
end

function modifier_flame_guard_cd:IsPurgable() 			
    return false 
end

function modifier_flame_guard_cd:IsPurgeException() 	
    return false 
end

function modifier_flame_guard_cd:GetTexture() 	
    return "flame_guard_cd" 
end



modifier_flame_guard_buff=class({})

function modifier_flame_guard_buff:IsHidden() 			
    return false 
end

function modifier_flame_guard_buff:IsPurgable() 			
    return false 
end

function modifier_flame_guard_buff:IsPurgeException() 	
    return false 
end

function modifier_flame_guard_buff:OnCreated()	
	if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
    self.team=self.parent:GetTeamNumber()
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.tick_interval=self.ability:GetSpecialValueFor("tick_interval")
    self.damage_per_second=self.ability:GetSpecialValueFor("damage_per_second")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_7")
    self.absorb_amount=self.ability:GetSpecialValueFor("absorb_amount")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_4")
    self.dam=
    {
        attacker = self.parent,
        ability = self.ability,
        damage = self.damage_per_second,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    if IsServer() then
        self:SetStackCount(self.absorb_amount)      
        local pf = ParticleManager:CreateParticle("particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControlForward(pf, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControlForward(pf, 1, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(pf, 2, Vector( self.radius, 0, 0))
        self:AddParticle(pf, false, false, -1, false, false)
        EmitSoundOn("Hero_EmberSpirit.FlameGuard.Loop", self.parent)
		
		self.shield_count = self.ability:GetSpecialValueFor("absorb_amount")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_4")
		self:SetStackCount(self.shield_count)
		
        self:StartIntervalThink(self.tick_interval)
    end  
end

function modifier_flame_guard_buff:OnRefresh()	
    self.team=self.parent:GetTeamNumber()
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.tick_interval=self.ability:GetSpecialValueFor("tick_interval")
    self.damage_per_second=self.ability:GetSpecialValueFor("damage_per_second")
    self.absorb_amount=self.ability:GetSpecialValueFor("absorb_amount")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_4")
    self.dam=
    {
        attacker = self.parent,
        ability = self.ability,
        damage = self.damage_per_second,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    if IsServer() then
        self:SetStackCount(self.absorb_amount)      
        self:StartIntervalThink(self.tick_interval)
    end  
end

function modifier_flame_guard_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT}
end

function modifier_flame_guard_buff:GetModifierIncomingDamageConstant(keys)
		if not IsServer() then
			 return self:GetStackCount() 
		end		 
		if self:GetParent():TG_HasTalent("special_bonus_ember_spirit_5") then
			 self.shield_count = self.shield_count - keys.damage     		
			-- print(self.shield_count)
			 self:SetStackCount(math.max(1,self.shield_count))
			 if self:GetStackCount() == 1 then
				self:Destroy()
			 end
			return -(self.shield_count + keys.damage) 
			else
			if keys.damage_type == 2 then
				self.shield_count = self.shield_count - keys.damage     		
			-- print(self.shield_count)
				 self:SetStackCount(math.max(1,self.shield_count))
				 if self:GetStackCount() == 1 then
					self:Destroy()
				 end
				return -(self.shield_count + keys.damage) 
			end
		end
		return 0
end
function modifier_flame_guard_buff:OnIntervalThink()	
    if not self.parent:IsAlive() then
        return 
    end 
    local heroes = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #heroes>0 then 
        for _,tar in pairs(heroes) do
            if not tar:IsMagicImmune() then 
                self.dam.victim=tar
                ApplyDamage(self.dam)
            end 
        end
    end
end

function modifier_flame_guard_buff:OnDestroy()
	if IsServer() then
		 StopSoundOn("Hero_EmberSpirit.FlameGuard.Loop", self.parent)
	end
end
