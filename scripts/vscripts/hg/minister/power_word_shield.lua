power_word_shield=class({})
LinkLuaModifier("modifier_power_word_shield", "hg/minister/power_word_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_power_word_shield_weak", "hg/minister/power_word_shield.lua", LUA_MODIFIER_MOTION_NONE)

function power_word_shield:IsHiddenWhenStolen()
    return false 
end

function power_word_shield:IsRefreshable()
    return true
end

function power_word_shield:IsStealable()
    return true 
end


function power_word_shield:GetManaCost()
    return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_cost") / 100)
end


function power_word_shield:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if IsEnemy(caster, target) then
		return UF_FAIL_CUSTOM
	end
    if  (target:HasModifier("modifier_power_word_shield_weak") and not caster:HasModifier("大招")) then
        return UF_FAIL_CUSTOM
    end
	return UF_SUCCESS
end

function power_word_shield:GetCustomCastErrorTarget(target)
    if IsEnemy(self:GetCaster(), target) then
        return "无法对敌人释放"
    else
        return "虚弱中"
    end
end


function power_word_shield:OnSpellStart()
    local caster=self:GetCaster()
	local target=self:GetCursorTarget()
    local shield=self:GetSpecialValueFor("shield")+self:GetSpecialValueFor("mana_cost")*self:GetCaster():GetMaxMana()*self:GetSpecialValueFor("mana_res") / 100
    EmitSoundOn("Hero_Abaddon.AphoticShield.Cast",caster)


    target:Purge(false, true, false, true, true)

	target:AddNewModifier(caster, self, "modifier_power_word_shield", {duration = self:GetSpecialValueFor("duration"),shield=shield})
    target:AddNewModifier(caster, self, "modifier_power_word_shield_weak", {duration = self:GetSpecialValueFor("weak_duration")})
end


modifier_power_word_shield=class({})

function modifier_power_word_shield:IsPurgable()
    return false
end

function modifier_power_word_shield:IsPurgeException()
    return false
end

function modifier_power_word_shield:IsHidden()
    return false 
end

function modifier_power_word_shield:OnCreated(tg)
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", self.parent)
	if IsServer() then
        self:SetStackCount(tg.shield)
        local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(fx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(fx2, 1,Vector(100,0,0))
		self:AddParticle(fx2, false, false, 1, false, false)
	end
end

function modifier_aphotic_shield:OnDestroy()
	if self:GetAbility() == nil then return end
    EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy",self.parent)
	StopSoundOn("Hero_Abaddon.AphoticShield.Loop",self.parent)
	if IsServer() then
        local damage=self.ability:GetSpecialValueFor("damage_absorb")+self.caster:TG_GetTalentValue("special_bonus_abaddon_5")
        local hp=self.ability:GetSpecialValueFor("hp")*0.01
	end
end

function modifier_aphotic_shield:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

end

function modifier_aphotic_shield:GetModifierTotal_ConstantBlock(tg)
    if self.ability and tg.target==self.parent then
        local surplus=self:GetStackCount()-tg.damage
        if surplus<=0 then
            self:Destroy()
            return surplus+tg.damage
        else
            self:SetStackCount(surplus)
            return tg.damage
        end
    end
end

function modifier_aphotic_shield:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("weak_duration")
end