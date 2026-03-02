-- Xyz Test

---@diagnostic disable: undefined-global

if false then
    require("edo_const.constant")
    require("edo_const.proc_xyz")
end

local s,id=GetID()

function s.initial_effect(c)
    -- 2 Level 4 monsters
    XXyz.AddProcedure(c,function(c) return c:IsSetCard(0x3939) end,4,2)
    c:EnableReviveLimit()

    -------------------------------------------------
    -- Detach 1; Draw 1 card
    -------------------------------------------------
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.descost)
    e1:SetTarget(s.drtg)
    e1:SetOperation(s.drop)
    c:RegisterEffect(e1)
end

-------------------------------------------------
-- DETACH COST
-------------------------------------------------

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
    end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-------------------------------------------------
-- DRAW EFFECT
-------------------------------------------------

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end