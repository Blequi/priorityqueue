-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priority queue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)
pq:enqueue("Lisa", 1)

-- iterating elements
for pos, value, priority in pq:iterator() do
    -- pos holds the element's position in the queue
    -- value holds the element's value
    -- priority holds the element's priority
    print(pos, value, priority)
end
