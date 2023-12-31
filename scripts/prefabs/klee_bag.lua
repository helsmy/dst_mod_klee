local assets = {
    Asset("ANIM", "anim/klee_bag.zip"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip"),
    Asset("IMAGE", "images/inventoryimages/klee_bag.tex"),
    Asset("ATLAS", "images/inventoryimages/klee_bag.xml"),
}

local function OnEquip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "klee_bag" )
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "klee_bag" )
    else
        -- owner.AnimState:OverrideSymbol("swap_body", "klee_bag", "backpack")
        owner.AnimState:OverrideSymbol("backpack", "klee_bag", "backpack")
        owner.AnimState:OverrideSymbol("swap_body", "klee_bag", "swap_body")
    end
    -- 加个10%没用的防御，不过在撑得荒里可能也挺有用的？
    -- 毕竟可莉的背包里都能装炸弹了，有点防御不过分
    owner.components.combat.external_defense_multipliers:SetModifier(inst, 0.1, "all_klee_bag_base")
    inst.components.container:Open(owner)
end

local function OnUnequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:ClearOverrideSymbol("backpack")
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.components.combat.external_defense_multipliers:RemoveModifier(inst, "all_klee_bag_base")
    inst.components.container:Close(owner)
end

local function onequiptomodel(inst, owner)
    inst.components.container:Close(owner)
end

local function OnPutInInventory(inst, owner)
    inst:DoTaskInTime(0, function(_inst, _owner)
        local grandOwner = _owner or
        (_inst.components.inventoryitem ~= nil and _inst.components.inventoryitem:GetGrandOwner())
        local bag = grandOwner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if grandOwner.components.inventory:FindItem(function(item) 
            return item ~= _inst and
                item.prefab == _inst.prefab end) ~= nil or 
                (bag ~= nil and bag ~= _inst and bag.prefab == _inst.prefab) 
            then
            grandOwner.components.inventory:DropItem(_inst, true, true) 
        end
    end, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("klee_bag_map.tex")

    inst.AnimState:SetBank("klee_bag")
    inst.AnimState:SetBuild("klee_bag")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddTag("backpack")
    inst:AddTag("waterproofer")

    local swap_data = {bank = "klee_bag", anim = "idle"}
    MakeInventoryFloatable(inst, "med", 0.1, 0.65, nil, nil, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(_inst) _inst.replica.container:WidgetSetup("piggyback") end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "klee_bag"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/klee_bag.xml"
    -- inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK ~= nil and EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable.restrictedtag = "klee"
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.walkspeedmult = 1

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("piggyback")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("klee_bag", fn, assets)