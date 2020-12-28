Player = Class{}



require 'Util'

local WALKING_SPEED = 100
local JUMP_VELOCITY = 255

function Player:init(map)

    floorHeight = (map.mapHeight / 2 - 3.2) * 16

    self.x = 50
    self.y = floorHeight
    self.width = 26
    self.height = 39

    self.gravity = 15

    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    -- reference to map for checking tiles
    self.map = map
    --self.texture = love.graphics.newImage('graphics/monkeySmallT.png')
    self.texture = love.graphics.newImage('graphics/UpdatedMonkeySpriteSheet609.png')

    self.sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    }

    self.frames = {}

    -- current animation frame
    self.currentFrame = nil

    self.state = 'idle'

    self.jumpsLeft = 2

    -- x and y velocity
    self.dx = 0
    self.dy = 0

    self.animations = {
        ['idle'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(80, 0, 20, 41, self.texture:getDimensions()),
                love.graphics.newQuad(0, 0, 28, 41, self.texture:getDimensions())
            },
            interval = 0.25
        }),

        ['colliding'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(80, 0, 20, 41, self.texture:getDimensions())
            }
        }),

        ['jumping'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(28, 0, 25, 41, self.texture:getDimensions()),
                love.graphics.newQuad(53, 0, 27, 41, self.texture:getDimensions())
            },
            interval = 0.15
        }),
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviors = {
        ['idle'] = function(dt)
            if self.dx ~= -90 then
                self.animation = self.animations['idle']
            else
                self.animation = self.animations['colliding']
            end

            -- add spacebar functionality to trigger jump state
            if love.keyboard.wasPressed('space') then
                if self.jumpsLeft > 0 then
                    self.jumpsLeft = self.jumpsLeft - 1
                    self.state = 'jumping'
                    self.sounds['jump']:play()
                    self.dy = -JUMP_VELOCITY
                end
            else
                self.dy = 0
            end
        end,

        ['jumping'] = function(dt)
            self.animation = self.animations['jumping']
            
            if love.keyboard.wasPressed('space') then
                if self.jumpsLeft == 1 then
                    self.jumpsLeft = 0
                    self.sounds['jump']:play()
                    self.dy = -JUMP_VELOCITY
                end
            end
            -- apply map's gravity before y velocity
            self.dy = self.dy + self.gravity
            self.dx = 0
        end,
    }
end

function Player:update(dt)

    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()

    -- apply velocity
    self.y = self.y + self.dy * dt

    self.x = self.x + self.dx * dt

    if self.y >= floorHeight then
        self.y = floorHeight
        self.dy = 0
        self.state = 'idle'
        self.jumpsLeft = 2
    end

end

function Player:IsBlockCollide(blockX, blockWidth, blockY)
    blockStart = blockX
    blockEnd  = blockX + blockWidth

    monkeyStart = self.x
    monkeyEnd = self.x + self.width

    blockTop = blockY

    monkeyBottom = self.y + self.height


    if monkeyEnd >= blockStart and monkeyEnd <= blockEnd and monkeyBottom > blockTop then
        self.dx = -90
    end

    if ((monkeyEnd >= blockStart and monkeyEnd <= blockEnd) or
       (monkeyStart >= blockStart and monkeyStart <= blockEnd)) and monkeyBottom < blockTop then
        self.dx = 0
    end

    if (self.y < floorHeight) and ((monkeyEnd >= blockStart and monkeyEnd <= blockEnd) or
       (monkeyStart >= blockStart and monkeyStart <= blockEnd)) then
        if monkeyBottom >= blockTop then
            self.y = blockTop - self.height
            self.dy = 0
        end
    end

end

function Player:IsDead()
    return (self.x < -self.width)
end

function Player:render()
    --rotate, scaleX, scaleY, move origin point to center
    love.graphics.draw(self.texture, self.currentFrame,
        math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, 1, 1, self.xOffset, self.yOffset)
end

