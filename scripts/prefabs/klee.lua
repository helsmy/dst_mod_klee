--初始加载
local MakePlayerCharacter = require "prefabs/player_common"
local ElementalSkillFactoryKlee = require "widgets/elementalcaster_factory_klee"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("ANIM", "anim/ghost_klee_build.zip"),
	Asset("ANIM", "anim/klee.zip"),
	Asset("ANIM", "anim/klee_hat.zip")
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.KLEE
end

local prefabs = FlattenTree(start_inv, true)

local skillkeys = {
    TUNING.ELEMENTALSKILL_KEY,
	TUNING.ELEMENTALBURST_KEY,
}

local function KleeHat(inst)
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) == nil then
		inst.AnimState:OverrideSymbol("swap_hat", "klee_hat", "swap_hat")
		inst.AnimState:Show("HAT")
	end
end

local function OnBecameHuman(inst)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end

local function OnLoad(inst)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    OnBecameHuman(inst)
end

local function OnDeath(inst)
	-- 4命 说起来其实也没什么卵用
	if inst.components.constellation:GetActivatedLevel() >= 4 and inst.burststate == true then
		local x, y, z = inst.Transform:GetWorldPosition()
		local pos = {x, y, z}
    	inst.components.combateffect_klee:DoAttackAndExplode(pos, 4, 5.55, 0)
	end
end

local function OnEquip(inst, data)
	if data ~= nil and data.item ~= nil and data.eslot == EQUIPSLOTS.HANDS and data.item:HasTag("genshin_catalyst") then
		-- print("set attack period")
		inst.components.combat:SetAttackPeriod(TUNING.KLEE_ATK_CD)
	end
end

local function OnUnequip(inst, data)
	if data ~= nil and data.item ~= nil and data.eslot == EQUIPSLOTS.HANDS then
		-- 切换回到默认的攻击速度
		-- print("unset attack period")
		inst.components.combat:SetAttackPeriod(0.5)
	end
end

-- 这个函数主客机都运行
local function ChargeSGFn(inst)
	if TheWorld.ismastersim then
		local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
		if weapon == nil or (not weapon:HasTag("genshin_catalyst")) then
			return "attack"
		end
	else
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		if equip == nil or (not equip:HasTag("genshin_catalyst")) then
			return "attack"
		end
	end
	return "klee_chargeattack"
end

local function AttackDecorator(func)
	local function InnerDecorator(inst, target, instancemult, ischarge)
		print("target:", type(target), target, "instancemult:", instancemult, "ischarge:", ischarge)
		if inst.components.constellation:GetActivatedLevel() >= 1 then
			-- 这里应该是设定成释放技能和攻击都进行一次协同攻击
			-- 但是可莉释放技能，现在是没有目标的，无法将协同攻击绑定并释放
			-- 所以先判断一下目标是不是一个有效的对象，来让效果暂时只在普攻时生效
			-- 这里是打算进行一次一定范围的目标搜索，
			-- 并且可以达成打到莫名奇妙的东西上达成血压上升
			if type(target) == "table" and math.random() < 0.25 then
				local spark = SpawnPrefab("klee_single_spark")
				spark.Transform:SetPosition(target.Transform:GetWorldPosition())
				spark:DoTaskInTime(10*FRAMES, function ()
					local x, y, z = target.Transform:GetWorldPosition()
					local pos = {x, y, z}
					inst.components.combateffect_klee:DoAreaAttack(pos, 1.1, TUNING.KLEE_SKILL_ELEBURST.DMG[inst.components.talents:GetTalentLevel(3)]*1.2, 0)
				end)
				spark:DoTaskInTime(12*FRAMES, spark.Remove)
			end
		end
		func(inst, target, instancemult, ischarge)
	end

	return InnerDecorator
end

local function AttackkeyFn(inst, weapon, target)
    if inst.burststate then
		return "elementalburst"
	else
        return inst.sg:HasStateTag("chargeattack") and "charge" or "normal"
	end
end

--普通攻击倍率
local function NormalATKRateFn(inst, target)
	return TUNING.KLEE_SKILL_NORMALATK.ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

--重击倍率
local function ChargeATKRateFn(inst, target)
	return TUNING.KLEE_SKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

local function CustomAttackFn(inst, target, instancemult, ischarge)
	-- assets(false, "CustomAttackFn breakpoint")
	print("attack status:", ischarge)
	-- print("attack status chargesgname:", FunctionOrValue(inst.chargesgname, inst))
	-- print("attack status cancharge:", inst.cancharge)
	local weapon = inst.components.combat:GetWeapon()
	if weapon ==nil or not weapon:HasTag("genshin_catalyst") then
		inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
		return
	end
	-- FIXME: 重击和元素爆发一起使用时有时候会崩溃
	if not ischarge then
		-- 临时将符合条件的武器的投射物设成可莉的投射物
		-- 这样可莉的普攻就永远是一样的了
		local old_proj = weapon.components.weapon.projectile
		weapon.components.weapon:SetProjectile("klee_proj")
		inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
		weapon.components.weapon:SetProjectile(old_proj)
		return
	end
end


