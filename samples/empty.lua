-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priority queue instance
local pq = priorityqueue()

print(pq:empty()) -- prints true

-- adding elements to it
pq:enqueue("Bob", 10)
pq:enqueue("Lisa", 1)

print(pq:empty()) -- prints false
