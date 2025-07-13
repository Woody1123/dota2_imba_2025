item_rd_book_copy=class({})

function item_rd_book_copy:OnSpellStart()
      local caster = self:GetCaster()
	  local tar = self:GetCursorTarget()
      if caster.Random_Skill and tar.Random_Skill and  caster.Random_Skill ~= tar.Random_Skill then
				  local name_1 = caster.Random_Skill:GetName() 
				  local name_2 =  tar.Random_Skill:GetName() 
				  if not caster:HasAbility(name_2) then
				  
					  local modifier_count = caster:GetModifierCount()
					  if modifier_count>0 then
							for i = 0, modifier_count do
								  local modifier_name = caster:GetModifierNameByIndex(i)
								  if modifier_name then
										local mod=caster:FindModifierByName(modifier_name)
										if mod and mod:GetAbility()==caster.Random_Skill then
											  caster:RemoveModifierByName(modifier_name)
										end
								  end
							end
					  end
					  if name=="prot" then
								  caster:StopSound("Hero_Pudge.Rot")
					  elseif name=="flame_guard" then
								  caster:StopSound("Hero_EmberSpirit.FlameGuard.Loop")
					  end
					  
					  caster:EmitSound("DOTA_Item.Tango.Activate")
					  caster:RemoveAbility(name_1)
					  caster.Random_Skill = nil
					  local ab=caster:AddAbility(name_2)
					  ab:SetLevel(4)
					  caster.Random_Skill = ab
                        CDOTA_PlayerResource.RD_SK[caster:GetPlayerOwnerID()]=ab:GetName()
                        CustomNetTables:SetTableValue("rd_skills", "RDSK", CDOTA_PlayerResource.RD_SK)
					  self:SpendCharge(0)
				  end
      end
end
