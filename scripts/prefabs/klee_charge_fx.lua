-- ‍dalao，试了一下，直接给inst.chargesgname赋值sg的name，不过好像并没起效。在CustomAttackFn里直接检测 inst.cancharge让状态直接转到重击倒是能行。
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