--goal: chop of spritesheet into a 4x4 grid, where each number 
--coresponds to different image

function generateQuads(atlas, tilewidth, tileheight)
    --atlas: spritesheet

    local sheetWidth = atlas:getWidth() / tilewidth
    --how many tiles wide is the sprite sheet
    local sheetHeight = atlas:getHeight() / tileheight
    --how many tiles high is the sheet

    local sheetCounter = 1
    local quads = {}
    --table which will store quads

    --iterate through sprite sheet and give each picture a number
    for y = 0, sheetHeight - 1 do 
        for x = 0, sheetWidth - 1 do 
            quads[sheetCounter] = 
                --find where new quad should start: 
                --will start off and grab the first 16 x 16 tile space as first pic
                --will go throguh x0 row 0 - 3 then move down y axis then go over it again in x1 row
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end        

    return quads
end