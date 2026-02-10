---@class DyeCount
local _, DC = ...

DyeCount = DC

function DC:TRADE_SKILL_SHOW()
    -- Check to make sure we have the dye crafting window open and recipe list available
    if not ProfessionsFrame then
        ChatFrame1:AddMessage("No ProfessionsFrame")
        return
    end
    if not ProfessionsFrame:IsShown() then
        ChatFrame1:AddMessage("ProfessionsFrame Not Shown")
        return
    end

    -- Thanks Plusmouse and Slackluster for this callback / method get data into the recipe list
    if not DC.TradeskillHook then
        ProfessionsFrame.CraftingPage.RecipeList.ScrollBox:RegisterCallback("OnAcquiredFrame", function(_, v, data)
            local recipeInfo = data.data.recipeInfo
            if recipeInfo then
                if data.parent.data.categoryInfo and data.parent.data.categoryInfo.skillLineID == 2984 then
                    local recipeID = recipeInfo.recipeID
                    if recipeID then
                        if not v.availableCount then
                            v.availableCount = v:CreateFontString(nil, "OVERLAY")
                            v.availableCount:SetFontObject("GameFontHighlight_NoShadow")
                            v.availableCount:SetHeight(12)
                            v.availableCount:SetPoint("RIGHT", v, "RIGHT", -5, 0)
                            v.availableCount:SetText(123456789)
                        end
                        local dyeData = C_TooltipInfo.GetRecipeResultItem(recipeInfo.recipeID)
                        local totalDye = C_Item.GetItemCount(dyeData.id, true, false, true, true)
                        v.availableCount:SetText(totalDye)
                    end
                else
                    if v.availableCount then
                        v.availableCount:SetText()
                    end
                end
            end
        end)
        DC.TradeskillHook = true
    end
end

EventRegistry:RegisterFrameEventAndCallback("TRADE_SKILL_SHOW", DC.TRADE_SKILL_SHOW)
