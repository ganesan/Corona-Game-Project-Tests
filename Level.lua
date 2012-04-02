-- Module implementation

module(..., package.seeall)  

-- include the Corona "storyboard" module to go next level when unlocked
storyboard = require "storyboard"

--****************************************************--
--
-- Initialization of Parameters for our Level class
-- levelSpeed -> fast: 3, normal:2, slow: 1
--
--****************************************************--

Level = {initTime = 60, textObj, textTimeOver, textStar, starsQty = 0, timeSpeed = 1000, levelSpeed = 2, levelBG={}, nextLvlLock = "true"} 


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


--**********************************************************************************************************************************--
--
-- setTimeSpeed(timeSpeed) -> Method to assign a custom value to the speed of the timer for the level(if its not defined it will be 1000ms by default) 
-- @timeSpeed -> use a positive integer to represent the speed of the timer for the level
--
--**********************************************************************************************************************************--

function Level:setTimeSpeed(timeSpeed)           

	self.timeSpeed = timeSpeed

end

--**********************************************************************************************************************************--


--**********************************************************************************************************************************--
--
-- getTimeSpeed() -> Method to get the current custom value of the initial time of the level(if its not defined it will be 1000ms by default) 
-- @return -> returns the integer value with the speed of the timer
--
--**********************************************************************************************************************************--

function Level:getTimeSpeed()           

	return self.timeSpeed

end

--**********************************************************************************************************************************--


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
	    if (self.initTime>=0) then
			self.textObj.text = "Time: "..self.initTime
			self.initTime = self.initTime - 1
			print(self.initTime)
	    elseif (self.initTime < 0) then
			self.textTimeOver.text = "Time is Over!"						  -- debuggin purposes only
			self:setStars_Qty(self.starsQty+1)
			self.textStar.text = "Stars: "..self:getStars_Qty()
		end
	end
	
	timer.performWithDelay(self.timeSpeed, listener, self.initTime+2) 
	
	timeGroup:insert( self.textObj )
	timeGroup:insert( self.textTimeOver )									  -- debuggin purposes only
	timeGroup:insert( self.textStar )
	
	return timeGroup
end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- timerRun(textW) -> Method to run a timed event, it goes from "initTime" value to 0
-- @textW -> text that displays the count down, in order to update it each second we get it here and send it back as a display group
-- @return -> display group with the interface text updating each second
--
--*************************************************************************************************************--

function Level:timerRun(textW)
		
	local timeGroup = display.newGroup()
	
	self.textTimeOver = display.newText("", 160, 160, native.SystemFont, 20)    -- debuggin purposes only 
	self.textTimeOver:setReferencePoint(display.CenterLeftReferencePoint)
	self.textTimeOver:setTextColor(255, 255, 255)
	
	local function listener( event )
	    if (self.initTime >= 0) then
			textW.text = "Time: "..self.initTime
			print(self.initTime) 											  -- debuggin
			self.initTime = self.initTime - 1
	    elseif (self.initTime < 0) then
			self.textTimeOver.text = "Time is Over!"						  -- debuggin purposes only
			self:setStars_Qty(self.starsQty+1)
			self.textStar.text = "Stars: "..self:getStars_Qty()
			timer.cancel( event.source )
			if (self:getStars_Qty() > 0) then								-- debuggin level unlock
				self.nextLvlLock = "false"
				timer.performWithDelay(1000,self:unlockLevel(2),1)			
			end
		end
	end
	
	timer.performWithDelay(self.timeSpeed, listener, self.initTime+2) 
	
	timeGroup:insert( self.textTimeOver )									  -- debuggin purposes only
	timeGroup:insert(textW)	
	
	return timeGroup

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
		self.textStar.x = 400
		self.textStar.y = 20
	
	return starsGroup

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- generateLevel_bg() -> Method to generate random level backgrounds
-- @lvl -> level set to use
-- @return -> levelBG_Group display object with the level backgroundss
--
--*************************************************************************************************************--

function Level:generateLevel_bg(lvl)

	local levelBG_Group = display.newGroup()

local levelBG = {	
					{
					"levelBG/lvl1_bg1.png",
					"levelBG/lvl1_bg2.png",
					"levelBG/lvl1_bg3.png"
					},
					{
					"levelBG/lvl2_bg1.png",
					"levelBG/lvl2_bg2.png",
					"levelBG/lvl2_bg3.png"
					}						
				}
	
	local rnd_BG = math.random(1, 3)
	
	local bg1 = display.newImage(levelBG[lvl][rnd_BG], 0, 0)
	
	levelBG_Group:insert(bg1)
	
	return levelBG_Group

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- checkLock() -> Method to check if the next level is locked or not in order to be able to play it or restart this one
-- @lvl -> 
-- @return -> 
--
--*************************************************************************************************************--

function Level:checkLock() 

	return self.nextLvlLock

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- unlockLevel() -> Method to unlock and save the state of level unlocked
-- @lvl -> 
-- @return -> 
--
--*************************************************************************************************************--

function Level:unlockLevel(lvl) 

	local gotolvl = "test"..lvl
	storyboard.gotoScene(gotolvl)

end
