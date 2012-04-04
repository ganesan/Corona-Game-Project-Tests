-- Module implementation

module(..., package.seeall)  

require "sprite"

--****************************************************--
--
-- Initialization of Parameters for our Level class
-- levelSpeed -> fast: 3, normal:2, slow: 1
--
--****************************************************--

local Player = require("Player")
local player = Player.Player:new()

Level = {result = nil, gametime = nil, initTime = 60, textObj, textTimeOver, textStar, starsQty = 0, timeSpeed = 1000, levelSpeed = 2, pauseTime = 5000, levelBG={{"levelBG/lvl1_bg1.png", "levelBG/lvl1_bg2.png"},	{"levelBG/lvl2_bg1.png", "levelBG/lvl2_bg2.png"}}, levelFloor={{"levelBG/lvl1_grd1.png", "levelBG/lvl1_grd2.png"},	{"levelBG/lvl2_grd1.png", "levelBG/lvl2_grd2.png"}}, nextLvlLock = "true",  halfW = display.contentWidth*0.5} 

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
--
-- setLevelSpeed(levelSpeed) -> Method to assign a custom value to the speed of the level(if its not defined it will be 2 by default) 
-- @timeSpeed -> integer to represent the speed of the level
--
--**********************************************************************************************************************************--

function Level:setLevelSpeed(levelSpeed)           

	self.levelSpeed = levelSpeed

	if (self.levelSpeed==1) then
		self.timeSpeed = 1500
	elseif (self.levelSpeed==2) then
		self.timeSpeed = 1000
	elseif (self.levelSpeed==3) then
		self.timeSpeed = 500
	elseif (self.levelSpeed==0) then
		self.timeSpeed = 0
	end
	
end

--**********************************************************************************************************************************--


--**********************************************************************************************************************************--
--
-- getTimeSpeed() -> Method to get the current custom value of the speed level(if its not defined it will be 2 by default) 
-- @return -> returns the integer value with the speed of the level
--
--**********************************************************************************************************************************--

function Level:getLevelSpeed()           

	return self.levelSpeed

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
-- timerRun(textW) -> Method to run a timed event, it goes from "initTime" value to 0 and shows it off on screen
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
	gametime = timer.performWithDelay(self.timeSpeed, listener, self.initTime+2) 
	
	timeGroup:insert( self.textTimeOver )									  -- debuggin purposes only
	timeGroup:insert(textW)	
	
	return timeGroup

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- startTimer() -> Method to run a timed event, it goes from "initTime" value to 0
--
--*************************************************************************************************************--

function Level:startTimer()

	local function listener( event )
	    if (self.initTime >= 0) then
			print(self.initTime) 											  -- debuggin
			self.initTime = self.initTime - 1 								
	    elseif (self.initTime < 0) then
	    	print("time is over!")											  -- debuggin
			timer.cancel( event.source )
			player:pauses()
		end
	end
	gametime = timer.performWithDelay(self.timeSpeed, listener, self.initTime+2) 

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
-- getBGSet() -> Method to get the set for the level backgrounds                      
-- @lvl -> level set to use
-- @return -> lvlBG_Group Array with the set of backgrounds to use
--
--*************************************************************************************************************--

function Level:getBGSet(lvl)

	local levelBG_Group = {}
	
	for key, value in pairs(self.levelBG[lvl]) do 
		table.insert(levelBG_Group, value)
	end
	
	return levelBG_Group
	
end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- getFloorSet() -> Method to get the set for the floor tile                 
-- @lvl -> level set to use
-- @return -> lvlFloor_Group Array with the set of backgrounds to use
--
--*************************************************************************************************************--

function Level:getFloorSet(lvl)

	local levelFloor_Group = {}
	
	for key, value in pairs(self.levelFloor[lvl]) do 
		table.insert(levelFloor_Group, value)
	end
	
	return levelFloor_Group
	
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

	--local gotolvl = lvl
	local gotolvl = "test"..lvl  --remove
	storyboard.gotoScene(gotolvl)

