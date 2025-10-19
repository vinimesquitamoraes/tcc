--- @module Prototipo
-- Este módulo exibe imagens e informações formatadas de pessoas desaparecidas.
-- Usa arquivos JSON e imagens JPEG com nomes correspondentes para compor a tela.

--- Soma dois números (exemplo de docstring)
-- @param a Primeiro número
-- @param b Segundo número
-- @return Soma de a + b
function add(a, b)
	return a + b
end

-- Abre o arquivo "dkjson.lua", analisa e executa seu conteúdo como um Lua chunk.
local json = dofile("dkjson.lua")

-- Canvas
local canvas = canvas or require("canvas")

-- Configurações
local IMG_WIDTH, IMG_HEIGHT = 200, 200
local FONT_NAME, FONT_SIZE = "vera", 9
local TEXTO_X_MARGIN, TEXTO_Y_SPACING = 20, 20
local LABEL_WIDTH = 150

-- Diretórios
local IMG_DIR = "info/img/"
local TXT_DIR = "info/json/"

-- Variáveis de controle
local arquivos = {}
local currentIndex = 1

--- Lista arquivos de um diretório com uma extensão específica
-- @param diretorio Caminho do diretório
-- @param extensao Extensão dos arquivos a buscar (sem o ponto)
-- @return Tabela com nomes dos arquivos encontrados
local function listarArquivos(diretorio, extensao)
    local lista = {}
    local cmd = 'ls "' .. diretorio .. '"'
    local p = io.popen(cmd)

    if not p then
        print("Não foi possível abrir o diretório: " .. diretorio)
        return nil
    end

    for arquivo in p:lines() do
        if arquivo:match("%." .. extensao .. "$") then
            print(arquivo)
            table.insert(lista, arquivo)
        end
    end
    p:close()

    if #lista == 0 then
        print("Nenhum arquivo com a extensão ." .. extensao .. " encontrado em " .. diretorio)
    end

    table.sort(lista)
    return lista
end

--- Formata os dados do JSON em uma tabela legível para exibição
-- @param t Tabela decodificada do JSON
-- @return Tabela formatada com pares label/valor
local function formatarTextoJson(t)
    local descricao = t.descricao or {}
    local ultima_vez = t.ultima_vez_visto or {}
    local contato = t.contato or {}

    return {
        {"NOME:", t.nome or "N/A"},
        {"IDADE:", tostring(t.idade or "N/A")},
        {"DESCRIÇÃO:", "pele " .. (descricao.cor or "N/A")
            .. ", olhos " .. (descricao.olhos or "N/A")
            .. ", cabelo " .. (descricao.cabelo or "N/A")
            .. ", com " .. (descricao.altura or "N/A") .. " altura."},
        {"ÚLTIMA VEZ VISTO(A):", (ultima_vez.data or "N/A") .. " às " .. (ultima_vez.hora or "N/A")
            .. ", trajava " .. (ultima_vez.roupa or "N/A")},
        {"ÚLTIMO LOCAL AVISTADO(A):", t.ultimo_local_avistamento or "N/A"},
    }
end

--- Quebra um texto em várias linhas com base na largura máxima
-- @param texto Texto a ser quebrado
-- @param maxWidth Largura máxima permitida
-- @return Tabela com linhas do texto quebrado
local function quebrarTexto(texto, maxWidth)
    local linhas = {}
    canvas:attrFont(FONT_NAME, FONT_SIZE, "bold")

    -- Transforma todo o texto em caixa alta
    --texto = string.upper(texto)

    for linha in texto:gmatch("[^\n]+") do
        local atual = ""
        for palavra in linha:gmatch("%S+") do
            local tentativa = (atual == "") and palavra or (atual .. " " .. palavra)

            if canvas:measureText(tentativa) > maxWidth then
                table.insert(linhas, atual)
                atual = palavra
            else
                atual = tentativa
            end
        end
        if atual ~= "" then
            table.insert(linhas, atual)
        end
    end

    return linhas
