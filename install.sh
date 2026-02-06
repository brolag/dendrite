#!/bin/bash
#
# Dendrite - Opinionated TUI Stack Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/brolag/dendrite/main/install.sh | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Config
DENDRITE_VERSION="0.1.0"
DENDRITE_DIR="${DENDRITE_ROOT:-$HOME/Sites/dendrite}"
REPO_URL="https://github.com/brolag/dendrite.git"

# ─────────────────────────────────────────
# Header
# ─────────────────────────────────────────

echo ""
echo -e "${MAGENTA}"
echo '   ____  _____ _   _ ____  ____  ___ _____ _____'
echo '  |  _ \| ____| \ | |  _ \|  _ \|_ _|_   _| ____|'
echo '  | | | |  _| |  \| | | | | |_) || |  | | |  _|'
echo '  | |_| | |___| |\  | |_| |  _ < | |  | | | |___'
echo '  |____/|_____|_| \_|____/|_| \_\___| |_| |_____|'
echo -e "${RESET}"
echo ""
echo -e "${BOLD}  D E N D R I T E  ${DIM}v${DENDRITE_VERSION}${RESET}"
echo -e "${DIM}  The opinionated TUI stack for agentic coding${RESET}"
echo -e "${DIM}  https://github.com/brolag/dendrite${RESET}"
echo ""

# ─────────────────────────────────────────
# Helper functions
# ─────────────────────────────────────────

info()    { echo -e "  ${BLUE}>${RESET} $1"; }
success() { echo -e "  ${GREEN}+${RESET} $1"; }
warn()    { echo -e "  ${YELLOW}!${RESET} $1"; }
error()   { echo -e "  ${RED}x${RESET} $1"; }
step()    { echo -e "\n${BOLD}[$1/$TOTAL_STEPS] $2${RESET}\n"; }

check_installed() {
    command -v "$1" &> /dev/null
}

backup_config() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.dendrite-backup.$(date +%Y%m%d%H%M%S)"
        cp "$file" "$backup"
        warn "Backed up $(basename "$file") -> $(basename "$backup")"
    fi
}

TOTAL_STEPS=7

# Tools to skip (populated by interactive selection)
SKIP_TOOLS=""

# ─────────────────────────────────────────
# Step 1: Check prerequisites
# ─────────────────────────────────────────

step 1 "Checking prerequisites"

if ! check_installed brew; then
    error "Homebrew is required. Install it first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
success "Homebrew found"

if ! check_installed git; then
    error "Git is required."
    exit 1
fi
success "Git found"

# Detect OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "Dendrite currently supports macOS only."
    exit 1
fi
success "macOS detected"

# ─────────────────────────────────────────
# Step 2: Clone or update Dendrite repo
# ─────────────────────────────────────────

step 2 "Setting up Dendrite"

if [ -d "$DENDRITE_DIR/.git" ]; then
    info "Updating existing installation..."
    cd "$DENDRITE_DIR"
    git pull origin main 2>/dev/null || true
    success "Updated to latest version"
else
    info "Cloning repository..."
    mkdir -p "$(dirname "$DENDRITE_DIR")"
    git clone "$REPO_URL" "$DENDRITE_DIR" 2>/dev/null || {
        # If repo doesn't exist yet, just use current directory
        if [ -f "./install.sh" ]; then
            DENDRITE_DIR="$(pwd)"
            warn "Using local directory"
        else
            error "Could not clone repository"
            exit 1
        fi
    }
    success "Repository ready"
fi

cd "$DENDRITE_DIR"

# ─────────────────────────────────────────
# Tool selection (interactive)
# ─────────────────────────────────────────

should_skip() {
    echo "$SKIP_TOOLS" | grep -qw "$1"
}

