local assets = {
	Asset("ANIM", "anim/klee_stella.zip"),
	Asset("ATLAS", "images/inventoryimages/klee_stella.xml"),
	Asset("IMAGE", "images/inventoryimages/klee_stella.tex")
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("stella")
	inst.AnimState:SetBuild("klee_stella")
	inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(1, 1, 1)

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

	inst.entity:SetPristine()

	inst:AddTag("constellation_star")
    inst:AddTag("klee_constellation_star")

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "klee_stella"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/klee_stella.xml"
	inst.components.inventoryitem:ChangeImageName("klee_stella")

	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	return inst
end

return Prefab("klee_constellation_star", fn, assets)