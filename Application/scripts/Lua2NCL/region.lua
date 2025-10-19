-- definicao do elemento region // Region CLASS
local region = {	id = "",
			left = "", 
			top = "", 
			right = "", 
			bottom = "", 
			width = "", 
			height = "",
			zIndex = "", 
			title = ""
		 }

function region:new(o)
	o = o or {}
	setmetatable(o,region)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function region:getType()
	return "region"
end

-- region precisa ter pelo menos o id, os outros atributos sao opcionais
function region:analyse()

	--print("Analysing region...")
	if (self.id ~= "") then
		
		-- itera sobre os elementos definidos na regiao
		for attr,value in pairs(self) do
			count = false
			--print(attr, value)
			-- itera sobre o modelo de region
			for k,v in pairs(region) do
				-- testa apenas com as tabelas (atributos) do modelo
				if (type(v) ~= "function") then
					if (attr == k) then
						count = true
					end
				end
			end
			-- se count eh falso, significa que o elemento nao pertence a region
			if (count == false) then
				print("Erro na definição do elemento region: O atributo ".. attr.. " não é permitido.")
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
					print("Erro na definição do elemento region: O valor do id ".. self.id .." ja existe")
					return false
				end
			end
			table.insert(ids,self.id)
		end
		table.insert(headElem,self)
		--print("region....OK")
		return true
	else
		print("Erro na definição do elemento region: id não definido")
		return false
	end
end

-- imprime a estrutura ncl de uma region
function region:print()
	
		local str = "<region "
		for attr,value in pairs(self) do
			str = str .. attr .. "=\"" .. value .. "\"" .. " "
		end
		str = str .. "/>\n"
		return (str)
	
end

return region
--++++++++++++++++++++++++++++++++++++++++++++++