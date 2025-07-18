wave_of_terror=class({})
LinkLuaModifier("modifier_wave_of_terror_debuff", "heros/hero_vengefulspirit/wave_of_terror.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_of_terror_buff", "heros/hero_vengefulspirit/wave_of_terror.lua", LUA_MODIFIER_MOTION_NONE)

function wave_of_terror:IsHiddenWhenStolen()
    return false
end

function wave_of_terror:IsStealable()
    return true
end


function wave_of_terror:IsRefreshable()
    return true
end


function wave_of_terror:OnSpellStart()
    local caster=self:GetCaster()
	local caster_pos=caster:GetAbsOrigin()
	local pos=self:GetCursorPosition()
	local dir=TG_Direction(pos+Vector(1,1,0),caster_pos)
	local wave_speed=self:GetSpecialValueFor( "wave_speed" )
	local wave_width=self:GetSpecialValueFor( "wave_width" )
	local vision_aoe=self:GetSpecialValueFor( "vision_aoe" )
	local dis=self:GetSpecialValueFor( "dis" )+caster:GetCastRangeBonus()+caster:Script_GetAttackRange()
	local wave_damage=self:GetSpecialValueFor( "wave_damage" )
	EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror" , caster)
	local p = {
		EffectName = "particles/econ/items/vengeful/vengeful_weapon_talon/vengeful_wave_of_terror_weapon_talon.vpcf",
		Ability = self,
		vSpawnOrigin = caster_pos,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		vVelocity = dir * wave_speed,
		fDistance = dis,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = vision_aoe,
        ExtraData = {hit=0}
	}
    ProjectileManager:CreateLinearProjectile(p)
	self:AddBuff(caster,self)
    if caster:HasScepter() then
        Timers:CreateTimer(1, function()
            EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror" , caster)
            local p = {
                EffectName = "particles/econ/items/vengeful/vengeful_weapon_talon/vengeful_wave_of_terror_weapon_talon.vpcf",
                Ability = self,
                vSpawnOrigin = caster_pos+dir*dis,
                fStartRadius = wave_width,
                fEndRadius = wave_width,
                vVelocity = -dir * wave_speed,
                fDistance = dis,
                Source = caster,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                bProvidesVision = true,
                iVisionTeamNumber = caster:GetTeamNumber(),
                iVisionRadius = vision_aoe,
                ExtraData = {hit=1}
            }
            ProjectileManager:CreateLinearProjectile(p)
			self:AddBuff(caster,self)
            return nil
        end)
    end
end


function wave_of_terror:OnProjectileHit_ExtraData( target, location,kv)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
    if kv.hit and kv.hit==1 then
        --self:EndCooldown()
    end
        target:AddNewModifier(caster, self, "modifier_wave_of_terror_debuff", {duration=self:GetSpecialValueFor( "duration" )})
        if caster:TG_HasTalent("special_bonus_vengefulspirit_4") then
            caster:PerformAttack(target, false, true, true, false, false, false, true)
        else
            caster:PerformAttack(target, false, false, true, false, false, false, true)
        end

end
function wave_of_terror:AddBuff(caster,ab)
	caster:AddNewModifier(caster,ab,"modifier_wave_of_terror_buff",{duration = 7})
end
modifier_wave_of_terror_buff=class({})

function modifier_wave_of_terror_buff:IsDebuff()
	return true
end
function modifier_wave_of_terror_buff:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end
function modifier_wave_of_terror_buff:IsHidden()
	return true
end

function modifier_wave_of_terror_buff:IsPurgable()
	return false
end

function modifier_wave_of_terror_buff:IsPurgeException()
	return false
end

function modifier_wave_of_terror_buff:DeclareFunctions()
	return
    {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
	}
end
function modifier_wave_of_terror_buff:GetModifierAttackRangeBonus() return 50 end
function modifier_wave_of_terror_buff:GetModifierBaseDamageOutgoing_Percentage() return 10 end
function modifier_wave_of_terror_buff:GetModifierPhysicalArmorBonus() return 10 end






modifier_wave_of_terror_debuff=class({})

function modifier_wave_of_terror_debuff:IsDebuff()
	return true
end

function modifier_wave_of_terror_debuff:IsHidden()
	return false
end

function modifier_wave_of_terror_debuff:IsPurgable()
	return true
end

function modifier_wave_of_terror_debuff:IsPurgeException()
	return true
end

function modifier_wave_of_terror_debuff:DeclareFunctions()
	return
    {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_wave_of_terror_debuff:GetModifierPhysicalArmorBonus()
	return   self:GetAbility():GetSpecialValueFor("armor_reduction")+self:GetCaster():TG_GetTalentValue("special_bonus_vengefulspirit_6")
end
