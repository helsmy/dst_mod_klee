local function dmgmultfunc(num)  --攻击倍率通用模板函数
    return string.format("%.1f%%", 100 * num) 
end

local function timefunc(num)  --时间通用模板函数
    return string.format("%.1f秒", num)
end

local function plainintfunc(num)    --直接写,整数
    return string.format("%d", num) 
end


local language = GetModConfigData("lang")
if language == 0 then
    if STRINGS.UI.OPTIONS.LANGUAGES == "语言" then
        language = 2
    else
        language = 1
    end
end

if language == 1 then
    STRINGS.CHARACTER_TITLES.klee = "Fleeing Sunlight"
    STRINGS.CHARACTER_NAMES.klee = "Klee"
    STRINGS.CHARACTER_DESCRIPTIONS.klee = "An explosives expert and a regular at the Knights of Favonius's confinement room. Also known as Fleeing Sunlight."
    STRINGS.CHARACTER_QUOTES.klee = "Do you wanna come fish blasting with me?"
    STRINGS.CHARACTER_SURVIVABILITY.klee = "Kaboom!"

    STRINGS.NAMES.KLEE = "Klee"
    STRINGS.SKIN_NAMES.klee_none = "Klee"
    
    STRINGS.NAMES.APPRENTICES_NOTES = "Apprentice's Notes"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.APPRENTICES_NOTES = "With words, this book records learning, experiments, and incantations.\nWith the spaces between words, it records a student's striving. "
    STRINGS.RECIPE_DESC.APPRENTICES_NOTES = "With words, this book records learning, experiments, and incantations.\nWith the spaces between words, it records a student's striving. "
    
    STRINGS.NAMES.KLEE_STELLA = "Klee's Stella Fortuna"
    STRINGS.NAMES.DOCOCOTALES = "Dodoco Tales"
    STRINGS.NAMES.DOCOCO_REFINEMENT = "Fragments of Innocence"

    STRINGS.NAMES.FRAGMENTS_OF_INNOCENCE = "Fragments of Innocence"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FRAGMENTS_OF_INNOCENCE = "Pages scattered on the wind. Each one is filled to the brim with childlike wonder, and their dimensions are an exact match for 'Dodoco Tales.' The abundant innocence and pure love therein will never fade, and just like the never-ending adventure in the book — this passionate fairy tale shall forever soar in the wake of the author's footsteps."
    STRINGS.RECIPE_DESC.FRAGMENTS_OF_INNOCENCE = "Specialized refinement material for 'Dodoco Tales'."

    STRINGS.RECIPE_DESC.KLEE_STELLA = "Klee's Constellation Activation Materials"
    STRINGS.RECIPE_DESC.DOCOCOTALES = "A children's book filled with childish short stories."

    STRINGS.NAMES.MINEBOMB = "Mine"
    STRINGS.NAMES.KLEE_BAG = "Klee's bag"

    STRINGS.NAMES.KLEE_CONSTELLATION_STAR = "Klee's Stella Fortuna"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.KLEE_CONSTELLATION_STAR = "Activation Material of Klee's Stella Fortuna"
    STRINGS.RECIPE_DESC.KLEE_CONSTELLATION_STAR = "Activation Material of Klee's Stella Fortuna"

    TUNING.KLEE_TALENTS_DESC = {
        titlename = {
            "Normal Attack: Kaboom!",
            "Jumpy Dumpty",
            "Sparks 'n' Splash",
            "Pounding Surprise",
            "Sparkling Burst",
            "All Of My Treasures",
        },
        content = {
            {
                {str = "Normal Attack: Kaboom!", title = true},
                {str = "Throws things that go boom when they hit things! Perform up to 3 explosive attacks, dealing AoE Pyro DMG.", title = false},
                {str = "Charged Attack", title = true},
                {str = "Consumes a certain amount of Stamina and deals AoE Pyro DMG to opponents after a short casting time.", title = false},
            },
            {
                {str = "Jumpy Dumpty is tons of boom-bang-fun! \nWhen thrown, Jumpy Dumpty bounces thrice, igniting and dealing AoE Pyro DMG with every bounce.", title = false},
                {str = "", title = false},
                {str = "On the third bounce, the bomb splits into many mines.", title = false},
                {str = "The mines will explode upon contact with opponents, or after a short period of time, dealing AoE Pyro DMG.", title = false},
                {str = "", title = false},
                {str = "Starts with 2 charges.", title = false},
                {str = "", title = false},
                {str = "Jumpy Dumpty is Klee's good friend! She can't help but introduce him to everyone.", title = false},
            },
            {
                {str = "Klee's Blazing Delight! For the duration of this ability, continuously summons Sparks 'n' Splash to attack nearby opponents, dealing AoE Pyro DMG.", title = false},
                {str = "\nThe knights all believe that Klee must have a lucky star watching over her to have never been hurt by any of her own bombs...", title = false},
            },
            {
                {str = "When Jumpy Dumpty and Normal Attacks deal DMG, Klee has a 50% chance to obtain an Explosive Spark.\nThis Explosive Spark is consumed by the next Charged Attack, which costs no Stamina and deals 50% increased DMG." , title = false},
            },
            {
                {str = "When Klee's Charged Attack results in a CRIT Hit, all party members gain 2 Elemental Energy.", title = false},
            },
            {
                {str = "Displays the location of nearby resources unique to Mondstadt on the mini-map.\nBut, Klee is not in Mondstadt now.", title = false},
            },
            {
                {str = "?", title = false},
            },
        },
    }

    TUNING.KLEE_SKILL_NORMALATK_TEXT = {
        ATK_DMG = {
            title = "Normal Attack Damage", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "charged Attack Damage", 
            formula = dmgmultfunc,
        },
    }

    TUNING.KLEE_SKILL_ELESKILL_TEXT = 
    {
        DMG = {
            title = "Jumpy Dumpty DMG",
            formula = dmgmultfunc,
        },
        CO_DMG = {
            title = "Mine DMG",
            formula = dmgmultfunc,
        },
        DURATION = {
            title = "Mine Duration",
            formula = timefunc,
        },
        CD = {
            title = "CD",
            formula = timefunc,
        },
    }
    
    TUNING.KLEE_SKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "Sparks 'n' Splash DMG", 
            formula = dmgmultfunc,
        },
        DURATION = {
            title = "Duration", 
            formula = timefunc,
        },
        CD = {
            title = "CD",
            formula = timefunc,
        },
        ENERGY = {
            title = "Energy Cost",
            formula = plainintfunc,
        },
    }

    TUNING.KLEE_CONSTELLATION_DESC = 
    {
        titlename = 
        {
            "Chained Reactions",
            "Explosive Frags",
            "Exquisite Compound",
            "Sparkly Explosion",
            "Nova Burst",
            "Blazing Delight",
        },
        content = 
        {
            "Attacks and Skills have a certain chance to summon sparks that bombard opponents, dealing DMG equal to 120% of Sparks 'n' Splash's DMG.",
            "Being hit by Jumpy Dumpty's mines decreases opponents' DEF by 23% for 10s. ",
            "Increases the Level of Jumpy Dumpty by 3.\nMaximum upgrade level is 15.",
            "If Klee leaves the field during the duration of Sparks 'n' Splash, her departure triggers an explosion that deals 555% of her ATK as AoE Pyro DMG.",
            "Increases the Level of Sparks 'n' Splash by 3.\nMaximum upgrade level is 15.",
            "While under the effects of Sparks 'n' Splash, Klee will regenerate 3 Energy for all members of the party (excluding Klee) every 3s.\nWhen Sparks 'n' Splash is used, all party members will gain a 10% Pyro DMG Bonus for 25s.",
        },
    }
