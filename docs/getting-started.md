# Getting Started with Dendrite

## Prerequisites

- macOS (Apple Silicon or Intel). cmux needs macOS 14 or later; on anything older
  the installer skips it and you use Ghostty as the terminal
- [Homebrew](https://brew.sh/) installed
- A terminal (Dendrite will install cmux for you)

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

The installer is interactive. It will:

1. Check prerequisites (Homebrew, Git)
2. Install 13 tools via Homebrew
3. Install monitoring tools (claude-monitor, ccm)
4. Apply optimized configs (with backup of existing ones)
5. Configure your shell with aliases and helpers
6. Verify everything works

## After Installation

### 1. Restart your terminal

Close and reopen your terminal, or run:

```bash
source ~/.zshrc
```

### 2. Open cmux

If cmux was just installed, open it from Applications. It picks up the font, theme and
colors Dendrite wrote to `~/.config/ghostty/config`, plus its own settings in
`~/.config/cmux/cmux.json`.

Prefer a plain terminal? Install Ghostty (`brew install --cask ghostty`) and use it
instead. The same config file drives both.

### 3. Try the basics

```bash
# Your new shell should show a minimal prompt with git info (starship)

# Try fuzzy finding
Ctrl+R              # Search command history
Ctrl+T              # Find files

# Try smart navigation
z Sites              # Jump to ~/Sites (zoxide learns over time)

# Try modern tools
ll                   # eza with icons and git status
cat README.md        # bat with syntax highlighting
lg                   # lazygit
```

### 4. Try multi-agent layout

Open a workspace for the task, then split it into 4 panes:

```
Cmd+N                 New workspace
Cmd+D                 Split right
Cmd+Shift+D           Split down
Opt+Cmd+Right         Focus the right pane
Cmd+Shift+D           Split down
```

You now have:

```
+------------------+------------------+
|   Top Left       |   Top Right      |
+------------------+------------------+
|   Bottom Left    |   Bottom Right   |
+------------------+------------------+
```

### 5. Start agents

```bash
# Top left: Agent 1
wt-new auth
cd .worktrees/auth && claude

# Top right: Agent 2
wt-new api
cd .worktrees/api && claude

# Bottom left: Git monitoring
lazygit

# Bottom right: Token monitoring
claude-monitor
```

When an agent stops to ask you something, its pane rings and the sidebar shows an
unread badge. `Cmd+I` opens notifications, `Cmd+Shift+U` jumps to the latest one.

### 6. Keep agents alive with herdr

Anything longer than a coffee break should run inside the runtime:

```bash
herdr                     # start or reattach to the default session
# Ctrl+B then v             split a pane and run your agent there
# Ctrl+B then q             detach — the agent keeps working

herdr session list        # every session
herdr agent list          # working, blocked or idle
```

Close the laptop, lose the network, reopen tomorrow: `herdr` puts you back where you
were. From another machine, use `herdr --remote <host>`.

## Aliases Reference

| Alias | Command | Description |
|-------|---------|-------------|
| `lg` | `lazygit` | Git TUI |
| `cm` | `claude-monitor` | Token monitor |
| `ll` | `eza -la --icons --git` | List files with details |
| `cat` | `bat --style=plain` | File viewer with syntax |
| `wt-new X` | `git worktree add ...` | Create worktree |
| `wt-list` | `git worktree list` | List worktrees |
| `wt-rm X` | `git worktree remove ...` | Remove worktree |

## Troubleshooting

### cmux shortcuts don't work

Reload the config with `Cmd+Shift+,` or `cmux reload-config`. If the font or theme
looks wrong instead, check `~/.config/ghostty/config` — that is where cmux reads them
from.

### Ghostty keybindings don't work

Quit Ghostty completely (`Cmd+Q`) and reopen. Config loads at startup.

### herdr says the server isn't running

Run `herdr status` to see the runtime state, and `herdr server` to start it
explicitly. `herdr server stop` kills it, which also kills the agents inside.

### Starship prompt not showing

Run `source ~/.zshrc` or check that the Dendrite block was added:

```bash
grep "Dendrite" ~/.zshrc
```

### claude-monitor crashes with heap error

You have too many session files. Give Node more memory:

```bash
NODE_OPTIONS="--max-old-space-size=8192" claude-monitor
```

### Tool X was not installed

Run the installer again - it skips already installed tools:

```bash
cd ~/Sites/dendrite && ./install.sh
```

Or install manually with Homebrew:

```bash
brew install <tool-name>
```
