if ai_normal == nil then
	ai_normal = class({})
end
function ai_normal:IsHidden() return false end
function ai_normal:IsDebuff() return false end
function ai_normal:IsPurgable() 		return false end
function ai_normal:IsPurgeException() 	return false end
function ai_normal:RemoveOnDeath() 	return false end
function ai_normal:OnCreated()
	self.parent = self:GetParent()
	self.parent.pos = nil
	self.unit_table = {}
	self.ability = {}
	if self.parent.stat == nil then
		self.parent.stat = 1
	end
	if IsServer() then
		if self.parent.lv == nil then
			self.parent.lv = 1
			if self.parent:GetPrimaryAttribute() == 0 then
				self.parent.lv = 2
			end
		end		
		self.team = self.parent:GetTeam()

	end
end

function ai_normal:think()
	if IsServer() then
		self.unit_table = AI_CHECK_SITUATION(self.parent)
			
			if self.unit_table[1][2] and self.parent:IsRangedAttacker() and self.unit_table[1][2]:IsRangedAttacker() then
				if TG_Distance(self.unit_table[1][2]:GetAbsOrigin(),self.parent:GetAbsOrigin())<150 then
					--print(self.unit_table[1][2]:GetName())
					--print("近了")
					AI_MOVEABOUT(self.parent,self.unit_table[3],50,self.unit_table[1][2]:GetAbsOrigin())
					return
				end	
					AI_MOVEABOUT(self.parent,self.unit_table[3],50,nil)
				else
					AI_MOVEABOUT(self.parent,self.unit_table[3],50,nil)
			end
		--AI_USE_ITEM(self.unit_table)
		--AI_USE_ABILITY(hero,self.ability,self.unit_table)
	end	
end
