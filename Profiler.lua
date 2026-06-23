local MR = MapRadar

-- ==================================================================================================
-- Lightweight profiler for RegisterForUpdate callbacks.
--
-- GetGameTimeMilliseconds() has ~1ms resolution, so a single fast call often reads 0. We accumulate
-- across all calls between resets and report total CPU-ms. When reset on a 1000ms cadence (see the
-- InvokeAnalyzer reader), totalMs reads directly as milliseconds-of-CPU-per-second (frame budget cost).

local profiles = {} -- name -> { calls, totalMs, maxMs }

local function getOrCreate(name)
    local p = profiles[name]
    if p == nil then
        p = { calls = 0, totalMs = 0, maxMs = 0 }
        profiles[name] = p
    end
    return p
end

-- Wraps fn so each invocation records its duration under the given name.
-- Returns the wrapped function to pass to RegisterForUpdate.
function MapRadar.Profile(name, fn)
    getOrCreate(name)
    return function(...)
        local p = profiles[name]
        local t0 = GetGameTimeMilliseconds()
        fn(...)
        local dt = GetGameTimeMilliseconds() - t0
        p.calls = p.calls + 1
        p.totalMs = p.totalMs + dt
        if dt > p.maxMs then
            p.maxMs = dt
        end
    end
end

function MapRadar.GetProfile(name)
    return profiles[name]
end

function MapRadar.ResetProfile(name)
    local p = profiles[name]
    if p ~= nil then
        p.calls = 0
        p.totalMs = 0
        p.maxMs = 0
    end
end

-- Formats a profile for display: total CPU-ms per second (reset cadence handled by the reader).
function MapRadar.FormatProfile(name)
    local p = profiles[name]
    if p == nil then
        return "-"
    end
    return string.format("%d", p.totalMs)
end
