#!/usr/bin/env bash
set -euo pipefail

# GToolkit Installer for Linux, macOS, and Android
# Downloads and installs the latest GToolkit release.

GITHUB_API="https://api.github.com/repos/feenkcom/gtoolkit/releases/latest"
GITHUB_DL="https://github.com/feenkcom/gtoolkit/releases/download"
FEENK_DL="https://dl.feenk.com/gt"
TMP_DIR=""

cleanup() { [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# --- Color output ---

supports_color() {
  [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]
}

if supports_color; then
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3)
  CYAN=$(tput setaf 6)
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
else
  RED="" GREEN="" YELLOW="" CYAN="" BOLD="" RESET=""
fi

info()  { printf "%s%s%s\n" "$CYAN"   "$1" "$RESET"; }
ok()    { printf "%s%s%s\n" "$GREEN"  "$1" "$RESET"; }
warn()  { printf "%s%s%s\n" "$YELLOW" "$1" "$RESET" >&2; }
error() { printf "%s%s%s\n" "$RED"    "$1" "$RESET" >&2; }

# --- Platform detection ---

detect_platform() {
  local os arch

  os=$(uname -s)
  case "$os" in
    Linux)
      # Check for Android
      if [ "$(uname -o 2>/dev/null)" = "Android" ] || [ -f /system/build.prop ]; then
        warn "Detected Android — using Linux build (best-effort support)"
      fi
      PLATFORM_OS="Linux"
      ;;
    Darwin)
      PLATFORM_OS="MacOS"
      ;;
    *)
      error "Unsupported operating system: $os"
      exit 1
      ;;
  esac

  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64)
      PLATFORM_ARCH="x86_64"
      ;;
    aarch64|arm64)
      PLATFORM_ARCH="aarch64"
      ;;
    *)
      error "Unsupported architecture: $arch"
      exit 1
      ;;
  esac
}

# --- HTTP download helper ---

download() {
  local url="$1" dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fSL --retry 3 -o "$dest" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$dest" "$url"
  else
    error "Neither curl nor wget found. Please install one and retry."
    exit 1
  fi
}

# Fetch URL contents to stdout
fetch() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    if [ -n "${GITHUB_TOKEN:-}" ]; then
      curl -fsSL --retry 3 -H "Authorization: token $GITHUB_TOKEN" "$url"
    else
      curl -fsSL --retry 3 "$url"
    fi
  elif command -v wget >/dev/null 2>&1; then
    if [ -n "${GITHUB_TOKEN:-}" ]; then
      wget -q -O- --header="Authorization: token $GITHUB_TOKEN" "$url"
    else
      wget -q -O- "$url"
    fi
  else
    error "Neither curl nor wget found. Please install one and retry."
    exit 1
  fi
}

# --- Version detection ---

get_latest_version() {
  info "Querying GitHub for the latest GToolkit release..."
  local response
  response=$(fetch "$GITHUB_API") || {
    error "Failed to query GitHub API."
    exit 1
  }

  # Parse tag_name without jq — look for "tag_name": "vX.Y.Z"
  LATEST_TAG=$(printf '%s' "$response" | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

  if [ -z "$LATEST_TAG" ]; then
    error "Could not determine latest version from GitHub API."
    exit 1
  fi

  info "Latest version: ${BOLD}${LATEST_TAG}${RESET}"
}

# --- Checksum verification ---

verify_checksum() {
  local zip_file="$1" expected_hash="$2"

  local actual_hash
  if command -v sha256sum >/dev/null 2>&1; then
    actual_hash=$(sha256sum "$zip_file" | cut -d' ' -f1)
  elif command -v shasum >/dev/null 2>&1; then
    actual_hash=$(shasum -a 256 "$zip_file" | cut -d' ' -f1)
  else
    warn "No sha256sum or shasum found — skipping checksum verification."
    return 0
  fi

  if [ "$actual_hash" = "$expected_hash" ]; then
    ok "Checksum verified."
    return 0
  else
    error "Checksum mismatch!"
    error "  Expected: $expected_hash"
    error "  Actual:   $actual_hash"
    return 1
  fi
}

# --- Post-install: load GToolkitLauncher ---

load_launcher_package() {
  local install_dir="$1"
  local gt_cli=""
  local separator=""

  # Find the GlamorousToolkit-cli binary
  case "$PLATFORM_OS" in
    Linux)
      if [ -f "${install_dir}/bin/GlamorousToolkit-cli" ]; then
        gt_cli="${install_dir}/bin/GlamorousToolkit-cli"
      fi
      ;;
    MacOS)
      local mac_cli="${install_dir}/GlamorousToolkit.app/Contents/MacOS/GlamorousToolkit-cli"
      if [ -f "$mac_cli" ]; then
        gt_cli="$mac_cli"
        separator="--"
      fi
      ;;
  esac

  if [ -z "$gt_cli" ]; then
    warn "GlamorousToolkit-cli binary not found — skipping launcher package install."
    return 0
  fi

  local st_file="${TMP_DIR}/load-launcher.st"
  cat > "$st_file" <<'SMALLTALK'
