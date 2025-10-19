-- definicao do connectorBase - CONNECTOR CLASS
local connectorBase = {	documentURI = "",
				alias= ""}

function connectorBase:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if (o:analyse()) then
		return o
	end
end

function connectorBase:getType()
	return "connectorBase"
end

function connectorBase:analyse()
	--print("Analysing connectorBase...")
	if (self.documentURI ~= "") then
		if (self.alias ~= "") then
			-- itera sobre os elementos definidos no descriptor
			for attr,value in pairs(self) do
				count = false
				--print(attr, value)
				-- itera sobre o modelo de descriptor
				for k,v in pairs(connectorBase) do
					-- testa apenas com as tabelas (atributos) do modelo
					if (type(v) ~= "function") then
						if (attr == k) then
							count = true
						end
					end
				end
				-- se count eh falso, significa que o elemento nao pertence a descriptor
				if (count == false) then
					print("Erro na definição do elemento connectorBase: O atributo ".. attr.. " não é permitido.")
					return false
				end
			end

			table.insert(headElem,self)
			--print("connectorBase....OK")
			return true
		else
			print("Erro na definição do elemento connectorBase: alias não definido")
			return false
		end
	else
		print("Erro na definição do elemento connectorBase: documentURI não definido")
		return false
	end
end

function connectorBase:print()
	-- body
	return "<importBase documentURI=\""..self.documentURI.."\" ".."alias=\""..self.alias.."\"/>\n"
end

return connectorBase
--+++++++++++++++++++++++++++++++++++++++++++++++++++