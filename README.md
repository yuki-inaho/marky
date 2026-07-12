<h1 align="center">
  <br>
   Marky
  <br>
</h1>

<h4 align="center">A fast, native markdown viewer for macOS and Linux built with <a href="https://v2.tauri.app">Tauri v2</a>, <a href="https://react.dev">React</a>, and <a href="https://github.com/markdown-it/markdown-it">markdown-it</a>. Beautiful rendering of tables, code blocks, task lists, math, and diagrams — with live reload.</h4>

<p align="center">
    <a href="https://github.com/yuki-inaho/marky/stargazers"><img src="https://img.shields.io/github/stars/yuki-inaho/marky" alt="Stars Badge"/></a>
    <a href="https://github.com/yuki-inaho/marky/network/members"><img src="https://img.shields.io/github/forks/yuki-inaho/marky" alt="Forks Badge"/></a>
</p>

<p align="center">
  <a href="https://youtu.be/nGBxt8uOVjc">View Demo</a> •
  <a href="#install">Install</a> •
  <a href="https://github.com/yuki-inaho/marky/issues">Request Features</a>
</p>

![Marky screenshot](assets/marky-img.png)

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
      </ul>
    </li>
    <li>
      <a href="#install">Install</a>
      <ul>
        <li><a href="#homebrew-macos">Homebrew (macOS)</a></li>
        <li><a href="#ubuntu--debian">Ubuntu / Debian</a></li>
        <li><a href="#appimage-linux">AppImage (Linux)</a></li>
        <li><a href="#from-source">From Source</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#keyboard-shortcuts">Keyboard Shortcuts</a></li>
    <li><a href="#development">Development</a></li>
    <li><a href="#built-with">Built With</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact-me">Contact Me</a></li>
  </ol>
</details>

## About The Project

Marky is a desktop markdown viewer designed for one thing: opening `.md` files from the terminal and getting beautiful, instant rendering. Launch it with `marky FILENAME` to view a file or `marky FOLDER` to open a folder as a persistent workspace (Obsidian-style). Files reload live as they change on disk — perfect for viewing Claude-generated plans, documentation, or notes as they're being written.

### Features

