<p align="center">
<pre>
 ____  _____ _   _ ____  ____  ___ _____ _____
|  _ \| ____| \ | |  _ \|  _ \|_ _|_   _| ____|
| | | |  _| |  \| | | | | |_) || |  | | |  _|
| |_| | |___| |\  | |_| |  _ < | |  | | | |___
|____/|_____|_| \_|____/|_| \_\___| |_| |_____|
</pre>
</p>

# Dendrite

<p align="center">
  <img src="https://img.shields.io/badge/Opinionated-TUI%20Stack-6366f1?style=for-the-badge" alt="TUI Stack">
  <img src="https://img.shields.io/badge/macOS-Only-000?style=for-the-badge&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Version-0.1.0-ec4899?style=for-the-badge" alt="Version">
</p>

<p align="center">
  <strong>An opinionated TUI stack for agentic coding with AI agents.</strong><br>
  <sub>One command. 12 tools. Zero config.</sub>
</p>

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

---

## The Problem

```
$ brew install ghostty neovim lazygit starship fzf zoxide eza bat fd ripgrep
$ # now configure each one...
$ # ghostty splits? lazygit theme? starship prompt? fzf keybindings?
$ # 5 tools x 30 min config = half a day gone
$ # and they still don't work together
```

## The Solution

```
$ curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash

  [1/7] Checking prerequisites.............. OK
  [2/7] Setting up Dendrite................. OK
  [3/7] Installing core tools............... 10/10
  [4/7] Installing monitoring tools......... 2/2
  [5/7] Applying configurations............. OK
  [6/7] Configuring shell................... OK
  [7/7] Verifying installation.............. 12/12

  Dendrite installed successfully.

$ # done. everything works together.
```

---

## What You Get

```
+─────────────────────────────────────────────────────+
|                    GHOSTTY                           |
| ┌────────────────────┬────────────────────┐         |
| │  $ claude          │  $ claude          │         |
| │                    │                    │         |
| │  Agent 1           │  Agent 2           │         |
| │  (worktree/auth)   │  (worktree/api)    │         |
| ├────────────────────┼────────────────────┤         |
| │  LAZYGIT           │  CLAUDE-MONITOR    │         |
| │  M auth/login.ts   │  ████████░░ 72%   │         |
| │  M auth/oauth.ts   │  Burn: 1.2k/min   │         |
| │  + api/users.ts    │  ETA: 2h 15m      │         |
| └────────────────────┴────────────────────┘         |
+─────────────────────────────────────────────────────+
```

---

## The Stack

```
LAYER            TOOL                 WHAT IT DOES
─────────────────────────────────────────────────────
Terminal         Ghostty              GPU splits, no tmux
Editor           Neovim + LazyVim     Modal editing + AI
Git              Lazygit              Real-time agent diffs
Token Monitor    claude-monitor       Burn rate & limits
Session Monitor  ccm                  Multi-agent tracking
Shell            Zsh + Starship       Fast prompt, git info
Fuzzy Find       fzf                  Ctrl+R, Ctrl+T, Alt+C
Navigation       zoxide               Smart cd (learns paths)
File View        bat + eza            Syntax highlight, icons
Search           ripgrep + fd         Fastest code search
AI Agents        Claude Code          Primary agent
Isolation        Git Worktrees        One per agent
```

---

## Quick Start

**One command:**

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

The installer will:
- Install all tools via Homebrew (skips already installed)
- Apply optimized configs for Ghostty, Lazygit, Starship
- Set up shell enhancements (fzf, zoxide, aliases)
- Configure keybindings for multi-agent workflow
- Install monitoring tools (claude-monitor, ccm)
- Back up your existing configs before changing anything

<details>
<summary><code>$ manual installation</code></summary>

```bash
git clone https://github.com/brolag/dendrite ~/Sites/dendrite
cd ~/Sites/dendrite && ./install.sh
# restart terminal
```

</details>

---

## Keybindings

### Ghostty

```
ACTION                    KEY
──────────────────────────────────────────
Split right               Cmd + Shift + →
Split down                Cmd + Shift + ↓
Navigate splits           Cmd + ← → ↑ ↓
Resize splits             Cmd + Ctrl + ← → ↑ ↓
Equalize splits           Cmd + Shift + E
Close split               Cmd + Shift + W
Fullscreen                Cmd + Enter
```

### Lazygit

```
KEY       ACTION
──────────────────────────────────────────
Tab       Switch panels
j / k     Navigate up / down
Space     Stage / unstage file
c         Commit
P         Push
?         All keybindings
q         Quit
```

### Shell

```
KEY          ACTION
──────────────────────────────────────────
Ctrl + R     Fuzzy search history (fzf)
Ctrl + T     Fuzzy find files (fzf)
Alt + C      Fuzzy cd directories (fzf)
z <partial>  Smart cd (zoxide)
```

---

## Multi-Agent Workflow

```bash
# 1. Create isolated workspaces
wt-new auth                    # .worktrees/auth (branch: feature/auth)
wt-new api                     # .worktrees/api  (branch: feature/api)

# 2. Open 4-panel layout in Ghostty
#    Cmd+Shift+→  Cmd+←  Cmd+Shift+↓  Cmd+→  Cmd+Shift+↓

# 3. Start agents
# Panel 1:  cd .worktrees/auth && claude
# Panel 2:  cd .worktrees/api && claude
# Panel 3:  lg                           (lazygit)
# Panel 4:  cm                           (claude-monitor)

# 4. Watch lazygit for real-time changes

# 5. Merge when done
git merge feature/auth
git merge feature/api

# 6. Clean up
wt-rm auth && wt-rm api
```

### Rules

```
MAX AGENTS:    2-3 (more is unmanageable)
TASK RULE:     Independent tasks only (no shared files)
SUPERVISION:   Always (this is not fire-and-forget)
RATE LIMITS:   Shared across all sessions
```

---

## Aliases

```bash
lg            # lazygit
cm            # claude-monitor
ll            # eza -la --icons --git
cat file      # bat with syntax highlighting
wt-new X      # git worktree add .worktrees/X -b feature/X
wt-list       # git worktree list
wt-rm X       # git worktree remove .worktrees/X
```

---

## Configs

All configs live in `configs/` and are applied during installation.
Existing configs are backed up before overwriting.

```
CONFIG       FILE                              SETS UP
─────────────────────────────────────────────────────────────
Ghostty      ~/.config/ghostty/config          Splits, keys, font
Starship     ~/.config/starship.toml           Minimal prompt
Lazygit      ~/Library/.../lazygit/config.yml  Theme, refresh
```

---

## Docs

```
FILE                        DESCRIPTION
─────────────────────────────────────────────────────────────
docs/getting-started.md     First-time setup walkthrough
docs/tools.md               Deep dive into each tool
docs/keybindings.md         All shortcuts in one place
docs/architecture.md        Why these tools, why this way
```

---

## FAQ

```
Q: Do I need all these tools?
A: The installer skips what you already have. But they work best together.

Q: Will this mess up my existing configs?
A: No. Everything is backed up before changes. You'll be asked before overwriting.

Q: Does this work on Linux?
A: macOS only for now. Linux support is planned.

Q: Can I use this without AI agents?
A: Yes. The TUI stack is useful on its own.
```

---

## Contributing

Contributions welcome. [Open an issue](https://github.com/brolag/dendrite/issues) or submit a PR.

## License

MIT - see [LICENSE](LICENSE)

---

<p align="center">
  <strong>Dendrite</strong><br>
  <sub>The branches that receive the signal.</sub><br>
  <sub>An <a href="https://indiemind.co">Indie Mind</a> project.</sub>
</p>
