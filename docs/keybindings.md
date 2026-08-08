# Keybindings Reference

All keyboard shortcuts in one place.

---

## cmux

### Workspaces

| Action | Key |
|--------|-----|
| New workspace | `Cmd + N` |
| Select workspace 1-9 | `Cmd + 1…9` |
| Workspace switcher | `Cmd + P` |
| Next / previous workspace | `Ctrl + Cmd + ]` / `Ctrl + Cmd + [` |
| Rename workspace | `Cmd + Shift + R` |
| Mark workspace as done | `Cmd + ;` |
| Toggle left sidebar | `Cmd + B` |
| Close workspace | `Cmd + Shift + W` |

### Split panes

| Action | Key |
|--------|-----|
| Split right | `Cmd + D` |
| Split down | `Cmd + Shift + D` |
| Focus pane left / right | `Opt + Cmd + Left` / `Opt + Cmd + Right` |
| Focus pane up / down | `Opt + Cmd + Up` / `Opt + Cmd + Down` |
| Toggle pane zoom | `Cmd + Shift + Enter` |
| Equalize split sizes | `Ctrl + Cmd + Shift + =` |

### Tabs (surfaces)

| Action | Key |
|--------|-----|
| New tab | `Cmd + T` |
| Next / previous tab | `Cmd + Shift + ]` / `Cmd + Shift + [` |
| Select tab 1-9 | `Ctrl + 1…9` |
| Rename tab | `Cmd + R` |
| Close tab | `Cmd + W` |
| Reopen last closed | `Cmd + Shift + T` |

### Notifications

| Action | Key |
|--------|-----|
| Show notifications | `Cmd + I` |
| Jump to latest unread | `Cmd + Shift + U` |
| Toggle unread state | `Opt + Cmd + U` |

### Browser pane

| Action | Key |
|--------|-----|
| Open browser | `Cmd + Shift + L` |
| Split browser right | `Opt + Cmd + D` |
| Focus address bar | `Cmd + L` |
| Developer tools | `Opt + Cmd + I` |

### Other

| Action | Key |
|--------|-----|
| Command palette | `Opt + Cmd + F` |
| Settings | `Cmd + ,` |
| Reload config | `Cmd + Shift + ,` |
| Toggle full screen | `Ctrl + Cmd + F` |
| Open diff viewer | `Ctrl + Cmd + Shift + D` |
| Find in directory | `Cmd + Shift + F` |

---

## herdr

Prefix is `Ctrl + B`. Press it, release, then the key.

| Action | Key |
|--------|-----|
| Split pane right | `Ctrl + B` then `v` |
| Split pane down | `Ctrl + B` then `-` |
| New tab | `Ctrl + B` then `c` |
| Detach (agents keep running) | `Ctrl + B` then `q` |
| Show all active bindings | `Ctrl + B` then `?` |

---

## Ghostty (fallback terminal)

Only applies if you use Ghostty instead of cmux. These come from Dendrite's
`~/.config/ghostty/config`.

### Splits

| Action | Key |
|--------|-----|
| Split right | `Cmd + Shift + Right` |
| Split down | `Cmd + Shift + Down` |
| Navigate left | `Cmd + Left` |
| Navigate right | `Cmd + Right` |
| Navigate up | `Cmd + Up` |
| Navigate down | `Cmd + Down` |
| Resize left | `Cmd + Ctrl + Left` |
| Resize right | `Cmd + Ctrl + Right` |
| Resize up | `Cmd + Ctrl + Up` |
| Resize down | `Cmd + Ctrl + Down` |
| Equalize splits | `Cmd + Shift + E` |
| Close split | `Cmd + Shift + W` |

### Window

| Action | Key |
|--------|-----|
| Fullscreen | `Cmd + Enter` |
| New tab | `Cmd + T` |
| Tab 1/2/3 | `Cmd + 1/2/3` |

---

## Lazygit

### Navigation

| Key | Action |
|-----|--------|
| `Tab` | Switch between panels |
| `j` / `k` | Move down / up |
| `h` / `l` | Collapse / expand |
| `Enter` | View details |
| `?` | Show all keybindings |
| `q` | Quit |

### Git Actions

| Key | Action |
|-----|--------|
| `Space` | Stage / unstage file |
| `a` | Stage / unstage ALL |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `b` | Branch operations |
| `M` | Merge |
| `r` | Rebase |
| `z` | Undo (experimental) |

---

## Shell (fzf + zoxide)

| Key | Action |
|-----|--------|
| `Ctrl + R` | Fuzzy search command history |
| `Ctrl + T` | Fuzzy find files |
| `Alt + C` | Fuzzy cd into directory |
| `z <partial>` | Smart cd (zoxide) |
| `zi` | Interactive zoxide selection |

---

## Neovim (LazyVim defaults)

### Essential

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Space + f + f` | Find files |
| `Space + f + g` | Live grep |
| `Space + e` | File explorer |
| `Space + b + d` | Close buffer |
| `Ctrl + h/j/k/l` | Navigate splits |

### Navigation

| Key | Action |
|-----|--------|
| `s` | Flash jump (2 chars) |
| `Space + 1-9` | Harpoon files |
| `-` | Oil file manager |
| `[b` / `]b` | Previous / next buffer |

### Git

| Key | Action |
|-----|--------|
| `Space + g + g` | Lazygit (from Neovim) |
| `Space + g + d` | Diff view |
| `]h` / `[h` | Next / previous hunk |
