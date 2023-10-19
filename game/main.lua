
local duck = require("duck")
local powerUp = require("PowerUp")

love.window.setTitle("DUNK HUNT")


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
    Load_GameOver()
end

function love.draw()
    if game_state == 0 then
        Draw_Menu()
    elseif game_state == 1 then
        Draw_Game()
    else 
        Draw_GameOver()
    end
end

function love.update(dt)
    if game_state == 0 then
        Update_Menu(dt)
    elseif game_state == 1 then
        Update_Game(dt)
    else
        Update_GameOver()
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

    _currentBullet = _maxBullet


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
    
    
    -- making sure the score dosent go below 0
    if _score < 0 then
        _score = 0
    end

    -- making sure the bullet dosent go below max bullet or below 0
    if _currentBullet > _maxBullet then
        _currentBullet = _maxBullet
    elseif _currentBullet < 0 then
        _currentBullet = 0
        game_state = 2
    end

    -- checking if mouse is over a powerUP
    for i, powerUpInstances in pairs(powerUp.powerUpList) do

        if checkCollision(_mouseX, _mouseY, powerUpInstances.x, powerUpInstances.y, powerUpInstances.width, powerUpInstances.height) then
            print("powerUp hit")
            powerUpInstances:gotCollected()
            table.remove( powerUp.powerUpList, i )
            break

        end
    end
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

    if button == 1 then -- Checks if left mouse button is pressed


        -- making sure we only use bullet when in game

        if game_state == 1 then
            _currentBullet = _currentBullet - 1
        end




        for i, duckInstance in ipairs(duck.duckList) do

            if checkCollision(x, y, duckInstance.x, duckInstance.y, duckInstance.width, duckInstance.height)  and _currentBullet > 0 then
                
                print("duck hit")
                createPowerUp()
                duckInstance:gotHit()
                break
            
            else
                if _score > 0 then
                    _score = _score - 475
                end
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

    if _timer <= 0 then
        game_state = 2
    end
    
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

-------------------------------------------GAMEOVER_MENU------------------------------------------------------------------------------------------------
function Load_GameOver()
    _GameOverBG = love.graphics.newImage("assets/gameoverBg.png")
    _GObuttonImage = love.graphics.newImage("assets/button.png")
    
    _GObuttonWidht = _buttonImage:getWidth()
    _GObuttonHeight = _buttonImage:getHeight()

    _GObuttonX = 320
    _GObuttonY = 380
end

function Draw_GameOver()
    love.graphics.draw(_GameOverBG)
    love.graphics.draw(_GObuttonImage, _GObuttonX, _GObuttonY)

    Draw_Crosshair()

end

function Update_GameOver()
    _mouseX = love.mouse.getX()
    _mouseY = love.mouse.getY()
    

    if love.mouse.isDown(1) then 
        if checkCollision(_mouseX, _mouseY, _GObuttonX, _GObuttonY, _GObuttonWidht, _GObuttonHeight) then
            game_state = 1
        end
    end
end


-------------------------------------------------------------------------------------------------------------------------------------------


