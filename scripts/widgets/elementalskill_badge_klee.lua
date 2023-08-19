local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Button = require "widgets/button"
local ImageButton = require "widgets/imagebutton"
local Draggable_GenshinBtn = require "widgets/draggable_genshinbtn"
-- 技能按键的UI，直接照抄元素反应作者的雷电将军mod
local keys = {
    KEY_TAB = 9,
    KEY_KP_PERIOD		= 266,
    KEY_KP_DIVIDE		= 267,
    KEY_KP_MULTIPLY		= 268,
    KEY_KP_MINUS		= 269,
    KEY_KP_PLUS			= 270,
    KEY_KP_ENTER		= 271,
    KEY_KP_EQUALS		= 272,
    KEY_MINUS = 45,
    KEY_EQUALS = 61,
    KEY_SPACE = 32,
    KEY_ENTER = 13,
    KEY_ESCAPE = 27,
    KEY_HOME = 278,
    KEY_INSERT = 277,
    KEY_DELETE = 127,
    KEY_END    = 279,
    KEY_PAUSE = 19,
    KEY_PRINT = 316,
    KEY_CAPSLOCK = 301,
    KEY_SCROLLOCK = 302,
    KEY_RSHIFT = 303, -- use KEY_SHIFT instead
    KEY_LSHIFT = 304, -- use KEY_SHIFT instead
    KEY_RCTRL = 305, -- use KEY_CTRL instead
    KEY_LCTRL = 306 ,-- use KEY_CTRL instead
    KEY_RALT = 307, -- use KEY_ALT instead
    KEY_LALT = 308, -- use KEY_ALT instead
    KEY_LSUPER = 311,
    KEY_RSUPER = 312,
    KEY_ALT = 400,
    KEY_CTRL = 401,
    KEY_SHIFT = 402,
    KEY_BACKSPACE = 8,
    KEY_PERIOD = 46,
    KEY_SLASH = 47,
    KEY_SEMICOLON = 59,
    KEY_LEFTBRACKET	= 91,
    KEY_BACKSLASH	= 92,
    KEY_RIGHTBRACKET= 93,
    KEY_TILDE = 96,
    KEY_A = 97,
    KEY_B = 98,
    KEY_C = 99,
    KEY_D = 100,
    KEY_E = 101,
    KEY_F = 102,
    KEY_G = 103,
    KEY_H = 104,
    KEY_I = 105,
    KEY_J = 106,
    KEY_K = 107,
    KEY_L = 108,
    KEY_M = 109,
    KEY_N = 110,
    KEY_O = 111,
    KEY_P = 112,
    KEY_Q = 113,
    KEY_R = 114,
    KEY_S = 115,
    KEY_T = 116,
    KEY_U = 117,
    KEY_V = 118,
    KEY_W = 119,
    KEY_X = 120,
    KEY_Y = 121,
    KEY_Z = 122,
    KEY_F1 = 282,
    KEY_F2 = 283,
    KEY_F3 = 284,
    KEY_F4 = 285,
    KEY_F5 = 286,
    KEY_F6 = 287,
    KEY_F7 = 288,
    KEY_F8 = 289,
    KEY_F9 = 290,
    KEY_F10 = 291,
    KEY_F11 = 292,
    KEY_F12 = 293,
    
    KEY_UP			= 273,
    KEY_DOWN		= 274,
    KEY_RIGHT		= 275,
    KEY_LEFT		= 276,
    KEY_PAGEUP		= 280,
    KEY_PAGEDOWN	= 281,
    
    KEY_0 = 48,
    KEY_1 = 49,
    KEY_2 = 50,
    KEY_3 = 51,
    KEY_4 = 52,
    KEY_5 = 53,
    KEY_6 = 54,
    KEY_7 = 55,
    KEY_8 = 56,
    KEY_9 = 57,
}

local function GetActualKey(key)
    for k,v in pairs(keys) do
	    if key == v then
		    return string.sub(k, 5)
		end
	end
	return ""
