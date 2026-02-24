# How the Installer Scripts Work

A detailed step-by-step walkthrough of `install-gtoolkit.sh` (Bash) and `install-gtoolkit.ps1` (PowerShell).

## install-gtoolkit.sh

### Step 1: Strict Mode and Globals

```bash
set -euo pipefail
```

This enables three safety nets:

- `-e` — exit immediately if any command fails
- `-u` — treat references to unset variables as errors
- `-o pipefail` — a pipeline fails if any command in it fails (not just the last one)

Three URL constants are defined for the GitHub API, GitHub release downloads, and the dl.feenk.com mirror. A `TMP_DIR` global is initialized to empty, and an EXIT trap is registered so the `cleanup` function always runs when the script exits — removing the temporary directory if one was created.

### Step 2: Color Output Setup

The `supports_color()` function checks three conditions:

1. stdout is a terminal (`-t 1`)
2. `tput` is available
3. The terminal reports at least 8 colors

If all pass, ANSI color variables (`RED`, `GREEN`, `YELLOW`, `CYAN`, `BOLD`, `RESET`) are set via `tput`. Otherwise they are set to empty strings, so the same `printf` calls work everywhere with the color codes acting as no-ops.

Four helper functions wrap `printf` with the appropriate color:

- `info` — cyan, for progress messages
- `ok` — green, for success messages
- `warn` — yellow, written to stderr
- `error` — red, written to stderr

### Step 3: Parse Install Directory

The `main()` function determines the install path using this priority:

1. **CLI argument** — `./install-gtoolkit.sh /my/path` uses `/my/path`
2. **Environment variable** — `GTOOLKIT_DIR=/my/path ./install-gtoolkit.sh` uses that value
3. **Interactive prompt** — if both stdin and stdout are terminals (`-t 0 && -t 1`), it displays the default (`~/gtoolkit`) and lets the user type an override or press Enter to accept
4. **Default** — non-interactive pipelines silently use `~/gtoolkit`

A leading `~` is expanded to `$HOME` via bash parameter substitution (`${install_dir/#\~/$HOME}`).

### Step 4: Detect Platform

The `detect_platform()` function sets two globals: `PLATFORM_OS` and `PLATFORM_ARCH`.

**Operating system** — `uname -s` returns:

