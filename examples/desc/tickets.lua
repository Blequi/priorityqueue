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

local function descending_comparer(a, b)
    return b - a
end

local tickets = priorityqueue(descending_comparer)

-- create the tickers by arrival
for _, c in ipairs(customers) do
    tickets:enqueue(c, c:age())
end

-- clearing the tickets
while (tickets.count > 0) do
    -- get the next customer
    local c, priority = tickets:dequeue()

    assert(priority == c:age(), "Unexpected customer priority")

    -- print the customer name and priority
    print(("%s has priority (%d)"):format(c:name(), priority))
end
