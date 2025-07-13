item_neutral_lvlup = class({})
function item_neutral_lvlup:OnSpellStart()
	self.caster=self.caster or self:GetCaster()
	if self.caster.neutral_level == nil then
		self.caster.neutral_level = 1
	end
	local now_item = self.caster:GetItemInSlot(16)
	if now_item~=nil and now_item.owner == self.caster:GetPlayerID()then
		if not now_item:IsNeutralDrop() then
			Notifications:Bottom(self.caster:GetPlayerOwnerID(), {text ="中立格子放中立装备才能升级", duration = 3})
			return
		end
		local name = now_item:GetName()
			if self.caster.neutral_level >=3 then
				Notifications:Bottom(self.caster:GetPlayerOwnerID(), {text ="你中立装备已经满级了，给别人把。", duration = 3})
			else		
				local pos = self.caster:GetAbsOrigin()
				local particleName = "particles/generic_hero_status/hero_levelup_godray.vpcf"		
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(pfx, 0, pos)
				ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,pos.z+1000))
				ParticleManager:ReleaseParticleIndex(pfx)
				EmitSoundOn("DOTA_Item.HavocHammer.Cast", self.caster)
					self.caster.neutral_level = self.caster.neutral_level + 1
					self.caster:RemoveItem(now_item)
					local new_item = self.caster:AddItemByName(name)
					new_item:SetLevel(self.caster.neutral_level)
					new_item.owner = self.caster:GetPlayerID()
					self:Destroy()
			end
		else	
		if self.caster:GetGold()>=30000 and self.caster.ex_neutral==nil then
			EmitSoundOn("DOTA_Item.HavocHammer.Cast", self.caster)
			PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), -30000, false, DOTA_ModifyGold_Unspecified)
			local item = self.caster:AddItemByName("item_pogo_stick")
			item.owner = self.caster:GetPlayerID()
			self.caster.ex_neutral = true
			self:Destroy()
			else
			Notifications:Bottom(self.caster:GetPlayerOwnerID(), {text ="你太贪心了", duration = 3})
		end
	end	
end