if [ -t 0 ]; then
    echo ""
    echo -e "  ${BOLD}Tool selection${RESET}"
    echo ""
    read -p "  Install all tools or choose individually? [A/c]: " selection_mode
    if [[ "$selection_mode" =~ ^[cC]$ ]]; then
        echo ""
        info "Select which tools to install (Enter = Yes):"
        echo ""

        # Core tools
        ALL_SEL_NAMES=(ghostty  nvim     lazygit  starship fzf      zoxide   eza      bat      fd  rg)
        ALL_SEL_DESCS=("Ghostty - Terminal emulator" "Neovim - Editor" "Lazygit - Git TUI" "Starship - Shell prompt" "Fzf - Fuzzy finder" "Zoxide - Smart cd" "Eza - Modern ls" "Bat - Modern cat" "Fd - Modern find" "Ripgrep - Code search")

        # Monitoring tools
        ALL_SEL_NAMES+=(claude-monitor ccm)
        ALL_SEL_DESCS+=("Claude Monitor - Token tracking" "CCM - Claude Code Monitor")

        j=0
        while [ $j -lt ${#ALL_SEL_NAMES[@]} ]; do
            read -p "  Install ${ALL_SEL_DESCS[$j]}? [Y/n]: " tool_choice
            if [[ "$tool_choice" =~ ^[nN]$ ]]; then
                SKIP_TOOLS="$SKIP_TOOLS ${ALL_SEL_NAMES[$j]}"
            fi
            j=$((j + 1))
        done
        echo ""
    fi
else
    info "Non-interactive mode detected — installing all tools"
fi

# ─────────────────────────────────────────
# Step 3: Install core tools
# ─────────────────────────────────────────

step 3 "Installing core tools"

# Parallel arrays (Bash 3.x compatible - no associative arrays)
TOOL_CMDS=(ghostty   nvim    lazygit  starship  fzf      zoxide    eza       bat       fd   rg)
TOOL_PKGS=(ghostty   neovim  lazygit  starship  fzf      zoxide    eza       bat       fd   ripgrep)
TOOL_TYPES=(cask     formula formula  formula   formula  formula   formula   formula   formula formula)
TOOL_DESCS=("Terminal emulator" "Editor" "Git TUI" "Shell prompt" "Fuzzy finder" "Smart cd" "Modern ls" "Modern cat" "Modern find" "Code search")

installed_count=0
skipped_count=0

i=0
while [ $i -lt ${#TOOL_CMDS[@]} ]; do
    cmd="${TOOL_CMDS[$i]}"
    pkg="${TOOL_PKGS[$i]}"
    type="${TOOL_TYPES[$i]}"
    desc="${TOOL_DESCS[$i]}"

    if should_skip "$cmd"; then
        warn "$desc ($cmd) - skipped by user"
        skipped_count=$((skipped_count + 1))
    elif check_installed "$cmd"; then
        success "$desc ($cmd) - already installed"
        skipped_count=$((skipped_count + 1))
    else
        info "Installing $desc ($pkg)..."
        if [ "$type" = "cask" ]; then
            brew install --cask "$pkg" 2>/dev/null || warn "Failed to install $pkg (install manually)"
        else
            brew install "$pkg" 2>/dev/null || warn "Failed to install $pkg"
        fi

        if check_installed "$cmd"; then
            success "$desc ($cmd) - installed"
            installed_count=$((installed_count + 1))
        else
            warn "$desc ($cmd) - install manually"
        fi
    fi
    i=$((i + 1))
done

echo ""
info "Installed: $installed_count | Already had: $skipped_count"

# ─────────────────────────────────────────
# Step 4: Install monitoring tools
# ─────────────────────────────────────────

step 4 "Installing monitoring tools"

# claude-monitor (Python/uv)
if should_skip "claude-monitor"; then
    warn "claude-monitor - skipped by user"
elif check_installed claude-monitor; then
    success "claude-monitor - already installed"
else
    if ! check_installed uv; then
        info "Installing uv package manager..."
        brew install uv 2>/dev/null || true
    fi

    if check_installed uv; then
        info "Installing claude-monitor..."
        uv tool install claude-monitor 2>/dev/null || warn "Failed to install claude-monitor"
        success "claude-monitor - installed"
    else
        warn "claude-monitor - install manually: uv tool install claude-monitor"
    fi
fi

# ccm (Node)
if should_skip "ccm"; then
    warn "ccm (claude-code-monitor) - skipped by user"
elif check_installed ccm; then
    success "ccm (claude-code-monitor) - already installed"
else
    if check_installed npm; then
        info "Installing ccm..."
        npm install -g claude-code-monitor 2>/dev/null || warn "Failed to install ccm"
        success "ccm - installed"
    else
        warn "ccm - install manually: npm install -g claude-code-monitor"
    fi
fi

# ─────────────────────────────────────────
# Step 5: Apply configurations
# ─────────────────────────────────────────

step 5 "Applying configurations"

# Ghostty config
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
if [ -f "$DENDRITE_DIR/configs/ghostty/config" ]; then
    mkdir -p "$HOME/.config/ghostty"
    if [ -f "$GHOSTTY_CONFIG" ]; then
        echo ""
        info "Existing Ghostty config found."
        read -p "  Overwrite? (y/N/merge): " ghostty_choice
        case "$ghostty_choice" in
            y|Y)
                backup_config "$GHOSTTY_CONFIG"
                cp "$DENDRITE_DIR/configs/ghostty/config" "$GHOSTTY_CONFIG"
                success "Ghostty config applied"
                ;;
            m|merge)
                backup_config "$GHOSTTY_CONFIG"
                cat "$DENDRITE_DIR/configs/ghostty/config" >> "$GHOSTTY_CONFIG"
                success "Ghostty config merged"
                ;;
            *)
                warn "Ghostty config skipped"
                ;;
        esac
    else
        cp "$DENDRITE_DIR/configs/ghostty/config" "$GHOSTTY_CONFIG"
        success "Ghostty config applied"
    fi
fi

# Starship config
STARSHIP_CONFIG="$HOME/.config/starship.toml"
if [ -f "$DENDRITE_DIR/configs/starship/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    if [ -f "$STARSHIP_CONFIG" ]; then
        backup_config "$STARSHIP_CONFIG"
    fi
    cp "$DENDRITE_DIR/configs/starship/starship.toml" "$STARSHIP_CONFIG"
    success "Starship config applied"
fi

# Lazygit config
LAZYGIT_CONFIG="$HOME/Library/Application Support/lazygit/config.yml"
if [ -f "$DENDRITE_DIR/configs/lazygit/config.yml" ]; then
    mkdir -p "$HOME/Library/Application Support/lazygit"
    if [ -f "$LAZYGIT_CONFIG" ]; then
        backup_config "$LAZYGIT_CONFIG"
    fi
    cp "$DENDRITE_DIR/configs/lazygit/config.yml" "$LAZYGIT_CONFIG"
    success "Lazygit config applied"
fi

# Neovim / LazyVim config (Dendrite theme)
NVIM_CONFIG="$HOME/.config/nvim"
if [ -d "$DENDRITE_DIR/configs/nvim" ] && ! should_skip "nvim"; then
    if [ -d "$NVIM_CONFIG" ]; then
        echo ""
        info "Existing Neovim config found."
        nvim_choice="y"
        if [ -t 0 ]; then
            read -p "  Apply Dendrite theme? (Y/n): " nvim_choice
            nvim_choice="${nvim_choice:-y}"
        fi
        case "$nvim_choice" in
            n|N)
                warn "Neovim theme skipped"
                ;;
            *)
                backup_config "$NVIM_CONFIG/init.lua"
                mkdir -p "$NVIM_CONFIG/lua/plugins"
                cp "$DENDRITE_DIR/configs/nvim/lua/plugins/dendrite-theme.lua" "$NVIM_CONFIG/lua/plugins/"
                success "Dendrite theme applied to existing Neovim config"
                ;;
        esac
    else
        info "Setting up Neovim with LazyVim + Dendrite theme..."
        mkdir -p "$NVIM_CONFIG/lua/config"
        mkdir -p "$NVIM_CONFIG/lua/plugins"
        cp "$DENDRITE_DIR/configs/nvim/init.lua" "$NVIM_CONFIG/"
        cp "$DENDRITE_DIR/configs/nvim/lua/config/"*.lua "$NVIM_CONFIG/lua/config/"
        cp "$DENDRITE_DIR/configs/nvim/lua/plugins/"*.lua "$NVIM_CONFIG/lua/plugins/"
        success "Neovim configured with LazyVim + Dendrite theme"
        info "Plugins will install on first launch of nvim"
    fi
