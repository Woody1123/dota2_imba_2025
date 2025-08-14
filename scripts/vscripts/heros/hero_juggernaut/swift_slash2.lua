swift_slash2=class({})

function swift_slash2:IsHiddenWhenStolen()
    return false
end

function swift_slash2:IsStealable()
    return true
end


function swift_slash2:IsRefreshable()
    return true
end

function swift_slash2:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_6")
end

function swift_slash2:GetCastPoint()
    if self:GetCaster():TG_HasTalent("special_bonus_juggernaut_8") then
        return 0
    else
        return 0.3
    end
end

function swift_slash2:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local tpos=target:GetAbsOrigin()
    local cpos=caster:GetAbsOrigin()
    local att_num=self:GetSpecialValueFor("att")
    local num=0
    caster:EmitSound("TG.jugginv")
	local ab = caster:FindAbilityByName("omni_slash")
	if ab and ab:GetLevel() >=1 then
		   caster:AddNewModifier(caster, ab, "modifier_omni_slash_buff",{duration=0.3,target = target:entindex()})
	end

    caster:MoveToTargetToAttack(target)
end
