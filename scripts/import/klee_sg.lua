local CANT_TAGS = TUNING.KLEE_AREA_ATK_NOTAGS

local function MakeMine(inst_spawner, attacker, mx, mz, cd)
    local x, y, z = inst_spawner.Transform:GetWorldPosition()
    local mine = SpawnPrefab("minebomb")
    
    local function Explode()
        local x, y, z = mine.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 3.2, {"_combat"}, CANT_TAGS)

        for i, v in pairs(TheSim:FindEntities(x, y, z, 3.2)) do
            if TUNING.KLEE_CONST_BREAK and v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                v.components.workable:WorkedBy(mine, 10)
            end
        end

        local old_state = attacker.components.combat.ignorehitrange
        attacker.components.combat.ignorehitrange = true
        for i, v in pairs(ents) do
            attacker.components.combat:DoAttack(v, nil, nil, 1, TUNING.KLEE_SKILL_ELESKILL.CO_DMG[attacker.components.talents:GetTalentLevel(2)], "elementalskill")
            if v.components.combat and attacker.components.constellation:GetActivatedLevel() >= 2 then
                v.components.combat.external_defense_multipliers:SetModifier(v, -0.23, "all_klee_c2_defensedown")
                v:DoTaskInTime(10, function ()
                    v.components.combat.external_defense_multipliers:RemoveModifier(v, "all_klee_c2_defensedown")
                end)
            end
        end
        mine:Remove()
        attacker.components.combat.ignorehitrange = old_state
    end
    
    mine.Transform:SetPosition(x+mx, 0, z+mz)
    mine.components.mine:SetOnExplodeFn(Explode)
    mine:ListenForEvent("Explode", Explode)
    -- mine:DoTaskInTime(15, Explode)
    mine:DoTaskInTime(cd, function()
        mine:PushEvent("Explode")
    end)
end

local function Mine(inst, attacker)
    MakeMine(inst, attacker, math.random(0, 5), math.random(0, 5), 11.5)
    MakeMine(inst, attacker, math.random(0, 5), math.random(0, 5),12)
    MakeMine(inst, attacker, math.random(-5, 0), math.random(0, 5), 12.5)
    MakeMine(inst, attacker, math.random(-5, 0), math.random(0, 5), 13)
    MakeMine(inst, attacker, math.random(0, 5), math.random(-5, 0), 13.5)
    MakeMine(inst, attacker, math.random(0, 5), math.random(-5, 0), 14)
    MakeMine(inst, attacker, math.random(-5, 0), math.random(-5, 0), 14.5)
    MakeMine(inst, attacker, math.random(-5, 0), math.random(-5, 0), 15)
end

-- 生成一个
local function MakeJumpyDumpty(attacker, g, offset, scale)
    local jumpy_dumpty = SpawnPrefab("jumpy_dumpty")
    jumpy_dumpty.components.complexprojectile:SetGravity(g)
    jumpy_dumpty.components.complexprojectile:SetLaunchOffset(Vector3(0, offset, 0))
    return jumpy_dumpty
end

-- 发射完整的3次弹跳
local function CastJumpyDumpty(caster, count, onhitfn)
    local g = {-80, -90, -100}
    local offset = {1.5, 0, 0}
    local scale = {1, 1, 1.3}
    local max_count = 3

    local x, y, z = caster.Transform:GetWorldPosition()
    local angle = (caster.Transform:GetRotation() + 90) * DEGREES
    local tx = 4 * math.sin(angle)
    local tz = 4 * math.cos(angle)

    local target = SpawnPrefab("explode_small")
    target.Transform:SetPosition(x+tx, y, z+tz)
    target:Remove()
    local jumpy_dumpty = MakeJumpyDumpty(caster, g[count], offset[count], scale[count])
    jumpy_dumpty.Transform:SetPosition(caster.Transform:GetWorldPosition())
    jumpy_dumpty.components.complexprojectile:SetOnHit(function(inst, attacker, target)
        inst.SoundEmitter:KillSound("hiss")
        inst.SoundEmitter:PlaySound("dontstarve/common/dropwood")

        local fx = SpawnPrefab("explode_small")
        local current_scale = scale[count]
        fx.Transform:SetScale(current_scale, current_scale, current_scale)
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

        onhitfn(inst, attacker)

        local x, y, z = inst.Transform:GetWorldPosition()
        
        count = count + 1
        if max_count >= count then
            local angle = (inst.Transform:GetRotation() + 90) * DEGREES
            local tx = 2 * math.sin(angle)
            local tz = 2 * math.cos(angle)

            local target = SpawnPrefab("explode_small")
            target.Transform:SetPosition(x+tx, y, z+tz)
            target:Remove()

            local proj = CastJumpyDumpty(attacker, count, onhitfn)
            proj.Transform:SetPosition(inst.Transform:GetWorldPosition())
            proj.components.complexprojectile:Launch(target:GetPosition(), attacker)
        else
            local ents = TheSim:FindEntities(x, y, z, 800, {"klee_mine"})
            for i, v in ipairs(ents) do
                v:PushEvent("Explode")
            end
            Mine(inst, attacker)
        end
        inst:Remove()
    end)
    if count == 1 then
        jumpy_dumpty.components.complexprojectile:Launch(target:GetPosition(), caster)
    end
    return jumpy_dumpty
