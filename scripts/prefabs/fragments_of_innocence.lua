local assets = {
	-- Asset("ANIM", "anim/klee_refinement.zip"),
	-- Asset("ATLAS", "images/inventoryimages/klee_refinement.xml"),
	Asset("ANIM", "anim/dococo_refinement.zip"),

	Asset("IMAGE", "images/inventoryimages/dococo_refinement.tex"),
	Asset("ATLAS", "images/inventoryimages/dococo_refinement.xml"),
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("dococo_refinement")
	inst.AnimState:SetBuild("dococo_refinement")
	inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

	inst.entity:SetPristine()

    inst:AddTag("fragments_of_innocence")

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "dococo_refinement"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dococo_refinement.xml"
    inst.components.inventoryitem:ChangeImageName("dococo_refinement")

	return inst
end

return Prefab("fragments_of_innocence", fn, assets)