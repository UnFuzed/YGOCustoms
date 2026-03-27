--Ultimate Void Trap

---@diagnostic disable: undefined-global

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
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.handcon(e)
    return true
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- Only allow activation if currently chaining something negatable
    return Duel.GetCurrentChain()>0 and Duel.IsChainNegatable(Duel.GetCurrentChain())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local chain=Duel.GetCurrentChain()
    if chain>0 then
        Duel.NegateEffect(chain)
    end
    Duel.Draw(tp,4,REASON_EFFECT)
end