elseif language == 2 then
    STRINGS.CHARACTER_TITLES.klee = "逃跑的太阳"
    STRINGS.CHARACTER_NAMES.klee = "可莉"
    STRINGS.CHARACTER_DESCRIPTIONS.klee = "西风骑士团禁闭室的常客，蒙德的爆破大师。人称「逃跑的太阳」。"
    STRINGS.CHARACTER_QUOTES.klee = "要和可莉一起去炸鱼吗？"
    STRINGS.CHARACTER_SURVIVABILITY.klee = "咔嘣！"

    STRINGS.NAMES.KLEE = "可莉"
    STRINGS.SKIN_NAMES.klee_none = "可莉"
    
    STRINGS.NAMES.APPRENTICES_NOTES = "学徒笔记"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.APPRENTICES_NOTES = "某个优等生留下的学习笔记，娟秀的字迹非常好看。记录了不少实用的咒语。"
    STRINGS.RECIPE_DESC.APPRENTICES_NOTES = "某个优等生留下的学习笔记，娟秀的字迹非常好看。记录了不少实用的咒语。"

    STRINGS.NAMES.KLEE_STELLA = "可莉的命星"
    STRINGS.NAMES.DOCOCOTALES = "嘟嘟可故事集"

    STRINGS.RECIPE_DESC.KLEE_STELLA = "可莉的命座激活素材"
    STRINGS.RECIPE_DESC.DOCOCOTALES = "一本封面华丽的童书。"

    STRINGS.NAMES.MINEBOMB = "诡雷"
    STRINGS.NAMES.KLEE_BAG = "可莉的背包"

    STRINGS.NAMES.FRAGMENTS_OF_INNOCENCE = "童真的断章"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FRAGMENTS_OF_INNOCENCE = "随风散落的断篇，每一页上都写满童趣之事，而尺寸恰好与《嘟嘟可故事集》完美相合。其间满溢的童心与纯真的爱永不褪色，就像书中永无完结的大冒险一样，热忱的童话永远随着其作者的脚步飞扬。"
    STRINGS.RECIPE_DESC.FRAGMENTS_OF_INNOCENCE = "嘟嘟可故事集专用精炼道具"

    STRINGS.NAMES.KLEE_CONSTELLATION_STAR = "可莉的命星"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.KLEE_CONSTELLATION_STAR = "可莉的命之座激活素材"
    STRINGS.RECIPE_DESC.KLEE_CONSTELLATION_STAR = "可莉的命之座激活素材"

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

    TUNING.KLEE_CONSTELLATION_DESC = 
    {
        titlename = 
        {
            "连环轰隆",
            "破破弹片",
            "可莉特调",
            "一触即发",
            "轰击之星",
            "火力全开",
        },
        content = 
        {
            "攻击与施放技能时，有几率召唤火花轰击敌人，造成相当于轰轰火花（大招单段）攻击伤害120％的伤害。",
            "蹦蹦炸弹的诡雷会使敌人防御力降低23％，持续10秒。 ",
            "蹦蹦炸弹的技能等级提高3级。\n至多提升至15级。",
            "如果在轰轰火花持续期间内退场，会引发爆炸，造成555％攻击力的火元素范围伤害。",
            "轰轰火花的技能等级提高3级。\n至多提升至15级。",
            "在轰轰火花的状态下，会持续为队伍中所有角色（不包括可莉自己）恢复元素能量（每3秒跳1次，共跳3次，回复约9点）；施放轰轰火花后的25秒内，队伍中所有角色获得10％火元素伤害加成。",
        },
    }
end
    STRINGS.CHARACTERS.KLEE = require "speech_wilson"
-- STRINGS.CHARACTER_QUOTES.klee = "西风骑士团禁闭室的常客，蒙德的爆破大师。人称「逃跑的太阳」。"
