WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    love.window.setTitle('Pong Game')

    --remove fade filter 
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallGameFont = love.graphics.newFont('Early_GameBoy.ttf', 8)
    largeGameFont = love.graphics.newFont('Early_GameBoy.ttf', 20)

    player1Score = 0
    player2Score = 0
    
    servingPlayer = math.random(2) == 1 and 1 or 2

    --initialize paddles
    paddle1 = Paddle(0, 20, 5, 20)
    paddle2 =  Paddle(VIRTUAL_WIDTH -5, VIRTUAL_HEIGHT - 30, 5, 20)
    ball=Ball(VIRTUAL_WIDTH/2-3, VIRTUAL_HEIGHT/2-3, 6, 6)


    if servingPlayer ==1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'

    push: setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end


function love.update(dt)

        --ball misses paddle1
        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:restart()
            ball.dx = 100
            gameState = 'serve'
        end

        --ball missespaddle2
        if ball.x > VIRTUAL_WIDTH-6 then
            player1Score = player1Score + 1
            servingPlayer =2 
            ball:restart()
            ball.dx = -100
            gameState = 'serve'
        end

        --ball hits paddle1
        if ball:collide(paddle1) then
            ball.dx = - ball.dx
        end

        --ball hits paddle2
        if ball:collide(paddle2) then
            ball.dx = - ball.dx
        end

        --ball bounces off top
        if ball.y <= 0 then
            ball.dy = - ball.dy
            ball.y = 0
        end

        --ball bounce off bottom
        if ball.y >= VIRTUAL_HEIGHT -6 then
            ball.y = - ball.y
            ball.y = VIRTUAL_HEIGHT -6
        end


        paddle1:update(dt)
        paddle2:update(dt)

        if love.keyboard.isDown('w') then
            paddle1.dy = -PADDLE_SPEED

        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        if love.keyboard.isDown('up') then
            paddle2.dy = - PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end

        if gameState == 'play' then
        ball:update(dt)
        end
    end



function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
       if gameState == 'start' then
            gameState = 'serve'
       elseif gameState == 'serve' then
        gameState = 'play'
        end
    end
end


function love.draw()
    push:apply('start')
    love.graphics.clear(30/255, 45/255, 60/255, 255/255)

    love.graphics.setFont(smallGameFont)

    if gameState == 'start' then
    love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press ENTER to play", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
    love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn", 0, 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press ENTER to serve", 0, 42, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(largeGameFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH /2+30, VIRTUAL_HEIGHT/3)
    paddle1:render()
    paddle2:render()
    ball:render()
    displayFPS()
    push:apply('end')
end


function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallGameFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end

