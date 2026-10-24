local priorityqueue = require("priorityqueue")

-- the customer class created earlier
local customer = require("examples.customer")

-- database of customers by
-- the order of arrival
local customers = {
    customer.new(50, "John", 1),
    customer.new(70, "Lisa", 4),
    customer.new(95, "Justin", 4),
    customer.new(70, "Bob", 25),
    customer.new(50, "Alice", 1),
    customer.new(10, "Mary", 60),
    customer.new(25, "Mark", 70)
}

local tickets = priorityqueue()

-- create the tickers by arrival
for _, c in ipairs(customers) do
    tickets:enqueue(c, c:score())
end

-- clearing the tickets
while (tickets.count > 0) do
    -- get the next customer
    local c, priority = tickets:dequeue()

    assert(priority == c:score(), "Unexpected customer priority")

    -- print the customer name and priority
    print(("%s has priority (%d)"):format(c:name(), priority))
end

-- Mary has priority (10)
-- Mark has priority (25)
-- John has priority (50)
-- Alice has priority (50)
-- Lisa has priority (70)
-- Bob has priority (70)
-- Justin has priority (95)
