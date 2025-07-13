modifier_unit_remove=class({})

function modifier_unit_remove:IsHidden() 			
    return true 
end
function modifier_unit_remove:RemoveOnDeath() 			
    return false 
end
function modifier_unit_remove:IsPurgable() 			
    return false 
end

function modifier_unit_remove:IsPurgeException() 	
    return false 
end
function modifier_unit_remove:OnCreated(keys) 
	if IsServer() then
		self:SetDuration(keys.duration+1,false)
	end
end
function modifier_unit_remove:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil then
			UTIL_Remove(self:GetParent())
		end
	end
end


