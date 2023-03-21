local CANT_TAGS = {"INLIMBO", "player", "chester", "companion", "wall"}

local function ShakeCamera(self)
	for i, v in ipairs(AllPlayers) do
		local distSq = v:GetDistanceSqToInst(self.inst)
		local k = math.max(0, math.min(1, distSq / 400))
		local intensity = k * 0.75 * (k - 2) + 0.75
		if intensity > 0 then
			if TUNING.KLEE_EXPLODE_LIGHT then
				v:ScreenFlash(intensity)
			end
			v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
		end
	end
end

local CombatEffect_klee = Class(function (self, inst)
    self.inst = inst
end)

function CombatEffect_klee:DoExplode(pos, region, burnt)
    -- destory everything!
    for i, v in pairs(TheSim:FindEntities(pos[1], pos[2], pos[3], region)) do
        if v:IsValid() and TUNING.KLEE_CONST_BREAK and v.components.workable ~= nil and
            v.components.workable:CanBeWorked() then
            v.components.workable:WorkedBy(self.inst, 10)
        end

        if burnt and v:IsValid() and TUNING.KLEE_BURN and v.components.fueled == nil and v.components.burnable ~= nil and
            not v.components.burnable:IsBurning() and not v:HasTag("burnt") then
            v.components.burnable:Ignite()
        end
    end

    ShakeCamera(self)
end

function CombatEffect_klee:DoAreaAttack(pos, region, instmulti, GainEnergy)
	local ents = TheSim:FindEntities(pos[1], pos[2], pos[3], region, {"_combat"}, CANT_TAGS)

    if ents ~= nil then
        self.inst.components.energyrecharge:GainEnergy(GainEnergy)
    end

    -- area attack
    local old_state = self.inst.components.combat.ignorehitrange
	self.inst.components.combat.ignorehitrange = true
	for i, v in pairs(ents) do
		if v ~= self.inst and v:IsValid() and not v:IsInLimbo() then
			self.inst.components.combat:DoAttack(v, nil, nil, 1, instmulti, nil)
			self.inst.components.sanity:DoDelta(0.5)
			v:PushEvent("explosion", {explosive = self.inst})
		end
	end
	self.inst.components.combat.ignorehitrange = old_state
end

function CombatEffect_klee:DoAttackAndExplode(attacker, region, instmulti, GainEnergy)
    -- destory everything!
    self:DoExplode(attacker, region, true)
    self:DoAreaAttack(attacker, region, instmulti, GainEnergy)
end

return CombatEffect_klee