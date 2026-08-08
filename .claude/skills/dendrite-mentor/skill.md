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

  1. cmux Basics          - Workspaces, panes, notifications
  2. Shell Power-ups      - fzf, zoxide, starship, aliases
  3. Lazygit              - Visual git in the terminal
  4. Neovim Essentials    - Navigate, edit, review
  5. Multi-Agent Setup    - Worktrees + parallel agents
  6. Persistent Sessions  - herdr, agents that survive
  7. Monitoring           - claude-monitor + ccm
  8. Full Workflow         - Put it all together

  Type a number to start, or "q" to quit.
```

## Lesson Structure

Each lesson follows this pattern:

1. **Explain** (2-3 sentences max)
2. **Show** (the exact command or keybinding)
3. **Practice** (ask user to try it)
4. **Verify** (check if it worked)
5. **Next** (move to next concept)

## Lesson 1: cmux Basics

### 1.1 One Workspace Per Task

Explain: cmux is a Ghostty-based terminal built for agents. A workspace is one task, and the sidebar shows its branch, PR and ports.

```
Try this now:

  Cmd + N          (new workspace)
  Cmd + O          (open the folder you want to work in)
  Cmd + 1          (jump back to the first workspace)
```

Ask: "Do you see both workspaces in the left sidebar? Type 'yes' to continue."

### 1.2 Creating Panes

```
Split the workspace:

  Cmd + D                (split right)
  Cmd + Shift + D        (split down)
```

### 1.3 Navigating Panes

```
Move between panes:

  Opt + Cmd + Right      (focus right)
  Opt + Cmd + Left       (focus left)
  Opt + Cmd + Up         (focus up)
  Opt + Cmd + Down       (focus down)
  Cmd + Shift + Enter    (zoom the focused pane)
```

### 1.4 Notifications

Explain: this is the reason cmux is in the stack. You do not have to watch panes.

```
When an agent finishes or asks a question, its pane rings.

  Cmd + I                (open notifications)
  Cmd + Shift + U        (jump to the latest unread)
```

### 1.5 Closing

```
Close a tab:         Cmd + W
Close a workspace:   Cmd + Shift + W
```

Note: if the user runs plain Ghostty instead of cmux, use `Cmd+Shift+Right` / `Cmd+Shift+Down` to split, `Cmd+Arrow` to navigate, and skip the workspace and notification steps.

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

### 5.2 The 4-Pane Layout

```
1. Cmd+N                   New workspace for the task
2. Cmd+D                   Split right
3. Cmd+Shift+D             Split below-left
4. Opt+Cmd+Right           Focus right
5. Cmd+Shift+D             Split below-right
```

### 5.3 Start Agents

```
Pane 1: cd .worktrees/auth && claude
Pane 2: cd .worktrees/api && claude
Pane 3: lazygit
Pane 4: claude-monitor
```

## Lesson 6: Persistent Sessions

### 6.1 Why herdr

Explain: a terminal window dies with the app. herdr runs a background server that owns the panes, so agents keep working through sleep, SSH drops and closed windows.

```
Run: herdr

You are now inside the default session. The prefix is Ctrl+B.
```

### 6.2 Panes Inside herdr

```
Ctrl+B then v      Split pane right
Ctrl+B then -      Split pane down
Ctrl+B then c      New tab
Ctrl+B then ?      Show every binding
```

### 6.3 Detach and Reattach

```
Ctrl+B then q      Detach (agents keep running)
herdr              Reattach where you left off
```

Ask: "Start a long command, detach, then reattach. Is it still running?"

### 6.4 Inspecting Sessions

```
herdr session list         All sessions
herdr agent list           Which agents are working, blocked or idle
herdr status               Runtime state
```

## Lesson 7: Monitoring

### 7.1 Token Monitoring

```
Run: cm (or claude-monitor)

Shows: burn rate, predictions, limits.
```

### 7.2 Session Monitoring

```
Run: ccm

Shows: all active Claude Code sessions, status, messages.
```

## Lesson 8: Full Workflow

Walk through a complete multi-agent task from start to finish:

1. Create worktrees for 2 independent features
2. Open a cmux workspace and split it into 4 panes
3. Start agents with clear task descriptions (inside herdr if the task is long)
4. Monitor progress in Lazygit, let cmux notifications tell you who is blocked
5. Review changes in Neovim
6. Merge when complete
7. Clean up worktrees

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| cmux shortcuts don't work | Config not reloaded | `Cmd+Shift+,` or `cmux reload-config` |
| cmux font/theme wrong | Reads Ghostty config | Fix `~/.config/ghostty/config` |
| herdr can't attach | Server not running | `herdr status`, then `herdr server` |
| Keybindings don't work | Ghostty loaded old config | Quit and reopen Ghostty (Cmd+Q) |
| Starship not showing | Shell not sourced | Run `source ~/.zshrc` |
| claude-monitor crashes | Too many JSONL files | Use `NODE_OPTIONS="--max-old-space-size=8192"` |
| zoxide doesn't jump | Not enough history | Use `cd` normally for a few days, then try `z` |
| fzf Ctrl+R empty | New shell | Use the shell more, history will build |

**Fallback**: If any tool fails, check `docs/getting-started.md` troubleshooting section or reinstall with `./install.sh`.
