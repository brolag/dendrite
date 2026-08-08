# Architecture

Why these tools, why this way.

---

## Design Principles

### 1. Terminal-native

Everything runs in the terminal. No browser tabs, no Electron apps, no context switching. Your hands stay on the keyboard.

### 2. Opinionated defaults

Every tool is pre-configured to work with every other tool. You don't need to spend hours figuring out how to make fzf work with zsh or how to lay out cmux panes.

### 3. Respect existing setup

The installer backs up your configs before changing anything. If you already have Neovim configured, it won't touch it.

### 4. One tool per job

No redundancy. One terminal, one editor, one git TUI, one prompt. Each tool is the best at what it does. The single deliberate overlap is cmux and herdr, and it exists because rendering panes and keeping processes alive are different jobs (see below).

---

## The Stack Layers

```
+─────────────────────────────────────────+
|            Terminal Layer                |
|  cmux (workspaces, panes, GPU render)   |
+─────────────────────────────────────────+
|            Runtime Layer                |
|  herdr (persistent agent sessions)      |
+─────────────────────────────────────────+
|            Shell Layer                  |
|  Zsh + Starship + fzf + zoxide         |
+─────────────────────────────────────────+
|            Editor Layer                 |
|  Neovim + LazyVim + Avante             |
+─────────────────────────────────────────+
|            Git Layer                    |
|  Git + Lazygit + Worktrees             |
+─────────────────────────────────────────+
|            Agent Layer                  |
|  Claude Code + Worktree Isolation       |
+─────────────────────────────────────────+
|            Monitor Layer                |
|  claude-monitor + ccm                   |
+─────────────────────────────────────────+
|            CLI Layer                    |
|  fd + rg + bat + eza                    |
+─────────────────────────────────────────+
```

---

## Why These Specific Tools

### Terminal: cmux over Ghostty

Ghostty won on speed and a version-controllable text config. cmux is built on Ghostty, so it inherits both, and adds the part that only matters when agents are doing the typing: a workspace per task in the sidebar with branch and PR state, and a ring on the pane when an agent blocks waiting for input. Without that, supervising 2-3 agents means cycling through splits to see who is stuck.

The tradeoff is honest: cmux is younger than Ghostty, requires macOS 14+, and is built for agent work rather than general terminal use. If you want a plain terminal, install Ghostty and skip cmux. The shipped `~/.config/ghostty/config` drives either one, which is why it stays in Ghostty's format.

### Runtime: herdr under the terminal

A terminal emulator dies with its window. Agents shouldn't. herdr runs a background server that owns the panes, so a task survives sleep, a dropped SSH link or a closed laptop, and you reattach from anywhere.

This is the one place Dendrite runs two tools that both draw panes. They answer different questions: cmux is what you look at, herdr is what keeps the process alive. Everyday work happens in cmux panes; herdr comes in when a task must outlive the window. Neither wraps Claude Code, so agents behave identically in both.

### Editor: Neovim over VS Code

In an agent-driven workflow, the editor is for reviewing changes, not writing code. Neovim in a cmux pane lets you review diffs without leaving the terminal. VS Code would require a separate window.

### Git: Lazygit over CLI

When 2-3 agents are modifying files simultaneously, `git status` is too slow. Lazygit shows changes in real-time across all panels.

### Monitor: Two tools, not one

claude-monitor tracks token burn rate (resource management). ccm tracks session status (agent management). Different concerns, different tools.

### Shell: Starship over Oh My Zsh themes

Oh My Zsh themes are slow. Starship is written in Rust and renders instantly. In a multi-split layout, every millisecond of prompt delay is visible.

### Navigation: zoxide + fzf

Together they eliminate `cd ../../../` forever. zoxide learns your paths, fzf finds everything else.

---

## Multi-Agent Architecture

```
                     cmux
                   /   |   \
                  /    |    \
           Pane 1    Pane 2    Pane 3
             |         |         |
        Claude Code  Claude    Lazygit
             |       Code        |
        Worktree 1  Worktree 2  Main repo
             |         |         |
        feature/A   feature/B   (monitors all)

        (any pane can run `herdr` first, so the
         agent inside it survives disconnects)
```

Each agent operates in isolation via git worktrees. They share the same repository history but work on different branches in different directories. Lazygit in the main repo sees changes from all worktrees.

---

## File Structure

```
dendrite/
+-- install.sh              # One-command installer
+-- configs/
|   +-- ghostty/config      # Terminal config (cmux + Ghostty)
|   +-- cmux/cmux.json      # cmux app config
|   +-- lazygit/config.yml  # Git TUI config
|   +-- starship/starship.toml  # Prompt config
+-- docs/
|   +-- getting-started.md  # First-time setup
|   +-- tools.md            # Deep dive per tool
|   +-- keybindings.md      # All shortcuts
|   +-- architecture.md     # This file
+-- .claude/
|   +-- skills/dendrite-mentor/skill.md  # Interactive learning
|   +-- agents/dendrite-coach.md         # Teaching agent
+-- LICENSE
+-- README.md
```
