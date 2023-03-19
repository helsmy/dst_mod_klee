local function SetElementalSkill(self, cd, count)
    self.cd.elementalskill = cd
    self.count = 0
    self.max_count = count
end

local function outofcooldown(self, skill)
    if self.inst.sg:HasStateTag("knockout") or self.inst.sg:HasStateTag("sleeping") or self.inst.sg.currentstate == "death" then
		return false
	end 
	
	if GetTime() - self[skill] < self.cd[skill] then
        -- 如果战技的还有剩余的数量
        if skill == "elementalskill" and self.count > 0 then
            return true
        end
	    return false
	end
	
	if not self:HasEnergy(self.energy[skill]) then
	    return false
    end

	self[skill] = GetTime()
	return true
end

-- 在战技的ui上的onupdate来调用这个，从而正确的增加战技的数量
local function AddElementalSkillCount(self)
    if self.max_count <= 0 then return end
    if self.count >= self.max_count then
        self.count = self.max_count
        return
    end

    self.count = self.count + 1

    -- 如果战技还能继续积累数量，重置冷却计时
    -- 计算下一个战技的冷却时间
    if self.count >= self.max_count then
        self.count = self.max_count
        return
    end
    
    self:LeftTimeDelta("elementalskill", -TUNING.KLEE_SKILL_ELESKILL.CD)
end

local function ConsumeElementalSkill(self)
    if self.count > 0 then
        self.count = self.count - 1
        return
    end
    self.count = 0
end

local function ElementalSkillFactoryKlee(inst)
    inst.components.elementalcaster.SetElementalSkill = SetElementalSkill
    inst.components.elementalcaster.outofcooldown = outofcooldown
    inst.components.elementalcaster.AddElementalSkillCount = AddElementalSkillCount
    inst.components.elementalcaster.ConsumeElementalSkill = ConsumeElementalSkill
end

return ElementalSkillFactoryKlee