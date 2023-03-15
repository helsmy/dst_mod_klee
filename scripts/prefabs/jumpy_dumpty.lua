-- 可莉的元素战技

local assets = {
	Asset("ANIM", "anim/jumpydumpty.zip")
}

local prefabs = {"explode_small", "minebomb"}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jumpydumpty")
    inst.AnimState:SetBuild("jumpydumpty")
    inst.AnimState:PlayAnimation("thrown")

    --inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.Transform:SetFourFaced()

    inst:AddTag("explosive")
    inst:AddTag("NOCLICK")

    inst:AddTag("genshin_projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")

    inst:AddComponent("weapon")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(20)

    inst:DoTaskInTime(5, inst.Remove)

    return inst
end

return Prefab("jumpy_dumpty", fn, assets, prefabs)

-- return MakeBomb("jumpydumpty", -80, 1.5, 1, "jumpydumpty2"),
-- 	MakeBomb("jumpydumpty2", -90, 0, 1, "jumpydumpty3"),
-- 	MakeBomb("jumpydumpty3", -100, 0, 1.3, nil)