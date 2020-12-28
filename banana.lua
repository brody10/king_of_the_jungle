Banana = Class{}

BANANA_SPEED = 90

function Banana:init(type)
    BananaPic = love.graphics.newImage('graphics/SB.png')
    BananaWidth = BananaPic:getWidth()
    BananaHeight = BananaPic:getHeight()

    self.x = VIRTUAL_WIDTH
    if type == 1 then
        self.y = ((map.mapHeight / 2 - 4) * 16) 
    else
        self.y = ((map.mapHeight / 2 - 5) * 16) 
    end

    self.bananaMusic = love.audio.newSource('sounds/coin.wav', 'static')

end

function Banana:update(dt)
    self.x = self.x - BANANA_SPEED * dt    
end

function Banana:BananaCollide(x, y, height, width)

    monkeyStart = x
    monkeyEnd = x + width

    monkeyBottom = y + height

    bananaStart = self.x 
    bananaEnd = self.y 
    bananaTop = self.y + BananaHeight 
    

    if monkeyEnd >= bananaStart and monkeyEnd <= bananaEnd and monkeyBottom >= BananaHeight then
        self.bananaMusic:play()
        return true
    end

    if monkeyEnd >= bananaStart and monkeyEnd <= bananaEnd and monkeyBottom >= BananaHeight then
        self.bananaMusic:play()
        return true

    end
end

function Banana:render()
    love.graphics.draw(BananaPic, self.x, self.y)  
end

