local automac_lib = require('automac_lib')
local M = {}

local inputs = {}
local outputs = {}
local synth_fn = nil

function M.add_input(s)
    table.insert(inputs, s)
end

function M.add_output(s)
    table.insert(outputs, s)
end

function M.synthesize()
    print("Synthesizing with inputs: " .. table.concat(inputs, ", ") .. " and outputs: " .. table.concat(outputs, ", "))
    synth_fn = automac_lib.synthesize{inputs = inputs, outputs = outputs}
end

function M.run(inp)
    if synth_fn == nil then
        error("Synthesize first")
    end
    return synth_fn(inp)
end

function M.clear()
    inputs = {}
    outputs = {}
    synth_fn = nil
end

M.automac = automac_lib

return M
