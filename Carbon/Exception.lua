--[[
	Carbon for Lua
	Exception

	Signals error conditions.

	Copyright (c) 2014 Lucien Greathouse (LPGhatguy)

	This software is provided 'as-is', without any express or implied warranty.
	In no event will the authors be held liable for any damages arising from the
	use of this software.

	Permission is granted to anyone to use this software for any purpose, including
	commercial applications, and to alter it and redistribute it freely, subject to
	the following restrictions:

	1. The origin of this software must not be misrepresented; you must not claim
	that you wrote the original software. If you use this software in a product, an
	acknowledgment in the product documentation would be appreciated but is not required.

	2. Altered source versions must be plainly marked as such, and must not be misrepresented
	as being the original software.

	3. This notice may not be removed or altered from any source distribution.
]]

local Carbon = (...)
local OOP = Carbon.OOP

local Exception = OOP:Class()
	:Metatable {
		__tostring = function(self)
			return tostring(self.Message)
		end
	}
	:Members {
		Message = "An exception occurred!"
	}

function Exception:_init(message)
	self.Message = message or self.Message
end

function Exception:Throw(level)
	error(self.Message, (level or 0) + 1)
end

return Exception