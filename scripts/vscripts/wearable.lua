wearable=class({})
--prop_dynamic
--prop_physics
--prop_detail
--prop_static
--prop_ragdoll
--prop_physics_multiplayer
--prop_physics_override
--prop_dynamic_override


function  wearable:ChangeHeroClothing(wear)
           local unit=SpawnEntityFromTableSynchronous(wear.type, {model=wear.name})
           unit:SetParent(wear.npc, "")
           unit:SetOwner(wear.npc)
           unit:FollowEntity(wear.npc, true)
	     unit:SetRenderAlpha(100)
           return unit
end


function wearable:RemoveBaseClothing(npc)
      if npc==nil then return end
	for k, v in pairs(npc:GetChildren()) do
		if v:GetClassname() == 'dota_item_wearable' then
			      v:RemoveSelf()
		end
	end
end

function wearable:HideClothing(table)
      if table==nil then return end
	for k, v in pairs(table) do
		if v then
			      v:AddEffects(EF_NODRAW)
		end
	end
end

function wearable:ShowClothing(table)
      if table==nil then return end
	for k, v in pairs(table) do
		if v then
			      v:RemoveEffects(EF_NODRAW)
		end
	end
end