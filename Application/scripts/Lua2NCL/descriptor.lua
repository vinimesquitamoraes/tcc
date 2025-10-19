-- definicao do elemento descriptor // DESCRIPTOR CLASS
local descriptor = {	id = "",
				region = "",
			 	player = "",
			 	explicitDur = "",
			 	freeze = "",
			 	tranIn = "",
			 	transOut = "",
			 	moveLeft = "",
			 	moveRight = "",
			 	moveUp = "",
			 	moveDown = "",
			 	focusIndex = "",
			 	foccusBorderColor = "",
			 	focusBorderWidth = "",
			 	focusBorderTransparency = "",
			 	focusSrc = "",
			 	focusSelSr = "",
			 	selBorderColor = ""
			 }

function descriptor:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function descriptor:getType()
	return "descriptor"
end

function descriptor:analyse()
	--print("Analysing descriptor...")
	if (self.id ~= "") then
		-- itera sobre os elementos definidos no descriptor
		for attr,value in pairs(self) do
			count = false

			-- itera sobre o modelo de descriptor
			for k,v in pairs(descriptor) do
				-- testa apenas com as tabelas (atributos) do modelo
				if (type(v) ~= "function") then
					if (attr == k) then
						count = true
					end
				end
			end
			-- se count eh falso, significa que o elemento nao pertence a descriptor
			if (count == false) then
				print("Erro na definição do elemento descriptor: O atributo ".. attr.. " não é permitido.")
				return false
			end
		end

		-- verificar se o id definido ja existe
		--print(#ids)
		if (#ids == 0) then
			table.insert(ids,self.id)
		elseif (#ids > 0) then
			for i=1,#ids do
				if (self.id == ids[i]) then
					print("Erro na definição do elemento descriptor: O valor do id ".. self.id .." ja existe")
					return false
				end
			end
			table.insert(ids,self.id)
		end

		-- verifica se o region apontado existe
		auxFlag = false
		if (self.region ~= "") then
			for k,elem in pairs(headElem) do
				if (elem:getType() == "region") then
					if (self.region == elem.id) then
						auxFlag = true
					end
				end
			end

			if (auxFlag == false) then
				print("Erro na definição do elemento descriptor: o region referenciado não está definido")
				return false
			end
		end

		table.insert(headElem, self)
		--print("descriptor....OK")
		return true
		
	else
		print("Erro na definição do elemento descriptor: id não definido")
		return false
	end
end

-- imprime a estrutura ncl do descriptor
function descriptor:print()
	local str = "<descriptor "
	for attr,value in pairs(self) do
		str = str .. attr .. "=\"" .. value .. "\"" .. " "
	end
	str = str .. "/>\n"
	return (str)
end

return descriptor
--+++++++++++++++++++++++++++++++++++++++++++++++