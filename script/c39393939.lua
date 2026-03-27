--Ultimate Void Trap

---@diagnostic disable: undefined-global

if false then
    require("edo_const.constant")
end

local s,id=GetID()
function s.initial_effect(c)
    --Activate from hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)

    --Activate in set turn (IMPORTANT)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    c:RegisterEffect(e2)

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.handcon(e)
    return true
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
        Duel.Destroy(rc,REASON_EFFECT)
    end
    Duel.Draw(tp,4,REASON_EFFECT)
end