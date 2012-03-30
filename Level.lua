-- Module implementation

module(..., package.seeall)  


--****************************************************--
--
-- Initialization of Parameters for our Level class
--
--****************************************************--

Level = {initTime = 60, textObj, textTimeOver, textStar, starsQty = 0}  


--********************************************************************************************************************************************************--
--
-- Level:new(o) -> constructor in order to be able to create/simulate "instances/prototypes as called in LUA" of this "class" 
-- @url http://www.lua.org/pil/16.2.html 
-- @return o -> returned self meta object
--
--********************************************************************************************************************************************************--
 
function Level:new(o)          

	o = o or {}
	
	setmetatable(o,self)
	self.__index = self
	
	return o
	
end


--**********************************************************************************************************************************--
--
-- setTime(initTime) -> Method to assign a custom value to the initial time of the level(if its not defined it will be 60 by default) 
-- @initTime -> use a positive integer to represent the timer for the level
--
--**********************************************************************************************************************************--

function Level:setTime(initTime)           

	self.initTime = initTime

end

--**********************************************************************************************************************************--


--**********************************************************************************************************************************--
--
-- getTime() -> Method to get the current custom value of the initial time of the level(if its not defined it will be 60 by default) 
-- @return -> returns the integer value with the timer of the level
--
--**********************************************************************************************************************************--

function Level:getTime()           

	return self.initTime

end

--**********************************************************************************************************************************--


--*************************************************************************************************************--
--
-- displayTimer() -> Method to display a count down timer in the mobile device, it goes from "initTime" value to 0
-- @return -> returns a display group with the level elements
--
--*************************************************************************************************************--

function Level:displayTimer()

	local timeGroup = display.newGroup()
	
	self.textObj = display.newText("Time: 60", 0,0, native.SystemFont, 14)
	self.textObj:setTextColor(255, 255, 255)
	self.textObj:setReferencePoint(display.CenterLeftReferencePoint)
	self.textObj.x = 20
	self.textObj.y = 20
	
	self.textTimeOver = display.newText("", 160, 20, native.SystemFont, 20)    -- debuggin purposes only 
	self.textTimeOver:setTextColor(255, 255, 255)
	
	local function listener( event )
	    if (self.initTime>-1) then
			self.textObj.text = "Time: "..self.initTime
			self.initTime = self.initTime - 1
			print(self.initTime)
	    elseif (self.initTime == -1) then
			self.textTimeOver.text = "Time is Over!"						  -- debuggin purposes only
			self:setStars_Qty(self.starsQty+1)
			self.textStar.text = "Stars: "..self:getStars_Qty()
		end
	end
	
	timer.performWithDelay(500, listener, 62) 
	
	timeGroup:insert( self.textObj )
	timeGroup:insert( self.textTimeOver )									  -- debuggin purposes only
	timeGroup:insert( self.textStar )
	
	return timeGroup
end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- timerRun() -> Method to run a timed event, it goes from "initTime" value to 0
--
--*************************************************************************************************************--

function Level:timerRun()

	local function listener( event )
	    if (self.initTime>-1) then
			self.initTime = self.initTime - 1
	    elseif (self.initTime == 0) then
			
		end
	end
	
	timer.performWithDelay(500, listener, 61) 

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- setStars_Qty(qty) -> Method to set the number of actual stars gotten in the level (if not set it is 0)
-- @qty -> integer value with the quantity of stars
--
--*************************************************************************************************************--

function Level:setStars_Qty(qty)

	self.starsQty = qty

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- getStars_Qty() -> Method to get the number of actual stars gotten in the level
-- @return -> integer value with the quantity of stars
--
--*************************************************************************************************************--

function Level:getStars_Qty(qty)

	return self.starsQty

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- displayStars_Qty() -> Method to get the number of actual stars gotten in the level
-- @return -> returns a display group to display the number of stars in the screen
--
--*************************************************************************************************************--

function Level:displayStars_Qty()

	local starsGroup = display.newGroup()
	
		self.textStar = display.newText("Stars: "..self.starsQty, 0,0, native.SystemFont, 14)
		self.textStar:setTextColor(255, 0, 255)
		self.textStar:setReferencePoint(display.CenterLeftReferencePoint)
		self.textStar.x = 160
		self.textStar.y = 160
	
	return starsGroup

end

--*************************************************************************************************************--