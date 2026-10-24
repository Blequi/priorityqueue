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
