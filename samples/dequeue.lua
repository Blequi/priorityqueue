-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priority queue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)
pq:enqueue("Lisa", 1)

-- remove "Lisa" from the queue and store on v1 variable,
-- and p1 variable contains the priority 1
local v1, p1 = pq:dequeue()

-- remove "Bob" from the queue and store on v2 variable,
-- and p2 variable contains the priority 10
local v2, p2 = pq:dequeue()

print(v1, p1) -- print "Lisa", 1
print(v2, p2) -- print "Bob", 10