end

local elementalskill_badge = Class(Draggable_GenshinBtn, function(self, owner, imgs, totalcd, key)
	Draggable_GenshinBtn._ctor(self, "elementalskill_badge")
	self.owner = owner
    self.scale_on_focus = false  --禁止缩放
	self.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
    
    self.percent = 0
    -- 技能0-2个可用的图标
    self.images = {}
    for i, v in ipairs(imgs) do
        local image = self:AddChild(Image(v[1], v[2]))-- altas, tex
        image:SetScale(1.7, 1.7, 1.7)
        self.images[i] = image
    end

    self.skillcdanim = self:AddChild(UIAnim())
    self.skillcdanim:GetAnimState():SetBank("genshincd_meter")
	self.skillcdanim:GetAnimState():SetBuild("genshincd_meter")
	self.skillcdanim:GetAnimState():SetPercent("recharge", 0)
    self.skillcdanim:SetPosition(240, -240, 0)
    self.skillcdanim:SetScale(2.4, 2.4, 2.4)

    self.totalcd = totalcd

	self.skillcd = self:AddChild(Text("genshinfont", 80))
	self.skillcd:SetHAlign(ANCHOR_MIDDLE)
	self.skillcd:MoveToFront()

    self.key_bg = self:AddChild(Image("images/ui/skillkey_bg.xml", "skillkey_bg.tex"))
    self.key_bg:SetPosition(0, -195, 0)
    self.key_bg:SetScale(1.6, 1.6, 1.6)

    self.key_text = self:AddChild(Text("genshinfont", 88, GetActualKey(key), {50/255, 50/255, 50/255, 1}))
    self.key_text:SetPosition(0, -195, 0)

    self.btn = self:AddChild(ImageButton("images/ui.xml", "blank.tex"))
    self.btn:ForceImageSize(130, 130)
	self.btn.scale_on_focus = false  --禁止缩放
	self.btn.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.btn:SetOnClick(function()
	    if not self:HasMoved() and self.onclick ~= nil then
            self.onclick()
        end
	end)

	self:StartUpdating()
end)

function elementalskill_badge:OnUpdate(dt)
    local elementalcaster = TheWorld.ismastersim and self.owner.components.elementalcaster or self.owner.replica.elementalcaster
    if elementalcaster == nil then
        return
    end
    local cd = math.max(0, self.totalcd - (elementalcaster.CDTime - elementalcaster.elementalskill))
    -- print(cd)
    -- print("GetTime:"..elementalcaster.CDTime.."  ,Bursttime:"..elementalcaster.elementalskill)

	if self.owner:HasTag("playerghost") then
        for i, v in ipairs(self.images) do
            v:Hide()
        end
		self.skillcd:Hide()
        self.skillcdanim:Hide()
        self.key_bg:Hide()
        self.key_text:Hide()
	else
        self.key_bg:Show()
        self.key_text:Show()
        if cd > 0 then
            self.skillcd:SetString(string.format("%.1f", cd))
            self.skillcdanim:GetAnimState():SetPercent("recharge", 1 - cd/self.totalcd)
            self.skillcd:Show()
            self.skillcdanim:Show()
            if elementalcaster.count == 0 then
                self.images[1]:Show()
                self.images[2]:Hide()
                self.images[3]:Hide()
                self.images[1]:SetTint(1, 1, 1, 0.6)
            else
                for i, v in ipairs(self.images) do
                    v:Hide()
                end
                self.images[elementalcaster.count+1]:Show()
                self.images[elementalcaster.count+1]:SetTint(1, 1, 1, 0.9)
            end
        else
            -- 冷却完成增加战技数量
            elementalcaster:AddElementalSkillCount()
            self.skillcd:Hide()
            self.skillcdanim:Hide()
            for i, v in ipairs(self.images) do
                v:Hide()
            end
            self.images[elementalcaster.count+1]:Show()
            self.images[1]:SetTint(1, 1, 1, 1)
        end
	end
end

return elementalskill_badge