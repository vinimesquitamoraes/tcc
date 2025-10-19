-- Definicao do elemento property // PROPERTY CLASS

local property = {	name="",
				value="",
				externable=""
			}

function property:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function property:getType()
	return "property"
end

function property:analyse()
	
	if (self.name ~= "") then
		return true
	else
		return false
	end	
end	

function property:print()
	-- body
end

return property
--+++++++++++++++++++++++++++++++++++++++++++++++++++