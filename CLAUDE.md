# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Standard Homebrew third-party tap (`al-bashkir/tools`) shipping two source-build formulae for upstream projects also owned by the same GitHub user:

- `Formula/envio.rb` — Rust CLI from `al-bashkir/envio` (built via `cargo install`).
- `Formula/ssh-tui.rb` — Go TUI from `al-bashkir/ssh-tui` (built via `go build`).

Users install with `brew install al-bashkir/tools/<formula>`. Bottles (precompiled binaries) are produced by tap CI and published to this repo's GitHub Releases via the `brew pr-pull` workflow.

## Common commands

All commands assume Homebrew (Linuxbrew on Linux) is installed and the working directory is the repo root.

### One-time local tap setup (for iterating on formulae)

```bash
TAP_PATH="$(brew --repository)/Library/Taps/al-bashkir/homebrew-tools"
mkdir -p "$(dirname "$TAP_PATH")"
ln -sfn "$PWD" "$TAP_PATH"
brew tap | grep al-bashkir/tools  # verify
```

If a real clone already sits at `$TAP_PATH`, remove it first (`rm -rf "$TAP_PATH"`); `ln -sfn` will not replace a real directory.

### Validate formulae

```bash
brew style Formula/envio.rb
brew style Formula/ssh-tui.rb
brew audit --strict --new al-bashkir/tools/envio       # use the tap-resolved name, not a path
brew audit --strict --new al-bashkir/tools/ssh-tui
brew test-bot --only-tap-syntax --tap=al-bashkir/tools  # full sweep CI runs
```

`brew audit` does not accept file paths in recent brew (`>= ~5.x`); pass the `<tap>/<formula>` name instead.

Cosmetic "cannot load such file -- bundler" warnings can appear in `brew style`/`brew audit` output but do not affect exit code; the audit logic still completes.

### Install + run formula tests locally

```bash
brew install --build-from-source al-bashkir/tools/envio
brew test al-bashkir/tools/envio
brew uninstall envio
```

Use `--build-from-source` to verify the source build path even when bottles exist. envio's cargo build takes about a minute; ssh-tui's go build is a few seconds.

### Bumping a formula version

1. Fetch the source tarball, compute SHA256:
   ```bash
   curl -fsSL -o /tmp/src.tgz https://github.com/<owner>/<repo>/archive/refs/tags/v<NEW>.tar.gz
   shasum -a 256 /tmp/src.tgz
   ```
2. Edit the formula's `url` (replace `v<OLD>` with `v<NEW>`) and `sha256`.
3. Open a single-commit PR.
4. Wait for `brew test-bot` to pass on `macos-26` and `ubuntu-latest`.
5. Apply the `pr-pull` label to trigger `publish.yml` — it cherry-picks the bump commit, downloads the bottle artifacts, appends a `bottle do { ... }` block referencing GitHub Releases URLs, uploads bottles, and pushes to `main`.

**Never squash-merge a tap PR if you want bottles.** `brew pr-pull` cherry-picks the original branch commits onto `main`; squash merges produce add/add conflicts because `main` already holds the collapsed result. Use a regular merge commit (or rebase). Single-commit bump PRs avoid the issue entirely.

## Architecture and conventions specific to this tap

### Formula style

Both formulae are **source-build only** — there are no per-platform `on_macos` / `on_linux` blocks pointing at upstream prebuilt binaries. A single top-level `url` covers every platform; brew auto-detects `version` from the URL, so explicit `version "..."` should not be added (audit will flag it as redundant). When a URL contains numeric noise that brew misparses (e.g. `_amd64`), restoring an explicit `version` is the correct workaround — see commit history for `ssh-tui.rb`.

### envio dependency stack

envio (Rust) links system `gpgme` and `libgpg-error` directly. The formula declares:

- `depends_on "pkgconf" => :build` — without it, the `libgpg-error-sys` cargo build script aborts on Linuxbrew CI because `pkg-config` is not on `PATH`.
- `depends_on "gpgme"` — runtime, used by envio for GPG-based encryption.
- `depends_on "libgpg-error"` — runtime; even though it is a transitive dep via gpgme, brew's `linkage --test` requires it to be declared explicitly because the binary links it directly.

If envio's upstream removes the GPG support (or splits it behind a feature flag), the latter two deps can be dropped.

### ssh-tui specifics

- The `v1.3.1` source tarball ships no `LICENSE` file (added later on `main` upstream); the formula uses `license "MIT"` as metadata only. Future bumps should pick up the LICENSE inside the tarball.
- ssh-tui has **no `--version` flag** — its CLI is subcommand-based and never prints a version. The `test do` block asserts the binary exists and is executable instead of pattern-matching version output.
- Shell completions are emitted at install time via `generate_completions_from_executable(bin/"ssh-tui", "completion", shells: [:bash, :zsh])`. Upstream supports only bash + zsh; do not add fish/powershell to the `shells:` list.

### envio specifics

- The version subcommand is `envio version` (not `envio --version`). The `test do` block must use the subcommand form.
- envio's `build.rs` writes generated artifacts to `man/envio.1` and `completions/{envio.bash,_envio,envio.fish,_envio.ps1}` in the source tree during `cargo install`. The formula installs the bash/fish/zsh completions and the man page; PowerShell is intentionally skipped.

### CI workflows

- `.github/workflows/tests.yml` runs `brew test-bot` on push to `main` and on every PR. Matrix: `macos-26`, `macos-15-intel`, `ubuntu-latest` (in `ghcr.io/homebrew/brew:main` container). On PRs it additionally runs `--only-formulae` (full install + bottle build) and uploads `*.bottle.*` artifacts. macos-15-intel typically does not produce a bottle when a transitive dep (e.g. `go`) is itself unbottled there — that is acceptable; Intel mac users source-build.
- `.github/workflows/publish.yml` runs `brew pr-pull` on `pull_request_target.labeled` events when the label is `pr-pull`. It needs write access to `contents` (already declared) so it can push bottle commits to `main` and upload bottle tarballs to GitHub Releases.

### Spec / plan documents (for Claude Code workflows)

Do **not** write spec or plan markdown files inside this repo. `brew style --tap` runs RuboCop with `rubocop-md` against every `*.md` file in the tap and tap-level `.rubocop.yml` excludes are ignored because brew passes file lists explicitly. Even one `.md` under `docs/` breaks `brew test-bot --only-tap-syntax`.

Use `~/.claude/projects/-home-bashkir-Projects-GITHUB-al-bashkir-homebrew-tools/specs/` and `.../plans/` instead — outside the tap working tree.
