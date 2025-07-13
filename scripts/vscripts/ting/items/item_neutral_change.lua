item_neutral_change = class({})
function item_neutral_change:OnSpellStart()
	self.caster=self.caster or self:GetCaster()
	self.caster:EmitSound("DOTA_Item.Tango.Activate")
	if self.caster.neutral_index == nil then
		self.caster.neutral_index = 1
	end
	if self.caster.neutral_level == nil then
		self.caster.neutral_level = 1
	end
	local change_item = Neutral_EX[self.caster.neutral_index]
	local now_item = self.caster:GetItemInSlot(16)
	if now_item~=nil and now_item:IsNeutralDrop() and now_item.owner == self.caster:GetPlayerID() then
		self.caster:RemoveItem(now_item)
		local new_item = self.caster:AddItemByName(change_item)
		new_item:SetLevel(self.caster.neutral_level)
		new_item.owner = self.caster:GetPlayerID()
		self.caster.neutral_index = self.caster.neutral_index  + 1
		if self.caster.neutral_index == #Neutral_EX +1  then 
			self.caster.neutral_index = 1
		end
		else
		
		Notifications:Bottom(self.caster:GetPlayerOwnerID(), {text ="请把中立装备放在正确位置，没有装备可以用锻造锤敲一个。", duration = 3})
	end	
end

