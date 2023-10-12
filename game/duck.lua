
local duckList = {}
local delay = 1




function createDuck()


    local duck = {}


    duck.image = love.graphics.newImage("assets/duck.png")

    duck.width = duck.image:getWidth()
    duck.height = duck.image:getHeight()

    duck.despawnDelay = 10.0

    duck.value = 500

    duck.x = math.random(0, love.graphics.getWidth() - duck.width)
    duck.y = 500
    duck.x_velocity, duck.y_velocity = 1, -1

    duck.speed = math.random( 130, 200)

    duck.isFacingLeft = false  

    duck.draw = function()
        local scaleX = duck.isFacingLeft and -1 or 1
        love.graphics.draw(duck.image, duck.x, duck.y, 0, scaleX, 1, scaleX == -1 and duck.width or 0, 0)
    end

    duck.movement = function(dt)
        if duck.x >= love.graphics.getWidth() - duck.width then
            duck.x = love.graphics.getWidth() - duck.width - 1
            duck.x_velocity = -duck.x_velocity
            duck.isFacingLeft = true
        elseif duck.x <= 0 then
            duck.x = 1
            duck.x_velocity = -duck.x_velocity
            duck.isFacingLeft = false
        end

        if duck.y >= love.graphics.getHeight() - duck.height then
            duck.y = love.graphics.getHeight() - duck.height - 1
            duck.y_velocity = -duck.y_velocity
        elseif duck.y <= 0 then
            duck.y = 1
            duck.y_velocity = -duck.y_velocity
        end

        duck.x = duck.x  + duck.x_velocity * duck.speed * dt
        duck.y = duck.y  + duck.y_velocity * duck.speed * dt
    end

    duck.gotHit = function()
        _score = _score + duck.value
    end

    table.insert( duckList, duck);
end

function drawDuck()
    for i = 1, #duckList, 1 do
        duckList[i].draw()
    end
end

function updateDuck(dt)
    
    for i = 1, #duckList, 1 do
        duckList[i].movement(dt)
    end

    -- removing the duck from the screen after the delay hit 0
    for i = #duckList, 1, -1 do
        duckList[i].despawnDelay = duckList[i].despawnDelay - dt

        if duckList[i].despawnDelay <= 0.0 then
            table.remove( duckList, i )
        end
    end

    -- spawning a new duck everytime the delay hit 0
    delay = delay - dt

    if delay <= 0.0 then
        createDuck()
        delay = math.random( 2, 3 )
    end
end

return {duckList = duckList}
