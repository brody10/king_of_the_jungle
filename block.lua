Block = Class{}

BLOCK_SPEED = 90

function Block:init(type)
    BlockOne = love.graphics.newImage('graphics/blockOne.png')
    BlockTwo = love.graphics.newImage('graphics/blockTwo.png')
    --BlockThree = love.graphics.newImage('graphics/blockThreeO.png')
    BlockWidth = BlockOne:getWidth()
    BlockHeight = BlockOne:getHeight()

    self.type = type
    self.x = VIRTUAL_WIDTH
    self.y = ((map.mapHeight / 2 - 2) * BlockHeight) 
    
    if type ~= 1 then
        self.y = self.y - BlockHeight
        
    end

end

function Block:update(dt)
    self.x = self.x - BLOCK_SPEED * dt
end

function Block:render()

    if self.type == 1 then
        love.graphics.draw(BlockOne, self.x, self.y)
    elseif self.type == 2 then
        love.graphics.draw(BlockTwo, self.x, self.y)
    end    
end