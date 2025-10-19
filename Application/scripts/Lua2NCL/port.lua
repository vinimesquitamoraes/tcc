-- definicao do port // PORT CLASS
local port = {	id = "", 
			component = "",
			interface = ""
		}

function port:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function port:getType()
	return "port"
end

function port:analyse()
	-- body
	if (self.id ~= "") then
		--verifica se o id ja existe no documento
		if (#ids == 0) then
			table.insert(ids,self.id)
		elseif (#ids > 0) then
			for i=1,#ids do
				if (self.id == ids[i]) then
					print("Erro na definição do elemento PORT: O valor do id ".. self.id .." ja existe")
					return false
				end
			end
			table.insert(ids,self.id)
		end

		-- verifica se o component apontado existe e se he valido
		auxFlag = false
		if (self.component ~= "") then
			for k,elem in pairs(body) do
				if (elem:getType() == "media" or elem:getType() == "context" ) then
					if (self.component == elem.id) then
						auxFlag = true
					end
				end
			end
			
			if (auxFlag == false) then
				print("Erro na definição do elemento PORT: o component referenciado não está definido")
				return false
			end
		else
			print("Erro na definição do elemento PORT: component não definido")
			return false
		end

		table.insert(body,self)
		return true

	else
		print("Erro na definição do elemento PORT: id não definido")
		return false
	end
end

-- imprime a estrutura ncl do port
function port:print()
	local str = "<port "
	for attr,value in pairs(self) do
		str = str .. attr:lower() .. "=\"" .. value .. "\"" .. " "
	end
	str = str .. "/>\n"
	return (str)
end

return port
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++ 