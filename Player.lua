module(..., package.seeall)

require "sprite"

Player = {life=3}

function Player:new(o)

	o = o or {}
	
	setmetatable(o,self)
	self.__index = self
	
	return o
	
end

function Player:spawn_player()

	local playerGroup = display.newGroup()

	local sheet2 = sprite.newSpriteSheet( "playerSprites/skater.png", 40, 47 ) 

	local spriteSet2 = sprite.newSpriteSet(sheet2, 1, 2)
	sprite.add( spriteSet2, "man", 1, 2, 200, 0 ) -- 

	local instance2 = sprite.newSprite( spriteSet2 )
	instance2.x = 120
	instance2.y = 280

	instance2:prepare("man")
	instance2:play()
	--
	
	-- adding physics to the dummy player
	physics.addBody( instance2, { density=1.0, friction=0.3, bounce=0.3 } )
	instance2.MyName="player"
	
	playerGroup:insert( instance2 )
	
	self:player_jump( instance2 )
	
	return playerGroup

end

function Player:player_jump(player)

	----------------------
	-- Player animations
	----------------------
	
	function player_jumps(event)
			player:setLinearVelocity(0, -150)
	end
	 
	Runtime:addEventListener("touch", player_jumps)

end

function Player:remove_life()

	

end