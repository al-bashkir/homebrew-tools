# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Standard Homebrew third-party tap (`al-bashkir/tools`) shipping two prebuilt-binary formulae for upstream projects also owned by the same GitHub user:

- `Formula/envio.rb` — Rust CLI from `al-bashkir/envio`. Per-platform binaries pulled from the upstream `CICD.yml` release assets.
- `Formula/ssh-tui.rb` — Go TUI from `al-bashkir/ssh-tui`. Per-platform binaries pulled from the upstream `release.yml` release assets.

Users install with `brew install al-bashkir/tools/<formula>`. **No Homebrew bottles, no `brew pr-pull`.** The prebuilt binary downloaded from the upstream release IS the precompiled artifact.

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

If `brew style`/`brew audit` exit non-zero with `Error: cannot load such file -- bundler` and a backtrace through `Homebrew/utils/gems.rb`, the local `vendor/portable-ruby/current` symlink is stale. Fix with:

```bash
brew vendor-install ruby
```

After that brew uses the freshly installed portable ruby and `brew style` returns `1 file inspected, no offenses detected`.

### Install + run formula tests locally

```bash
brew install al-bashkir/tools/envio
brew test al-bashkir/tools/envio
brew linkage --test al-bashkir/tools/envio   # see "envio linkage caveat" below
brew uninstall envio
```

Install is now a download + extract (seconds), not a compile. There is no `--build-from-source` path — both formulae are binary-only.

### Bumping a formula version

1. Wait for the upstream release CI to finish publishing assets:
   - envio: `al-bashkir/envio` → `.github/workflows/CICD.yml` builds 3 tarballs on tag push.
   - ssh-tui: `al-bashkir/ssh-tui` → `.github/workflows/release.yml` builds 4 tarballs on tag push.
2. Fetch each asset and compute SHA256:

   envio (3 SHAs):
   ```bash
   VER=<new>
   for triple in aarch64-apple-darwin aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu; do
     curl -fsSL -o "/tmp/envio-$triple.tgz" \
       "https://github.com/al-bashkir/envio/releases/download/v$VER/envio-v$VER-$triple.tar.gz"
     shasum -a 256 "/tmp/envio-$triple.tgz"
   done
   ```

   ssh-tui (4 SHAs):
   ```bash
   VER=<new>
   for plat in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
     curl -fsSL -o "/tmp/ssh-tui-$plat.tgz" \
       "https://github.com/al-bashkir/ssh-tui/releases/download/v${VER}/ssh-tui_v${VER}_${plat}.tar.gz"
     shasum -a 256 "/tmp/ssh-tui-$plat.tgz"
   done
   ```
3. Edit the formula:
   - **envio**: bump every `v0.6.5` → `v<new>` in URLs (URLs hard-code the version literal because the Rust target triple `url` parses cleanly to a version, so an explicit `version "..."` would be redundant per `brew audit --strict`); replace each `sha256`.
   - **ssh-tui**: bump `version "..."`, replace each `sha256`. URLs use `#{version}` interpolation — no URL edits needed. Explicit `version` is required here because the URL `_amd64`/`_arm64` suffix confuses brew's version-detection heuristic.
4. Open a single-commit PR.
5. Wait for `brew test-bot` to pass on `macos-26` and `ubuntu-latest`. `--only-formulae` does a full `brew install` + `brew test` cycle.
6. Merge (regular merge commit or squash — there is no `brew pr-pull` cherry-pick step to worry about anymore).

## Architecture and conventions specific to this tap

### Formula style

Both formulae are **prebuilt-binary installs**. They use per-platform `on_macos` / `on_linux` × `on_arm` / `on_intel` blocks with one `url` + `sha256` pair per supported platform. There is no top-level `url`. Each block points at an upstream release asset.

`ssh-tui.rb` declares an explicit `version "1.3.1"` because the URL contains `_amd64`/`_arm64` numeric noise that brew's version-detection heuristic misreads. `envio.rb` does **not** declare `version` — Rust target-triple URLs (`envio-v0.6.5-aarch64-apple-darwin.tar.gz`, etc.) parse cleanly and `brew audit --strict` flags the explicit declaration as redundant. To compensate, envio URLs hard-code the version literal (`v0.6.5`) rather than interpolate `#{version}`.

### Platform matrix

| Formula | macOS arm64 | macOS x86_64 | Linux x86_64 | Linux arm64 |
|---------|-------------|--------------|--------------|-------------|
| envio   | yes         | **no**       | yes          | yes         |
| ssh-tui | yes         | yes          | yes          | yes         |