end

--- Desenha texto formatado na tela centralizado
-- Labels são exibidos em vermelho e negrito, valores em preto normal
-- @param textoFormatado Tabela com pares {label, valor}
-- @param maxWidth Largura máxima para o texto
-- @param startY Posição vertical inicial
local function desenharTextoFormatado(textoFormatado, maxWidth, startY)
    local canvas_dx = canvas:attrSize()
    local y = startY

    for _, par in ipairs(textoFormatado) do
        local label, valor = par[1], par[2]
        local textoCompleto = label .. " " .. valor
        local linhas = quebrarTexto(textoCompleto, maxWidth)

        for i, linha in ipairs(linhas) do
            local linhaLargura = canvas:measureText(linha)
            local x = (canvas_dx - linhaLargura) / 2

            if i == 1 then
                local labelFim = linha:find(":")
                if labelFim then
                    local labelTexto = linha:sub(1, labelFim)
                    local valorTexto = linha:sub(labelFim + 1)

                    canvas:attrFont(FONT_NAME, FONT_SIZE, "bold")
                    canvas:attrColor("red")
                    canvas:drawText(x, y, string.upper(labelTexto))

                    local labelLargura = canvas:measureText(labelTexto)
                    canvas:attrFont(FONT_NAME, FONT_SIZE, "bold")
                    canvas:attrColor("black")
                    canvas:drawText(x + labelLargura, y, valorTexto)
                    
                else
                    canvas:attrFont(FONT_NAME, FONT_SIZE, "bold")
                    canvas:attrColor("red")
                    canvas:drawText(x, y, linha)
                end
            else
                canvas:attrFont(FONT_NAME, FONT_SIZE, "bold")
                canvas:attrColor("black")
                canvas:drawText(x, y, linha)
            end

            y = y + TEXTO_Y_SPACING
        end
    end
end

