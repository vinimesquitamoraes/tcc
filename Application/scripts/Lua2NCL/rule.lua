-- definicao do elemento rule // rule CLASS
local rule = {	id = "",
				var = "",
				comparator = "",
				value = ""
		 }

function rule:new(o)
	o = o or {}
	setmetatable(o,rule)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function rule:getType()
	return "rule"
end

-- rule precisa ter pelo menos o id, os outros atributos sao opcionais
function rule:analyse()

	--print("Analysing rule...
	if (self.id ~= "") then
		if((self.var~="")and(self.comparator~="")and(self.value~="")) then
			
			-- itera sobre os elementos definidos na regiao
			for attr,value in pairs(self) do
				count = false
				--print(attr, value)
				-- itera sobre o modelo de rule
				for k,v in pairs(rule) do
					-- testa apenas com as tabelas (atributos) do modelo
					if (type(v) ~= "function") then
						if (attr == k) then
							count = true
						end
					end
				end
				-- se count eh falso, significa que o elemento nao pertence a rule
				if (count == false) then
					print("Erro na definição do elemento rule: O atributo ".. attr.. " não é permitido.")
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
						print("Erro na definição do elemento rule: O valor do id ".. self.id .." ja existe")
						return false
					end
				end
				table.insert(ids,self.id)
			end
			table.insert(headElem,self)
			--print("rule....OK")
			return true
		else
			print("Erro na definição do elemento rule: falta algum elemento válido!!! (var,comparator or value)")
		end
	else
		print("Erro na definição do elemento rule: id não definido")
		return false
	end
end

-- imprime a estrutura ncl de uma rule
function rule:print()
	
		local str = "<rule "
		for attr,value in pairs(self) do
			str = str .. attr .. "=\"" .. value .. "\"" .. " "
		end
		str = str .. "/>\n"
		return (str)
	
end

return rule
--++++++++++++++++++++++++++++++++++++++++++++++