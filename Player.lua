module(..., package.seeall)

require "sprite"

Player = {life=3, instance2}

function Player:new(o)

	o = o or {}
	
	setmetatable(o,self)
	self.__index = self
	
	return o
	
end

function Player:setSpriteInstance(spriteSet)
	self.instance2 = sprite.newSprite( spriteSet )
end

function Player:getSpriteInstance()
	return self.instance2
end

function Player:spawn_player()

	local playerGroup = display.newGroup()

	local sheet2 = sprite.newSpriteSheet( "playerSprites/skater.png", 40, 47 ) 

	local spriteSet2 = sprite.newSpriteSet(sheet2, 1, 2)
	sprite.add( spriteSet2, "man", 1, 2, 200, 0 ) -- 

	self:setSpriteInstance(spriteSet2)
	
	self.instance2.x = 120
	self.instance2.y = 280
	self.instance2.rotation = 0

	self.instance2:prepare("man")
	self.instance2:play()
	--
	
	-- adding physics to the dummy player
	physics.addBody( self.instance2, { density=1.0, friction=1.0, bounce=0 } )
	self.instance2.MyName="player"
	
	playerGroup:insert( self.instance2 )
	
	self:player_jump( self.instance2 )
	
	return playerGroup

end

function Player:player_jump(player)
	
	function player_jumps(event)
			player:setLinearVelocity(0, -150)
	end
	 
	Runtime:addEventListener("touch", player_jumps)

end

function Player:pauses()

	local function spriteListener( event )
    	if (event.phase == "loop") then
    		self.instance2:pause()
    	end
	end
	 
	-- Add sprite listener
	self.instance2:addEventListener( "sprite", spriteListener )

	return

end