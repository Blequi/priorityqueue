# priorityqueue

[![Coverage Status](https://coveralls.io/repos/github/Blequi/priorityqueue/badge.svg)](https://coveralls.io/github/Blequi/priorityqueue)

## Overview

Priority Queue is a data structure whose elements are ordered by priority. Elements sharing the same priority are maintained in a queue obeying a FIFO behavior (first in, first out).

> [!NOTE]
> 
> By default, this module uses an **ascending** order in the priority of elements.

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
    * [Ascending Order](#ascending-order)
    * [Descending Order](#descending-order)
* [Properties](#properties)
    * [count](#count)
    * [version](#version)
* [Methods](#methods)
    * [clear](#clear)
    * [dequeue](#dequeue)
    * [empty](#empty)
    * [enqueue](#enqueue)
    * [iterator](#iterator)
    * [peek](#peek)
* [Unit Tests](#unit-tests)
* [Code Coverage](#code-coverage)

## Installation

* If you have [LuaRocks](https://luarocks.org/) installed and configured on your machine, then run the command

    ```bash
    luarocks install priorityqueue
    ```

* Another possibility is to copy the file [priorityqueue.lua](./priorityqueue.lua) to any location covered by `LUA_PATH` environment variable and `require("priorityqueue")` it.

> [!IMPORTANT]
>
> If you choose to install out of LuaRocks, you also need to install both [queue](https://github.com/Blequi/queue) (&ge; `0.0.2`) and [binarytree](https://github.com/Blequi/binarytree)  (&ge; `0.0.3`). `queue` and `binarytree` are two runtime dependencies of **priorityqueue**.

## Usage

In the following, assume a healthcare system that upon arrival, each customer is triaged in such a way to collect information (`name`, `age`). By the end, a health `score` is assigned to the customer with a numeric value such that lower values mean a fragile health state. This hypothetic system could have a `customer` class (see [here](./examples/customer.lua))

```lua
local customer = {}
customer.__index = customer

function customer:score()
    return self._score
end

function customer:name()
    return self._name
end

function customer:age()
    return self._age
end

function customer.new(score, name, age)
    assert(type(score) == "number" and score > 0,
        "`score' is expected to be a positive number.")
    assert(type(name) == "string" and #name > 1,
        "`name' is expected to be a string longer than one character")
    assert(type(age) == "number" and age > 0,
        "`age' is expected to be a positive number")

    local instance = setmetatable({
        _score = score,
        _name = name,
        _age = age,
    }, customer)
    instance.__index = instance
    return instance
end

return customer
```

### Ascending Order

In such hypothetic system using the previous `customer` class, we could use a priority queue for support tickets (see [here](./examples/asc/tickets.lua)) in ascending order by `score` as follows:

```lua
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
```

### Descending Order

We are going to proceed the hypothetic system using the `customer` class. This time, we could use a priority queue for support tickets (see [here](./examples/desc/tickets.lua)) following a descending order by `age`:

```lua
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
```

## Properties

### count

* *Description*: the number of elements in the priority queue
* *Signature*: `count`
    * *return (integer)*
* *Example*:

    ```lua
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
    ```

### version

* *Description*: the version of this library
* *Signature*: `version`
    * *return (string)*
* *Example*:

    ```lua
    -- loading the module
    local priorityqueue = require("priorityqueue")

    -- creating a priorityqueue instance
    local pq = priorityqueue()

    -- print the library version
    print(pq.version)
    ```

## Methods

### clear

* *Description*: removes all the elements from the priority queue
* *Signature*: `clear()`
    * *return (void)*
* *Example*:

    ```lua
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
    ```

### dequeue

* *Description*: pops the first element from the priority queue
* *Signature*: `dequeue()`
    * *return (object, object)*
* *Example*:

    ```lua
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
    ```

### empty

* *Description*: verifies the absence of elements in the priority queue
* *Signature*: `empty()`
    * *return (boolean)*
* *Example*:

    ```lua
    -- loading the module
    local priorityqueue = require("priorityqueue")

    -- creating a priority queue instance
    local pq = priorityqueue()

    print(pq:empty()) -- prints true

    -- adding elements to it
    pq:enqueue("Bob", 10)
    pq:enqueue("Lisa", 1)

    print(pq:empty()) -- prints false
    ```

### enqueue

* *Description*: pushes an element into the priority queue
* *Signature*: `enqueue(value, priority)`
    * *value (object)*: element to push into the priority queue
    * *priority (object)*: priority of the element to push into the priority queue (ideally a number, but could be any comparable object like a string)
    * *return (void)*
* *Example*:

    ```lua
    -- loading the module
    local priorityqueue = require("priorityqueue")

    -- creating a priority queue instance
    local pq = priorityqueue()

    -- adding elements to it
    pq:enqueue("Bob", 10)
    pq:enqueue("Lisa", 1)

    print(pq.count) -- 2 will be printed
    ```

### iterator

* *Description*: iterates the priority queue
* *Signature*: `iterator()`
    * *return (function)*
* *Example*:

    ```lua
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
    ```

### peek

* *Description*: peeks an element from the first position in the priority queue, but does not remove it
* *Signature*: `peek()`
    * *return (object, object)*
* *Example*:

    ```lua
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
    ```

## Unit Tests

In order to run the unit tests, you need [busted](https://github.com/lunarmodules/busted) (a test library). To install `busted`, run

```bash
luarocks install busted
```

After ```busted``` installation, open a terminal (or command prompt) in the **priorityqueue** directory and run:

```bash
lua test.lua
```

## Code Coverage

Since *priorityqueue* is a tiny library, one primary goal is the achievement of high code coverage running unit tests.

In order to run the code coverage on tests, you need ```busted``` library and also [luacov](https://github.com/lunarmodules/luacov). To install `luacov`, run

```bash
luarocks install luacov
```

1. After `luacov` installation, open a terminal (or command prompt) in the **priorityqueue** directory and run the following command to generate code coverage statistics (`luacov.stats.out`)

    ```bash
    lua -lluacov test.lua
    ```

2. Once the statistics file was created, run `luacov` to generate the final report (`luacov.report.out`):

    ```bash
    luacov
    ```

3. Open the report (`luacov.report.out`) on your preferred text editor.
