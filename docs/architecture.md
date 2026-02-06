# Architecture

Why these tools, why this way.

---

## Design Principles

### 1. Terminal-native

Everything runs in the terminal. No browser tabs, no Electron apps, no context switching. Your hands stay on the keyboard.

### 2. Opinionated defaults

Every tool is pre-configured to work with every other tool. You don't need to spend hours figuring out how to make fzf work with zsh or how to set up Ghostty splits.

### 3. Respect existing setup

The installer backs up your configs before changing anything. If you already have Neovim configured, it won't touch it.

### 4. One tool per job

No redundancy. One terminal, one editor, one git TUI, one prompt. Each tool is the best at what it does.

---

## The Stack Layers

```
+─────────────────────────────────────────+
|            Terminal Layer                |
|  Ghostty (splits, tabs, GPU rendering)  |
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

### Terminal: Ghostty over iTerm2

iTerm2 is great but Ghostty is faster (Metal GPU), lighter, and has a text config that can be version controlled. For multi-agent work, native splits without tmux reduce complexity.

### Editor: Neovim over VS Code

In an agent-driven workflow, the editor is for reviewing changes, not writing code. Neovim in a Ghostty split lets you review diffs without leaving the terminal. VS Code would require a separate window.

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
                    Ghostty
                   /   |   \
                  /    |    \
          Split 1   Split 2   Split 3
             |         |         |
        Claude Code  Claude    Lazygit
             |       Code        |
        Worktree 1  Worktree 2  Main repo
             |         |         |
        feature/A   feature/B   (monitors all)
```

Each agent operates in isolation via git worktrees. They share the same repository history but work on different branches in different directories. Lazygit in the main repo sees changes from all worktrees.

---

## File Structure

```
dendrite/
+-- install.sh              # One-command installer
+-- configs/
|   +-- ghostty/config      # Terminal config
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
