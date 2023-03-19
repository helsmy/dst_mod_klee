local assets = {
	Asset("ANIM", "anim/klee_sparks.zip")
}

local prefabs = {"explode_small"}

local function multi()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("klee_sparks")
	inst.AnimState:SetBuild("klee_sparks")
	inst.AnimState:PlayAnimation("multi")

	inst.Transform:SetFourFaced()

	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("combateffect_klee")
	inst.persists = false

	return inst
end

local function single()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("klee_sparks")
	inst.AnimState:SetBuild("klee_sparks")
	inst.AnimState:PlayAnimation("single")

	inst.Transform:SetScale(3, 3, 3)

	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	return inst
end

local function front()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddFollower()

	inst.AnimState:SetBank("klee_sparks")
	inst.AnimState:SetBuild("klee_sparks")
	inst.AnimState:PlayAnimation("front", true)

	inst.Transform:SetScale(0.5, 0.5, 0.5)

	inst:AddTag("FX")

	inst.entity:SetPristine()

	SpawnPrefab("explosive_spark_back").entity:SetParent(inst.entity)

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:DoTaskInTime(30, inst.Remove)

	return inst
end

local function back()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("klee_sparks")
	inst.AnimState:SetBuild("klee_sparks")
	inst.AnimState:PlayAnimation("back", true)

	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

return Prefab("klee_multi_spark", multi, assets, prefabs),
	Prefab("klee_single_spark", single, assets, prefabs),
	Prefab("explosive_spark", front, assets),
	Prefab("explosive_spark_back", back, assets)