end

--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- createLevel() -> Method to create the Level with its animation (camera moving)                   ------WORK ON THIS (2 sequencial images as it is now, should be 3? or 2 is ok?)
-- @
-- @
--
--*************************************************************************************************************--

function Level:createLevel(lvlset, floorset)

	local levelBGSet = self:getBGSet(lvlset)
	local levelFloorSet = self:getFloorSet(floorset)
	
	local lbg1 = levelBGSet[1]
	local lbg2 = levelBGSet[2]
	
	local lgrd1 = levelFloorSet[1]
	local lgrd2 = levelFloorSet[2]
	
	local levelGroup = display.newGroup()
 

	local myRectangle = display.newRect(330, 240, 150, 50)
	myRectangle.rotation = -15
	myRectangle.strokeWidth = 2
	myRectangle:setFillColor(140, 140, 140)
	myRectangle:setStrokeColor(180, 180, 180)


	local bg1 = display.newImage( lbg1, 0, 0 ); -- place bg1 at the origin
	local bg2 = display.newImage( lbg2, bg1.x + (bg1.width * 1.5), 0); -- place bg2 right after bg1

	local grass1 = display.newImage( lgrd1, 0, 244 )
	local grass2 = display.newImage( lgrd2, grass1.x + (grass1.width*1.5), 244 )

	local moveBG = function(event)
	   if (self.initTime>=0) then
		   bg1:translate(self.levelSpeed*-2, 0); -- move bg1 bgSpeed on the x plane
		   bg2:translate(self.levelSpeed*-2, 0); -- move bg2 bgSpeed on the x plane
		   grass1:translate(self.levelSpeed*-2, 0);
		   grass2:translate(self.levelSpeed*-2, 0);
		   myRectangle:translate(self.levelSpeed*-2, 0)
		   
		   
		   if ((bg1.x + bg1.width / 2) < display.contentWidth and (bg1.x + bg1.width / 2) > 0) then
			  bg2.x = bg1.x + bg1.width;
			  grass2.x = grass1.x + grass1.width;
		   elseif((bg2.x + bg2.width / 2) < display.contentWidth and (bg2.x + bg2.width / 2) > 0) then
			  bg1.x = bg2.x + bg2.width;
			  grass1.x = grass2.x + grass2.width;
		   end
	   end
	end
	
	Runtime:addEventListener("enterFrame", moveBG);
	
	local groundShape = { -self.halfW,-21, self.halfW,-21, self.halfW,21, -self.halfW,21 }
	
	--local obstacleShape = { 0, 41, 0,81, 200,80, 200,80 }

	physics.addBody( grass1, "static", { friction=1.0, density=1.0, bounce=0, shape=groundShape } )
	physics.addBody( grass2, "static", { friction=1.0, density=1.0, bounce=0, shape=groundShape } )
	physics.addBody( myRectangle, "static", { friction=0.5, density=1.0, bounce=0.1, shape=obstacleShape } )
	
	levelGroup:insert( bg1 )
	levelGroup:insert( bg2 )
	levelGroup:insert( grass1 )
	levelGroup:insert( grass2 )
	levelGroup:insert( myRectangle )

	return levelGroup
	
end


--*************************************************************************************************************--


--*************************************************************************************************************--
--
-- initLevel() -> 
-- @
-- @
-- @
-- @
-- @
--
--*************************************************************************************************************--

function Level:initLevel( lvltime, lvlspeed, lvlstars, lvlbgset, lvlgrdset )
	local displaylvl = display.newGroup()

		self:setTime(lvltime)
		self:setLevelSpeed(lvlspeed)
		self:setStars_Qty(lvlstars)

		self:startTimer()
		local player_created = player:spawn_player()

		displaylvl:insert(self:createLevel(lvlbgset, lvlgrdset))
		displaylvl:insert(player_created)

	return displaylvl
end

--*************************************************************************************************************--