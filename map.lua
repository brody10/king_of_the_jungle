Map = Class{}

require 'Util'

--somehow divide path into numbers

BOTTOM_TILE = 2
FIRST_TILE = 1
SECONDARY_TILE = 3
GREEN_TILE = 4

RED_TILE = 10

BLOCK_ONE = 13
BLOCK_TWO = 14


function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/blocksSprite.png')
    self.tileWidth = 16
    self.tileHeight = 16

    self.sprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    self.gravity = 15
    
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    --make path of blocks
    for x = 0, self.mapWidth do
        self:setTile(x, self.mapHeight / 2 + 1, BOTTOM_TILE)
        if x % 2 == 0 then
            self:setTile(x, self.mapHeight / 2, FIRST_TILE)
            self:setTile(x, self.mapHeight / 2 + 2, RED_TILE)
        else
            self:setTile(x, self.mapHeight / 2, SECONDARY_TILE)
            self:setTile(x, self.mapHeight / 2 + 2, RED_TILE)
        end
    end

    

end

function Map:update(dt)

end

function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(x, y)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    --return value from previous function
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    --wherever y is (-1 for 1 index), goes through whole row then adds y and does next row 
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= nil then
                love.graphics.draw(self.spritesheet, self.sprites[tile],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end
end
