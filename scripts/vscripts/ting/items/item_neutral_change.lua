item_neutral_change = class({})

function item_neutral_change:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.Tango.Activate")

	caster.neutral_index = caster.neutral_index or 1
	caster.neutral_level = caster.neutral_level or 1

	local function TryAddNeutralItem(index)
		if index > #Neutral_EX then
			print("✘ 所有中立物品尝试失败")
			Notifications:Bottom(caster:GetPlayerOwnerID(), {
				text = "所有中立物品放入失败，可能是背包满或物品定义异常。",
				duration = 3
			})
			return
		end

		local item_name = Neutral_EX[index]
		print("→ 尝试创建物品:", item_name)

		local now_item = caster:GetItemInSlot(16)
		if now_item then
			print("→ 清理旧中立物品:", now_item:GetAbilityName())
			caster:RemoveItem(now_item)
		end

		-- 创建并直接放入
		local new_item = CreateItem(item_name, caster, caster)
		if not new_item then
			print("✘ 物品创建失败:", item_name)
			TryAddNeutralItem(index + 1)
			return
		end

		new_item:SetLevel(caster.neutral_level)
		new_item.owner = caster:GetPlayerID()

		-- 尝试直接添加
		local added_item = caster:AddItem(new_item)

		-- 延迟 0.2 秒检测 slot16 是否成功填充
		Timers:CreateTimer(0.2, function()
			local slot16 = caster:GetItemInSlot(16)
			if slot16 and slot16:GetAbilityName() == item_name then
				print("✔ 成功放入 slot16:", item_name)
				caster.neutral_index = index + 1
				if caster.neutral_index > #Neutral_EX then
					caster.neutral_index = 1
				end
			else
				print("✘ 放入 slot16 失败，尝试下一个")
				if added_item then
					caster:RemoveItem(added_item)
				end
				TryAddNeutralItem(index + 1)
			end
		end)
	end

	TryAddNeutralItem(caster.neutral_index)
end
