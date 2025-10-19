-- Definicao do link // LINK CLASS 
local link = {when = {}, ["do"]= {}}

function link:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	table.insert(links,o)
	return o
end


-- function verify(elo)
-- 	str = elo
-- 	local sentence = {
-- 		'full';
-- 		full = lpeg.V'begin' * lpeg.V'object' * (lpeg.V'complement'^0) *lpeg.P'do' * lpeg.V'space' * lpeg.V'reaction' * lpeg.P'end',
-- 		begin = lpeg.P'when' * lpeg.V'space',
-- 		object = lpeg.V'name' * lpeg.P'.' * lpeg.V'action' * lpeg.V'space',
-- 		action = lpeg.R'az'^1,
-- 		complement = lpeg.P'with' * lpeg.V'space' * lpeg.V'key' * lpeg.V'space',
-- 		key = lpeg.C( (lpeg.R'AZ') * ((lpeg.R'AZ' + lpeg.P'_')^0) ),
-- 		reaction = ((lpeg.P'and' * lpeg.V'space')^0 * ((lpeg.V'object')^1) * lpeg.V'space')^1,
-- 		space = (lpeg.S'\n \t\r\f')^0,
-- 		name = lpeg.C( (lpeg.R'AZ' + lpeg.R'az') * ((lpeg.R'AZ' + lpeg.R'az' + lpeg.R'09' + lpeg.P'_')^0) )
-- 	}

-- 	--print(lpeg.match(sentence, elo))
-- 	if lpeg.match(sentence, elo) == nil then
-- 		print("Erro na definicao do link")
-- 		return nil
-- 	end

-- end

function link:getType()
	return "link"
end

function link:print()
--[[	A tabela link eh dividida eh duas subtabelas, condition (indice "when") e action (indice "do".
		A subtabela de condicao (when) contem subtabelas 
		

		condition = {	[1]= condition do link, a acao que deve acontecer para disparar as actions
						[2]= id da media ligada a condition,
						[3]= * interface do componente
						[4]= * Nome do Parametro, caso exista
						[5]= * value do parametro
					 }

		action = {	[i] = contem os roles das acoes que devem ser disparadas pelo link }
		cmp = {	[i]= contem o component(media) correspondete ao role contido em action[i] } cmp -> component
		paramName = {} - tabela para uso caso exista parametros ou interface nas medias ligadas as actions, recebe apenas o nome do parametro
		paramValue = {} - recebe o valor do parametro ]]

	local condition, action, cmp = {}, {}, {}
	
	--string que sera impressa no file
	local tag = "<link xconnector=\""

	-- itera sobre a tabela link que deve conter os elementos "when"-condition e "do"-action	
	-- i iterara sobre os indices dos elementos(when e do) e v1 recebera seus valores
	for i,v1 in pairs(self) do

		-- a iteracao agora eh sobre os valores de "when" e "do" que também sao tabelas
		-- j contem o role(evento) e v2 contem as medias(componentes) que sofrera o evento j
		for j,v2 in pairs(v1) do
			
			-- verificando qual a condicao para o disparo do link
			if (i == "when") then
				-- primeiro elemento formara o alias do link
				condition[1] = j
				
				-- iteracao no proximo nivel. Tabela com a media(componente) da condicao 	
				for k,v3 in pairs(v2) do
					--print(type(k))
					if (type(k) == "string") then
						if (k == "interface") then condition[3] = v3  
						else
							condition[4] = k
							condition[5] = v3	
						end
					else
						condition[2]=v3
					end
				end

			-- verificando as acoes que serao disparadas pelo link
			elseif (i== "do") then
				-- iteracao no ultimo nivel das tabelas. 
				-- atribuiçao dos roles e respectivos componentes do action disparado pelo link
				for k,v3 in pairs(v2) do
					table.insert(action,j)
					table.insert(cmp,v3)
				end
			end
		end
	end
	-- contrucao do xconnector do link
	-- o xconnector eh composto do alias + role do condition + roles das actions
	-- primeiro eh preciso descobrir o alias do connector usado
	for i,t in pairs(headElem) do
		if (t:getType()=="connectorBase") then
			tag = tag..t.alias.."#"
		end 
	end
	-- concatenacao com a condition do link
	if (condition[4] == "keyCode") then
		tag = tag.."onKeySelection"
	else
		tag = tag..condition[1]
	end
	-- concatenacao com as actions do link
	for i,v in pairs(action) do
		-- if (string.find(tag,firstToUpper(v))) then
		-- 	tag = tag.."N"
		-- else
		if (action[i] ~= action[i+1]) then
			tag = tag..firstToUpper(v).."N"
		else
			tag = tag.."N"
		end
	end
	tag = tag .. "\">\n"

	-- criacao dos binds
	-- primeiro a condition
	-- sem interface
	if (condition[3] == nil) then
		-- verifica se existe uma key
		if (condition[4] == nil) then
			tag = tag .. "\t\t\t<bind role=\""..condition[1].."\" ".."component=\""..condition[2].."\"/>\n"
		else
			tag = tag .. "\t\t\t<bind role=\""..condition[1].."\" ".."component=\""..condition[2].."\">\n"
			tag = tag.. "\t\t\t\t<bindParam name=\""..condition[4].."\"".." value=\""..condition[5].."\"/>\n"
			tag = tag.. "\t\t\t</bind>\n"
		end
	else -- com interface
		-- verifica se existe uma key
		if (condition[4] == nil) then
			tag = tag .. "\t\t\t<bind role=\""..condition[1].."\" ".."component=\""..condition[2].."\"".." interface=\""..condition[3].."\"/>\n"
		else
			tag = tag .. "\t\t\t<bind role=\""..condition[1].."\" ".."component=\""..condition[2].."\"".." interface=\""..condition[3].."\">\n"
			tag = tag.. "\t\t\t\t<bindParam name=\""..condition[4].."\"".." value=\""..condition[5].."\"/>\n"
			tag = tag.. "\t\t\t</bind>\n"
		end
		
	end	

	-- agora a(s) action(s)
	for i,v in pairs(action) do
		tag = tag .. "\t\t\t<bind role=\""..action[i].."\" ".."component=\""..cmp[i].. "\"/>\n"
	end
	tag = tag .. "\t\t</link>\n"
	return(tag)	
end


return link
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++