local assets = {
	Asset("ANIM", "anim/minebomb.zip")
}

local prefabs = {"explode_small"}

local mine_test_fn = function(dude, inst)
	return not (dude.components.health and dude.components.health:IsDead() and dude.components.combat:CanBeAttacked(inst))
end

local function MineTest(inst)
	local mine = inst.components.mine
	if mine ~= nil then
		local notags = {"notraptrigger", "flying", "ghost", "playerghost", "spawnprotection", "player", "chester", "companion"}
		table.insert(notags, "player")
		local target = FindEntity(inst, 1.5, mine_test_fn, "_combat", notags, {"monster", "character", "animal"})
		if target then
			mine:Explode(target)
		end
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("minebomb")
	inst.AnimState:SetBuild("minebomb")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst.Transform:SetScale(0.5, 0.5, 0.5)

	inst:AddTag("trap")
	inst:AddTag("klee_mine")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor")

	inst:AddComponent("mine")
	
	inst.components.mine.StartTesting = function(self)
		self:StopTesting()
		self.testtask = self.inst:DoPeriodicTask(0, MineTest)
	end
	inst.components.mine:Reset()

	return inst
end

return Prefab("minebomb", fn, assets, prefabs),
	MakePlacer("common/landmine_placer", "trap_teeth_maxwell", "trap_teeth_maxwell", "idle")