--元素战技
local function elementalskillfn(inst)
	if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalskill") then
	    return
	end

	inst.components.elementalcaster:ConsumeElementalSkill()
	inst:PushEvent("cast_elementalskill")
	inst.sg:GoToState("klee_elementalskill")
end

--元素爆发结束
local function elementalburst_exitfn(inst)
	if inst.burststate == true then
		inst.burststate = false
		inst._burststate:set(false)
		inst.SparksnSplash:Remove()
	end

	if inst.components.inventory.isexternallyinsulated then
		inst.components.inventory.isexternallyinsulated:RemoveModifier(inst)
	end
end

--元素爆发
local function elementalburstfn(inst)
    if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalburst") then
	    return
	end
	local SparksnSplashEffect = function ()
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 8, {"_combat"}, TUNING.KLEE_AREA_ATK_NOTAGS)
		local targets = {}
		for i, v in ipairs(ents) do
			if v ~= inst and v ~= inst.SparksnSplash then
				targets[#targets+1] = v
			end
		end
		-- 要是什么目标都没有就返回
		if #targets == 0 then return end
		local target = targets[1]
		-- 在符合要求的目标里随机找一个(让你血压上升的索敌来了)
		if #targets > 1 then
			target = targets[math.random(1, #targets)]
		end
		-- 生成攻击火花
		local sparks = SpawnPrefab("klee_multi_spark")
		sparks.Transform:SetPosition(target.Transform:GetWorldPosition())
		sparks:DoTaskInTime(1.4, sparks.Remove)
		-- 再进行一次超小范围的AOE，随机攻击3-5次
		local attack_count = math.random(3, 5)
		-- 莫名其妙的会鞭尸，生物死亡可能后不是立即被删除
		-- 不过这也让人血压上升，就当是特性了
		for i = 1, attack_count do
			sparks:DoTaskInTime(0.6+0.1*i, function ()
				local fx = SpawnPrefab("explode_small")
				fx.Transform:SetPosition(sparks.Transform:GetWorldPosition())
				fx.Transform:SetScale(0.8, 0.8, 0.8)
				local x1, y1, z1 = sparks.Transform:GetWorldPosition()
				local pos = {x1, y1, z1}
				inst.components.combateffect_klee:DoAreaAttack(pos, 1.1, TUNING.KLEE_SKILL_ELEBURST.DMG[inst.components.talents:GetTalentLevel(3)], 0)
			end)
		end
	end
	inst.SparksnSplash = SpawnPrefab("sparks_n_splash")
	inst.SparksnSplash.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
	inst.SparksnSplash.owner = inst
	-- 0.5s发动一次，之后每隔2s一次，完成6次
	inst.SparksnSplash:DoTaskInTime(0.5, function ()
		SparksnSplashEffect()
		inst.SparksnSplash:DoPeriodicTask(2, function ()
			SparksnSplashEffect()
		end)
	end)

	-- 6命 don't strave alone时卵用没有的命座
	if inst.components.constellation:GetActivatedLevel() >= 6 then
		inst.SparksnSplash:DoPeriodicTask(3, function ()
			for index, v in ipairs(AllPlayers) do
				if v ~= inst and v.components.energyrecharge then
					v.components.energyrecharge:GainEnergy(3)
				end
			end
		end)
	end

	-- if inst.burststate then
	-- 	elementalburst_exitfn(inst)
	-- 	if inst.exittask ~= nil then
	-- 		inst.exittask:Cancel()
	-- 		inst.exittask = nil
	-- 	end
	-- end

	inst.burststate = true
	inst._burststate:set(true)
	inst.exittask = inst:DoTaskInTime(TUNING.KLEE_SKILL_ELEBURST.DURATION, elementalburst_exitfn)

	-- inst:AddTag("stronggrip")

	inst:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 1})
	TheWorld:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 1})

    -- 以后加一个元素爆发的动画
	-- inst.sg:GoToState("klee_elementalburst")

end

