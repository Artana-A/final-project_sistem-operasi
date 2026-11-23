#!/usr/bin/env bash
set -u

SCRIPT_NAME="verifikasi.sh"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="${LOG_FILE:-$REPO_DIR/output/backup.log}"

log_msg() {
  local level="$1"
  shift
  local ts line
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  line="$ts [$level] [$SCRIPT_NAME] $*"
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
  if [ "$level" = "ERROR" ] || [ "$level" = "WARN" ]; then
    echo "$line" >&2
  else
    echo "$line"
  fi
  echo "$line" >> "$LOG_FILE" 2>/dev/null || true
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  log_msg "ERROR" "Pemakaian: $0 <file_arsip.tar.gz> [file.sha256]"
  exit 2
fi

ARCHIVE="$1"
CHECKSUM_FILE="${2:-${ARCHIVE}.sha256}"

if [ ! -f "$ARCHIVE" ]; then
  log_msg "ERROR" "File arsip tidak ditemukan: $ARCHIVE"
  exit 2
fi

if [ ! -f "$CHECKSUM_FILE" ]; then
  log_msg "ERROR" "File checksum tidak ditemukan: $CHECKSUM_FILE"
  exit 2
fi

ARCHIVE_DIR="$(cd "$(dirname "$ARCHIVE")" && pwd)"
ARCHIVE_BASE="$(basename "$ARCHIVE")"
CHECKSUM_ABS="$(cd "$(dirname "$CHECKSUM_FILE")" && pwd)/$(basename "$CHECKSUM_FILE")"

if (cd "$ARCHIVE_DIR" && sha256sum -c --status "$CHECKSUM_ABS"); then
  log_msg "INFO" "Integritas valid (checksum cocok): $ARCHIVE_BASE"
  exit 0
else
  log_msg "ERROR" "Checksum tidak cocok / arsip berpotensi berubah: $ARCHIVE_BASE"
  exit 4
fi
