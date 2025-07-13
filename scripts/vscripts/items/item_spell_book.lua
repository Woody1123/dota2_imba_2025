item_spell_book=class({})
LinkLuaModifier("modifier_item_spell_book", "items/item_spell_book.lua", LUA_MODIFIER_MOTION_NONE)


function item_spell_book:CastFilterResult()
    local caster=self:GetCaster()
end




function item_spell_book:OnSpellStart()
    local caster=self:GetCaster()
    TG_Modifier_Num_ADD(caster,"modifier_item_spell_book",1,1)
    self:SpendCharge(0)
end

modifier_item_spell_book=class({})

function modifier_item_spell_book:GetTexture()
    return "item_spell_book"
end

function modifier_item_spell_book:IsHidden()
    return false
end

function modifier_item_spell_book:IsPurgable()
    return false
end

function modifier_item_spell_book:IsPurgeException()
    return false
end

function modifier_item_spell_book:IsPermanent()
    return true
end


function modifier_item_spell_book:AllowIllusionDuplicate()
    return false
end

function modifier_item_spell_book:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_item_spell_book:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_spell_book:GetModifierSpellAmplify_Percentage()
    return  self:GetStackCount()
end