-- The MIT License (MIT)
--
-- Copyright (c) 2026 Blequi https://github.com/Blequi/priorityqueue
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local version = "0.0.1"

local binarytree = require("binarytree")
local queue      = require("queue")

--- Definition of a node
-- of the priority queue
local node = {}
node.__index = node

function node:get_priority()
    return self._p
end

function node:get_queue()
    return self._q
end

function node:enqueue(value)
    local q = self:get_queue()
    q:enqueue(value)
end

function node:empty()
    local q = self:get_queue()
    return q:empty()
end

function node:dequeue()
    local q = self:get_queue()
    return q:dequeue()
end

function node.new(priority)
    local o = setmetatable({
        _p = priority,
        _q = queue()
    }, node)
    o.__index = o
    return o
end
-- end of node

-- Start of the priority queue
local function clear(self)
    local tree = self._t
    tree:clear()
    self.count = 0
end

local function dequeue(self)
    local count = self.count
    if (count <= 0) then
        error("The priority queue is empty.", 2)
    end
    local tree = self._t
    local first = tree:first()
    local value = first:dequeue()
    if (first:empty()) then
        assert(tree:remove(first) == 1, "Failed to remove exactly one node from the tree.")
    end
    self.count = count - 1
    return value, first:get_priority()
end

local function empty(self)
    return self.count == 0
end

local function enqueue(self, value, priority)
    if (priority == nil) then
        error("`priority' cannot be nil.", 2)
    end
    local tree = self._t
    local n = node.new(priority)
    local found, element = tree:find(n)
    if (not found) then
        element = n
        tree:add(element)
    end
    element:enqueue(value)
    self.count = self.count + 1
end

local function iterator(self)
    return coroutine.wrap(
        function()
            local tree = self._t
            local k = 1
            for i, n in tree:iterator() do
                local q = n:get_queue()
                for j, value in q:iterate() do
                    coroutine.yield(k, value, n:get_priority())
                    k = k + 1
                end
            end
        end
    )
end

local function peek(self)
    local count = self.count
    if (count <= 0) then
        error("The priority queue is empty.", 2)
    end
    local tree = self._t
    local first = tree:first()
    return first:get_queue():peek(), first:get_priority()
end

local function piterator(self, priority)
    if (priority == nil) then
        error("`priority' cannot be nil.", 2)
    end
    return coroutine.wrap(
        function()
            local tree = self._t
            local n = node.new(priority)
            local found, element = tree:find(n)
            if (found) then
                local q = element:get_queue()
                for j, value in q:iterate() do
                    coroutine.yield(j, value, priority)
                end
            end
        end
    )
end
-- end of priority queue

-- default comparer for nodes
local function default_comparer(a, b)
    local ap = a:get_priority()
    local bp = b:get_priority()
    local res = 0
    if (ap < bp) then
        res = -1
    elseif (ap > bp) then
        res = 1
    end
    return res
end

-- wrap the comparer function
-- provided by the user
local function wrapped_comparer(comparer)
    return function(a, b)
        return comparer(a:get_priority(), b:get_priority())
    end
end

local function create(comparer)
    local tcomparer = type(comparer)
    if (not (comparer == nil or tcomparer == "function")) then
        error(("bad #1 argument (function expected, but got `%s')."):format(tcomparer), 2)
    end
    local data = nil
    data = {
        -- private fields (DO NOT use them directly)
        _t = binarytree(
            comparer == nil and default_comparer or wrapped_comparer(comparer)
        ),

        -- properties
        count   = 0,
        version = version,

        -- methods
        clear     = function(self) clear(data) end,
        dequeue   = function(self) return dequeue(data) end,
        empty     = function(self) return empty(data) end,
        enqueue   = function(self, value, priority) enqueue(data, value, priority) end,
        iterator  = function(self) return iterator(data) end,
        peek      = function(self) return peek(data) end,
        piterator = function(self, priority) return piterator(data, priority) end
    }

    return setmetatable({}, {
        __index     = data,
        __newindex  = function(self, key, value)
            error("`priorityqueue' module is readonly.", 2)
        end,
        __metatable = false
    })
end

return create
