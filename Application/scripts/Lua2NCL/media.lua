-- Definicao do elemento media // MEDIA CLASS
local media = {	id = "",
			src = "", 
			descriptor = "",
			type = "",
			refer = "",
			instance = "",
			property = "",
			area = ""
		}

function media:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function media:getType()
	return "media"
end

-- validacao sintatica da tabela media. Verifica se os atributos estao corretos.
function media:analyse()

	--print("Analysing MEDIA..")
	-- verifica se existe id definido
	if (self.id ~= "") then
		--verifica se o id ja existe no documento
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

		-- verifica se ha src ou type, se nao houver apenas imprime sugestao
		if (self.src == "" and self.type == "") then
			print("Erro na definição do elemento MEDIA: O elemento deve possuir os atributos src ou type")
			return false
		end

		-- verifica se o descriptor apontado existe
		auxFlag = false
		if (self.descriptor ~= "") then
			for k,elem in pairs(headElem) do
				if (elem:getType() == "descriptor") then
					if (self.descriptor == elem.id) then
						auxFlag = true
					end
				end
			end
			
			if (auxFlag == false) then
				print("Erro na definição do elemento MEDIA: o descriptor referenciado não está definido")
				return false
			end
		end
		
		--print("MEDIA OK")
		table.insert(body, self)
		return true
	else
		print("Erro na definição do elemento MEDIA: id não definido")
		return false
	end

end

-- imprime a estrutura ncl da media
function media:print()	

	local flag = false
	local attrName, attrExtra = {},{}
	local str = "<media "

	for attr,value in pairs(self) do
		if (type(value) == "string") then
			str = str .. attr:lower() .. "=\"" .. value .. "\"" .. " "
		else
			if (value:getType() == "property" or value:getType() == "area") then
				flag = true
				table.insert(attrName,value:getType())
				table.insert(attrExtra,value)
			end
		end
	end
	
	if (#attrName > 0) then
		str = str .. ">\n"
		for i=1,(#attrName),1 do
			str = str .. "\t\t\t<"..attrName[i].." "
			for n,v in pairs(attrExtra[i]) do
				str = str..n.."=\""..v.. "\"" .. " "
			end
			str = str .. "/>\n"
		end
		str = str .."\t\t</media>\n"
	else
		str = str .. "/>\n"
	end
	return (str)
	
end

return media
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++ 