EpMonitor current disable.
[
Metacello new
  repository: 'github://StephanEggermont/GToolkitLauncher:main/src';
  baseline: 'GToolkitLauncher';
  load.
] ensure: [ EpMonitor current enable ].
15 seconds wait.
EpMonitor current disable.
[
#BaselineOfGToolkitLauncher asClass loadLepiter.
] ensure: [ EpMonitor current enable ].
15 seconds wait.
BlHost pickHost universe snapshot: true andQuit: true.
SMALLTALK

  info "Loading GToolkitLauncher package (this may take several minutes)..."
  # Pattern: GlamorousToolkit-cli *image [--] st <script> --interactive --no-quit
  # The -- separator is required on macOS between the image glob and the st subcommand
  if (cd "$install_dir" && "$gt_cli" *image $separator st "$st_file" --interactive --no-quit); then
    ok "GToolkitLauncher loaded successfully."
  else
    warn "GToolkitLauncher install failed — GToolkit is still usable without it."
  fi
}

# --- Main install ---

install() {
  local install_dir="$1"
  local asset_name="GlamorousToolkit-${PLATFORM_OS}-${PLATFORM_ARCH}-${LATEST_TAG}.zip"
  local github_url="${GITHUB_DL}/${LATEST_TAG}/${asset_name}"
  local feenk_url="${FEENK_DL}/${asset_name}"
  local checksum_name="${asset_name}.sha256"
  local github_checksum_url="${GITHUB_DL}/${LATEST_TAG}/${checksum_name}"

  TMP_DIR=$(mktemp -d)

  local zip_file="${TMP_DIR}/${asset_name}"

  # Download zip — try GitHub first, fall back to dl.feenk.com
  info "Downloading ${asset_name}..."
  if download "$github_url" "$zip_file" 2>/dev/null; then
    ok "Downloaded from GitHub."
  else
    warn "GitHub download failed — trying dl.feenk.com..."
    if download "$feenk_url" "$zip_file" 2>/dev/null; then
      ok "Downloaded from dl.feenk.com."
    else
      error "Download failed from all sources."
      exit 1
    fi
  fi

  # Checksum verification (GitHub checksums only)
  local checksum_file="${TMP_DIR}/${checksum_name}"
  if download "$github_checksum_url" "$checksum_file" 2>/dev/null; then
    local expected_hash
    expected_hash=$(cut -d' ' -f1 < "$checksum_file")
    verify_checksum "$zip_file" "$expected_hash" || exit 1
  else
    warn "Checksum file not available — skipping verification."
  fi

  # Prepare install directory
  if [ -d "$install_dir" ]; then
    warn "Install directory already exists: $install_dir"
    warn "Existing files may be overwritten."
  fi
  mkdir -p "$install_dir"

  # Extract
  info "Extracting to ${install_dir}..."
  if ! command -v unzip >/dev/null 2>&1; then
    error "unzip is required but not found. Please install it and retry."
    exit 1
  fi
  unzip -qo "$zip_file" -d "$install_dir"
  ok "Extraction complete."
  echo ""

  # Post-install: load GToolkitLauncher into the image
  load_launcher_package "$install_dir"

  # Success
  echo ""
  ok "GToolkit ${LATEST_TAG} installed to: ${BOLD}${install_dir}${RESET}"
  echo ""

  # Launch instructions
  case "$PLATFORM_OS" in
    Linux)
      local bin
      if [ -f "${install_dir}/bin/GlamorousToolkit" ]; then
        bin="${install_dir}/bin/GlamorousToolkit"
      elif [ -f "${install_dir}/GlamorousToolkit" ]; then
        bin="${install_dir}/GlamorousToolkit"
      fi
      if [ -n "${bin:-}" ]; then
        info "To launch: ${BOLD}${bin}${RESET}"
      else
        info "To launch, run the GlamorousToolkit binary in ${install_dir}"
      fi
      ;;
    MacOS)
      local app
      if [ -d "${install_dir}/GlamorousToolkit.app" ]; then
        app="${install_dir}/GlamorousToolkit.app"
      fi
      if [ -n "${app:-}" ]; then
        info "To launch: ${BOLD}open ${app}${RESET}"
      else
        info "To launch, open the GlamorousToolkit app in ${install_dir}"
      fi
      ;;
  esac
}

# --- Entry point ---

main() {
  local default_dir="${HOME}/gtoolkit"
  local install_dir=""

  # Priority: CLI arg > env var > interactive prompt > default
  if [ $# -ge 1 ]; then
    install_dir="$1"
  elif [ -n "${GTOOLKIT_DIR:-}" ]; then
    install_dir="$GTOOLKIT_DIR"
  elif [ -t 0 ] && [ -t 1 ]; then
    printf "%sInstall directory [%s]: %s" "$BOLD" "$default_dir" "$RESET"
    read -r user_dir
    install_dir="${user_dir:-$default_dir}"
  else
    install_dir="$default_dir"
  fi

  # Expand ~ if present at start
  install_dir="${install_dir/#\~/$HOME}"

  echo ""
  info "GToolkit Installer"
  info "=================="
  echo ""

  detect_platform
  info "Platform: ${PLATFORM_OS} ${PLATFORM_ARCH}"
  echo ""

  get_latest_version
  echo ""

  install "$install_dir"
}

main "$@"