--- Carrega imagens e seus respectivos dados JSON
-- Associa arquivos JPEG e JSON com o mesmo nome base
--[[
local function carregarArquivos()
    local imagens = listarArquivos(IMG_DIR, "jpeg")
    for _, img in ipairs(imagens) do
        local nomeBase = img:match("(.+)%.%w+$")
        local jsonFile = nomeBase .. ".json"
        local jsonPath = TXT_DIR .. jsonFile
        local arq = io.open(jsonPath, "r")
        if arq then
            local conteudo = arq:read("*a")
            arq:close()
            local dados, _, err = json.decode(conteudo)
            if dados then
                local textoFormatado = formatarTextoJson(dados)
                table.insert(arquivos, {
                    imagem = IMG_DIR .. img,
                    texto = textoFormatado
                })
                print("Par carregado: " .. img .. " + " .. jsonFile)
            else
                print("Erro ao decodificar JSON: " .. err)
            end
        else
            print("JSON não encontrado para: " .. img)
        end
    end
    print("Total de pares carregados: " .. #arquivos)
end]]

local function carregarArquivos()
    local jsons = listarArquivos(TXT_DIR, "json")

    for _, jsonFile in ipairs(jsons) do
        local jsonPath = TXT_DIR .. jsonFile
        local arq = io.open(jsonPath, "r")

        if arq then
            local conteudo = arq:read("*a")
            arq:close()

            local dados, _, err = json.decode(conteudo)
            if not dados then
                print("Erro ao decodificar JSON: " .. err .. " (" .. jsonFile .. ")")
            else
                local fotoRelativa = dados.foto or ""
                local imgPath = fotoRelativa

                -- Verifica se o caminho da imagem é relativo ou absoluto
                if not fotoRelativa:match("^/") then
                    imgPath = IMG_DIR .. fotoRelativa
                end

                -- Testa se o arquivo de imagem existe
                local imgFile = io.open(imgPath, "r")
                if imgFile then
                    imgFile:close()

                    local textoFormatado = formatarTextoJson(dados)
                    table.insert(arquivos, {
                        imagem = imgPath,
                        texto = textoFormatado
                    })
                    print("Par carregado: " .. jsonFile .. " + " .. fotoRelativa)
                else
                    print("Imagem não encontrada: " .. imgPath .. " (referenciada em " .. jsonFile .. ")")
                end
            end
        else
            print("Erro ao abrir JSON: " .. jsonFile)
        end
    end

    print("Total de pares carregados: " .. #arquivos)
end


--- Atualiza a tela com a imagem e informações da pessoa atual
function redraw()
    local item = arquivos[currentIndex]
    if not item then
        print("Nenhum item para exibir (índice: " .. currentIndex .. ")")
        return
    end

    local canvas_dx, canvas_dy = canvas:attrSize()
    local imagemCanvas = canvas:new(IMG_WIDTH, IMG_HEIGHT)
    local rawImg = canvas:new(item.imagem)
    imagemCanvas:compose(0, 0, rawImg)

    local img_x = (canvas_dx - IMG_WIDTH) / 2
    local img_y = 80

    -- Fundo branco da tela
    canvas:attrColor("white")
    canvas:drawRect("fill", 0, 0, canvas_dx, canvas_dy)


    -- Título com retângulo vermelho
    	canvas:attrFont("vera", 21, "bold")
    local titulo = "DESAPARECIDO(A)"
    local larguraTitulo = canvas:measureText(titulo)
    local alturaTexto = 30
    local margem = 30

    local xTexto = (canvas_dx - larguraTitulo) / 2
    local yTexto = 10  -- move tudo mais pra cima

    -- Retângulo vermelho
    canvas:attrColor("red")
    canvas:drawRect("fill",
	xTexto - margem,
	yTexto - margem / 2,
	larguraTitulo + 2 * margem,
	alturaTexto + margem
     )

    -- Texto branco por cima
    canvas:attrColor("white")
    canvas:drawText(xTexto, yTexto, titulo)

    -- Imagem e informações
    canvas:compose(img_x, img_y, imagemCanvas)
    desenharTextoFormatado(item.texto, canvas_dx - 2 * TEXTO_X_MARGIN, img_y + IMG_HEIGHT + 20)
    
    
	-- Faixa inferior com informações de emergência
	local faixaAltura = 70
	local texto1 = "DENUNCIE:"
	local texto2 = "📞 190 ou "

	canvas:attrColor("red")
	canvas:drawRect("fill", 0, canvas_dy - faixaAltura, canvas_dx, faixaAltura)

	canvas:attrColor("white")
	canvas:attrFont(FONT_NAME, 12, "bold")

	-- Medir os textos
	local largura1 = canvas:measureText(texto1)
	local largura2 = canvas:measureText(texto2)
	local espacamento = 10  -- espaço em pixels entre os textos

	-- Ajustar posição para a esquerda
	-- Para deslocar para a esquerda, use um valor fixo para o x_inicial (ex: 20)
	local x_inicial = 15  -- Aqui você define a margem da esquerda
	local y_texto = canvas_dy - faixaAltura + 25

	-- Desenhar os textos lado a lado
	canvas:drawText(x_inicial, y_texto, texto1)
	canvas:drawText(x_inicial + largura1 + espacamento, y_texto, texto2)
    
    canvas:flush()
end

--- Manipulador de eventos do NCL
-- Responde ao início da apresentação e às teclas de navegação
-- @param evt Evento recebido
function handler(evt)
    if evt.class == "ncl" and evt.type == "presentation" and evt.action == "start" then
        carregarArquivos()
        if #arquivos == 0 then
            print("Nenhum conteúdo encontrado")
        else
            redraw()
        end
    elseif evt.class == "key" and evt.type == "press" then
        if evt.key == "GREEN" then
            currentIndex = (currentIndex % #arquivos) + 1
            redraw()
        elseif evt.key == "YELLOW" then
            currentIndex = (currentIndex - 2 + #arquivos) % #arquivos + 1
            redraw()
        end
    end
end

-- Registra o manipulador de eventos
event.register(handler)
