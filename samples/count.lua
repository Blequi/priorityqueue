-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priorityqueue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)

print(pq.count) -- 1 will show up

-- adding elements to it
pq:enqueue("Lisa", 1)

print(pq.count) -- 2 will show up
