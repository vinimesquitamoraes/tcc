-- Definicao do elemento area // AREA CLASS

local area = {	id="",
			begin="",
			['end']="",
			first="",
			last="",
			beginText="",
			endText="",
			beginPosition="",
			endPosition="",
			coords="",
			label="",
			clip=""
		}

function area:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function area:getType()
	return "area"
end

function area:analyse()
	
	if (self.id ~= "") then
		if (#ids == 0) then
			table.insert(ids,self.id)
		elseif (#ids > 0) then
			for i=1,#ids do
				if (self.id == ids[i]) then
					print("Erro na definição do elemento MEDIA: O valor do id ".. self.id .." ja existe")
					return false
				end
			end
			table.insert(ids,self.id)
		end
		return true
	else
		return false
	end	
end	

function area:print()
	-- body
end

return area
--+++++++++++++++++++++++++++++++++++++++++++++++