Trigger_trap=class({})
LinkLuaModifier("modifier_Trigger_Trap", "heros/hero_templar_assassin/Trigger_trap.lua", LUA_MODIFIER_MOTION_NONE)


function Trigger_trap:IsHiddenWhenStolen()return false
end
function Trigger_trap:IsStealable() return true
end
function Trigger_trap:IsRefreshable()return true
end

function Trigger_trap:GetCooldown(level)
	return 0.5
end

function Trigger_trap:OnSpellStart()
    self:GetCaster():RemoveModifierByName("modifier_psionic_trap_buff")
end