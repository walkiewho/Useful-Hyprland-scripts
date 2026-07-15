# Useful Hyprland scripts

Набор вспомогательных скриптов для оконного менеджера Hyprland, упрощающих работу с окнами, scratchpad‑ами и фокусировкой.

## Требования

- [Hyprland](https://hyprland.org/) (последняя стабильная версия)
- [jq](https://stedolan.github.io/jq/) – для обработки JSON‑вывода Hyprland
- Дополнительные приложения (опционально):
  - `chromium` (или другой браузер, поддерживающий `--app`) для `chatgpt-scratchpad.sh`
  - `spotify-launcher` для `spotify-scratchpad.sh`
  - `mousepad` для `toggle_mousepad.sh`

## Описание скриптов

### `chatgpt-scratchpad.sh`

Открывает веб‑интерфейс ChatGPT в отдельном специальном workspace (scratchpad). При первом запуске создаётся окно Chromium с профилем `chatgpt` (путь `~/.config/chromium-profiles/chatgpt`). Повторный вызов переключает видимость этого scratchpad‑workspace.

**Зависимости**: `chromium`, `jq`, `hyprctl`.

**Использование**:
```bash
~/.local/scripts/chatgpt-scratchpad.sh
```

**Примечание**: имя класса окна задано как `chrome-chatgpt.com__-Default` – при использовании другого браузера или иного URL может потребоваться корректировка.

---

### `focus_window_under_cursor.sh`

Фокусирует окно, которое находится непосредственно под указателем мыши. Для определения целевого окна используется скрипт `get_windows_by_pos`.

**Зависимости**: `get_windows_by_pos` (должен быть в том же каталоге или в PATH), `hyprctl`.

**Использование**:
```bash
~/.local/scripts/focus_window_under_cursor.sh
```

Скрипт временно отключает `no_warps`, чтобы курсор не перемещался при смене фокуса.

---

### `get_shell.sh`

Определяет имя текущей интерактивной оболочки (интерпретатора). Проверяет переменные `BASH_VERSION`, `ZSH_VERSION`, `FISH_VERSION`; если ни одна не задана, выполняет запрос через `ps`.

**Использование**:
```bash
~/.local/scripts/get_shell.sh
# Вывод: bash, zsh, fish или имя исполняемого файла
```

---

### `get_windows_by_pos`

Принимает координаты X и Y (в пикселях) и возвращает в формате JSON информацию об окне, находящемся в этой точке на текущем рабочем столе. Если координаты не переданы, используются текущие координаты курсора.

**Синтаксис**:
```bash
get_windows_by_pos [X] [Y]
```

Пример без аргументов (использует позицию курсора):
```bash
~/.local/scripts/get_windows_by_pos
```

Пример с явными координатами:
```bash
~/.local/scripts/get_windows_by_pos 100 200
```

**Вывод** (JSON):
```json
{
  "address": "0x12345678",
  "title": "Terminal",
  "class": "Alacritty",
  "at": [10, 20],
  "size": [800, 600],
  "workspace": 1
}
```

Скрипт учитывает слой окон (сортирует по `layer` в обратном порядке) и выбирает самое верхнее окно на активном workspace.

---

### `keybinds.conf`

Пример фрагмента конфигурации Hyprland, демонстрирующий привязки клавиш для использования скриптов.

Содержимое:
```
bind = SUPER, F2, exec, ~/.local/scripts/spotify-scratchpad.sh
bind = Super, A, exec, ~/.local/scripts/toggle_mousepad.sh
bind = Super+Shift, E, exec, hyprctl dispatch exec "[float; size 960 540; move 480 270; opacity 0.95 0.8] xdg-open ./"
```

Чтобы применить эти привязки, добавьте строки в ваш `~/.config/hypr/hyprland.conf`.

---

### `spotify-scratchpad.sh`

Аналог `chatgpt-scratchpad.sh`, но для Spotify. Открывает Spotify в scratchpad‑workspace с именем `spotify`. При повторном вызове переключает видимость этого workspace.

**Зависимости**: `spotify-launcher`, `jq`, `hyprctl`.

**Использование**:
```bash
~/.local/scripts/spotify-scratchpad.sh
```

---

### `toggle_mousepad.sh`

Организует работу с редактором Mousepad в качестве выдвижной боковой панели. При первом запуске создаётся плавающее окно Mousepad размером 400x800, расположенное у левого края экрана (x=5, y=100). При последующих вызовах окно переключается между видимым положением (x=5) и скрытым (x=-505), перемещаясь на текущий рабочий стол при необходимости. При скрытии фокус передаётся окну под курсором с помощью `focus_window_under_cursor.sh`.

**Особенности**:
- Для запоминания адреса окна используется файл `/tmp/toggle_window.addr`.
- Если окно было закрыто, файл сбрасывается и при следующем вызове создаётся новое окно.
- При переключении workspace окно автоматически перемещается на текущий активный workspace.

**Зависимости**: `mousepad`, `hyprctl`, `jq`, а также `focus_window_under_cursor.sh` для корректного возврата фокуса.

**Использование**:
```bash
~/.local/scripts/toggle_mousepad.sh
```

## Настройка и интеграция

Рекомендуется разместить все скрипты в одном каталоге`~/.local/scripts` и добавить этот каталог в переменную `PATH` или указывать полные пути в конфигурации Hyprland.


## Примечания

- Все скрипты рассчитаны на работу в окружении Hyprland; для других оконных менеджеров они не будут работать.
- В скриптах используются абсолютные пути к исполняемым файлам – при необходимости измените их под вашу систему.
- Файл `/tmp/toggle_window.addr` создаётся автоматически; его можно безопасно удалить вручную, если потребуется сбросить состояние панели Mousepad.
- Для корректной работы `chatgpt-scratchpad.sh` убедитесь, что каталог `~/.config/chromium-profiles/chatgpt` существует и Chromium имеет права на запись в него. При необходимости измените путь в скрипте.
