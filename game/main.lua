local duck = require("duck")
local powerUp = require("PowerUp")



_scoreImage = love.graphics.newImage("assets/scoreImage.png")



_screenWidth = love.graphics.getWidth()
_screenHeight = love.graphics.getHeight()

love.mouse.setVisible(false)

_backgroundImage = love.graphics.newImage("assets/background.png")

---------------------BASE FUNCTION-------------------------
function love.load()
    game_state = 0



    _font = love.graphics.newFont("assets/gamer.ttf", 35)
    love.graphics.setFont(_font)


    Load_Menu()
    Load_Game()

end

function love.draw()
    if game_state == 0 then
        Draw_Menu()
    else
        Draw_Game()
    end
end

function love.update(dt)
    if game_state == 0 then
        Update_Menu(dt)
    else
        Update_Game(dt)
    end
end
---------------------------------------------------------


---------------------------------------------------------------------MENU_FUNCTION--------------------------------------------------------------------------
function Load_Menu()

    Load_Crosshair()

    _menuBackground = love.graphics.newImage("assets/menuBg.jpg")
    _buttonImage = love.graphics.newImage("assets/button.png")
    
    _buttonWidht = _buttonImage:getWidth()
    _buttonHeight = _buttonImage:getHeight()

    _buttonX = 320
    _buttonY = 380
end

function Draw_Menu()
    love.graphics.draw(_menuBackground)
    love.graphics.draw(_buttonImage, _buttonX, _buttonY)

    Draw_Crosshair()
end

function Update_Menu(dt)

    _mouseX = love.mouse.getX()
    _mouseY = love.mouse.getY()
    

    if love.mouse.isDown(1) then 
        if checkCollision(_mouseX, _mouseY, _buttonX, _buttonY, _buttonWidht, _buttonHeight) then
            game_state = 1
        end
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------GAME_FUNCTION--------------------------------------------------------------------------
function Load_Game()

    _timer = 60
    
    _score = 0
    
    _maxBullet = 10
    _currentBullet = 0

    _currentBullet = _maxBullet + 1


    Load_BackGround()
    Load_Crosshair()
    Load_Timer()    

end

function Draw_Game()

    Draw_BackGround()

    -- calling in the duck classe
    drawDuck()
    drawPowerUp()
    
    Draw_Crosshair()
    Draw_Timer()

    love.graphics.draw(_scoreImage, 640, 530)
    love.graphics.print(_score, 680, 530)
    
    love.graphics.print("SCORE", 720, 550)

    love.graphics.print(_currentBullet .. "/" .. _maxBullet, 650, 550)
end

function Update_Game(dt)
    Update_Timer(dt)

    -- calling in the duck classe
    updateDuck(dt)
    updatePowerUp(dt)

    _mouseX = love.mouse.getX()
    _mouseY = love.mouse.getY()
    
end

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
        _currentBullet = _currentBullet - 1
        for i, duckInstance in ipairs(duck.duckList) do

            if checkCollision(x, y, duckInstance.x, duckInstance.y, duckInstance.width, duckInstance.height) then
                
                print("duck hit")
                createPowerUp()
                duckInstance:gotHit()
                table.remove(duck.duckList, i) -- remove duck form the list    
                break
            
            else
                _score = _score - 475
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

-------------------------------------------------------------------------------------------------------------------------------------------