- `Linux` → `PLATFORM_OS="Linux"`. An additional check for Android is performed via `uname -o` or the presence of `/system/build.prop`. If detected, a warning is printed, but the OS is still set to `Linux` since the same download asset is used.
- `Darwin` → `PLATFORM_OS="MacOS"` (matching GToolkit's asset naming convention).
- Anything else → exits with an error.

**Architecture** — `uname -m` returns:

- `x86_64` or `amd64` → `PLATFORM_ARCH="x86_64"`
- `aarch64` or `arm64` (macOS's name) → `PLATFORM_ARCH="aarch64"`
- Anything else → exits with an error.

### Step 5: Get Latest Version

The `get_latest_version()` function fetches JSON from the GitHub releases API using `fetch()`, which prefers `curl -fsSL --retry 3` and falls back to `wget -q -O-`.

The JSON response is parsed without `jq`:

1. `grep -o` extracts the `"tag_name": "..."` key-value pair
2. `sed` strips everything except the version string (e.g., `v1.1.169`)

The result is stored in the global `LATEST_TAG`. If the API call fails or the tag can't be parsed, the script exits with an error.

### Step 6: Construct URLs and Create Temp Directory

Inside `install()`, the asset filename is assembled from the three detected values:

```
GlamorousToolkit-{PLATFORM_OS}-{PLATFORM_ARCH}-{LATEST_TAG}.zip
```

Two download URLs are built — one for GitHub releases, one for dl.feenk.com. A checksum URL is built for the `.sha256` file. Then `mktemp -d` creates a temporary directory, assigned to the global `TMP_DIR` so the EXIT trap can clean it up.

### Step 7: Download the Zip

The `download()` helper tries `curl -fSL --retry 3` first, falling back to `wget -q`. The flags mean:

- `-f` — fail silently on HTTP errors (returns a non-zero exit code)
- `-S` — show errors even with `-s`
- `-L` — follow redirects (GitHub uses 302 redirects to CDN)
- `--retry 3` — retry up to 3 times on transient failures

The script attempts the GitHub URL first. If that fails, it prints a warning and tries dl.feenk.com. If both fail, it exits with an error. Stderr from `curl`/`wget` is suppressed (`2>/dev/null`) so the fallback logic produces clean output.

### Step 8: Verify SHA256 Checksum

The script attempts to download the `.sha256` checksum file from the GitHub release. If the download succeeds, it extracts the expected hash (first whitespace-delimited field) and calls `verify_checksum()`.

`verify_checksum()` computes the actual hash using:

- `sha256sum` (available on Linux), or
- `shasum -a 256` (available on macOS)

If neither tool is available, it warns and skips verification. If the computed hash doesn't match the expected hash, both values are printed and the script exits with a failure.

If the checksum file itself couldn't be downloaded, verification is skipped with a warning.

### Step 9: Extract to Install Directory

If the target directory already exists, a warning is printed that files may be overwritten. `mkdir -p` ensures the directory exists. The script verifies that `unzip` is available (exits with an error if not), then runs:

```bash
unzip -qo "$zip_file" -d "$install_dir"
```

- `-q` — quiet mode (no file listing)
- `-o` — overwrite existing files without prompting

### Step 10: Load GToolkitLauncher Package

After extraction, the `load_launcher_package()` function installs the [GToolkitLauncher](https://github.com/StephanEggermont/GToolkitLauncher) Smalltalk package into the freshly extracted image.

1. **Find the CLI binary** — on Linux, it looks for `bin/GlamorousToolkit-cli`. On macOS, it looks for `GlamorousToolkit.app/Contents/MacOS/GlamorousToolkit-cli`. If not found, a warning is printed and the step is skipped.
2. **Write a Smalltalk script** — a temporary `load-launcher.st` file is created in `$TMP_DIR`. The script disables `EpMonitor` (change tracking) around the Metacello load, waits 15 seconds (Lepiter isn't immediately ready after loading), calls `loadLepiter`, then saves the image and quits via `BlHost pickHost universe snapshot: true andQuit: true`.
3. **Run it** — the CLI binary is invoked with the pattern `GlamorousToolkit-cli *image st <script> --interactive --no-quit`, from within the install directory. The `*image` shell glob resolves to the `.image` file. On macOS, a `--` separator is inserted between the image glob and the `st` subcommand, matching GToolkitLauncher's own invocation pattern.

If the process fails for any reason (binary not found, network error during the Metacello load, Smalltalk exception), the script prints a warning and continues. GToolkit remains usable — the user just gets a vanilla install without the launcher package.

This step can take several minutes as it downloads and compiles Smalltalk packages.

### Step 11: Print Success and Launch Instructions

A success message shows the version and install path. Then, based on the detected OS:

- **Linux** — checks for the binary at `bin/GlamorousToolkit` first (the actual release layout), then `GlamorousToolkit` at the root. Prints the full path to whichever is found.
- **macOS** — checks for `GlamorousToolkit.app` and prints an `open` command if found.

### Step 12: Cleanup

When the script exits — whether from success, failure, or interruption — the EXIT trap fires. The `cleanup()` function checks if `TMP_DIR` is non-empty and removes it with `rm -rf`, ensuring no downloaded zip files are left behind on disk.

---

## install-gtoolkit.ps1

The PowerShell script follows the same logic flow. Here are the key differences at each step.

### Strict Mode

```powershell
$ErrorActionPreference = "Stop"
```

This is PowerShell's equivalent of `set -e` — any error terminates execution.

### Install Directory Priority

Same priority order, different syntax:

1. `-InstallDir` parameter
2. `$env:GTOOLKIT_DIR` environment variable
3. `Read-Host` interactive prompt (when `[Environment]::UserInteractive` is true and input is not redirected)
4. Default: `$env:USERPROFILE\gtoolkit`

### Architecture Detection

Instead of `uname -m`, the script reads `$env:PROCESSOR_ARCHITECTURE`:

- `AMD64` → `x86_64`
- `ARM64` → `aarch64`
- `x86` → `x86_64` (32-bit PowerShell on a 64-bit OS reports `x86`)

### API Call and Version Parsing

`Invoke-RestMethod` returns a parsed PowerShell object directly, so `$response.tag_name` extracts the version with no text processing needed.

### Downloads

`Invoke-WebRequest` handles HTTP downloads. The progress bar is disabled (`$ProgressPreference = "SilentlyContinue"`) because it dramatically slows down large downloads in PowerShell.

### Checksum Verification

`Get-FileHash -Algorithm SHA256` is built into PowerShell — no need to check for external tools. The hash comparison normalizes both values to lowercase.

### Extraction

`Expand-Archive` is built into PowerShell — no `unzip` dependency needed.

### Post-Install: Load GToolkitLauncher Package

After extraction, `Install-LauncherPackage` loads the [GToolkitLauncher](https://github.com/StephanEggermont/GToolkitLauncher) package into the image, following the same logic as the Bash script:

1. **Find the CLI binary** — checks for `bin\GlamorousToolkit-cli.exe`. Also locates the `.image` file via `Get-ChildItem`. If either is missing, a warning is printed and the step is skipped.
2. **Write a Smalltalk script** — the same `load-launcher.st` content (with `EpMonitor` disable/enable and `BlHost pickHost universe snapshot: true andQuit: true`) is written to the temp directory using `Set-Content`.
3. **Run it** — `Start-Process -Wait -PassThru -NoNewWindow` launches `GlamorousToolkit-cli.exe` with the image filename, `st` subcommand, script path, `--interactive`, and `--no-quit`.

If the process fails or returns a non-zero exit code, a warning is printed and the install continues normally. This step runs inside the `try` block, so temp file cleanup still happens via `finally`.

### Cleanup

A `try`/`finally` block around the download and extraction section ensures `Remove-Item -Recurse -Force` runs on the temp directory regardless of success or failure. This is more idiomatic in PowerShell than a trap-based approach.

---

## Download Sources and Rate Limits

Both scripts use two download sources: GitHub releases (primary) and dl.feenk.com (fallback). Each source has different trade-offs.

### GitHub Releases

The GitHub API call to detect the latest version (`api.github.com/repos/.../releases/latest`) is subject to rate limiting:

- **Unauthenticated requests**: 60 per hour per IP address
- **Authenticated requests**: 5,000 per hour (requires a personal access token)

Asset downloads (`github.com/.../releases/download/...`) go through GitHub's CDN and are more generous, but GitHub can still throttle or return HTTP 429 responses under heavy load.

To check your remaining API quota:

```bash
curl -s -I https://api.github.com/repos/feenkcom/gtoolkit/releases/latest | grep -i x-ratelimit
```

This returns headers like:

```
x-ratelimit-limit: 60
x-ratelimit-remaining: 42
x-ratelimit-reset: 1707580800
```

The `reset` value is a Unix timestamp indicating when the quota resets.

**When GitHub-first becomes a problem:**

- **CI / automated environments** — repeated runs exhaust the 60 req/hr limit quickly, especially when multiple machines share a single public IP (NAT)
- **Corporate networks** — firewalls or proxies sometimes block `github.com` or `api.github.com`
- **Regional performance** — GitHub may geo-route to slower CDN nodes in some regions
- **Outages** — GitHub occasionally has service disruptions (the Feenk fallback covers this)

### Authenticating with a GitHub Token

Both scripts support the `GITHUB_TOKEN` environment variable to authenticate API requests, raising the rate limit from 60 to 5,000 requests per hour. The token is only sent to the GitHub API endpoint for version detection — it is never sent to dl.feenk.com or to CDN asset downloads.

**Linux / macOS:**

```bash
GITHUB_TOKEN=ghp_xxxx ./install-gtoolkit.sh
```

**Windows (PowerShell):**

```powershell
$env:GITHUB_TOKEN = "ghp_xxxx"
.\install-gtoolkit.ps1
```

In GitHub Actions, the token is available automatically as `${{ secrets.GITHUB_TOKEN }}`.

**Other mitigations for the API rate limit:**

- Cache the version tag between runs to avoid redundant API calls
- Use conditional requests with `If-None-Match` / ETag headers to avoid consuming quota when the release hasn't changed

### dl.feenk.com

Feenk's download server has no publicly documented rate limits or status page. As a small company's infrastructure, it likely has lower capacity than GitHub's CDN.

**When Feenk-first becomes a problem:**

- **Unknown limits** — no public documentation on rate limits or throttling behavior
- **Single point of infrastructure** — no multi-region CDN guarantees, so download speeds may vary by geography
- **Path stability** — if Feenk restructures their download paths or deprecates the mirror, downloads fail silently
- **No version detection** — the GitHub API is still required to determine the latest release tag, so the API rate limit applies regardless of which source provides the zip file
- **No checksums** — the `.sha256` files are only hosted on GitHub releases, so integrity verification is unavailable when downloading from Feenk alone

### Summary

| Concern | GitHub-first (current default) | Feenk-first |
|---|---|---|
| Rate limits | Well-documented, hittable in CI | Unknown, possibly lower capacity |
| Reliability | High (CDN-backed) | Single server |
| Version detection | Native via API | Still needs GitHub API |
| Checksums | Available | Not hosted |
| Corporate networks | Sometimes blocked | Less likely to be blocked |
| Download speed | Multi-region CDN | Single origin |

The current approach — GitHub primary with Feenk fallback — provides the best combination of speed, reliability, and verifiability for most users. The main risk is the 60 req/hr API rate limit in automated or shared-IP scenarios, which can be resolved by setting `GITHUB_TOKEN`.
