rearm=class({})

function rearm:IsHiddenWhenStolen()
    return false
end

function rearm:IsStealable()
    return true
end

function rearm:IsRefreshable()
    return true
end

function rearm:GetCastAnimation()
	return ACT_DOTA_TINKER_REARM2
end


function rearm:OnSpellStart()
    local caster=self:GetCaster()
    --if not bInterrupted then
		local current_ability
		for i = 0, 23 do
			current_ability = caster:GetAbilityByIndex(i)
			if current_ability and self ~= current_ability and not Is_DATA_TG(NOT_RS_SK,current_ability:GetName()) then
				current_ability:EndCooldown()
				current_ability:RefreshCharges()
			end
		end
        if caster:HasInventory() then
            for i=0,9 do
              local item= caster:GetItemInSlot(i)
                if item~=nil then
                    if not Is_DATA_TG(NOT_RS_ITEM_TK,item:GetName()) then
                        item:EndCooldown()
                    end
                end
            end
			local slot_15 = caster:GetItemInSlot(15)
			local slot_16 = caster:GetItemInSlot(16)
			if slot_15 and not Is_DATA_TG(NOT_RS_ITEM_TK,slot_15:GetName()) then
			print(slot_15:GetName())
				 slot_15:EndCooldown()
			end
			if slot_16 and not Is_DATA_TG(NOT_RS_ITEM_TK,slot_16:GetName()) then
			print(slot_16:GetName())
				 slot_16:EndCooldown()
			end
			
			
        end
	--end
end