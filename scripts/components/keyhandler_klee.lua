-- 处理自定义按键和按键的RPC事件绑定，直接照抄元素反应作者的雷电将军mod

local function IsHUDScreen(inst) 
	local defaultscreen = false 
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name  and type(TheFrontEnd:GetActiveScreen().name) == "string"  and TheFrontEnd:GetActiveScreen().name == "HUD" then 
		defaultscreen = true 
	end 
	return defaultscreen 
end  

local KeyHandler_Klee = Class(function(self, inst)
	self.inst = inst
	self.paused = false
	self.enabled = true 
	self.ticktime = 0
	self.skillkeys = {}
end)

function KeyHandler_Klee:SetSkillKeys(keys)
    self.skillkeys = keys
end

function KeyHandler_Klee:SetEnabled(enable)
	self.enabled = enable
end 

function KeyHandler_Klee:CanTrigger()
	return self.enabled and IsHUDScreen(self.inst) and (self.inst.sg == nil or not self.inst.sg:HasStateTag("dead"))
	and self.inst.components.playercontroller:IsEnabled()
end 


function KeyHandler_Klee:IsKeyDownForOtherSkills(key)
	-- if self:IsKeyDown(400) or self:IsKeyDown(401) or self:IsKeyDown(402)  --ctrl,shift,alt
	-- 	or self:IsKeyDown(304) or self:IsKeyDown(306) or self:IsKeyDown(308)
	-- 	or self:IsKeyDown(303) or self:IsKeyDown(305) or self:IsKeyDown(307) then
	-- 		return true
	-- end
	if TheInput:IsKeyDown(KEY_CTRL) or TheInput:IsKeyDown(KEY_CTRL) or TheInput:IsKeyDown(KEY_ALT) then
		return true
	end

	return false 
end

function KeyHandler_Klee:HandleRPC(Rpc, clientfn, key)
	local x,y,z = ( TheInput:GetWorldPosition() or Vector3(0,0,0) ):Get()
	local entity = TheInput:GetWorldEntityUnderMouse()
	local Namespace = Rpc.Namespace
	local Action = Rpc.Action
	if clientfn then 
		clientfn(self.inst, x, y, z, entity)
	end	
	SendModRPCToServer(MOD_RPC[Namespace][Action], x, y, z, entity)
end 

function KeyHandler_Klee:AddActionListener(Key, Rpc, keytype, clientfn)
	local keyevent = keytype or "keyup"
	
	if keyevent == "keyup" then
		TheInput:AddKeyUpHandler(Key, function()
			if self.inst == ThePlayer then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, Key)
				end
			end	
		end)
	else
		TheInput:AddKeyDownHandler(Key, function()
			if self.inst == ThePlayer then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, Key)
				end
			end	
		end)
	end
end

return KeyHandler_Klee