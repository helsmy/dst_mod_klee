local ElementalBurst_Badge = require "widgets/elementalburst_badge"
local ElementalSkill_Badge = require "widgets/elementalskill_badge_klee"

local klee_skill_imgs = {
    {"images/ui/skills/klee_skill_02.xml", "klee_skill_02.tex"},
    {"images/ui/skills/klee_skill_12.xml", "klee_skill_12.tex"},
    {"images/ui/skills/klee_skill_22.xml", "klee_skill_22.tex"},
}

-- 技能按键的UI，直接照抄元素反应作者的雷电将军mod
AddClassPostConstruct("widgets/controls",function(self)        
	if self.owner and self.owner:HasTag("klee") then

	    self.elementalburst_badge = self:AddChild(ElementalBurst_Badge(self.owner, "klee_energy", "klee_energy", "anim", nil, TUNING.KLEE_SKILL_ELEBURST.CD, TUNING.ELEMENTALBURST_KEY))
        self.elementalburst_badge:SetPosition(100 + 1600 * TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE * 80 + 20, 0)
        self.elementalburst_badge:SetScale(0.4 * TUNING.GENSHINCORE_UISCALE)
        self.elementalburst_badge:SetOnClick(function()
            SendModRPCToServer(MOD_RPC["klee"]["elementalburst"])
        end)
        self.elementalburst_badge:SetOnDragFinish(function(oldpos, newpos)
            TheSim:SetPersistentString("klee_elementalburst_badge", json.encode({ position = newpos }), false)
        end)

		self.elementalskill_badge = self:AddChild(ElementalSkill_Badge(self.owner, klee_skill_imgs, TUNING.KLEE_SKILL_ELESKILL.CD, TUNING.ELEMENTALSKILL_KEY))
        self.elementalskill_badge:SetPosition(1600 * TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE * 100, 0)
        self.elementalskill_badge:SetScale(0.3 * TUNING.GENSHINCORE_UISCALE)
        self.elementalskill_badge:SetOnClick(function()
            SendModRPCToServer(MOD_RPC["klee"]["elementalskill"])
        end)
        self.elementalskill_badge:SetOnDragFinish(function(oldpos, newpos)
            TheSim:SetPersistentString("klee_elementalskill_badge", json.encode({ position = newpos }), false)
        end)

        --恢复位置，写法参考了Insight
        TheSim:GetPersistentString("klee_elementalburst_badge", function(success, str)
            if not success then
                return
            end
            local valid, pos = pcall(function() return json.decode(str).position end)
            print(pos)
            if not valid then
                return
            end
            local screen_width, screen_height = TheSim:GetScreenSize()
            if pos.x < 0 or pos.x > screen_width or pos.y < 0 or pos.y > screen_height then
                self.elementalburst_badge:SetPosition(screen_width - 100, TUNING.GENSHINCORE_UISCALE * 80 + 20, pos.z)
                return
            end
            self.elementalburst_badge:SetPosition(pos.x, pos.y, pos.z)
        end)
        TheSim:GetPersistentString("klee_elementalskill_badge", function(success, str)
            if not success then
                return
            end
            local valid, pos = pcall(function() return json.decode(str).position end)
            if not valid then
                return
            end
            local screen_width, screen_height = TheSim:GetScreenSize()
            if pos.x < 0 or pos.x > screen_width or pos.y < 0 or pos.y > screen_height then
                self.elementalskill_badge:SetPosition(screen_width - 200, TUNING.GENSHINCORE_UISCALE * 80, pos.z)
                return
            end
            self.elementalskill_badge:SetPosition(pos.x, pos.y, pos.z)
        end)
	end
end)