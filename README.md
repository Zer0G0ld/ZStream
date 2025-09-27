# ZStream – Playlist Automática para OBS

🎵 **ZStream** é um script Lua para OBS Studio que permite criar uma **playlist automática 24h**, ideal para rádios online, transmissões contínuas ou qualquer cenário que precise de música ininterrupta.

Ele suporta arquivos MP3, MP4 e WAV, com loop infinito, shuffle e atualização de um arquivo "Tocando agora".

---

## Funcionalidades

- Suporta **MP3, MP4 e WAV**.
- **Loop infinito** de reprodução.
- **Shuffle contínuo** (embaralhamento aleatório).
- Atualiza automaticamente um arquivo TXT **"Tocando agora"**.
- Log detalhado no OBS para acompanhar trocas de música.
- Timer de fallback para troca automática caso nenhum evento seja detectado.
- Configurações persistentes e seguras.

---

## Instalação

1. Baixe o script `zstream.lua`.
2. Abra o OBS e vá em **Ferramentas → Scripts → Adicionar**.
3. Selecione o arquivo `zstream.lua`.
4. Configure:
   - **Pasta da Playlist**: diretório onde estão suas músicas.
   - **Nome da Fonte de Mídia**: a fonte de mídia do OBS que vai reproduzir a música.
   - **Shuffle**: habilite se quiser ordem aleatória.
   - **Arquivo 'Tocando agora'**: caminho do arquivo TXT que será atualizado.

---

## Uso

- Ao carregar o script, a primeira música será iniciada automaticamente.
- A cada fim de música (ou fallback do timer), a próxima música será tocada.
- O arquivo TXT será atualizado com o nome da música atual.
- Logs aparecem em **OBS → Ajuda → Mostrar log do script**.

---

## Configurações

O script permite salvar e recarregar as configurações de:

- Nome da fonte de mídia.
- Shuffle (ativo ou desativo).
- Caminho do arquivo "Tocando agora".

---

## Contribuição

Sinta-se à vontade para abrir **issues** ou enviar **pull requests**.  
Melhorias sugeridas:

- Detecção real do fim de mídia (sem depender do timer de fallback).
- Suporte a subpastas na playlist.
- Melhorias na interface de configuração no OBS.
- Compatibilidade multiplataforma (Linux/Mac).

---

## Changelog

### v1.0 – 26/09/2025
- Primeira versão funcional.
- Suporta MP3, MP4, WAV.
- Loop infinito e shuffle.
- Arquivo TXT "Tocando agora" atualizado automaticamente.
- Timer de fallback a cada 3 minutos.
- Logs de troca de música no OBS.
- Funções de `load`, `unload` e `save` implementadas.
- Shuffle contínuo ao reiniciar a playlist.
- Script testado e funcional no OBS 32-bit e 64-bit.

---

## Autor

**Zer0G0ld**

---

## Licença

Este projeto está licenciado sob a [**GNU General Public License v3.0 (GPLv3)**](LICENSE).  
Você pode redistribuir e/ou modificar o código sob os termos da GPLv3.  

Para mais informações, consulte: [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)
