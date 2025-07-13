item_strength_book=class({})
LinkLuaModifier("modifier_item_strength_book", "items/item_strength_book.lua", LUA_MODIFIER_MOTION_NONE)


function item_strength_book:CastFilterResult()
    local caster=self:GetCaster()
    if not IsServer() then return end
end





function item_strength_book:OnSpellStart()
    local caster=self:GetCaster()
    TG_Modifier_Num_ADD(caster,"modifier_item_strength_book",5,5)
    self:SpendCharge(0)
end

modifier_item_strength_book=class({})

function modifier_item_strength_book:GetTexture()
    return "item_strength_book"
end

function modifier_item_strength_book:IsHidden()
    return false
end

function modifier_item_strength_book:IsPurgable()
    return false
end

function modifier_item_strength_book:IsPurgeException()
    return false
end

function modifier_item_strength_book:IsPermanent()
    return true
end


function modifier_item_strength_book:AllowIllusionDuplicate()
    return false
end

function modifier_item_strength_book:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_item_strength_book:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

    }
end

function modifier_item_strength_book:GetModifierBonusStats_Strength()
    return  self:GetStackCount()
end