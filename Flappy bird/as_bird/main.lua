WINDOW_WIDTH = 1285 
WINDOW_HEIGHT = 720
 
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 288

background = love.graphics.newImage('assets/background.png')
background_scroll = 0
background_speed = 30
background_looping_point = 413

ground = love.graphics.newImage('assets/ground.png')
ground_scroll = 0
ground_speed = 60
ground_looping_point = 500

PAUSE = false

push = require('push')
Class = require('class')

require('Bird')
require('Pipe')
require('PairPipe')

require('StateMachine'  )
require('states/BaseState')
require('states/PlayState')
require('states/TitleScreenState')
require('states/ScoreState')
require('states/CountdownState')
--[[
    Load
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('assets/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/flappy.ttf', 32)
    flappyFont = love.graphics.newFont('assets/flappy.ttf', 40)
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable=true,
        fullscreen=false,
        vsync=true
    })

    sounds = {
        ['marios_way']=love.audio.newSource('audio/marios_way.mp3','static'),
        ['explosion']=love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt']=love.audio.newSource('audio/hurt.wav', 'static'),
        ['jump']=love.audio.newSource('audio/jump.wav', 'static'),
        ['score']=love.audio.newSource('audio/score.wav', 'static'),
    }

    gStateMachine = StateMachine{
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['title'] = function() return TitleScreenState() end,
        ['count'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

    sounds['marios_way']:setLooping(true)
    sounds['marios_way']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'p' then
        if PAUSE == true then
            PAUSE = false
        else
            PAUSE = true
        end
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Update
]]
function love.update(dt)
    if not PAUSE then

    background_scroll = (background_scroll + background_speed * dt)%
    background_looping_point
    ground_scroll = (ground_scroll + ground_speed * dt)%
    ground_looping_point

    gStateMachine:update(dt)
    end   
    love.keyboard.keysPressed = {}
end

--[[
    Render
]]
function love.draw()
    push:start()

    love.graphics.draw(background, -background_scroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -ground_scroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
