PairPipe = Class{}

local GAP_HEIGHT = math.random(70, 90)

function PairPipe:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.scored = false
    self.y = y

    self.pipes = {
        ['top'] = Pipe('top', y),
        ['bottom'] = Pipe('bottom', y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false
end

function PairPipe:update(dt)
    GAP_HEIGHT = math.random(70, 90)

    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['bottom'].x = self.x
        self.pipes['top'].x = self.x
    else
        self.remove = true
    end
end

function PairPipe:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