envio macOS Intel is intentionally unsupported — upstream `CICD.yml` does not build that target. The formula declares `depends_on arch: :arm64` inside `on_macos do ... end`, so brew refuses the install on x86_64-apple-darwin before fetching anything. The `on_intel` block inside `on_macos` exists only as a syntax stub (reuses the arm64 URL) because `brew test-bot --only-tap-syntax` iterates every macOS version, including Intel-only ones, and a missing URL would fail tap-syntax with `formula requires at least a URL`. The arch dep gates real installs; the stub URL is never fetched. Once upstream CI starts producing an `x86_64-apple-darwin` asset, drop `depends_on arch: :arm64` and replace the stub URL/sha256 with the real ones.

### envio dep stack

envio (Rust) dynamic-links system `gpgme` and `libgpg-error`. Where those libraries come from depends on the OS:

- **macOS**: the upstream `CICD.yml` build job runs on a `macos-14` runner and installs `gpgme` via Homebrew before compiling. The resulting binary links Homebrew paths, so the formula declares both deps inside `on_macos do ... end`:

```ruby
on_macos do
  depends_on "gpgme"
  depends_on "libgpg-error"
  on_arm do
    url "https://github.com/al-bashkir/envio/releases/download/v0.6.5/envio-v0.6.5-aarch64-apple-darwin.tar.gz"
    sha256 "..."
  end
end
```
- **Linux**: the upstream `CICD.yml` build job uses `cross` with `aarch64-unknown-linux-gnu` / `x86_64-unknown-linux-gnu` targets. The container's apt-installed `libgpgme11` / `libgpg-error0` are linked in. The resulting binaries reference system `/lib64/lib{gpgme,gpg-error}.so` paths. Declaring `depends_on "gpgme"` on Linux would not help (the binary does not look in Homebrew's prefix anyway) and would pull in ~40 transitive Homebrew packages for nothing. Instead, Linux users need their distro's gpgme installed:
  - Debian/Ubuntu: `apt install libgpgme11 libgpg-error0`
  - Fedora/RHEL: `dnf install gpgme libgpg-error`
  - Arch: `pacman -S gpgme libgpg-error`

This means `brew linkage --test al-bashkir/tools/envio` on Linux always reports "Unwanted system libraries" for the two GPG libs. **This is expected and known**, and `brew test-bot` does not promote the warning to a failure for non-bottled, non-new formulae (`test_bot/formulae.rb` sets `ignore_failures = !new_formula && !bottled_on_current_version`). The PR check stays green; the warning is informational.

`pkgconf` and `rust` are **not** build deps anymore — prebuilt binaries do not need a Rust toolchain at install time.

### ssh-tui specifics

- `go` is **not** a build dep — the formula installs a prebuilt binary.
- ssh-tui has **no `--version` flag** — its CLI is subcommand-based and never prints a version. The `test do` block asserts the binary exists and is executable instead of pattern-matching version output.
- Shell completions are emitted at install time via `generate_completions_from_executable(bin/"ssh-tui", "completion", shells: [:bash, :zsh])`. Upstream supports only bash + zsh; do not add fish/powershell to the `shells:` list.
- Upstream `release.yml` tarballs ship only the bare binary — no man page, no LICENSE inside the tarball. License metadata stays on the formula.

### envio specifics

- The version subcommand is `envio version` (not `envio --version`). The `test do` block uses the subcommand form.
- envio's upstream `CICD.yml` builds the binary, strips it, then bundles it with `envio.1`, `autocomplete/envio.bash`, `autocomplete/envio.fish`, `autocomplete/_envio`, `autocomplete/_envio.ps1`, plus README and both LICENSE files into the release tarball. The formula installs the bash/fish/zsh completions and the man page; PowerShell is intentionally skipped.
- The tarball has a single top-level directory `envio-v<X>-<triple>/`. Homebrew's stage logic cd's into it automatically — `def install` paths are relative to that directory.

### CI workflows

- `.github/workflows/tests.yml` runs `brew test-bot` on push to `main` and on every PR. Matrix: `macos-26` and `ubuntu-latest` (in `ghcr.io/homebrew/brew:main` container). On PRs it also runs `--only-formulae` (full install + `brew test`). No bottle artifacts are produced and no upload-artifact step exists.
- There is **no** `publish.yml` workflow. The `pr-pull` label has no effect.

### Spec / plan documents (for Claude Code workflows)

Do **not** write spec or plan markdown files inside this repo. `brew style --tap` runs RuboCop with `rubocop-md` against every `*.md` file in the tap and tap-level `.rubocop.yml` excludes are ignored because brew passes file lists explicitly. Even one `.md` under `docs/` breaks `brew test-bot --only-tap-syntax`.

Use `~/.claude/projects/-home-bashkir-Projects-GITHUB-al-bashkir-homebrew-tools/specs/` and `.../plans/` instead — outside the tap working tree.
