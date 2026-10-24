-- loading the module
local priorityqueue = require("priorityqueue")

-- creating a priority queue instance
local pq = priorityqueue()

-- adding elements to it
pq:enqueue("Bob", 10)
pq:enqueue("Lisa", 1)
pq:enqueue("John", 1)
pq:enqueue("Olivia", 10)
pq:enqueue("Martin", 1)

-- iterating elements with priority 10
for pos, value, priority in pq:piterator(10) do
    -- pos holds the element's position among those with the same priority
    -- value holds the element's value
    -- priority holds the element's priority
    print(pos, value, priority)
end

-- This script produces
-- the following output:
--
-- 1, Bob, 10
-- 2, Olivia, 10
