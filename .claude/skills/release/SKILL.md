---
name: release
description: Bump al-bashkir/homebrew-tools formulae (envio, ssh-tui, kubegonfig) when upstream publishes new releases. Detects new versions via GitHub Releases API, fetches per-platform assets (tarballs or bare binaries), recomputes SHA256s, edits formulae (including envio macOS-Intel auto-promotion), lints with brew style + audit, opens a single combined PR. Trigger when user wants to release new upstream versions of envio, ssh-tui, or kubegonfig into the Homebrew tap.
---

# release

Procedure to bump one or both formulae in `al-bashkir/homebrew-tools` to match the latest upstream GitHub Release.

## Inputs

- `$ARGUMENTS` — optional. One of: `envio`, `ssh-tui`, `kubegonfig`, or empty.
  - Empty: check all formulae.
  - `envio`: bump envio only.
  - `ssh-tui`: bump ssh-tui only.
  - `kubegonfig`: bump kubegonfig only.

## Procedure

1. **Preflight** — see "Preflight guards" section below.
2. **Determine scope** — filter formula list by `$ARGUMENTS`.
3. **Detect upstream versions** — `gh api .../releases/latest`. Skip formula if current == upstream.
4. **Fetch tarballs + compute SHA256** — per-platform, with envio Intel probe.
5. **Edit formulae** — in-place, preserving file shape.
6. **Lint** — `brew style` + `brew audit --strict --new`. Stop on failure, leave edits unstaged.
7. **Branch, commit, push** — naming convention in "Branch + commit" section.
8. **Open PR** — `gh pr create` with structured body.
9. **Report** — print PR URL on final line.

## Preflight guards

Run each check from the homebrew-tools working tree. Each check that fails MUST abort the procedure with a one-line diagnostic and non-zero exit. Do not proceed past any failure.

```bash
set -euo pipefail

# 1. Working dir is the tap repo
remote_url=$(git remote get-url origin 2>/dev/null || true)
case "$remote_url" in
  *al-bashkir/homebrew-tools|*al-bashkir/homebrew-tools.git) : ;;
  *) echo "ERROR: not in al-bashkir/homebrew-tools repo (origin=$remote_url)"; exit 1 ;;
esac

# 2. On main branch
current_branch=$(git symbolic-ref --short HEAD)
if [ "$current_branch" != "main" ]; then
  echo "ERROR: must be on main, currently on $current_branch"; exit 1
fi

# 3. Working tree clean
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: working tree dirty; stash or commit first"
  git status --short
  exit 1
fi

# 4. main up-to-date with origin/main
git fetch origin main
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
  echo "ERROR: local main not up-to-date with origin/main; pull first"
  exit 1
fi

# 5. gh authenticated
if ! gh auth status >/dev/null 2>&1; then
  echo "ERROR: gh not authenticated; run 'gh auth login'"; exit 1
fi

echo "Preflight OK"
```

## Scope detection

Parse the optional argument into the `formulae` array. Empty arg = both formulae.

```bash
# $ARGUMENTS is substituted by the skill harness before bash sees it.
arg="${ARGUMENTS:-}"
case "$arg" in
  "")          formulae=(envio ssh-tui kubegonfig) ;;
  envio)       formulae=(envio) ;;
  ssh-tui)     formulae=(ssh-tui) ;;
  kubegonfig)  formulae=(kubegonfig) ;;
  *)
    echo "ERROR: invalid argument '$arg'. Valid: envio | ssh-tui | kubegonfig | (empty)"
    exit 1
    ;;
esac
printf 'Scope: %s\n' "${formulae[*]}"
```

## Version detection

For each formula in `formulae`, parse the current version from the formula file and fetch the latest upstream release tag. Populate `to_bump` with only formulae where current != upstream.

