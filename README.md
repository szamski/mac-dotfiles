# Dotfiles

Konfiguracja srodowiska macOS - ZSH + Oh My Zsh, Ghostty, Neovim (LazyVim), Starship prompt. Motyw: **TokyoNight**.

## Szybki start

```bash
git clone https://github.com/TWOJ_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Co zostanie zainstalowane

### Narzedzia CLI (via Homebrew)

| Narzedzie | Opis |
|-----------|------|
| `bat` | Lepszy `cat` z syntax highlighting |
| `btop` | Monitor zasobow |
| `dust` | Lepszy `du` |
| `eza` | Lepszy `ls` z ikonami |
| `fd` | Lepszy `find` |
| `fzf` | Fuzzy finder |
| `gh` | GitHub CLI |
| `gum` | Narzedzie do ladnych skryptow |
| `lazygit` | TUI dla gita |
| `mise` | Manager wersji (Node, Python, etc.) |
| `neovim` | Edytor |
| `ripgrep` | Lepszy `grep` |
| `starship` | Prompt |
| `tldr` | Uproszczone man pages |
| `zoxide` | Lepszy `cd` (uczy sie Twoich sciezek) |

### Aplikacje (via Homebrew Cask)

- **Ghostty** - terminal
- **Docker Desktop**
- **VS Code**
- **JetBrainsMono Nerd Font**

### Shell

- **Oh My Zsh** z pluginami: syntax-highlighting, autosuggestions, fzf, zoxide, eza, mise
- **Starship** prompt (motyw TokyoNight)

### Neovim

- **LazyVim** z extras: TypeScript, Python, JSON, Markdown, Claude Code, Neo-tree
- Motyw **TokyoNight Night** z przezroczystym tlem
- Wymagany font: JetBrainsMono Nerd Font

### Ghostty

- Font: JetBrainsMono Nerd Font 13pt
- Motyw: TokyoNight z przezroczystym tlem (90% opacity + blur)
- Shader kursora (cursor_warp)
- Splity: `Cmd+D` / `Cmd+Shift+D`, nawigacja: `Cmd+Opt+strzalki`

## Struktura

```
dotfiles/
├── install.sh              # Skrypt instalacyjny
├── zsh/.zshrc              # Konfiguracja ZSH
├── git/.gitconfig          # Git (EDYTUJ name i email!)
├── ghostty/config          # Konfiguracja Ghostty
├── starship/starship.toml  # Konfiguracja Starship
└── nvim/                   # Konfiguracja Neovim (LazyVim)
    ├── init.lua
    ├── lazyvim.json
    ├── lua/config/
    ├── lua/plugins/
    └── plugin/after/
```

## Po instalacji

1. **Edytuj `~/.gitconfig`** - ustaw swoje imie i email
2. **Zrestartuj terminal** lub `source ~/.zshrc`
3. **Otworz `nvim`** - pluginy zainstaluja sie automatycznie przy pierwszym uruchomieniu
4. **Zainstaluj wersje jezykow** (opcjonalnie):
   ```bash
   mise use --global node@lts python@3.12
   ```

## Przydatne aliasy

| Alias | Komenda |
|-------|---------|
| `n` | `nvim` (bez argumentu otwiera `.`) |
| `gs` | `git status -sb` |
| `glog` | `git log --oneline --graph --decorate -20` |
| `d` | `docker` |
| `ff` | `fzf` z podgladem `bat` |
| `eff` | Otworz wybrany plik w `$EDITOR` |
| `mkcd dir` | `mkdir -p` + `cd` |
| `port 3000` | Pokaz co uzywa portu |
| `compress dir` | Skompresuj do `.tar.gz` |
