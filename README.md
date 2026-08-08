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
  <sub>One command. 13 tools. Zero config.</sub>
</p>

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

---

## The Problem

```
$ brew install cmux herdr neovim lazygit starship fzf zoxide eza bat fd ripgrep
$ # now configure each one...
$ # cmux workspaces? herdr sessions? lazygit theme? starship prompt?
$ # 5 tools x 30 min config = half a day gone
$ # and they still don't work together
```

## The Solution

```
$ curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash

  [1/7] Checking prerequisites.............. OK
  [2/7] Setting up Dendrite................. OK
  [3/7] Installing core tools............... 11/11
  [4/7] Installing monitoring tools......... 2/2
  [5/7] Applying configurations............. OK
  [6/7] Configuring shell................... OK
  [7/7] Verifying installation.............. 13/13

  Dendrite installed successfully.

$ # done. everything works together.
```

---

## What You Get

```
+─────────────────────────────────────────────────────+
|                      CMUX                            |
| ┌────────────────────┬────────────────────┐         |
| │  $ claude          │  $ claude          │         |
| │                    │                    │         |
| │  Agent 1           │  Agent 2 ● waiting │         |
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
Terminal         cmux                 Workspace per agent, alerts
Agent Runtime    herdr                Sessions that survive anything
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

`cmux` is a Ghostty-based terminal built for coding agents: one vertical tab per
workspace with branch and PR status, a ring on the pane when an agent stops to ask
you something, and a CLI so agents can drive the terminal themselves. It inherits
font, theme and colors from `~/.config/ghostty/config`, so plain Ghostty still works
as a fallback terminal if you want a general-purpose one.

`herdr` is the runtime underneath: agents keep running when your laptop sleeps, the
SSH link drops or you close the window. Reattach from any device with `herdr`.

---

## Quick Start

**One command:**

```bash
curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
```

The installer will:
- Install all tools via Homebrew (skips already installed)
- Apply optimized configs for cmux, Lazygit, Starship
- Set up shell enhancements (fzf, zoxide, aliases)
- Install the agent runtime (herdr) for persistent sessions
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

### cmux

```
ACTION                    KEY
──────────────────────────────────────────
New workspace             Cmd + N
Go to workspace 1-9       Cmd + 1..9
Workspace switcher        Cmd + P
Split right               Cmd + D
Split down                Cmd + Shift + D
Focus another pane        Opt + Cmd + ← → ↑ ↓
Zoom pane                 Cmd + Shift + Enter
Equalize splits           Ctrl + Cmd + Shift + =
Notifications             Cmd + I
Jump to latest unread     Cmd + Shift + U
Open browser in split     Opt + Cmd + D
Close tab                 Cmd + W
```

### herdr

```
ACTION                    KEY
──────────────────────────────────────────
Split pane right          Ctrl + B  then  v
Split pane down           Ctrl + B  then  -
New tab                   Ctrl + B  then  c
Detach (keeps running)    Ctrl + B  then  q
Show all bindings         Ctrl + B  then  ?
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
# 1. Create isolated worktrees
wt-new auth                    # .worktrees/auth (branch: feature/auth)
wt-new api                     # .worktrees/api  (branch: feature/api)

# 2. Open 4-pane layout in cmux
#    Cmd+D  Cmd+Shift+D  Opt+Cmd+→  Cmd+Shift+D

# 3. Start agents
# Pane 1:   cd .worktrees/auth && claude
# Pane 2:   cd .worktrees/api && claude
# Pane 3:   lg                           (lazygit)
# Pane 4:   cm                           (claude-monitor)

# 4. Watch lazygit for real-time changes.
#    cmux rings the pane when an agent stops to ask you something (Cmd+I)

# 5. Merge when done
git merge feature/auth
git merge feature/api

# 6. Clean up
wt-rm auth && wt-rm api
```

### Sessions that outlive your laptop

Start the agents inside `herdr` and they keep working after sleep, an SSH drop or a
closed window:

```bash
herdr                          # start or reattach to the default session
# Ctrl+B then v                  split a pane, run an agent in it
# Ctrl+B then q                  detach — agents keep running

herdr session list             # every session, from any device
herdr agent list               # which agents are working, blocked or idle
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
Terminal     ~/.config/ghostty/config          Font, colors, splits
cmux         ~/.config/cmux/cmux.json          Sidebar, terminal, browser
Starship     ~/.config/starship.toml           Minimal prompt
Lazygit      ~/Library/.../lazygit/config.yml  Theme, refresh
```

The terminal config uses Ghostty's format because cmux reads it for font, theme and
colors. The same file configures Ghostty if you use it as your fallback terminal.

Existing configs are never replaced without a yes. In a piped install, where there
is no way to answer, yours are kept untouched.

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
A: No config you already have is replaced without a yes. A piped install has no
   way to ask, so there they are all left alone. When you do say yes, the
   original is backed up next to it as <name>.dendrite-backup.<timestamp>.

Q: Does this work on Linux?
A: macOS only for now. Linux support is planned.

Q: I'm on macOS 13 or older.
A: Everything installs except cmux, which needs macOS 14+. The installer detects
   this, skips it and tells you to install Ghostty instead.

Q: Why cmux instead of Ghostty?
A: cmux is built on Ghostty and adds what agent work needs: a workspace per task,
   alerts when an agent blocks on you, and a CLI agents can script. Same renderer,
   same config file.

Q: I want a plain terminal, not an agent one.
A: Install Ghostty and skip cmux. The shipped ~/.config/ghostty/config works for
   both, and every other tool in the stack is terminal-agnostic.

Q: cmux and herdr both manage panes. Isn't that redundant?
A: cmux is the app you look at, herdr is the process that keeps agents alive.
   Run herdr inside cmux when a task must survive sleep or a dropped connection.

Q: Can I use this without AI agents?
A: The TUI stack is useful on its own, but cmux is built for agents. Swap it for
   Ghostty if you never run one.
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
  <sub>An <a href="https://indie-mind.com">Indie Mind</a> project.</sub>
</p>
