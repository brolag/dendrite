---
name: dendrite-mentor
description: Interactive terminal mentor that teaches users the Dendrite TUI stack step by step. Use when user says "/dendrite", "teach me dendrite", or "how do I use this stack"
trigger: /dendrite
allowed-tools: Read, Bash, Glob, Grep
---

# Dendrite Mentor

Interactive skill that teaches the Dendrite TUI stack through hands-on exercises.

## Activation

When the user triggers this skill, present the lesson menu:

```
  DENDRITE MENTOR
  ══════════════════════════════════

  Choose a lesson:

  1. Ghostty Basics       - Splits, tabs, navigation
  2. Shell Power-ups      - fzf, zoxide, starship, aliases
  3. Lazygit              - Visual git in the terminal
  4. Neovim Essentials    - Navigate, edit, review
  5. Multi-Agent Setup    - Worktrees + parallel agents
  6. Monitoring           - claude-monitor + ccm
  7. Full Workflow         - Put it all together

  Type a number to start, or "q" to quit.
```

## Lesson Structure

Each lesson follows this pattern:

1. **Explain** (2-3 sentences max)
2. **Show** (the exact command or keybinding)
3. **Practice** (ask user to try it)
4. **Verify** (check if it worked)
5. **Next** (move to next concept)

## Lesson 1: Ghostty Basics

### 1.1 Creating Splits

Explain: Ghostty has built-in splits. No tmux needed.

```
Try this now:

  Cmd + Shift + Right    (creates a split to the right)
  Cmd + Left             (go back to the left split)
  Cmd + Shift + Down     (creates a split below)
```

Ask: "Did you see three panels? Type 'yes' to continue."

### 1.2 Navigating Splits

```
Navigate between your 3 splits:

  Cmd + Right      (go right)
  Cmd + Left       (go left)
  Cmd + Up         (go up)
  Cmd + Down       (go down)
```

### 1.3 Resizing and Equalizing

```
Resize a split:

  Cmd + Ctrl + Right     (make wider)
  Cmd + Ctrl + Left      (make narrower)
  Cmd + Shift + E        (equalize all splits)
```

### 1.4 Closing Splits

```
Close a split:

  Cmd + Shift + W
```

## Lesson 2: Shell Power-ups

### 2.1 Starship Prompt

Explain: Your prompt now shows git branch, language versions, and command duration.

```
Look at your prompt. You should see:

  ~/Sites/dendrite on  main >

The purple text is your git branch. The ">" is your prompt character.
```

### 2.2 Fuzzy Finding with fzf

```
Try these:

  Ctrl + R       Search your command history (type to filter)
  Ctrl + T       Find any file (type partial name)
  Alt + C        Jump to any directory
```

### 2.3 Smart Navigation with zoxide

```
Try this:

  z dendrite     (jumps to ~/Sites/dendrite from anywhere)

zoxide learns. The more you visit a directory, the higher it ranks.
```

### 2.4 Modern CLI

```
Try the aliases:

  ll             (eza with icons and git status)
  cat README.md  (bat with syntax highlighting)
```

## Lesson 3: Lazygit

### 3.1 Opening Lazygit

```
Run: lg (or lazygit)

You'll see 5 panels: Status, Files, Branches, Commits, Diff.
```

### 3.2 Basic Navigation

```
Tab           Switch panels
j / k         Move up/down
Enter         Expand/view details
Space         Stage/unstage a file
q             Quit
```

### 3.3 Making a Commit

```
1. Navigate to Files panel
2. Space to stage files
3. c to start commit
4. Type message and Enter
```

## Lesson 4: Neovim Essentials

### 4.1 Opening Files

```
nvim .                    Open current directory
Space + f + f             Find files (fuzzy)
Space + f + g             Search in files (grep)
```

### 4.2 Navigation

```
s + 2 chars               Flash jump to any word
Space + e                 File explorer
- (dash)                  Oil file manager
```

### 4.3 Reviewing Agent Changes

```
Space + g + g             Open lazygit inside Neovim
Space + g + d             Diff view
]h / [h                   Next/prev git hunk
```

## Lesson 5: Multi-Agent Setup

### 5.1 Creating Worktrees

```
wt-new auth               Create worktree for auth feature
wt-new api                Create worktree for API feature
wt-list                   See both worktrees
```

### 5.2 The 4-Panel Layout

```
1. Cmd+Shift+Right         Split right
2. Cmd+Left                Go left
3. Cmd+Shift+Down          Split below-left
4. Cmd+Right               Go right
5. Cmd+Shift+Down          Split below-right
```

### 5.3 Start Agents

```
Panel 1: cd .worktrees/auth && claude
Panel 2: cd .worktrees/api && claude
Panel 3: lazygit
Panel 4: claude-monitor
```

## Lesson 6: Monitoring

### 6.1 Token Monitoring

```
Run: cm (or claude-monitor)

Shows: burn rate, predictions, limits.
```

### 6.2 Session Monitoring

```
Run: ccm

Shows: all active Claude Code sessions, status, messages.
```

## Lesson 7: Full Workflow

Walk through a complete multi-agent task from start to finish:

1. Create worktrees for 2 independent features
2. Open 4-panel layout in Ghostty
3. Start agents with clear task descriptions
4. Monitor progress in Lazygit
5. Review changes in Neovim
6. Merge when complete
7. Clean up worktrees

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Keybindings don't work | Ghostty loaded old config | Quit and reopen Ghostty (Cmd+Q) |
| Starship not showing | Shell not sourced | Run `source ~/.zshrc` |
| claude-monitor crashes | Too many JSONL files | Use `NODE_OPTIONS="--max-old-space-size=8192"` |
| zoxide doesn't jump | Not enough history | Use `cd` normally for a few days, then try `z` |
| fzf Ctrl+R empty | New shell | Use the shell more, history will build |

**Fallback**: If any tool fails, check `docs/getting-started.md` troubleshooting section or reinstall with `./install.sh`.
