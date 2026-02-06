# Tool Guide

Deep dive into each tool in the Dendrite stack and why it was chosen.

---

## Terminal: Ghostty

**Why Ghostty over iTerm2/Kitty/Alacritty?**

- GPU-accelerated rendering via Metal (macOS native)
- Built-in splits without tmux or zellij
- Plain text config (`key = value`)
- Created by Mitchell Hashimoto (HashiCorp founder)
- Lightweight (~50MB vs iTerm2 ~200MB)

**Config location:** `~/.config/ghostty/config`

**Key feature for agents:** Native splits let you run 2-3 Claude Code instances side by side with one keypress to navigate between them.

---

## Editor: Neovim + LazyVim

**Why Neovim over VS Code/Cursor?**

- Runs in the terminal (stays in Ghostty)
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
