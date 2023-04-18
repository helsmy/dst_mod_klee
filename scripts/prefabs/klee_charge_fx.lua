local assets = {
	Asset("ANIM", "anim/klee_fx.zip")
}

local prefabs = {"explode_small"}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("klee_fx")
	inst.AnimState:SetBuild("klee_fx")
	inst.AnimState:PlayAnimation("fields")

	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)

	inst:AddTag("explosive")
	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst.spark = false

	return inst
end

return Prefab("klee_charge_fx", fn, assets, prefabs)