-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priority queue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)

print(pq.count) -- prints 1

local v1, p1 = pq:peek() -- v1 holds "Bob", p1 holds 10

print(pq.count) -- peek does not remove elements, so 1 is still printed
print(v1) -- prints "Bob"

-- adding more elements
pq:enqueue("Lisa", 20)

print(pq.count) -- prints 2

local v2, p2 = pq:peek() -- v2 still holds "Bob" and p2 holds 10, because elements were not removed

print(pq.count) -- peek does not remove elements, so 2 is still printed
print(v2) -- prints "Bob"
