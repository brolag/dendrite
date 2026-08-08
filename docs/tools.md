# Tool Guide

Deep dive into each tool in the Dendrite stack and why it was chosen.

---

## Terminal: cmux

**Why cmux over Ghostty/iTerm2/Kitty?**

- Built on Ghostty, so you keep the Metal GPU renderer and its config format
- One vertical tab per workspace, showing git branch, PR status and open ports
- The pane rings and the sidebar badges when an agent is waiting on you
- CLI and Unix socket API: agents can create workspaces, split panes and send keys
- Built-in browser pane an agent can drive against your dev server
- Free and open source (GPL-3.0-or-later), macOS 14+

**Config locations:**

- `~/.config/ghostty/config` — font, theme, colors (inherited from Ghostty)
- `~/.config/cmux/cmux.json` — sidebar, terminal and browser behavior
- `.cmux/cmux.json` — optional per-project overrides

**Key feature for agents:** you stop babysitting panes. Run one agent per workspace and let cmux tell you which one stopped to ask a question, instead of cycling through splits to check.

**Useful CLI:**

```bash
cmux list-workspaces          # every open workspace
cmux new-split right          # split the focused pane
cmux send "yes"               # type into the focused terminal
cmux notify --title "Build" --body "done"
```

**Prefer a general-purpose terminal?** Install Ghostty instead and skip cmux. Dendrite's `~/.config/ghostty/config` is written in Ghostty's format precisely so it works with either one. You lose the workspace sidebar, the agent notifications and the scripting API, and nothing else in the stack changes.

---

## Agent Runtime: herdr

**Why herdr?**

- Agents keep running when your machine sleeps, SSH drops or you close the window
- Reattach from any device, including a thin client over `herdr --remote <host>`
- Named sessions are fully separate runtime namespaces
- Detects 19+ agent CLIs out of the box, no wrapper around Claude Code needed
- Reports agent status (working, blocked, idle) through a socket API
- Apache-2.0

**Command:** `herdr` (launches or reattaches to the default session)

**Keybindings:** prefix is `Ctrl+B`. Then `v` splits right, `-` splits down, `c` opens a tab, `q` detaches, `?` lists every binding.

**Useful CLI:**

```bash
herdr session list            # every session
herdr session attach work     # attach to a named one
herdr agent list              # which agents are working or blocked
herdr agent prompt <target> "continue"
herdr server stop             # stop the background server
```

**Key feature for agents:** a long refactor survives your commute. Detach on the laptop, reattach on another machine, the agent never noticed.

**cmux or herdr for panes?** cmux is the app you look at, herdr is the process that keeps agents alive. Use cmux panes for everyday work and start `herdr` inside a pane when a task must outlive the window.

---

## Editor: Neovim + LazyVim

**Why Neovim over VS Code/Cursor?**

- Runs in the terminal (stays in cmux)
- Modal editing is faster once learned
- LazyVim provides a sane default config
- Avante plugin for AI integration
- Oil.nvim for file management
- Harpoon for fast file switching

**Config location:** `~/.config/nvim/`

**Key feature for agents:** When Claude Code edits files, you can review changes instantly in a split without leaving the terminal.

---

## Git Visual: Lazygit

**Why Lazygit over git CLI?**

- See all changes at a glance (files, branches, commits, diffs)
- Stage/unstage with one keypress
- Real-time updates when agents modify files
- Interactive rebase without memorizing commands

**Config location:** `~/Library/Application Support/lazygit/config.yml`

**Key feature for agents:** Watch in real-time which files your AI agents are modifying. Select any file to see the exact diff.

---

## Token Monitor: claude-monitor

**Why this monitor?**

- 6,400+ stars, most popular Claude Code monitor
- ML-powered predictions for token limits
- Multi-plan support (Pro, Max5, Max20)
- Terminal-native, no browser needed

**Command:** `claude-monitor` or `cm` (alias)

**Key feature for agents:** Know when you're approaching token limits before sessions get cut off.

---

## Session Monitor: ccm

**Why ccm?**

- Monitors multiple Claude Code sessions simultaneously
- Ghostty native support
- Mobile web interface via QR code
- Shows session status (running, waiting, done)

**Command:** `ccm`

**Key feature for agents:** See all your parallel agents in one dashboard.

---

## Shell Prompt: Starship

**Why Starship over Oh My Zsh themes?**

- Written in Rust (instant rendering)
- Shows git branch, status, language versions
- Minimal by default, extensible
- Cross-shell (works with zsh, bash, fish)

**Config location:** `~/.config/starship.toml`

---

## Fuzzy Finder: fzf

**Why fzf?**

- `Ctrl+R` to fuzzy search command history
- `Ctrl+T` to fuzzy find files
- `Alt+C` to fuzzy cd into directories
- Integrates with vim, git, and everything else

---

## Smart Navigation: zoxide

**Why zoxide over cd?**

- Learns your most visited directories
- `z Sites` jumps to `~/Sites` without full path
- `z sb` jumps to `~/Sites/sb`
- Gets smarter the more you use it

---

## Modern CLI Replacements

| Old | New | Why |
|-----|-----|-----|
| `ls` | `eza` | Icons, colors, git status |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `find` | `fd` | Faster, simpler syntax |
| `grep` | `ripgrep (rg)` | Fastest code search available |

---

## Isolation: Git Worktrees

**Why worktrees over branches?**

- Each agent gets its own directory
- No `git stash` / `git checkout` needed
- Agents can't step on each other's files
- Same repo, same history, different workspaces

**Commands:**

```bash
wt-new auth        # Create .worktrees/auth on branch feature/auth
wt-list             # Show all worktrees
wt-rm auth          # Remove worktree after merge
```
