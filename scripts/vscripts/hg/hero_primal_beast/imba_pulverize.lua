---
--- Created by hg.
--- DateTime: 2022/7/16 13:08
---
imba_pulverize=class({})


function imba_pulverize:IsHiddenWhenStolen() 		return false end
function imba_pulverize:IsRefreshable() 			return false end
function imba_pulverize:IsStealable() 				return true end
function imba_pulverize:GetCastPoint()
    if self:GetCaster():HasModifier("modifier_imba_onslaught_charge") then
        return 0
    end
    return 0.25
end

function imba_pulverize:OnSpellStart()
    self:swash()
    if self:GetCaster():TG_HasTalent("special_bonus_imba_primal_beast_6") then
        Timers:CreateTimer(0.5,function() self:swash() return nil end)
    end
end


function imba_pulverize:swash()
    if not IsServer() then return end
    local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("base_damage")
	local minidur = self:GetSpecialValueFor("ministun")
    local dur=minidur
    local maxdur = self:GetSpecialValueFor("maxstun")
	local radius = self:GetSpecialValueFor("splash_radius")+caster:GetCastRangeBonus()
    local first_hero_flag=0

    EmitSoundOn("Hero_PrimalBeast.RockThrow.Stun", self:GetCaster())
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 1, Vector(radius,1,1))
	ParticleManager:ReleaseParticleIndex(fx)


    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
        if enemy:IsRealHero() and first_hero_flag==0 then
            first_hero_flag=1
            dur=maxdur
        else
            dur=minidur
        end
				ApplyDamage({
						victim 			= enemy,
						damage 			= damage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self,
						})
		local Knockback ={
          should_stun = dur, --打断
          knockback_duration = minidur, --击退时间 减去不能动的时间就是太空步的时间
          duration = dur, --不能动的时间
          knockback_distance = 0,
          knockback_height = 600,	--击退高度
          center_x =  caster:GetAbsOrigin().x,	--施法者为中心
          center_y =  caster:GetAbsOrigin().y,
          center_z =  caster:GetAbsOrigin().z,
		}
	  		enemy:AddNewModifier_RS(caster, self, "modifier_knockback", Knockback)  --白牛的击退
	end
end