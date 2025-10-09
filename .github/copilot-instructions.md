# Copilot Instructions

## 📦 Repo layout

- `nixos/`: NixOS host config; `configuration.nix` imports `hardware-configuration.nix` and is the only place you should edit.
- `nvim/`: LazyVim-based Neovim setup with bootstrap in `init.lua`, user tweaks under `lua/config/*`, and plugin specs under `lua/plugins/`.
- `alacritty/`: Terminal profile in `alacritty.toml`, including font, opacity, and tmux launch wiring.

## 💤 Neovim setup

- Lazy is bootstrapped in `lua/config/lazy.lua`; new plugins go under `lua/plugins/*.lua` and auto-load.
- `lua/plugins/example.lua` currently exits early with `if true then return {} end`; remove that guard when adding real specs instead of editing defaults in place.
- Extra modules are declared in `lazyvim.json` (Copilot native, FZF, Yanky, language packs, testing); keep this in sync with plugin intent before editing lockfiles.
- Plugins are pinned via `lazy-lock.json`; run `:Lazy sync` after edits and `:Lazy lock` before committing to refresh hashes.
- Lua formatting is enforced by `stylua.toml` (2-space indent, width 120); run `stylua lua/` inside `nvim/` before saving larger changes.

## ⚙️ NixOS configuration

- `configuration.nix` opts into the latest kernel, enables Plasma 6, PipeWire, NetworkManager, Firefox, and user `j`; add packages via `users.users.j.packages` for per-user tools.
- Hardware details (Btrfs root, EFI boot UUIDs, swap) live in `hardware-configuration.nix`; avoid editing manually.
- Validate changes with `sudo nixos-rebuild dry-run` and apply with `sudo nixos-rebuild switch` while pointing at this repo checkout.

## 🖥️ Terminal & shell

- Alacritty launches zsh and auto-creates a fresh tmux session (`tmux new-session -s <first-free-index>`); preserve the quoted `shell.args` when tweaking.
- Custom keybindings for copy/paste, font zoom, and history clearing are already mapped; add new bindings by extending the `bindings` array.

## 🛠️ Common workflows

- Neovim plugin maintenance: `:Lazy sync`, `:Lazy clean`, then `:Lazy lock` to update `lazy-lock.json`.
- LSP/tool installations are delegated to Mason via LazyVim extras; list ensures in `lazyvim.json` rather than manual mason configs.
- Keep Nix and Neovim changes in separate commits when possible so the lockfile churn stays reviewable.

## 📝 Conventions & gotchas

- Prefer small Lua modules under `lua/config/` for keymaps/options; they auto-load on the `VeryLazy` event.
- When enabling new languages, reuse the existing extras pattern (`lazyvim.plugins.extras.lang.*`) to get Treesitter/LSP wired without custom boilerplate.
- Commit `lazyvim.json` and `lazy-lock.json` together whenever extras or plugin pins change.
- This repo has no test suite; rely on `nixos-rebuild`, `stylua`, and Neovim `:checkhealth` for sanity checks.
