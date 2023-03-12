local function dmgmultfunc(num)  --攻击倍率通用模板函数
    return string.format("%.1f%%", 100 * num) 
end

local function timefunc(num)  --时间通用模板函数
    return string.format("%.1f秒", num)
end

local function plainintfunc(num)    --直接写,整数
    return string.format("%d", num) 
end

-- 先用中文，不管什么狗屁本地化
-- 天赋描述
TUNING.KLEE_TALENTS_DESC = {
    titlename = {
        "普通攻击·砰砰",
        "蹦蹦炸弹",
        "轰轰火花",
        "砰砰礼物",
        "火花无限",
        "全是宝藏",
    },
    content = {
        {
            {str = "普通攻击·砰砰", title = true},
            {str = "投掷在碰撞后爆炸的好东西!进行至多三段的炸弹攻击，造成火元素范围伤害。", title = false},
            {str = "重击", title = true},
            {str = "消耗一定体力，短暂咏唱后，轰击敌人，造成火元素范围伤害。", title = false},
        },
        {
            {str = "投岀带来无限快乐的蹦蹦炸弹！蹦蹦炸弹会连续弹跳三次，每次弹跳都会引发爆炸，造成火元素范围伤害。", title = false},
            {str = "", title = false},
            {str = "第三次弹跳后，将分裂成许多（8个）诡雷。", title = false},
            {str = "诡雷会在接触到敌人或一段时间后发生爆炸，造成火元素范围伤害", title = false},
            {str = "", title = false},
            {str = "初始拥有2次可使用次数。", title = false},
            {str = "", title = false},
            {str = "蹦蹦是可莉的「好朋友」…可莉总是忍不住向人介绍他们。", title = false},
        },
        {
            {str = "可莉火力全开！在技能持续时间内，不停召唤轰轰火花攻击附近的敌人，造成火元素范围伤害。 ", title = false},
            {str = "\n骑士团的人相信，可莉从来不被自己的炸弹所伤，一定有幸运星眷顾着她吧…", title = false},
        },
        {
            {str = "蹦蹦炸弹与普通攻击造成伤害时，有50％的几率赋予可莉一朵爆裂火花。施放重击时将消耗爆裂火花，使本次重击不消耗体力，造成的伤害提升50％。\n2朵爆裂火花生成的时间间隔不小于5秒。" , title = false},
        },
        {
            {str = "可莉的重击造成暴击后，为队伍中所有角色恢复2点元素能量。\n不过现在队里只有可莉一个人", title = false},
        },
        {
            {str = "在小地图上显示周围的蒙德区域特产的位置。\n但是现在可莉根本不在蒙德", title = false},
        },
        {
            {str = "?", title = false},
        },
    },
}

TUNING.KLEE_SKILL_NORMALATK_TEXT = {
    ATK_DMG = {
        title = "普通攻击伤害", 
        formula = dmgmultfunc,
    },
    CHARGE_ATK_DMG = {
        title = "重击伤害", 
        formula = dmgmultfunc,
    },
}

TUNING.KLEE_SKILL_ELESKILL_TEXT = 
{
    DMG = {
        title = "蹦蹦炸弹伤害",
        formula = dmgmultfunc,
    },
    CO_DMG = {
        title = "诡雷伤害",
        formula = dmgmultfunc,
    },
    DURATION = {
        title = "诡雷持续时间",
        formula = timefunc,
    },
    CD = {
        title = "冷却时间",
        formula = timefunc,
    },
}

TUNING.KLEE_SKILL_ELEBURST_TEXT = 
{
    DMG = {
        title = "轰轰火花伤害", 
        formula = dmgmultfunc,
    },
    DURATION = {
        title = "持续时间", 
        formula = timefunc,
    },
    CD = {
        title = "冷却时间",
        formula = timefunc,
    },
    ENERGY = {
        title = "元素能量",
        formula = plainintfunc,
    },
}

