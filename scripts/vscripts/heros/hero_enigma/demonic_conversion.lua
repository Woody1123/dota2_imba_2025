demonic_conversion=class({})
LinkLuaModifier("modifier_demonic_conversion_buff", "heros/hero_enigma/demonic_conversion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_malefice_debuff", "heros/hero_enigma/malefice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_malefice_debuff1", "heros/hero_enigma/malefice.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function demonic_conversion:IsHiddenWhenStolen() 
    return false 
end

function demonic_conversion:IsStealable() 
    return true 
end

function demonic_conversion:IsRefreshable() 			
    return true 
end

function demonic_conversion:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local duration =self:GetSpecialValueFor("dur")
    local spawn_count =self:GetSpecialValueFor("spawn_count")
    if caster.demonic_conversionnum==nil then 
        caster.demonic_conversionnum=0
        caster.demonic_conversionmax=0
        caster.demonic_conversioncd=0
    end
    cur_tar:EmitSound("Hero_Enigma.Demonic_Conversion")
    if ( cur_tar:IsCreep() or cur_tar:IsNeutralUnitType() ) and not cur_tar:IsBoss()  then
            cur_tar:Kill( nil, caster )
    end 
    for num=1,spawn_count do 
        local eid=CreateUnitByName("npc_dota_dire_eidolon", cur_tar:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
        eid:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
        eid:AddNewModifier(caster, self, "modifier_kill", {duration=duration})
		eid:AddNewModifier(caster, self, "modifier_unit_remove", {duration=duration})
        eid:AddNewModifier(caster, self, "modifier_demonic_conversion_buff", {duration=duration,son = 1})
    end 
end

modifier_demonic_conversion_buff= class({})


function modifier_demonic_conversion_buff:IsHidden() 			
    return true 
end

function modifier_demonic_conversion_buff:IsPurgable() 		
    return false
end

function modifier_demonic_conversion_buff:IsPurgeException() 
    return false 
end
function modifier_demonic_conversion_buff:CheckState()
    return
    {
		[MODIFIER_STATE_CANNOT_MISS] = true,
    }
end
function modifier_demonic_conversion_buff:OnCreated(keys)
	if self:GetAbility() == nil then return end
    self.caster=self:GetCaster()
    self.split_attack_count=self:GetAbility():GetSpecialValueFor("split_attack_count")
    self.duration =self:GetAbility():GetSpecialValueFor("dur")
    self.eidolon_hp =self:GetAbility():GetSpecialValueFor("eidolon_hp")
    self.max =self:GetAbility():GetSpecialValueFor("max")
	self.magic_dmg = self.caster:GetIntellect(false)
	self.hp = 40
    local eidolon_dmg =self:GetAbility():GetSpecialValueFor("eidolon_dmg")
    if not IsServer() then
        return
    end  
	self.son = keys.son
	if self.son == 0 then
		self.hp = 5
	end
    local p= ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(p, 1, self.caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p)
    self:GetParent():SetBaseMaxHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
    self:GetParent():SetMaxHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
    self:GetParent():SetHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
    self:GetParent():SetBaseDamageMax(eidolon_dmg)
    self:GetParent():SetBaseDamageMin(eidolon_dmg)
	self:GetParent():SetPhysicalArmorBaseValue(self:GetCaster():GetLevel())
    self.caster.demonic_conversionmax= self.caster.demonic_conversionmax+1
	--[[
	Timers:CreateTimer(0.2,function()
		self:GetParent():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())		
	return nil 
	end)]]
end

function modifier_demonic_conversion_buff:OnRefresh()
   self:OnCreated()
end

function modifier_demonic_conversion_buff:OnDestroy()				
    if not IsServer() then
        return
    end  
    self.caster.demonic_conversionmax= self.caster.demonic_conversionmax-1
end


function modifier_demonic_conversion_buff:DeclareFunctions()
	return 
		{
            MODIFIER_EVENT_ON_ATTACK_LANDED,
            MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		}
end
function modifier_demonic_conversion_buff:GetModifierProcAttack_BonusDamage_Magical(keys)
	return keys.target:IsBuilding() and 0 or self.magic_dmg
end

function modifier_demonic_conversion_buff:OnAttackLanded(tg)
    if not IsServer() then
        return 
    end
    if tg.attacker == self:GetParent() and self.son == 1 then
        if  self.caster.demonic_conversionmax <self.max then
            self.caster.demonic_conversionnum=self.caster.demonic_conversionnum+1
        if self.caster.demonic_conversionnum>=self.split_attack_count then 
            self.caster.demonic_conversionnum=0
            self:GetParent():SetBaseMaxHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
            self:GetParent():SetMaxHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
            self:GetParent():SetHealth(self.eidolon_hp+self.caster:GetStrength()*self.hp)
            local eid=CreateUnitByName("npc_dota_dire_eidolon", self:GetParent():GetAbsOrigin(), true,self.caster, self.caster, self.caster:GetTeamNumber())
            eid:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
            eid:AddNewModifier(self.caster, self:GetAbility(), "modifier_kill", {duration=self.duration})
			eid:AddNewModifier(self.caster, self:GetAbility(), "modifier_unit_remove", {duration=self.duration})
			eid:AddNewModifier(self.caster, self:GetAbility(), "modifier_demonic_conversion_buff", {duration=self.duration,son = 0})
        end
    end
    end
end

function modifier_demonic_conversion_buff:OnDeath(tg)
    if not IsServer() then
        return 
    end
    if tg.unit == self:GetParent() then
        if not Is_Chinese_TG(tg.unit,tg.attacker) and  not tg.attacker:IsMagicImmune() and tg.attacker:IsHero() then 
            local ab=self.caster:FindAbilityByName("malefice")
            if ab and ab:GetLevel()>0 then  
                local dur=self.caster:TG_HasTalent("special_bonus_enigma_4") and 3 or 1
                tg.attacker:AddNewModifier(self.caster, ab, "modifier_malefice_debuff", {duration=dur})
            end 
        end
    end
end