```bash
declare -A upstream_repo=(
  [envio]="al-bashkir/envio"
  [ssh-tui]="al-bashkir/ssh-tui"
  [kubegonfig]="al-bashkir/kubegonfig"
)
declare -A current_ver
declare -A new_ver
to_bump=()

for f in "${formulae[@]}"; do
  case "$f" in
    envio)
      cur=$(grep -oE 'releases/download/v[0-9]+\.[0-9]+\.[0-9]+' Formula/envio.rb | head -1 | sed 's|.*/v||')
      ;;
    ssh-tui)
      cur=$(grep -oE 'releases/download/v[0-9]+\.[0-9]+\.[0-9]+' Formula/ssh-tui.rb | head -1 | sed 's|.*/v||')
      ;;
    kubegonfig)
      cur=$(grep -oE 'releases/download/v[0-9]+(\.[0-9]+)*' Formula/kubegonfig.rb | head -1 | sed 's|.*/v||')
      ;;
  esac
  [ -n "$cur" ] || { echo "ERROR: could not parse current version for $f"; exit 1; }
  current_ver[$f]=$cur

  tag=$(gh api "repos/${upstream_repo[$f]}/releases/latest" -q .tag_name 2>/dev/null || true)
  [ -n "$tag" ] || { echo "ERROR: gh api returned no tag for ${upstream_repo[$f]}"; exit 1; }
  upstream=${tag#v}
  new_ver[$f]=$upstream

  if [ "$cur" = "$upstream" ]; then
    echo "$f: v$cur (current)"
  else
    echo "$f: v$cur -> v$upstream (BUMP)"
    to_bump+=("$f")
  fi
done

if [ ${#to_bump[@]} -eq 0 ]; then
  echo "All formulae current. Nothing to do."
  exit 0
fi
```

## Tarball fetch — envio

Runs only if `envio` is in `to_bump`. Fetches 3 mandatory triple tarballs, probes for the optional x86_64-apple-darwin asset.

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx envio; then
  v=${new_ver[envio]}
  declare -A envio_sha
  envio_promote_intel=0
  envio_intel_url=""
  envio_intel_sha=""

  for triple in aarch64-apple-darwin aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu; do
    url="https://github.com/al-bashkir/envio/releases/download/v${v}/envio-v${v}-${triple}.tar.gz"
    out="/tmp/envio-${triple}.tgz"
    curl -fsSL -o "$out" "$url" || { echo "ERROR: envio asset 404: $triple ($url)"; exit 1; }
    envio_sha[$triple]=$(sha256sum "$out" | awk '{print $1}')
    echo "envio $triple: ${envio_sha[$triple]}"
  done

  # Probe Intel macOS asset (HEAD only, no body fetch needed for probe)
  intel_url="https://github.com/al-bashkir/envio/releases/download/v${v}/envio-v${v}-x86_64-apple-darwin.tar.gz"
  if curl -fsSI "$intel_url" >/dev/null 2>&1; then
    echo "envio: x86_64-apple-darwin asset present — will promote on_intel block"
    envio_promote_intel=1
    envio_intel_url=$intel_url
    curl -fsSL -o /tmp/envio-x86_64-apple-darwin.tgz "$intel_url"
    envio_intel_sha=$(sha256sum /tmp/envio-x86_64-apple-darwin.tgz | awk '{print $1}')
    echo "envio x86_64-apple-darwin: $envio_intel_sha"
  else
    echo "envio: x86_64-apple-darwin asset absent — Intel stub will mirror arm64"
  fi
fi
```

## Tarball fetch — ssh-tui

Runs only if `ssh-tui` is in `to_bump`. Four mandatory platform tarballs.

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx ssh-tui; then
  v=${new_ver[ssh-tui]}
  declare -A sshtui_sha

  for plat in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
    url="https://github.com/al-bashkir/ssh-tui/releases/download/v${v}/ssh-tui_v${v}_${plat}.tar.gz"
    out="/tmp/ssh-tui-${plat}.tgz"
    curl -fsSL -o "$out" "$url" || { echo "ERROR: ssh-tui asset 404: $plat ($url)"; exit 1; }
    sshtui_sha[$plat]=$(sha256sum "$out" | awk '{print $1}')
    echo "ssh-tui $plat: ${sshtui_sha[$plat]}"
  done
fi
```

