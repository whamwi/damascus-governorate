#!/usr/bin/env bash
# Convert every .doc/.rtf under incoming/<date>/ to .docx (and .txt) in a work
# directory, keeping the sub-folder name. The originals are never touched.
#   tools/convert.sh incoming/2026-10-27 /tmp/dg_work
set -euo pipefail
src=$1; out=$2
find "$src" -type f \( -name '*.doc' -o -name '*.rtf' -o -name '*.docx' \) -print0 |
while IFS= read -r -d '' f; do
  sub=$(basename "$(dirname "$f")")
  mkdir -p "$out/docx/$sub" "$out/txt/$sub"
  case "$f" in
    *.docx) cp "$f" "$out/docx/$sub/" ;;
    *)      soffice --headless --convert-to docx --outdir "$out/docx/$sub" "$f" >/dev/null 2>&1 ;;
  esac
  soffice --headless --convert-to "txt:Text (encoded):UTF8" --outdir "$out/txt/$sub" "$f" >/dev/null 2>&1
done
