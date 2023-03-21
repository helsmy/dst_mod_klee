local assets = {
	Asset("ANIM", "anim/klee_proj.zip")
}

local prefabs = {"explode_small"}

local function OnHit(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	local pos = {x, y, z}
	inst.SoundEmitter:KillSound("hiss")
	inst.SoundEmitter:PlaySound("dontstarve/common/dropwood")
	SpawnPrefab("explode_small").Transform:SetPosition(x, y, z)

	attacker.components.combateffect_klee:DoAreaAttack(pos, 1.5, TUNING.KLEE_SKILL_NORMALATK.ATK_DMG[attacker.components.talents:GetTalentLevel(1)], 0)
	attacker.components.combateffect_klee:DoExplode(pos, 1.3, false)
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("klee_proj")
	inst.AnimState:SetBuild("klee_proj")
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
	inst.components.complexprojectile:SetHorizontalSpeed(23)
	inst.components.complexprojectile:SetGravity(-100)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1.5, 0))
	inst.components.complexprojectile:SetOnHit(OnHit)

    return inst
end

return Prefab("klee_proj", fn, assets, prefabs)