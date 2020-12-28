if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

if arg[#arg] == "vsc_debug" then require("lldebugger").start() end
if pcall(require, "lldebugger") then require("lldebugger").start() end
if pcall(require, "mobdebug") then require("mobdebug").start() end


--TODO DAD: problem: get caught on front of block and float or if not jump brought up to block height, animations

push = require 'push'
Class = require 'class'

require 'Map'
require 'Player'
require 'Util'
require 'Block'
require 'animation'
require 'Banana'

--these need to be set better
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seed RNG
math.randomseed(os.time())

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

map = Map()
player = Player(map)

blocks = {}
bananas= {}

spawnTimer = 0
bananaCounter = 0

GameState = {
    START = 1, 
    PLAY = 2,
    GAMEOVER = 3, 
}

function love.load()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })


    love.window.setTitle('King Of The Jungle')

    love.keyboard.keysPressed = {}

    background = love.graphics.newImage('graphics/forest3_210Longer.png')

    width = background:getWidth()
    height = background:getHeight()

    backgroundOffset = 0
    BACKGROUND_SPEED = 30
    BACKGROUND_LOOP = width / 3
    
    titleScreen = love.graphics.newImage('graphics/titleScreen.png')

    gameState = GameState.START

    gameOver = love.audio.newSource('sounds/gameover2.wav', 'static')

    TopBananaPic = love.graphics.newImage('graphics/SB.png')
    
    music = love.audio.newSource('sounds/jungle.wav', 'static')
    music:setLooping(true)
    music:setVolume(0.50)
    music:play()

    timerActive = false
    timerDuration = 0
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end
    
    if gameState == GameState.START and (key == 'enter' or key =='return') then
        gameState = GameState.PLAY
        
    end
    love.keyboard.keysPressed[key] = true
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    if gameState == GameState.PLAY then

        map:update(dt)
        player:update(dt)
        
        backgroundOffset = ((backgroundOffset + (BACKGROUND_SPEED * dt)) % BACKGROUND_LOOP)
        
        spawnTimer = spawnTimer + dt
        if spawnTimer > 2 then
            value = love.math.random(30)
            if value < 15 then
                table.insert(blocks, Block(1))
            else
                table.insert(blocks, Block(2))
            end

            Newvalue = love.math.random(50)
            if Newvalue < 10 then
                table.insert(bananas, Banana(1))
            elseif Newvalue > 35 then
                table.insert(bananas, Banana(2))
            end
            spawnTimer = 0
        end

        for k, block in pairs(blocks) do 
            block:update(dt)

            if block.x < -map.tileWidth - 17 then
                table.remove(blocks, k)
            end
        end

        for k, banana in pairs(bananas) do     
            banana:update(dt)

            if banana.x < -map.tileWidth - 17 then
                table.remove(bananas, k)
            end

            if banana:BananaCollide(dt, player.x, player.y, player.height, player.width) then
                bananaCounter = bananaCounter + 1 
                table.remove(bananas, k)
            end

        end

        for k, block in pairs(blocks) do 
            player:IsBlockCollide(block.x, 16, block.y)
            
        end

        if player:IsDead() then
            timerActive = true
            gameOver:play()
            music:stop()

            gameState = GameState.GAMEOVER
        end
    elseif gameState == GameState.GAMEOVER then
        if timerActive then
            timerDuration = timerDuration + dt
            if timerDuration >= 2 then
                love.event.quit()
            end
        end      
    end

    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:start()
    
    if gameState == GameState.START then
        love.graphics.setColor(1, 1, 1, 1) --white
        love.graphics.draw(titleScreen, 0, 0, 0, .27, .22)
        ScoreFont = love.graphics.newFont('font.TTF', 8)
        love.graphics.setFont(ScoreFont)
        if math.floor(love.timer.getTime()) % 2 == 0 then   
            love.graphics.print("Press Enter To Play!", VIRTUAL_WIDTH / 2 - 45, 210)    
        end 
        
    elseif gameState == GameState.PLAY then
        love.graphics.draw(background, -backgroundOffset, 0)
        map:render()
        player:render()

        for k, block in pairs(blocks) do 
            block:render()
        end

        for k, banana in pairs(bananas) do 
            banana:render()
        end
        
    
        love.graphics.draw(TopBananaPic, VIRTUAL_WIDTH - 75, 25)  
    
        love.graphics.setColor(0, 1, 1, 1)
        smallFont = love.graphics.newFont('font.TTF', 32)
        love.graphics.setFont(smallFont)
        love.graphics.print(string.format("%02d", bananaCounter), VIRTUAL_WIDTH - 50, 20)
    elseif gameState == GameState.GAMEOVER then
            love.graphics.setColor(1, 1, 1, 1)
            ScoreFont = love.graphics.newFont('font.TTF', 50)
            love.graphics.setFont(ScoreFont)
            love.graphics.printf("Game Over!", 0, 50, VIRTUAL_WIDTH, 'center')
    end

    -- end virtual resolution
    push:finish()
end


