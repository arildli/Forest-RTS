
print('\nLoading...')

-- Module loading
local errorCount = 0

function loadModule(name)
	local status, err = pcall(function()
		-- Load the module
		require(name)
	end)

	if not status then
		-- Increase errorCount
		errorCount = errorCount + 1

		-- Inform the user
		print('WARNING: '..name..' failed to load!')
		print(err)
	end
end


loadModule('SimpleRTS')

-- The rest of the modules will be loaded inside 'SimpleRTS' as these requires the
-- game mode to be set.