end

local klee_chargeattack = State{
    name = "klee_chargeattack",
    tags = { "chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack", "autopredict" },

    onenter = function(inst)
        -- print("DoChargedAttack")
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        
        -- 天赋 砰砰礼物 爆裂火花效果检查
        if inst.explosive_spark then
            -- print("PoundingSurprise take effect")
            inst.components.combat.external_attacktype_multipliers:SetModifier(inst, 0.5, "charge_sparkseffect")
        end

        inst.AnimState:PlayAnimation("klee_charge")
    end,

    timeline = (function ()
        local fx = nil
        return {
            TimeEvent(2*FRAMES, function (inst)
                local x, y, z = inst.Transform:GetWorldPosition()
                local angle = (inst.Transform:GetRotation() + 90) * DEGREES
                local tx = 6 * math.sin(angle)
                local tz = 6 * math.cos(angle)
                fx = SpawnPrefab("klee_charge_fx")
                fx.Transform:SetPosition(x+tx, y, z+tz)
                fx.Transform:SetScale(0.7, 0.7, 0.7)
            end),
    
            TimeEvent(3*FRAMES, function (inst)
                fx.Transform:SetScale(0.8, 0.8, 0.8)
            end),
    
            TimeEvent(4*FRAMES, function (inst)
                fx.Transform:SetScale(0.9, 0.9, 0.9)
            end),
    
            TimeEvent(5*FRAMES, function (inst)
                fx.Transform:SetScale(1, 1, 1)
            end),
            
            TimeEvent(10*FRAMES, function (inst)
                local x, y, z = fx.Transform:GetWorldPosition()
                local pos = {x, y, z}
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_explode")
                inst.SoundEmitter:KillSound("hiss")
                local explode_fx = SpawnPrefab("explode_small")
                explode_fx.Transform:SetPosition(x, y, z)
                explode_fx.Transform:SetScale(2, 2, 2)
                inst.components.combateffect_klee:DoAttackAndExplode(pos, 2.5, TUNING.KLEE_SKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)],0)
                
                -- 天赋 砰砰礼物 爆裂火花效果结算完毕，移除
                if inst.explosive_spark then
                    -- print("Remove PoundingSurprise")
                    inst.components.combat.external_attacktype_multipliers:RemoveModifier(inst, "charge_sparkseffect")
                    inst.explosive_spark:Remove()
                    inst.explosive_spark = nil
                end
    
                inst.sg:RemoveStateTag("nointerrupt")
                inst.sg:RemoveStateTag("notalking")
                inst.sg:RemoveStateTag("autopredict")
            end),
    
            -- 延迟2帧退出状态保证嘟可可故事集能检测到重击
            TimeEvent(12*FRAMES, function (inst)
                inst.sg:RemoveStateTag("chargeattack")
                inst.sg:RemoveStateTag("attack")
                fx:Remove()
                fx = nil
            end),
        }
    end)(),

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.sg:RemoveStateTag("nointerrupt")
        inst.sg:RemoveStateTag("notalking")
        inst.sg:RemoveStateTag("autopredict")
        inst.sg:RemoveStateTag("chargeattack")
        inst.sg:RemoveStateTag("attack")
        inst.sg:RemoveStateTag("abouttoattack")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
    end,
}