- **CLI-first** — `marky README.md` opens a window. `marky ./docs/` opens a folder.
- **Live reload** — edits on disk (from your editor, Claude, etc.) update the view instantly.
- **Folders** — add folders as persistent workspaces (Obsidian-style). They appear in a sidebar and restore on launch.
- **Cmd+K command palette** — fuzzy-search files across all open folders, powered by [nucleo](https://github.com/helix-editor/nucleo).
- **Syntax highlighting** — [Shiki](https://shiki.style) with VS Code themes for accurate, beautiful code blocks.
- **Math** — KaTeX rendering for `$inline$` and `$$display$$` math.
- **Mermaid diagrams** — fenced `mermaid` blocks render as SVG.
- **GFM** — tables, task lists, strikethrough, autolinks, footnotes.
- **Light & dark themes** — follows system preference or toggle manually.
- **Sanitized rendering** — all HTML is run through DOMPurify. Safe to view untrusted markdown.
- **Small & fast** — native webview, no Electron. Production `.dmg` is under 15 MB.

## Install

### Homebrew (macOS)

_NOTE_: I am currently waiting for apple developer review so for the time being the app is not signed. This will be fixed soon.

```bash
brew tap GRVYDEV/tap
brew install --cask GRVYDEV/tap/marky
# This is temporary until I can sign the binary
xattr -cr /Applications/Marky.app
```

### Ubuntu / Debian

Download the `.deb` for your architecture from the [latest release](https://github.com/yuki-inaho/marky/releases/latest):

```bash
# amd64
curl -LO https://github.com/yuki-inaho/marky/releases/latest/download/marky_0.1.3_amd64.deb
sudo dpkg -i marky_0.1.3_amd64.deb

# arm64
curl -LO https://github.com/yuki-inaho/marky/releases/latest/download/marky_0.1.3_arm64.deb
sudo dpkg -i marky_0.1.3_arm64.deb
```

### AppImage (Linux)

Download the AppImage from the [latest release](https://github.com/yuki-inaho/marky/releases/latest):

```bash
curl -LO https://github.com/yuki-inaho/marky/releases/latest/download/Marky_0.1.3_amd64.AppImage
chmod +x Marky_0.1.3_amd64.AppImage
./Marky_0.1.3_amd64.AppImage
```

### From Source (official procedure)

The release workflow builds Linux artifacts on Ubuntu 22.04, where WebKitGTK 4.1 is available. This is the supported native source-build environment.

```bash
sudo apt-get update
sudo apt-get install -y \
  curl build-essential pkg-config \
  libwebkit2gtk-4.1-dev libgtk-3-dev libappindicator3-dev \
  librsvg2-dev patchelf xdg-utils

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

# Node.js 22+ and pnpm
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install --global pnpm@latest

git clone https://github.com/yuki-inaho/marky.git
cd marky
pnpm install
pnpm approve-builds --all
pnpm tauri build
./scripts/install-cli.sh
```

The install script symlinks `marky` to `~/.local/bin/`. Make sure that's on your `PATH`:

```bash
# bash/zsh
export PATH="$HOME/.local/bin:$PATH"

# fish
set -Ux fish_user_paths $HOME/.local/bin $fish_user_paths
```

### Ubuntu 20.04 / Focal

Ubuntu 20.04's system packages provide WebKitGTK 4.0 and GLib 2.64, while the current Marky/Tauri source uses WebKitGTK 4.1 and GLib 2.70+. A native Focal build is therefore not supported. The tested compatibility route is to install `proot`, build against an Ubuntu 22.04 runtime root, and launch Marky inside that root.

```bash
sudo apt-get update
sudo apt-get install -y curl ca-certificates proot tar

# Node.js 22+ and pnpm on the Focal host
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install --global pnpm@latest

ROOTFS="$HOME/.local/share/marky/ubuntu-jammy-rootfs"
mkdir -p "$ROOTFS"
curl -L https://partner-images.canonical.com/core/jammy/current/ubuntu-jammy-core-cloudimg-amd64-root.tar.gz \
  | tar -xz -C "$ROOTFS"

# Install the GUI development/runtime packages in the Jammy root.
sudo mkdir -p "$ROOTFS/usr/sbin"
printf '#!/bin/sh\nexit 101\n' | sudo tee "$ROOTFS/usr/sbin/policy-rc.d" >/dev/null
sudo chmod 755 "$ROOTFS/usr/sbin/policy-rc.d"
proot -0 -r "$ROOTFS" -b /dev -b /proc -b /sys -b /etc/resolv.conf:/etc/resolv.conf \
  /bin/sh -lc 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential pkg-config libwebkit2gtk-4.1-dev libgtk-3-dev \
    libappindicator3-dev librsvg2-dev patchelf xdg-utils ca-certificates git'

git clone https://github.com/yuki-inaho/marky.git
cd marky
pnpm install
pnpm approve-builds --all
pnpm build

# Build Rust on the Focal host while pkg-config/linking use the Jammy root.
export MARKY_ROOTFS="$ROOTFS"
export PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1
export PKG_CONFIG_SYSROOT_DIR="$ROOTFS"
export PKG_CONFIG_LIBDIR="$ROOTFS/usr/lib/x86_64-linux-gnu/pkgconfig:$ROOTFS/usr/share/pkgconfig:$ROOTFS/usr/lib/pkgconfig"
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="$PWD/scripts/cc-rootfs-linker.sh"
(cd src-tauri && cargo build --release)

cp src-tauri/target/release/marky "$ROOTFS/usr/bin/marky"
chmod +x "$ROOTFS/usr/bin/marky"
export WEBKIT_EXEC_PATH=/usr/lib/x86_64-linux-gnu/webkit2gtk-4.1
export GST_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gstreamer-1.0
proot -0 -r "$ROOTFS" -b /dev -b /proc -b /sys -b /run -b /tmp -b /home:/home \
  /usr/bin/marky
```

The repository's release workflow uploads `Marky_<version>_<arch>.AppImage` to the GitHub release. Focal users should use the compatibility procedure above; the standard Ubuntu 22.04 AppImage is not a native Focal binary.

## Usage

```bash
# Open a single file
marky README.md

# Open a folder as a workspace
marky ./docs/

# Open with no args — restores your last session
marky
```

## Keyboard Shortcuts

| Shortcut      | Action                              |
| ------------- | ----------------------------------- |
| `Cmd+K`       | Command palette (fuzzy file search) |
| `Cmd+O`       | Open file                           |
| `Cmd+Shift+O` | Add folder                          |
| `Cmd+F`       | Search in page                      |

## Development

```bash
pnpm install
pnpm tauri dev       # dev server with HMR
```

### Run Tests

```bash
# Frontend
pnpm test

# Rust
cd src-tauri && cargo test
```

### Project Structure

```
src-tauri/       Rust backend — CLI, file I/O, file watching, folder registry, fuzzy search
src/             React frontend — markdown pipeline, UI components, theme
src/components/  App components (Viewer, Sidebar, CommandPalette, etc.)
src/components/ui/  shadcn/ui primitives
src/lib/         Core logic (markdown-it config, Shiki, Tauri IPC wrappers)
src/styles/      Tailwind base + markdown prose styles
scripts/         Install helpers
```

## Built With

| Layer               | Tech                                                      |
| ------------------- | --------------------------------------------------------- |
| Desktop shell       | [Tauri v2](https://v2.tauri.app)                          |
| Frontend            | React + TypeScript + Vite                                 |
| Markdown            | [markdown-it](https://github.com/markdown-it/markdown-it) |
| Syntax highlighting | [Shiki](https://shiki.style)                              |
| Math                | [KaTeX](https://katex.org)                                |
| Diagrams            | [Mermaid](https://mermaid.js.org)                         |
| Fuzzy search        | [nucleo](https://github.com/helix-editor/nucleo)          |
| UI primitives       | [shadcn/ui](https://ui.shadcn.com)                        |
| Styling             | [Tailwind CSS](https://tailwindcss.com)                   |
| File watching       | [notify](https://github.com/notify-rs/notify)             |

## Roadmap

- **Built-in AI chat** — chat with Claude Code or Codex directly inside your markdown documents
- **Git diff review** — view and review local git diffs without leaving the app

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create.
Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch: `git checkout -b feature/AmazingFeature`
3. Commit your Changes: `git commit -m 'Add some AmazingFeature'`
4. Push to the Branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

Before submitting a PR:

- Run `pnpm test` and `cd src-tauri && cargo test`
- Run `pnpm typecheck`
- Actually open a markdown file with `pnpm tauri dev` and verify it renders correctly

## Contact Me

> GitHub [@GRVYDEV](https://github.com/GRVYDEV) &nbsp;&middot;&nbsp;
> Twitter [@grvydev](https://twitter.com/grvydev)
