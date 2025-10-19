-- definicao do elemento transition // transition CLASS
local transition = {	id = "",
			type = "", 
			subtype = "", 
			dur = "", 
			startProgress = "", 
			endProgress = "", 
			direction = "",
			fadeColor = "", 
			horRepeat = "",
			vertRepeat = "",
			borderWidth = "",
			borderColor = ""
		 }

function transition:new(o)
	o = o or {}
	setmetatable(o,transition)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function transition:getType()
	return "transition"
end

-- transition precisa ter pelo menos o id, os outros atributos sao opcionais
function transition:analyse()

	--print("Analysing transition...")
	if (self.id ~= "") then
		if (self.type ~= "") then
			-- itera sobre os elementos definidos na regiao
			for attr,value in pairs(self) do
				count = false
				--print(attr, value)
				-- itera sobre o modelo de transition
				for k,v in pairs(transition) do
					-- testa apenas com as tabelas (atributos) do modelo
					if (type(v) ~= "function") then
						if (attr == k) then
							count = true
						end
					end
				end
				-- se count eh falso, significa que o elemento nao pertence a transition
				if (count == false) then
					print("Erro na definição do elemento transition: O atributo ".. attr.. " não é permitido.")
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
						print("Erro na definição do elemento transition: O valor do id ".. self.id .." ja existe")
						return false
					end
				end
				table.insert(ids,self.id)
			end
			table.insert(headElem,self)
			--print("transition....OK")
			return true
		else
			print("Erro na definição do elemento transition: type não definido")
			return false	
		end
	else
		print("Erro na definição do elemento transition: id não definido")
		return false
	end
end

-- imprime a estrutura ncl de uma transition
function transition:print()
	
		local str = "<transition "
		for attr,value in pairs(self) do
			str = str .. attr .. "=\"" .. value .. "\"" .. " "
		end
		str = str .. "/>\n"
		return (str)
	
end

return transition
--++++++++++++++++++++++++++++++++++++++++++++++