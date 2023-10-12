
local powerUpList = {}

function createPowerUp()

    print("init")
    local powerUp = {}

    powerUp.image = love.graphics.newImage("assets/bullet.png")
    
    powerUp.width = powerUp.image:getWidth()
    powerUp.height = powerUp.image:getHeight()

    powerUp.despawnDelay = 10.0

    powerUp.x = math.random(0, love.graphics.getWidth() - powerUp.width)
    powerUp.y = math.random(0, love.graphics.getHeight() - powerUp.height)


    powerUp.speed = math.random( 200, 400)

    powerUp.draw = function()
        love.graphics.draw(powerUp.image, powerUp.x, powerUp.y)
    end

    powerUp.movement = function(dt)
        powerUp.y = powerUp.y - powerUp.speed
    end

    powerUp.gotCollected = function()
        _currentBullet = _currentBullet + math.random(1, 2)
    end
    
    table.insert(powerUpList, powerUp)
end

function drawPowerUp()
    for i = 1, #powerUpList, 1 do
        powerUpList[i].draw()
    end
end

function updatePowerUp(dt)
    
    for i = 1, #powerUpList, 1 do
        powerUpList[i].movement(dt)
    end

    -- removing the duck from the screen after the delay hit 0
    for i = #powerUpList, 1, -1 do
        powerUpList[i].despawnDelay = powerUpList[i].despawnDelay - dt

        if powerUpList[i].despawnDelay <= 0.0 then
            table.remove( powerUpList, i )
        end
    end

end

return {powerUpList = powerUpList}