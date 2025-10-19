
-- definicao do elemento head // HEAD CLASS
local head = {	region = {},
			descriptor = {},
			connectorBase = {},
			rule = {},
			transition = {}
		}	

function head:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	--headElem = o
	if (o:analyse()) then
		return o
	end
end

-- o head nao contem nenhum elemento obrigatorio, mas se existir algum elemento declarado nele
-- entao verifica-se se este elemento esta declarado corretamente.
function head:analyse()
	--print("Analysing head...")
	if (#self > 0) then
		-- itera sobre os elementos declarodos em head
		for i,elem in pairs(self) do
			count  = false
			-- itera sobre o modelo do elemento head
			for k,v in pairs(head) do
				-- testa so as tabelas
				if (type(v) ~= "function") then
					-- se o tipo do elemento declarado for igual a algum no modelo, esta correto.
					-- se o elemento nao estiver no modelo, o contador continua falso pois ele nao deveria estar em head
					if (elem:getType() == k) then
						count = true
					end
					--print(i, elem:getType(), k)
				end
			end
			-- se count eh falso, significa que o elemento nao pertence a head
			if (count == false) then
				print("Erro na definição do elemento HEAD: O tipo ".. elem.getType().. " não é permitido.")
				return false
			end
			--print(count)
		end
	end
	table.insert(headElem,self)
	--print("AAQUIIIIIIIIIIIIIIIII",#headElem)
	return true
end

function head:print()
	-- body
	--head:analyse()
end

function head:getType()
	return "head"
end


return head
--++++++++++++++++++++++++++++++++++++++++++++++