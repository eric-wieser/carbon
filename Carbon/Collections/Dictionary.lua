--[[
	Carbon for Lua
	#class Collections.Dictionary
	#inherits OOP.Object, Serializable

	#description {
		Provides a set of utilities to operate on dictionary structures.

		Most methods here are intended to be called as both OOP-style methods and on pure data objects.
	}

	#alias List Collections.List
	#alias Set Collections.Set
]]

local Carbon, self = ...
local List = Carbon.Collections.List
local Set = Carbon.Collections.Set

local Dictionary = {}

Dictionary.__object_metatable = {
	__index = Dictionary
}

Dictionary.Is = {
	[Dictionary] = true
}

local indexables = {
	["table"] = true,
	["userdata"] = true
}

local function indexable(item)
	local t = type(item)
	if (t == "table") then
		return true, t
	elseif (t == "userdata") then
		local meta = getmetatable(item)
		return meta and not not meta.__index, t
	end

	return false, t
end

--[[#method {
	!!public Dictionary Dictionary:New([table data])
		!!optional data: The data of the dictionary. Empty if not specified.

	Turns the given object into a Dictionary.
	Allows method-style syntax to be used on the object.
}]]
function Dictionary:New(object)
	return setmetatable(object or {}, self.__object_metatable)
end

function Dictionary:Serialize()
	return nil, Carbon.Exceptions.NotImplementedException("Dictionary:Serialize")
end

function Dictionary.DeserializeInPlace(source)
	return self.Deserialize(source, self)
end

function Dictionary.Deserialize(source, out)
	return nil, Carbon.Exceptions.NotImplementedException("Dictionary:Deserialize")
end

--[[#method {
	!!public @List Dictionary.Keys(table self)
		!!required self: The table to retrieve keys for.

	Returns all the keys in the table.
}]]
function Dictionary.Keys(self)
	local keys = List:New({})

	for key in pairs(self) do
		table.insert(keys, key)
	end

	return keys
end

--[[#method {
	!!public @List Dictionary.Values(table self)
		!!required self: The table to retrieve values for.

	Returns all the values in the table in a @List
}]]
function Dictionary.Values(self)
	local values = List:New({})

	for key, value in pairs(self) do
		table.insert(values, value)
	end

	return values
end

--[[#method {
	!!public @Set Dictionary.ToSet(table self, [table out])
		!!required self: The table to convert to a set.
		!!optional out: Where to put the resulting set. Defaults to a new set.

	Converts the Dictionary to a @Set.
}]]
function Dictionary.ToSet(self, out)
	out = out or Set:New({})

	for key, value in pairs(self) do
		out[key] = not not value
	end

	return values
end

--[[#method {
	!!public table Dictionary.ShallowCopy(table self, [table to])
		!!required self: The table to source data from
		!!optional to: The table to copy into; an empty table if not given.

	Shallow copies data from one table into another and returns the result.
}]]
function Dictionary.ShallowCopy(self, to)
	to = to or Dictionary:New()

	for key, value in pairs(self) do
		to[key] = value
	end

	return to
end

Dictionary.Copy = ShallowCopy

--[[#method {
	!!public Dictionary Dictionary.DeepCopy(table self, [table to, bool datawise, table map])
		!!required self: The dictionary to source data from.
		!!optional to: The dictionary to copy into; an empty table if not given.
		!!optional datawise: Whether the copy should ignore Copy member functions.
		!!internal map: A map projecting original values into copied values.

	Performs a self-reference fixing deep copy from one table into another.
	Handles self-references properly.
}]]
function Dictionary.DeepCopy(self, to, datawise, map)
	to = to or Dictionary:New()
	map = map or {
		[self] = to
	}

	for key, value in pairs(self) do
		local i, t = indexable(value)
		if (i) then
			if (not map[value]) then
				local copy = (not datawise) and value.Copy or value.DeepCopy or value.ShallowCopy

				if (copy) then
					map[value] = copy(value)
				elseif (t == "table") then
					map[value] = {}
					Dictionary.DeepCopy(value, map[value], datawise, map)
				end
			end

			to[key] = map[value]
		else
			to[key] = value
		end
	end

	return to
end

--[[#method {
	!!public table Dictionary.ShallowMerge(table self, table to)
		!!required self: The table to source data from.
		!!required to: The table to output into.

	Performs a merge into a table without overwriting existing keys.
}]]
function Dictionary.ShallowMerge(self, to)
	for key, value in pairs(self) do
		if (to[key] == nil) then
			to[key] = value
		end
	end

	return to
end

--[[#method {
	!!public table Dictionary.DeepCopyMerge(table self, table to)
		!!required self: The table to source data from.
		!!required to: The table to put data into.

	Performs a merge into the table, performing a deep copy on all table members.
}]]
function Dictionary.DeepCopyMerge(self, to)
	for key, value in pairs(self) do
		if (to[key] == nil) then
			if (type(value) == "table") then
				to[key] = Dictionary.DeepCopy(value)
			else
				to[key] = value
			end
		end
	end

	return to
end

Carbon.Metadata:RegisterMethods(Dictionary, self)

return Dictionary