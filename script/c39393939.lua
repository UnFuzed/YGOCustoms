--Ultimate Void Trap

---@diagnostic disable: undefined-global

-- Only for VSCode autocomplete
if false then
    require("edo_const.constant")
    require("edo_const.card_counter_constants")
    require("edo_const.cards_specific_functions")
    require("edo_const.proc_normal")
    require("edo_const.proc_fusion")
    require("edo_const.proc_link")
    require("edo_const.proc_synchro")
    require("edo_const.proc_xyz")
end

local s,id=GetID()
function s.initial_effect(c)
    --Activate from hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.handcon(e)
    return true
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
    Duel.Draw(tp,4,REASON_EFFECT)
end