local function constellation_func3(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(2, inst, 3, "klee_constellation3")
end

local function constellation_func5(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(3, inst, 3, "klee_constellation5")
end

local function NewTalentsObject()
	local last_time = GetTime()
	-- 天赋 砰砰礼物
	local function PoundingSurprise(inst, data)
		if inst.explosive_spark then return end
		local now = GetTime()
		if math.random() < 0.5 then return end
		if now - last_time < 5 then return end

		inst.explosive_spark = SpawnPrefab("explosive_spark")
		inst.explosive_spark.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
		last_time = now
	end

	-- 天赋 火花无限 暴击充能
	local function SparklingBurst(inst, data)
		if data.attackkey ~= "charge" or (not data.crit) then return end
		for i, v in pairs(AllPlayers) do
			if v.components.energyrecharge then
				v.components.energyrecharge:GainEnergy(2)
			end
		end
	end

	local function OnDamageCalculated(inst, data)
		PoundingSurprise(inst, data)
		SparklingBurst(inst, data)
	end

	return OnDamageCalculated
end

AddModRPCHandler("klee", "elementalskill", AttackDecorator(elementalskillfn))
AddModRPCHandler("klee", "elementalburst", AttackDecorator(elementalburstfn))

local common_postinit = function(inst) 
	inst.MiniMapEntity:SetIcon( "klee.tex" )

	inst.Transform:SetScale(0.85, 0.85, 0.85)

	-- tags
	inst:AddTag("klee")
	inst:AddTag("pyro")
	inst:AddTag("catalyst_class")
	inst:AddTag("genshin_character")

	inst.character_description = STRINGS.CHARACTER_DESCRIPTIONS.klee

	-- 命座信息
	inst.constellation_decription = TUNING.KLEE_CONSTELLATION_DESC 
	inst.constellation_starname = "klee_constellation_star"

	-- 天赋信息
	inst.talents_path = "images/ui/talents_klee"
	inst.talents_number = 6
	inst.talents_ingredients = TUNING.KLEE_TALENTS_INGREDIENTS
	inst.talents_description = TUNING.KLEE_TALENTS_DESC
	inst.talents_attributes = {
		value = {
			TUNING.KLEE_SKILL_NORMALATK,
			TUNING.KLEE_SKILL_ELESKILL,
			TUNING.KLEE_SKILL_ELEBURST,
		},
		text = {
			TUNING.KLEE_SKILL_NORMALATK_TEXT,
			TUNING.KLEE_SKILL_ELESKILL_TEXT,
			TUNING.KLEE_SKILL_ELEBURST_TEXT,
		},
		keysort = {
			TUNING.KLEE_SKILL_NORMALATK_SORT,
			TUNING.KLEE_SKILL_ELESKILL_SORT,
			TUNING.KLEE_SKILL_ELEBURST_SORT,
		},
	}

	inst:AddComponent("keyhandler_klee")
	inst.components.keyhandler_klee:SetSkillKeys(skillkeys)
	--释放
	inst.components.keyhandler_klee:AddActionListener(TUNING.ELEMENTALSKILL_KEY, {Namespace = "klee", Action = "elementalskill"}, "keyup", nil)
	inst.components.keyhandler_klee:AddActionListener(TUNING.ELEMENTALBURST_KEY, {Namespace = "klee", Action = "elementalburst"}, "keyup", nil)

    ----------------------------------------------------------------------------
    --状态
    inst.burststate = false
	--网络变量
	inst._burststate = net_bool(inst.GUID, "klee._burststate", "statedirty")
	--不是主机
	if not TheWorld.ismastersim then
		inst:ListenForEvent("statedirty", function(inst)
			inst.burststate = inst._burststate:value()
		end)
	end
	----------------------------------------------------------------------------

	inst.chargesgname = ChargeSGFn
end

local master_postinit = function(inst)
	inst.soundsname = "willow"

	--添加元素充能
	inst:AddComponent("energyrecharge")
	inst.components.energyrecharge:SetMax(TUNING.KLEE_SKILL_ELEBURST.ENERGY)

	--设置元素战技和元素爆发施放
	inst:AddComponent("elementalcaster")
	ElementalSkillFactoryKlee(inst)
	inst.components.elementalcaster:SetElementalSkill(TUNING.KLEE_SKILL_ELESKILL.CD, TUNING.KLEE_SKILL_ELESKILL_COUNT)
	inst.components.elementalcaster:SetElementalBurst(TUNING.KLEE_SKILL_ELEBURST.CD, TUNING.KLEE_SKILL_ELEBURST.ENERGY)
	
	-- 频繁使用的攻击效果
	inst:AddComponent("combateffect_klee")
	
	--天赋
	inst:AddComponent("talents")
	
	-- 命座
	inst:AddComponent("constellation")
	inst.components.constellation:SetLevelFunc(3, constellation_func3)
	inst.components.constellation:SetLevelFunc(5, constellation_func5)


	-- 三维设置
	inst.components.health:SetMaxHealth(TUNING.KLEE_HEALTH)
	inst.components.hunger:SetMax(TUNING.KLEE_HUNGER)
	inst.components.sanity:SetMax(TUNING.KLEE_SANITY)
	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE

	-- 初始物品
	inst.starting_inventory = start_inv.default

	inst.components.combat:SetDefaultDamage(TUNING.KLEE_BASEATK)
	inst.components.combat.damagemultiplier = 1
	inst.components.combat.damagebonus = 0
	inst.components.combat:SetAttackPeriod(2)

	inst.components.combat.overrideattackkeyfn = AttackkeyFn

	inst:DoPeriodicTask(FRAMES, KleeHat)

	inst.OnLoad = OnLoad

	inst.normalattackdmgratefn = NormalATKRateFn
	inst.chargeattackdmgratefn = ChargeATKRateFn
	inst.customattackfn = AttackDecorator(CustomAttackFn)

	inst.elementalburst_exit = elementalburst_exitfn

	-- 监听器 处理天赋
	inst:ListenForEvent("damagecalculated", NewTalentsObject())
	inst:ListenForEvent("death", OnDeath)

	-- 监听器 处理装备上法器时的攻速调整
	inst:ListenForEvent("equip", OnEquip)
	inst:ListenForEvent("unequip", OnUnequip)
end

return MakePlayerCharacter("klee", prefabs, assets, common_postinit, master_postinit)

