#!/bin/bash
set -e

# ============================================================================
# Dotfiles Installer
# ============================================================================
# Ustawia srodowisko macOS: Homebrew, narzedzia CLI, zsh, Ghostty, Neovim,
# Starship prompt - wszystko w stylu TokyoNight.
#
# Uzycie:
#   ./install.sh            # Normalna instalacja
#   ./install.sh --dry-run  # Tylko pokaz co zostanie zrobione (bez zmian)
# ============================================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false

if [[ "$1" == "--dry-run" || "$1" == "-n" ]]; then
    DRY_RUN=true
fi

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
dry()     { echo -e "${CYAN}[DRY-RUN]${NC} $1"; }

run() {
    if $DRY_RUN; then
        dry "$*"
    else
        "$@"
    fi
}

backup_and_link() {
    local src="$1"
    local dst="$2"

    if $DRY_RUN; then
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            dry "Backup: $dst -> $BACKUP_DIR/"
        fi
        dry "Symlink: $dst -> $src"
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -rL "$dst" "$BACKUP_DIR/" 2>/dev/null || true
        rm -rf "$dst"
        warn "Backup starego pliku: $dst -> $BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    success "Symlink: $dst -> $src"
}

# ============================================================================
echo ""
echo -e "${BLUE}========================================${NC}"
if $DRY_RUN; then
echo -e "${CYAN}  Dotfiles Installer (DRY RUN)          ${NC}"
echo -e "${CYAN}  Nic nie zostanie zmienione!           ${NC}"
else
echo -e "${BLUE}  Dotfiles Installer                    ${NC}"
fi
echo -e "${BLUE}========================================${NC}"
echo ""

# ============================================================================
# 1. Homebrew
# ============================================================================
info "Sprawdzam Homebrew..."
if ! command -v brew &>/dev/null; then
    if $DRY_RUN; then
        dry "Zainstalowalbym Homebrew"
    else
        info "Instaluje Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        success "Homebrew zainstalowany"
    fi
else
    success "Homebrew juz zainstalowany"
fi

# ============================================================================
# 2. Pakiety Homebrew (formulae)
# ============================================================================
info "Instaluje narzedzia CLI..."

FORMULAE=(
    bat
    btop
    dust
    eza
    fd
    fzf
    gh
    git
    gum
    lazygit
    mise
    neovim
    ripgrep
    starship
    tldr
    zoxide
)

for pkg in "${FORMULAE[@]}"; do
    if command -v brew &>/dev/null && brew list "$pkg" &>/dev/null; then
        success "$pkg juz zainstalowany"
    else
        if $DRY_RUN; then
            dry "brew install $pkg"
        else
            info "Instaluje $pkg..."
            brew install "$pkg"
            success "$pkg zainstalowany"
        fi
    fi
done

# ============================================================================
# 3. Casks (aplikacje GUI)
# ============================================================================
info "Instaluje aplikacje..."

CASKS=(
    ghostty
    docker-desktop
    visual-studio-code
)

for cask in "${CASKS[@]}"; do
    if command -v brew &>/dev/null && brew list --cask "$cask" &>/dev/null; then
        success "$cask juz zainstalowany"
    else
        if $DRY_RUN; then
            dry "brew install --cask $cask"
        else
            info "Instaluje $cask..."
            brew install --cask "$cask"
            success "$cask zainstalowany"
        fi
    fi
done

# ============================================================================
# 4. Font
# ============================================================================
info "Instaluje JetBrainsMono Nerd Font..."
if command -v brew &>/dev/null && brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    success "Font juz zainstalowany"
else
    if $DRY_RUN; then
        dry "brew install --cask font-jetbrains-mono-nerd-font"
    else
        brew install --cask font-jetbrains-mono-nerd-font
        success "Font zainstalowany"
    fi
fi

# ============================================================================
# 5. Oh My Zsh
# ============================================================================
info "Sprawdzam Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if $DRY_RUN; then
        dry "Zainstalowalbym Oh My Zsh"
    else
        info "Instaluje Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh zainstalowany"
    fi
else
    success "Oh My Zsh juz zainstalowany"
fi

# Pluginy ZSH
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    if $DRY_RUN; then
        dry "git clone zsh-syntax-highlighting -> $ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        info "Instaluje zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        success "zsh-syntax-highlighting zainstalowany"
    fi
else
    success "zsh-syntax-highlighting juz zainstalowany"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    if $DRY_RUN; then
        dry "git clone zsh-autosuggestions -> $ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        info "Instaluje zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        success "zsh-autosuggestions zainstalowany"
    fi
else
    success "zsh-autosuggestions juz zainstalowany"
fi

# ============================================================================
# 6. Symlinki konfiguracji
# ============================================================================
info "Tworzenie symlinkow..."

# ZSH
backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Git (kopiujemy zamiast symlinka - user musi ustawic swoje dane)
if [ ! -f "$HOME/.gitconfig" ]; then
    if $DRY_RUN; then
        dry "Skopiowalbym .gitconfig -> ~/.gitconfig (WYMAGA EDYCJI name/email!)"
    else
        cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
        warn "Skopiowano .gitconfig - EDYTUJ ~/.gitconfig i ustaw swoje name i email!"
    fi
else
    warn ".gitconfig juz istnieje - pomijam (sprawdz git/.gitconfig z tego repo na inspiracje)"
fi

# Starship
backup_and_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# Ghostty
backup_and_link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# Ghostty shaders
if [ ! -d "$HOME/.config/ghostty/shaders" ]; then
    if $DRY_RUN; then
        dry "git clone ghostty-shaders -> ~/.config/ghostty/shaders"
    else
        info "Klonuje ghostty-shaders..."
        git clone https://github.com/m-ahdal/ghostty-shaders.git "$HOME/.config/ghostty/shaders"
        success "Shadery Ghostty zainstalowane"
    fi
else
    success "Shadery Ghostty juz istnieja"
fi

# Neovim
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# ============================================================================
# 7. Bun
# ============================================================================
info "Sprawdzam Bun..."
if ! command -v bun &>/dev/null; then
    if $DRY_RUN; then
        dry "Zainstalowalbym Bun"
    else
        info "Instaluje Bun..."
        curl -fsSL https://bun.sh/install | bash
        success "Bun zainstalowany"
    fi
else
    success "Bun juz zainstalowany"
fi

# ============================================================================
# Gotowe!
# ============================================================================
echo ""
if $DRY_RUN; then
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  DRY RUN zakonczony                    ${NC}"
    echo -e "${CYAN}  Zadne zmiany nie zostaly wprowadzone  ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    echo -e "  Aby zainstalowac naprawde, uruchom:"
    echo -e "  ${YELLOW}./install.sh${NC}"
else
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Instalacja zakonczona!                ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "Nastepne kroki:"
    echo -e "  1. ${YELLOW}Edytuj ~/.gitconfig${NC} - ustaw swoje name i email"
    echo -e "  2. ${YELLOW}Zrestartuj terminal${NC} (lub: source ~/.zshrc)"
    echo -e "  3. ${YELLOW}Otworz nvim${NC} - pluginy zainstaluja sie automatycznie"
    echo -e "  4. ${YELLOW}Opcjonalnie zainstaluj mise${NC} - do zarzadzania wersjami Node, Python etc."
    echo -e "     mise use --global node@lts python@3.12"
    echo ""
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "  Backup starych plikow: ${BLUE}$BACKUP_DIR${NC}"
        echo ""
    fi
fi
