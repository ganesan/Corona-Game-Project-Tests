-----------------------------------------------------------------------------------------
--
-- test.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

-- include Corona's "widget" library (menu interface, buttons, scrollviews and that kind of stuff)
local widget = require "widget"

-- including the module for the "class" level
local Level = require("Level")
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	local test_level = Level.Level:new()  -- Creating an instance of Level
	
	local testing = test_level:initLevel(10, 2, 0, 1, 1)


	print("Total Time: "..test_level:getTime())
	print("Stars: "..test_level:getStars_Qty())
	print("Level Speed: "..test_level:getLevelSpeed())
	print("Timer Speed: "..test_level:getTimeSpeed().."ms")
	--display.getInfo("textureMemoryUsed")
	
	physics.setDrawMode( "hybrid" )

	group:insert( testing )	-- inserting elements into the group of the scene,  (note-self: must insert .view property for widgets)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	package.loaded[physics] = nil
	physics = nil
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene