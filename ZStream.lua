obs           = obslua
authors       = "Zer0G0ld"
version       = "1.0"
source_name   = "<Nome da Fonte>"
playlist      = {}
current_index = 1
shuffle       = true
now_playing   = "now_playing.txt"

-- Descrição
function script_description()
    return "Playlist automática para rádio 24h no OBS\n" ..
            "Suporta MP3/MP4/WAV, loop infinito, shuffle e arquivo 'Tocando agora'."
end

-- Configurações do script
function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_path(props, "folder", "Pasta da Playlist",
        obs.OBS_PATH_DIRECTORY, "", nil)
    obs.obs_properties_add_text(props, "source", "Nome da Fonte de Mídia", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_bool(props, "shuffle", "Tocar em ordem aleatória")
    obs.obs_properties_add_path(props, "txtfile", "Arquivo 'Tocando agora'",
        obs.OBS_PATH_FILE, "*.txt", nil)
    return props
end

-- Atualizar configurações
function script_update(settings)
    local folder = obs.obs_data_get_string(settings, "folder")
    source_name  = obs.obs_data_get_string(settings, "source")
    shuffle      = obs.obs_data_get_bool(settings, "shuffle")
    now_playing  = obs.obs_data_get_string(settings, "txtfile")

    playlist = {}
    current_index = 1

    if folder ~= "" then
        local p = io.popen('dir "' .. folder .. '" /b')
        for file in p:lines() do
            if file:match("%.mp3$") or file:match("%.mp4$") or file:match("%.wav$") then
                table.insert(playlist, folder .. "\\" .. file)
            end
        end
        p:close()
    end

    if shuffle then
        math.randomseed(os.time())
        for i = #playlist, 2, -1 do
            local j = math.random(i)
            playlist[i], playlist[j] = playlist[j], playlist[i]
        end
    end

    obs.script_log(obs.LOG_INFO, "Carregados " .. tostring(#playlist) .. " arquivos na playlist.")
    if #playlist > 0 then
        next_file_safe()
    else
        obs.script_log(obs.LOG_WARNING, "Nenhum arquivo de mídia encontrado na pasta!")
    end
end

-- Função para tocar arquivo (segura)
function play_file_safe(file)
    if not file then return end
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local settings = obs.obs_source_get_settings(source)
        local safe_file = file:gsub("\\", "/"):gsub("['\"]", "")
        obs.obs_data_set_string(settings, "local_file", safe_file)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
        write_now_playing(file)
        obs.script_log(obs.LOG_INFO, "Tocando agora: " .. (file:match("([^/\\]+)$") or file))
    else
        obs.script_log(obs.LOG_WARNING, "Fonte '" .. source_name .. "' não encontrada!")
    end
end

-- Escreve no arquivo TXT "Tocando agora"
function write_now_playing(file)
    local f = io.open(now_playing, "w")
    if f ~= nil then
        local name = file:match("([^/\\]+)$")
        f:write("Tocando agora: " .. name .. "\n")
        f:close()
    end
end

-- Próxima música com shuffle contínuo
function next_file_safe()
    current_index = current_index + 1
    if current_index > #playlist then
        current_index = 1
        if shuffle then
            math.randomseed(os.time())
            for i = #playlist, 2, -1 do
                local j = math.random(i)
                playlist[i], playlist[j] = playlist[j], playlist[i]
            end
        end
    end
    obs.timer_add(function() play_file_safe(playlist[current_index]) end, 50)
end

-- Detecta fim de mídia (via eventos do OBS)
function on_event(event, data)
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPING then
        obs.timer_remove(check_media)
    end
end

-- Timer de checagem (fallback simples)
local counter = 0
function check_media()
    counter = counter + 1
    if counter % 180 == 0 then
        next_file_safe()
    end
end

-- Carrega script
function script_load(settings)
    obs.timer_add(check_media, 1000)
    obs.obs_frontend_add_event_callback(on_event)
end
-- Descarrega script
function script_unload()
    obs.timer_remove(check_media)
    obs.obs_frontend_remove_event_callback(on_event)
end

-- Salva configurações
function script_save(settings)
    obs.obs_data_set_string(settings, "source", source_name)
    obs.obs_data_set_bool(settings, "shuffle", shuffle)
    obs.obs_data_set_string(settings, "txtfile", now_playing)
end