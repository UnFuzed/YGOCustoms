--Ultimate Void Trap (Counter Trap Style)
---@diagnostic disable: undefined-global

local s,id=GetID()
function s.initial_effect(c)
    --Activate as Counter Trap
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

--Can only activate if the chain is negatable
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev)
end

--Set targeting info
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end

--Negate the activation, destroy the card, and draw
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
        Duel.Destroy(rc,REASON_EFFECT)
    end
    Duel.Draw(tp,4,REASON_EFFECT)
end