## Asset fetch — kubegonfig

Runs only if `kubegonfig` is in `to_bump`. Assets are **bare binaries**, not tarballs (`kubegonfig-{os}-{arch}`, no extension). The release also publishes per-asset `.sha256` sidecar files, but the simplest source of truth is the GitHub asset `digest` field (`sha256:...`) — no download required.

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx kubegonfig; then
  v=${new_ver[kubegonfig]}
  declare -A kube_sha

  rel_json=$(gh api "repos/al-bashkir/kubegonfig/releases/tags/v${v}")
  for plat in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
    digest=$(jq -r --arg n "kubegonfig-${plat}" '.assets[] | select(.name==$n) | .digest' <<<"$rel_json")
    sha=${digest#sha256:}
    [ -n "$sha" ] || { echo "ERROR: kubegonfig asset/digest missing: kubegonfig-${plat}"; exit 1; }
    kube_sha[$plat]=$sha
    echo "kubegonfig $plat: ${kube_sha[$plat]}"
  done
fi
```

If a `digest` field is ever absent (older releases), fall back to downloading the bare binary and hashing it: `curl -fsSL -o /tmp/kubegonfig-$plat "https://github.com/al-bashkir/kubegonfig/releases/download/v${v}/kubegonfig-${plat}" && sha256sum /tmp/kubegonfig-$plat`.

## Formula edit — envio

When invoked at runtime, prefer the Edit tool over `sed` for in-place edits. The bash snippet below documents the exact substitutions to perform; the executing model SHOULD translate each substitution into an Edit tool call against `Formula/envio.rb`. Use `sed -i` as a fallback only if Edit is unavailable.

**Substitutions (run only if envio in `to_bump`):**

1. Bump the literal version in every URL line. There are exactly four URL lines in `Formula/envio.rb` (one per `on_macos arm`/`on_macos intel`/`on_linux arm`/`on_linux intel`). Replace `v${current_ver[envio]}` with `v${new_ver[envio]}` everywhere it appears.

2. Replace each `sha256 "..."` line with the new digest for its matching block:
   - arm64-apple-darwin block (`on_macos do > on_arm do`) → `envio_sha[aarch64-apple-darwin]`
   - x86_64-apple-darwin block (`on_macos do > on_intel do`) → **depends on promotion flag**
   - aarch64-linux block (`on_linux do > on_arm do`) → `envio_sha[aarch64-unknown-linux-gnu]`
   - x86_64-linux block (`on_linux do > on_intel do`) → `envio_sha[x86_64-unknown-linux-gnu]`

3. **Intel macOS stub handling** (the `on_intel` block nested inside `on_macos do`):

   **If `envio_promote_intel == 1`:**
   - Replace the stub URL with `$envio_intel_url`.
   - Replace the stub sha with `$envio_intel_sha`.
   - Remove the line `depends_on arch: :arm64` from inside `on_macos do`.
   - Remove the stub-explainer comment block (lines starting with `# No upstream x86_64-apple-darwin asset.` through `# URL and drop the arch dep once envio CICD.yml builds one.`). Replace with no comment, or with a one-line comment `# x86_64-apple-darwin asset promoted from upstream release on YYYY-MM-DD`.

   **If `envio_promote_intel == 0`:**
   - Mirror the arm64-apple-darwin URL into the on_intel block (URL becomes the same `aarch64-apple-darwin` asset URL).
   - Mirror the arm64-apple-darwin sha into the on_intel block.
   - Leave `depends_on arch: :arm64` intact.
   - Leave the existing stub-explainer comment intact.

   This is idempotent in both directions: if a previously-promoted formula loses the Intel asset (unlikely but possible), the procedure restores the stub.

4. **Sanity asserts after edits** (executable check):

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx envio; then
  v=${new_ver[envio]}
  # Confirm every URL got bumped — no leftover old-version literal in URL lines
  if grep -E '^[[:space:]]*url ' Formula/envio.rb | grep -q "v${current_ver[envio]}"; then
    echo "ERROR: leftover old version v${current_ver[envio]} in envio URL line"
    grep -nE '^[[:space:]]*url ' Formula/envio.rb
    exit 1
  fi
  # Confirm 4 URL lines still present
  url_count=$(grep -cE '^[[:space:]]*url ' Formula/envio.rb)
  if [ "$url_count" != "4" ]; then
    echo "ERROR: envio URL line count = $url_count, expected 4"; exit 1
  fi
  # Confirm 4 sha256 lines still present
  sha_count=$(grep -cE '^[[:space:]]*sha256 ' Formula/envio.rb)
  if [ "$sha_count" != "4" ]; then
    echo "ERROR: envio sha256 line count = $sha_count, expected 4"; exit 1
  fi
  # Promotion-flag-specific assert on the arch dep
  if [ "$envio_promote_intel" = "1" ]; then
    if grep -q 'depends_on arch: :arm64' Formula/envio.rb; then
      echo "ERROR: envio promotion requested but arch dep still present"; exit 1
    fi
  else
    if ! grep -q 'depends_on arch: :arm64' Formula/envio.rb; then
      echo "ERROR: envio not promoted but arch dep missing"; exit 1
    fi
  fi
  echo "envio formula edits OK"
fi
```

## Formula edit — ssh-tui

Use the Edit tool to perform the substitutions below against `Formula/ssh-tui.rb`. Use `sed -i` only as a fallback.

**Substitutions (run only if ssh-tui in `to_bump`):**

1. Bump the literal version in every URL line. `Formula/ssh-tui.rb` hard-codes the version twice per URL (`.../download/v<X>/ssh-tui_v<X>_<os>_<arch>.tar.gz`) and declares **no** `version` — brew's version-detection heuristic parses these filenames cleanly and `brew audit --strict` rejects an explicit declaration as redundant. Replace `v${current_ver[ssh-tui]}` with `v${new_ver[ssh-tui]}` everywhere it appears.

2. Replace each `sha256 "..."` line with the new digest for its matching block. The block-to-platform mapping:
   - `on_macos do > on_arm do` → `sshtui_sha[darwin_arm64]`
   - `on_macos do > on_intel do` → `sshtui_sha[darwin_amd64]`
   - `on_linux do > on_arm do` → `sshtui_sha[linux_arm64]`
   - `on_linux do > on_intel do` → `sshtui_sha[linux_amd64]`

3. **Sanity asserts after edits:**

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx ssh-tui; then
  # Confirm every URL got bumped — no leftover old-version literal in URL lines
  if grep -E '^[[:space:]]*url ' Formula/ssh-tui.rb | grep -q "v${current_ver[ssh-tui]}"; then
    echo "ERROR: leftover old version v${current_ver[ssh-tui]} in ssh-tui URL line"
    grep -nE '^[[:space:]]*url ' Formula/ssh-tui.rb
    exit 1
  fi
  # Confirm no explicit version declaration crept back in (brew audit --strict rejects it)
  if grep -qE '^[[:space:]]*version "' Formula/ssh-tui.rb; then
    echo "ERROR: ssh-tui declares an explicit version; brew audit flags it as redundant"; exit 1
  fi
  # Confirm 4 sha256 lines still present
  sha_count=$(grep -cE '^[[:space:]]*sha256 ' Formula/ssh-tui.rb)
  if [ "$sha_count" != "4" ]; then
    echo "ERROR: ssh-tui sha256 line count = $sha_count, expected 4"; exit 1
  fi
  # Confirm 4 url lines still present
  url_count=$(grep -cE '^[[:space:]]*url ' Formula/ssh-tui.rb)
  if [ "$url_count" != "4" ]; then
    echo "ERROR: ssh-tui url line count = $url_count, expected 4"; exit 1
  fi
  echo "ssh-tui formula edits OK"
fi
```

## Formula edit — kubegonfig

Use the Edit tool to perform the substitutions below against `Formula/kubegonfig.rb`. Use `sed -i` only as a fallback. Same shape as envio and ssh-tui: the version literal is hard-coded in each URL and there is **no** `version` declaration — the bare-binary filenames carry no version, but brew scans it from the `download/v<X>/` path segment, so a declaration audits as redundant.

**Substitutions (run only if kubegonfig in `to_bump`):**

1. Bump the literal version in every URL line: replace `v${current_ver[kubegonfig]}` with `v${new_ver[kubegonfig]}` everywhere it appears.

2. Replace each `sha256 "..."` line with the new digest for its matching block. Block-to-platform mapping:
   - `on_macos do > on_arm do` → `kube_sha[darwin-arm64]`
   - `on_macos do > on_intel do` → `kube_sha[darwin-amd64]`
   - `on_linux do > on_arm do` → `kube_sha[linux-arm64]`
   - `on_linux do > on_intel do` → `kube_sha[linux-amd64]`

3. **Sanity asserts after edits:**

```bash
if printf '%s\n' "${to_bump[@]}" | grep -qx kubegonfig; then
  if grep -E '^[[:space:]]*url ' Formula/kubegonfig.rb | grep -q "v${current_ver[kubegonfig]}/"; then
    echo "ERROR: leftover old version v${current_ver[kubegonfig]} in kubegonfig URL line"
    grep -nE '^[[:space:]]*url ' Formula/kubegonfig.rb
    exit 1
  fi
  if grep -qE '^[[:space:]]*version "' Formula/kubegonfig.rb; then
    echo "ERROR: kubegonfig declares an explicit version; brew audit flags it as redundant"; exit 1
  fi
  sha_count=$(grep -cE '^[[:space:]]*sha256 ' Formula/kubegonfig.rb)
  if [ "$sha_count" != "4" ]; then
    echo "ERROR: kubegonfig sha256 line count = $sha_count, expected 4"; exit 1
  fi
  url_count=$(grep -cE '^[[:space:]]*url ' Formula/kubegonfig.rb)
  if [ "$url_count" != "4" ]; then
    echo "ERROR: kubegonfig url line count = $url_count, expected 4"; exit 1
  fi
  echo "kubegonfig formula edits OK"
fi
```

## Lint

Run `brew style` and `brew audit --strict --new` per touched formula. On any failure, stop the procedure, leave edits unstaged, and surface the failing command + tail of output to the user.

```bash
lint_failed=0
for f in "${to_bump[@]}"; do
  echo ">>> brew style Formula/$f.rb"
  if ! brew style "Formula/$f.rb"; then
    echo "ERROR: brew style failed for $f"
    lint_failed=1
    break
  fi
  echo ">>> brew audit --strict --new al-bashkir/tools/$f"
  if ! brew audit --strict --new "al-bashkir/tools/$f"; then
    echo "ERROR: brew audit failed for $f"
    lint_failed=1
    break
  fi
done

if [ "$lint_failed" = "1" ]; then
  echo "Lint failed. Edits left unstaged. Inspect with: git diff Formula/"
  exit 1
fi
echo "Lint OK"
```

If `brew style`/`brew audit` exits with a `cannot load such file -- bundler` error, run `brew vendor-install ruby` once (per CLAUDE.md) and retry — do NOT bake the auto-retry into the skill itself, surface it to the user instead.

## Branch + commit + push + PR

Construct branch name, commit message, and PR body from the `to_bump` list. Single-formula and dual-formula cases produce different branch names but a uniform commit-message shape.

```bash
# Build branch name and commit subject from to_bump (any count)
if [ ${#to_bump[@]} -eq 1 ]; then
  f=${to_bump[0]}
  branch="release/${f}-v${new_ver[$f]}"
  commit_msg="chore: bump ${f} to v${new_ver[$f]}"
else
  segs=()      # branch segments, e.g. envio-v0.6.6
  parts=()     # commit-subject parts, e.g. "envio to v0.6.6"
  for f in "${to_bump[@]}"; do
    segs+=("${f}-v${new_ver[$f]}")
    parts+=("${f} to v${new_ver[$f]}")
  done
  branch="release/$(IFS=-; echo "${segs[*]}")"
  commit_msg="chore: bump $(IFS=,; echo "${parts[*]}" | sed 's/,/, /g')"
fi

# Refuse if branch exists locally or on remote
if git show-ref --verify --quiet "refs/heads/$branch"; then
  echo "ERROR: branch $branch already exists locally"; exit 1
fi
if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
  echo "ERROR: branch $branch already exists on origin"; exit 1
fi

# Create branch and stage only the touched formulae
git switch -c "$branch"
for f in "${to_bump[@]}"; do
  git add "Formula/${f}.rb"
done

# Commit (no Co-Authored-By trailer per ~/.claude/CLAUDE.md)
git commit -m "$commit_msg"

# Push
git push -u origin "$branch"
```

**Build the PR body in a temp file** (heredoc with all interpolations done, so `gh pr create --body-file` reads a static string):

```bash
body_file=$(mktemp)
{
  echo "## Summary"
  echo
  for f in "${to_bump[@]}"; do
    echo "### ${f}: v${current_ver[$f]} → v${new_ver[$f]}"
    echo
    echo "Upstream release: https://github.com/${upstream_repo[$f]}/releases/tag/v${new_ver[$f]}"
    echo
    echo "SHA256:"
    case "$f" in
      envio)
        echo "- aarch64-apple-darwin: \`${envio_sha[aarch64-apple-darwin]}\`"
        if [ "$envio_promote_intel" = "1" ]; then
          echo "- x86_64-apple-darwin (newly promoted): \`${envio_intel_sha}\`"
        else
          echo "- x86_64-apple-darwin: mirror of aarch64 stub (\`depends_on arch: :arm64\` still in effect)"
        fi
        echo "- aarch64-unknown-linux-gnu: \`${envio_sha[aarch64-unknown-linux-gnu]}\`"
        echo "- x86_64-unknown-linux-gnu: \`${envio_sha[x86_64-unknown-linux-gnu]}\`"
        if [ "$envio_promote_intel" = "1" ]; then
          echo
          echo "**macOS Intel:** upstream now ships an \`x86_64-apple-darwin\` asset. Dropped \`depends_on arch: :arm64\`."
        fi
        ;;
      ssh-tui)
        echo "- darwin_arm64: \`${sshtui_sha[darwin_arm64]}\`"
        echo "- darwin_amd64: \`${sshtui_sha[darwin_amd64]}\`"
        echo "- linux_arm64: \`${sshtui_sha[linux_arm64]}\`"
        echo "- linux_amd64: \`${sshtui_sha[linux_amd64]}\`"
        ;;
      kubegonfig)
        echo "- darwin-arm64: \`${kube_sha[darwin-arm64]}\`"
        echo "- darwin-amd64: \`${kube_sha[darwin-amd64]}\`"
        echo "- linux-arm64: \`${kube_sha[linux-arm64]}\`"
        echo "- linux-amd64: \`${kube_sha[linux-amd64]}\`"
        ;;
    esac
    echo
  done
  echo "## Test plan"
  echo
  echo "- [ ] \`brew test-bot\` green on \`macos-26\`"
  echo "- [ ] \`brew test-bot\` green on \`ubuntu-latest\`"
  echo "- [ ] \`brew install al-bashkir/tools/<formula>\` succeeds locally on at least one platform"
} > "$body_file"

pr_url=$(gh pr create --title "$commit_msg" --body-file "$body_file")
rm -f "$body_file"
echo "$pr_url"
```
