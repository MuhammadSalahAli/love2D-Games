Pipe = Class{}

PIPE_IMAGE = love.graphics.newImage('assets/pipe.png')


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 54
    self.y = y

    self.orientation = orientation

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT
end

function Pipe:update(dt)
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y ), 0, 1, (self.orientation == 'top' and -1 or 1))
end
