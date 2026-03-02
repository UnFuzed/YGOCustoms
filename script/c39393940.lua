-- Vocaloid Stage

---@diagnostic disable: undefined-global

if false then
    require("edo_const.constant")
    require("edo_const.card_counter_constants")
    require("edo_const.cards_specific_functions")
end

local s,id=GetID()

function s.initial_effect(c)

    -------------------------------------------------
    -- Activate
    -------------------------------------------------
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -------------------------------------------------
    -- ATK Boost
    -------------------------------------------------
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.atktg)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)

    -------------------------------------------------
    -- DEF Boost
    -------------------------------------------------
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)

    -------------------------------------------------
    -- Pay 500 LP; Special Summon
    -------------------------------------------------
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1,id)
    e3:SetCost(s.spcost)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

-------------------------------------------------
-- ATK/DEF BOOST
-------------------------------------------------

function s.atktg(e,c)
    return c:IsFaceup() and c:IsSetCard(0x3939)
end

function s.countfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3939)
end

function s.atkval(e,c)
    local g=Duel.GetMatchingGroup(s.countfilter,c:GetControler(),LOCATION_MZONE,0,nil)
    return #g * 200
end

-------------------------------------------------
-- SPECIAL SUMMON EFFECT
-------------------------------------------------

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x3939)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(
                s.spfilter,tp,
                LOCATION_HAND+LOCATION_GRAVE,
                0,1,nil,e,tp)
    end

    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,
        LOCATION_HAND+LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,
        LOCATION_HAND+LOCATION_GRAVE,
        0,1,1,nil,e,tp)

    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end