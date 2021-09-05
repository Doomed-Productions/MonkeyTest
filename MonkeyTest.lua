require "Classifier"

local separator = "------------------------------------------------------"

---@class MonkeyTest : Class
---@field name string
---@field test fun()[]
---@field before fun()
---@field after fun()
local monkeytest = class()
monkeytest:declare{
    name="test suite",
    tests = {},
    output=io.output(),
    before = function() end,
    after = function() end
}

---Sets the default before function
---@param func fun()
function monkeytest:_before(func)
    self.before = func
end

---Sets the default after function
---@param func fun()
function monkeytest:_after(func)
    self.before = func
end

---Adds a given function to the list of tests
---@param name string
---@param test fun()
function monkeytest:_test(name, test)
    self.tests[name] = test
end

---Runs a full test
---@param test fun()
function monkeytest:runTest(test)
    local instance = {}
    self.before(instance)
    test(instance)
    self.after(instance)
end

---Runs all the tests
function monkeytest:run()
    self.output:write("Welcome to MonkeyTest ! Let's play with your functions" .. "\n")
    self.output:write("Running Test Suite : "..self.name .. "\n")
    self.output:write(separator .. "\n")
    self.output:write(separator .. "\n")
    local testrunResults = ""
    for k, v in pairs(self.tests) do
        self.output:write("RUNNING TEST "..k .. "\n")
        local result, error = pcall(self.runTest, self, v)
        if result then
            testrunResults = testrunResults .. "."
            self.output:write("\27[32mPASSED\27[0m" .. "\n")
        else
            testrunResults = testrunResults .. "\27[31mF\27[0m"
            self.output:write("\27[31mFAILED\27[0m" .. "\n")
            self.output:write(error .. "\n")
        end
        self.output:write(separator .. "\n")
    end
    self.output:write(testrunResults .. "\n")
end

---Tests if the given subject equals true
---@param subject boolean
function monkeytest.assertTrue(subject)
    if not subject then
        error("assertTrue failed on: ".. tostring(subject), 2)
    end
end

---Tests if the given subject equals the given target
---@param subject table
---@param target table
function monkeytest.assertTableEquals(subject, target)
    -- TODO table equality
    if not subject == target then
        error("assertTableEquals failed.", 2)
    end
end

return monkeytest