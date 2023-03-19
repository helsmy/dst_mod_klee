local assets = {
	Asset("ANIM", "anim/klee_fx.zip")
}

local function fn()
    local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddFollower()

	inst.AnimState:SetBank("klee_fx")
	inst.AnimState:SetBuild("klee_fx")
	inst.AnimState:PlayAnimation("clover", true)

	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

	inst.Transform:SetScale(0.85, 0.85, 0.85)
	inst.Transform:SetFourFaced()

	inst:AddTag("FX")

	inst.owner = nil

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

    -- 保持轰轰火花的朝向
	inst:DoPeriodicTask(FRAMES, function()
        if inst.owner ~= nil then
            inst.Transform:SetRotation(inst.owner.Transform:GetRotation())
        else
            inst.owner = GetClosestInstWithTag("klee", inst, 0.5)
        end
    end)

	return inst
end

return Prefab("sparks_n_splash", fn, assets)