local klee_chargeattack_client = State{
    name = "klee_chargeattack",
    tags = {"chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack" },

    onenter = function(inst)
        -- print("DoChargedAttack")
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
        end
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        inst.AnimState:PlayAnimation("klee_charge")
    end,

    timeline = 
    {
        TimeEvent(12*FRAMES, function (inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("autopredict")
            inst.sg:RemoveStateTag("chargeattack")
            inst.sg:RemoveStateTag("attack")
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        inst.sg:RemoveStateTag("nointerrupt")
        inst.sg:RemoveStateTag("notalking")
        inst.sg:RemoveStateTag("autopredict")
        inst.sg:RemoveStateTag("chargeattack")
        inst.sg:RemoveStateTag("attack")
        inst.sg:RemoveStateTag("abouttoattack")
    end,
}

--元素战技
local klee_elementalskill = State{
    name = "klee_elementalskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible", "pausepredict" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        inst.components.playercontroller:Enable(false)
        -- inst.AnimState:PlayAnimation(eleskill_anim)
        -- inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
            inst.AnimState:Hide("ARM_CARRY")
        end

        -- 可以考虑加点可莉的语音
        -- inst.SoundEmitter:PlaySound("raiden_sound/sesound/raiden_eleskill")

        inst:AddTag("stronggrip")
        inst.AnimState:PlayAnimation("throw")
    end,

    timeline=
    {
        TimeEvent(0 * FRAMES, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local angle = (inst.Transform:GetRotation() + 90) * DEGREES
            local tx = 4 * math.sin(angle)
            local tz = 4 * math.cos(angle)

            local explode_fx = SpawnPrefab("explode_small")
            explode_fx.Transform:SetPosition(x+tx, y, z+tz)
            explode_fx:Remove()
            -- if mintarget ~= nil then
            --     inst:FacePoint(Point(mintarget.Transform:GetWorldPosition()))
            -- end
            -- local facingangle = inst.Transform:GetRotation() * DEGREES
            -- local fx = SpawnPrefab("raiden_eleskill_fx")
            -- fx.Transform:SetPosition(x + math.cos(-facingangle) * 2.5, 1.5, z + math.sin(-facingangle) * 2.5)
        end),

        TimeEvent(2 * FRAMES, function(inst)
            -- local x, y, z = inst.Transform:GetWorldPosition()
            -- local facingangle = inst.Transform:GetRotation() * DEGREES
            -- local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
            CastJumpyDumpty(inst, 1, function (jumpy, attacker)
                local x, y, z = jumpy.Transform:GetWorldPosition()
                local pos = {x, y, z}
                attacker.components.energyrecharge:GainEnergy(2)
                inst.components.combateffect_klee:DoAttackAndExplode(pos, 4, TUNING.KLEE_SKILL_ELESKILL.DMG[attacker.components.talents:GetTalentLevel(2)],8)
            end)
        end),

        TimeEvent(7 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.components.playercontroller:Enable(true)
    end,

    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
            inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst:RemoveTag("stronggrip")
        inst.components.playercontroller:Enable(true)
    end,
}

local klee_elementalskill_client = State{
    name = "klee_elementalskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleskill_anim)

        inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
            inst.AnimState:Hide("ARM_CARRY")
        end
    end,

    timeline=
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst)
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.components.playercontroller:Enable(true)
    end,

    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
            inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst.components.playercontroller:Enable(true)
    end,
}

--添加Status Graph
local function SGWilsonPostInit(sg)
    sg.states["klee_chargeattack"]   = klee_chargeattack
    sg.states["klee_elementalskill"] = klee_elementalskill
end

local function SGWilsonClientPostInit(sg)
    sg.states["klee_chargeattack"]   = klee_chargeattack_client
    sg.states["klee_elementalskill"] = klee_elementalskill_client
end

AddStategraphState("SGwilson", klee_chargeattack)
AddStategraphState("SGwilson", klee_elementalskill)

AddStategraphState("SGwilson_client", klee_chargeattack_client)
AddStategraphState("SGwilson_client", klee_elementalskill_client)

AddStategraphPostInit("wilson", SGWilsonPostInit)
AddStategraphPostInit("wilson_client", SGWilsonClientPostInit)

