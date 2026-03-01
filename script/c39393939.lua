-- Vocaloid – Hatsune Miku

-- Only for VSCode autocomplete
---@diagnostic disable: undefined-global

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
    -- Add 1 "Vocaloid" card from Deck to hand when Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))      -- Effect description
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)          -- Normal Summon
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)                     -- Once per turn
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)        -- Special Summon
    c:RegisterEffect(e2)
end

-- Filter for "Vocaloid" cards
function s.thfilter(c)
    return c:IsSetCard(0x3939) and c:IsAbleToHand()
end

-- Target function
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Operation function
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end