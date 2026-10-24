-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priorityqueue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)
pq:enqueue("Lisa", 1)

print(pq.count) -- 2 will be printed

-- clearing the priority queue
pq:clear()

print(pq.count) -- 0 will be printed
