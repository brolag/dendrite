# Getting Started with Dendrite

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Homebrew](https://brew.sh/) installed
- A terminal (Dendrite will install Ghostty for you)

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

The installer is interactive. It will:

1. Check prerequisites (Homebrew, Git)
2. Install 12 tools via Homebrew
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

### 2. Open Ghostty

If Ghostty was just installed, open it from Applications.

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

Create the 4-panel layout:

```
Cmd+Shift+Right      Split right
Cmd+Left              Go to left split
Cmd+Shift+Down        Split down
Cmd+Right             Go to right split
Cmd+Shift+Down        Split down
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

### Ghostty keybindings don't work

Quit Ghostty completely (`Cmd+Q`) and reopen. Config loads at startup.

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
