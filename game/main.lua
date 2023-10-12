local duck = require("duck")

_score = 0

_font = love.graphics.newFont("assets/gamer.ttf", 35)

_scoreImage = love.graphics.newImage("assets/scoreImage.png")

_screenWidth = love.graphics.getWidth()
_screenHeight = love.graphics.getHeight()

love.mouse.setVisible(false)


---------------------BASE FUNCTION-------------------------
function love.load()
    love.graphics.setFont(_font)


    Load_BackGround()
    Load_Crosshair()
    Load_Timer()    

end

function love.draw()

    Draw_BackGround()
    -- calling in the duck classe
    drawDuck()

    Draw_Crosshair()
    Draw_Timer()

    love.graphics.draw(_scoreImage, 640, 530)
    love.graphics.print(_score, 680, 530)
    
    love.graphics.print("SCORE", 720, 550)
end

function love.update(dt)
    Update_Timer(dt)

    -- calling in the duck classe
    updateDuck(dt)

    _mouseX = love.mouse.getX()
    _mouseY = love.mouse.getY()
end
---------------------------------------------------------




-------------------BACKGROUND----------------------------
function Load_BackGround()
    _backgroundImage = love.graphics.newImage("assets/background.png")
end

function Draw_BackGround()
    love.graphics.draw(_backgroundImage)
end
---------------------------------------------------------

---------------------COLLISON DETECTION------------------
function love.mousepressed(x, y, button, istouch, presses)

    if button == 1 then -- Checks if left mouse button is pressed.

        for i, duckInstance in ipairs(duck.duckList) do

            if checkCollision(x, y, duckInstance.x, duckInstance.y, duckInstance.width, duckInstance.height) then
                
                print("duck hit")
                duckInstance:gotHit()
                table.remove(duck.duckList, i) -- remove duck form the list    
                break
                
            end
        end
    end
end

function checkCollision(mx, my, x, y, width, height)
    return mx > x and mx < x + width and my > y and my < y + height
end
---------------------------------------------------------



-------------------TIMER---------------------------------
function Load_Timer()
    _timer = 60
end

function Draw_Timer()
    love.graphics.print("Time: " .. math.ceil( _timer ), 350, 0)
end

function Update_Timer(dt)
    _timer = _timer - dt
end
---------------------------------------------------------





-------------------CROSSHAIR-----------------------------
function Load_Crosshair()
    _crosshairImage = love.graphics.newImage("assets/crosshair.png")
    _crosshairWidth = _crosshairImage:getWidth()
    _crosshairHeight = _crosshairImage:getHeight()
    _crosshairX = 100
    _crosshairY = 100
end

function Draw_Crosshair()
    love.graphics.draw(_crosshairImage, _mouseX - (_crosshairWidth/2), _mouseY - (_crosshairHeight/2))
end
--------------------------------------------------------
