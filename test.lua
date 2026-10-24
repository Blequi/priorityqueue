require("busted.runner")()

describe("priorityqueue module", function()
    local priorityqueue
    setup(function()
        priorityqueue = require("priorityqueue")
    end)

    it("should be of type function", function()
        assert.are.equals("function", type(priorityqueue))
    end)

    it("should throw exception trying to set fields in the objects", function()
        local pq = priorityqueue()
        for _, v in ipairs({1, -2.1, "str", function() end, coroutine.create(function() end), {}}) do
            assert.has_error(function() pq.field = v end)
            assert.has_error(function() pq.count = v end)
        end
    end)

    describe("constructor", function()
        describe("should create a (table) instance", function()
            it("without any arguments", function()
                assert.are.equals("table", type(priorityqueue()))
            end)
            it("once a comparer function is provided", function()
                assert.are.equals("table", type(priorityqueue(function(a, b) return b - a end)))
            end)
        end)
        it("should throw exception when comparer argument is not of type nil or function", function()
            for _, t in ipairs({1, -2.1, "str", coroutine.create(function() end), {}}) do
                assert.has_error(function() priorityqueue(t) end)
            end
        end)
    end)

    describe("count property", function()
        it("should be readonly", function()
            local pq = priorityqueue()
            assert.has_error(function() pq.count = 1 end)
            pq:enqueue("obj", 1)
            assert.has_error(function() pq.count = 50 end)
        end)
        it("should be 0 on empty queues", function()
            local pq = priorityqueue()
            assert.are.equals(0, pq.count)
            pq:enqueue("obj", 1)
            pq:clear()
            assert.are.equals(0, pq.count)
        end)
        it("should increment 1 after enqueue", function()
            local pq = priorityqueue()
            assert.are.equals(0, pq.count)
            pq:enqueue("obj", 1)
            assert.are.equals(1, pq.count)
            pq:enqueue("obj2", 12)
            assert.are.equals(2, pq.count)
            pq:enqueue("obj3", 12)
            pq:enqueue("obj4", 0)
            pq:enqueue("obj5", -1)
            assert.are.equals(5, pq.count)
            pq:enqueue("obj6", 0)
            assert.are.equals(6, pq.count)
        end)
        it("should decrement 1 after dequeue", function()
            local pq = priorityqueue()
            pq:enqueue("obj", 1)
            pq:enqueue("obj2", 12)
            pq:enqueue("obj3", 12)
            pq:enqueue("obj4", 0)
            pq:enqueue("obj5", -1)
            pq:enqueue("obj6", 0)
            assert.are.equals(6, pq.count)
            pq:dequeue()
            assert.are.equals(5, pq.count)
            pq:dequeue()
            assert.are.equals(4, pq.count)
            pq:dequeue()
            pq:dequeue()
            pq:dequeue()
            assert.are.equals(1, pq.count)
            pq:dequeue()
            assert.are.equals(0, pq.count)
        end)
    end)

    describe("clear method", function()
        it("should set count to 0", function()
            local pq = priorityqueue()
            pq:enqueue("obj", 1)
            pq:clear()
            assert.are.equals(0, pq.count)
            pq:enqueue("obj1", 1)
            pq:enqueue("obj2", 10)
            pq:enqueue("obj3", 1)
            pq:clear()
            assert.are.equals(0, pq.count)
        end)
        it("should not iterate on any elements", function()
            local pq = priorityqueue()
            pq:enqueue("obj", 1)
            pq:clear()
            for i, v, p in pq:iterator() do
                error("unexpected element after clearing.")
            end
            pq:enqueue("obj1", 1)
            pq:enqueue("obj2", 10)
            pq:enqueue("obj3", 1)
            pq:clear()
            for i, v, p in pq:iterator() do
                error("unexpected element after clearing.")
            end
        end)
    end)

    describe("dequeue method", function()
        it("should throw exception on empty queues", function()
            local pq = priorityqueue()
            assert.has_error(function() return pq:dequeue() end)
            pq:enqueue("obj", 1)
            pq:clear()
            assert.has_error(function() return pq:dequeue() end)
        end)
        it("should return the element with lowest priority of a list", function()
            local list = {
                {p = 1, d = 'T'},
                {p = 3, d = 'O' },
                {p = 2, d = 'N' },
                {p = 2, d = 'I'},
                {p = 1, d = '<SPACE>'},
                {p = 1, d = 'M'},
                {p = 2, d = 'R'},
                {p = 2, d = 'S'},
                {p = 1, d = '<EOF>'}
            }

            local pq = priorityqueue()

            for i, node in ipairs(list) do
                pq:enqueue(node.d, node.p)
            end

            local v, p
            v, p = pq:dequeue()
            assert.are.equals('T', v)
            assert.are.equals(1, p)
            v, p = pq:dequeue()
            assert.are.equals('<SPACE>', v)
            assert.are.equals(1, p)
            v, p = pq:dequeue()
            assert.are.equals('M', v)
            assert.are.equals(1, p)
            v, p = pq:dequeue()
            assert.are.equals('<EOF>', v)
            assert.are.equals(1, p)
            v, p = pq:dequeue()
            assert.are.equals('N', v)
            assert.are.equals(2, p)
            v, p = pq:dequeue()
            assert.are.equals('I', v)
            assert.are.equals(2, p)
            v, p = pq:dequeue()
            assert.are.equals('R', v)
            assert.are.equals(2, p)
            v, p = pq:dequeue()
            assert.are.equals('S', v)
            assert.are.equals(2, p)
            v, p = pq:dequeue()
            assert.are.equals('O', v)
            assert.are.equals(3, p)
        end)
    end)

    describe("empty method", function()
        it("should return false for priority queues containing any elements", function()
            local pq = priorityqueue()
            pq:enqueue("obj", 1)
            assert.False(pq:empty())
            pq:enqueue("obj2", 10)
            assert.False(pq:empty())
            pq:enqueue("obj3", 1)
            assert.False(pq:empty())
        end)
        it("should return true for priority queues without elements", function()
            local pq = priorityqueue()
            assert.True(pq:empty())
            pq:enqueue("obj", 1)
            pq:clear()
            assert.True(pq:empty())
        end)
    end)

    describe("enqueue method", function()
        it("should throw exception when priority is nil", function()
            local pq = priorityqueue()
            assert.has_error(function()
                pq:enqueue("obj")
            end)
        end)
    end)

    describe("iterate method", function()
        describe("using descending comparer", function()
            it("should match a predefined table", function()
                local list = {
                    {p = 1, d = 'T'},
                    {p = 3, d = 'O' },
                    {p = 2, d = 'N' },
                    {p = 2, d = 'I'},
                    {p = 1, d = '<SPACE>'},
                    {p = 1, d = 'M'},
                    {p = 2, d = 'R'},
                    {p = 2, d = 'S'},
                    {p = 1, d = '<EOF>'}
                }

                local pq = priorityqueue(function(a, b) return b - a end)

                for i, node in ipairs(list) do
                    pq:enqueue(node.d, node.p)
                end

                local correct_order = {}

                local function insert_element(index)
                    table.insert(correct_order, list[index])
                end

                insert_element(2)
                insert_element(3)
                insert_element(4)
                insert_element(7)
                insert_element(8)
                insert_element(1)
                insert_element(5)
                insert_element(6)
                insert_element(9)

                for i, v, p in pq:iterator() do
                    local item = correct_order[i]
                    assert.are.equals(v, item.d)
                    assert.are.equals(p, item.p)
                end
            end)
        end)

        it("should match a predefined table", function()
            local list = {
                {p = 1, d = 'T'},
                {p = 3, d = 'O' },
                {p = 2, d = 'N' },
                {p = 2, d = 'I'},
                {p = 1, d = '<SPACE>'},
                {p = 1, d = 'M'},
                {p = 2, d = 'R'},
                {p = 2, d = 'S'},
                {p = 1, d = '<EOF>'}
            }

            local pq = priorityqueue()

            for i, node in ipairs(list) do
                pq:enqueue(node.d, node.p)
            end

            local correct_order = {}

            local function insert_element(index)
                table.insert(correct_order, list[index])
            end

            insert_element(1)
            insert_element(5)
            insert_element(6)
            insert_element(9)
            insert_element(3)
            insert_element(4)
            insert_element(7)
            insert_element(8)
            insert_element(2)

            for i, v, p in pq:iterator() do
                local item = correct_order[i]
                assert.are.equals(v, item.d)
                assert.are.equals(p, item.p)
            end
        end)
    end)

    it("should match a predefined table", function()
        local list = {
            {p = 1, d = 'T'},
            {p = 3, d = 'O' },
            {p = 2, d = 'N' },
            {p = 2, d = 'I'},
            {p = 1, d = '<SPACE>'},
            {p = 1, d = 'M'},
            {p = 2, d = 'R'},
            {p = 2, d = 'S'},
            {p = 1, d = '<EOF>'}
        }

        local pq = priorityqueue()

        for i, node in ipairs(list) do
            pq:enqueue(node.d, node.p)
        end

        local function assert_element(index)
            local value, priority = pq:dequeue()
            assert(priority == list[index].p, "Priority mismatch")
            assert(value    == list[index].d, "Value mismatch")
        end

        assert_element(1)
        assert_element(5)
        assert_element(6)
        assert_element(9)
        assert_element(3)
        assert_element(4)
        assert_element(7)
        assert_element(8)
        assert_element(2)
    end)

    it("should match a predefined table using a descending comparer", function()
        local list = {
            {p = 1, d = 'T'},
            {p = 3, d = 'O' },
            {p = 2, d = 'N' },
            {p = 2, d = 'I'},
            {p = 1, d = '<SPACE>'},
            {p = 1, d = 'M'},
            {p = 2, d = 'R'},
            {p = 2, d = 'S'},
            {p = 1, d = '<EOF>'}
        }


        local pq = priorityqueue(function(a, b) return b - a end)

        for i, node in ipairs(list) do
            pq:enqueue(node.d, node.p)
        end

        local function assert_element(index)
            local value, priority = pq:dequeue()
            assert(priority == list[index].p, "Priority mismatch")
            assert(value    == list[index].d, "Value mismatch")
        end

        assert_element(2)
        assert_element(3)
        assert_element(4)
        assert_element(7)
        assert_element(8)
        assert_element(1)
        assert_element(5)
        assert_element(6)
        assert_element(9)
    end)

    describe("peek method", function()
        it("should throw exception on empty queues", function()
            local pq = priorityqueue()
            assert.has_error(function() pq:peek() end)
            pq:enqueue("obj", 1)
            pq:clear()
            assert.has_error(function() pq:peek() end)
        end)
        it("should peek the lowest priority element", function()
            local pq = priorityqueue()
            pq:enqueue("obj", 1)
            local v, p
            v, p = pq:peek()
            assert.are.equals("obj", v)
            assert.are.equals(1, p)
            pq:enqueue("obj2", 10)
            v, p = pq:peek()
            assert.are.equals("obj", v)
            assert.are.equals(1, p)
            pq:enqueue("obj3", 1)
            v, p = pq:peek()
            assert.are.equals("obj", v)
            assert.are.equals(1, p)
            pq:enqueue("obj4", 0)
            v, p = pq:peek()
            assert.are.equals("obj4", v)
            assert.are.equals(0, p)
        end)
    end)

    describe("version property", function()
        it("should be of type string", function()
            local pq = priorityqueue()
            assert.are.equals("string", type(pq.version))
        end)

        it("should be readonly", function()
            local pq = priorityqueue()
            assert.has_error(function() pq.version = 2 end)
        end)
    end)
end)