fi

# ─────────────────────────────────────────
# Step 6: Configure shell
# ─────────────────────────────────────────

step 6 "Configuring shell"

SHELL_RC="$HOME/.zshrc"
if [ ! -f "$SHELL_RC" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

DENDRITE_BLOCK="# ── Dendrite TUI Stack ──"

if ! grep -q "$DENDRITE_BLOCK" "$SHELL_RC" 2>/dev/null; then
    info "Adding Dendrite config to $(basename "$SHELL_RC")..."
    cat >> "$SHELL_RC" << 'DENDRITE_EOF'

# ── Dendrite TUI Stack ──
# https://github.com/brolag/dendrite

# Starship prompt
eval "$(starship init zsh)" 2>/dev/null

# Zoxide (smart cd)
eval "$(zoxide init zsh)" 2>/dev/null

# Fzf keybindings and completion
source <(fzf --zsh) 2>/dev/null

# Aliases
alias ls="eza --icons" 2>/dev/null
alias ll="eza -la --icons --git" 2>/dev/null
alias cat="bat --style=plain" 2>/dev/null
alias lg="lazygit"
alias cm="claude-monitor"

# Git worktree helpers
wt-new() {
    local name="$1"
    if [ -z "$name" ]; then
        echo "Usage: wt-new <feature-name>"
        return 1
    fi
    mkdir -p .worktrees
    git worktree add ".worktrees/$name" -b "feature/$name"
    echo "Worktree created: .worktrees/$name (branch: feature/$name)"
}

wt-list() {
    git worktree list
}

wt-rm() {
    local name="$1"
    if [ -z "$name" ]; then
        echo "Usage: wt-rm <feature-name>"
        return 1
    fi
    git worktree remove ".worktrees/$name"
    echo "Worktree removed: $name"
}

# ── End Dendrite ──
DENDRITE_EOF
    success "Shell configured"
else
    warn "Dendrite block already in $(basename "$SHELL_RC")"
fi

# ─────────────────────────────────────────
# Step 7: Verify installation
# ─────────────────────────────────────────

step 7 "Verifying installation"

echo ""
printf "  ${BOLD}%-20s %-12s %-10s${RESET}\n" "Tool" "Status" "Command"
printf "  %-20s %-12s %-10s\n" "────────────────────" "────────────" "──────────"

verify_tool() {
    local name="$1"
    local cmd="$2"
    if check_installed "$cmd"; then
        printf "  %-20s ${GREEN}%-12s${RESET} %-10s\n" "$name" "installed" "$cmd"
    else
        printf "  %-20s ${RED}%-12s${RESET} %-10s\n" "$name" "missing" "$cmd"
    fi
}

verify_tool "Ghostty" "ghostty"
verify_tool "Neovim" "nvim"
verify_tool "Lazygit" "lazygit"
verify_tool "Starship" "starship"
verify_tool "Fzf" "fzf"
verify_tool "Zoxide" "zoxide"
verify_tool "Eza" "eza"
verify_tool "Bat" "bat"
verify_tool "Fd" "fd"
verify_tool "Ripgrep" "rg"
verify_tool "Claude Monitor" "claude-monitor"
verify_tool "CCM" "ccm"

# ─────────────────────────────────────────
# Done
# ─────────────────────────────────────────

echo ""
echo -e "${MAGENTA}${BOLD}  ══════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  Dendrite installed successfully.${RESET}"
echo -e "${MAGENTA}${BOLD}  ══════════════════════════════════════════════${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo ""
echo "  1. Restart your terminal (or run: source $SHELL_RC)"
echo "  2. Open Ghostty"
echo "  3. Try the multi-agent layout:"
echo ""
echo "     Cmd+Shift+Right    Split right"
echo "     Cmd+Shift+Down     Split down"
echo "     Cmd+Arrow           Navigate splits"
echo ""
echo "  4. In each split:"
echo ""
echo "     Split 1:  claude             # Agent 1"
echo "     Split 2:  claude             # Agent 2"
echo "     Split 3:  lazygit            # Git monitoring"
echo "     Split 4:  claude-monitor     # Token tracking"
echo ""
echo -e "  ${BOLD}Useful aliases:${RESET}"
echo ""
echo "     lg           lazygit"
echo "     cm           claude-monitor"
echo "     ll           eza -la with icons"
echo "     wt-new X     create git worktree"
echo "     wt-list      list worktrees"
echo "     wt-rm X      remove worktree"
echo ""
echo -e "  ${BOLD}Docs:${RESET} https://github.com/brolag/dendrite"
echo ""
