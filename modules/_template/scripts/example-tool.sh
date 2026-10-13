#!/bin/bash
# An example utility script (replace with your own, or delete it). Scripts are the tooling
# this module's guides call: the guide names the script and treats it as the single source
# of whatever it owns (formats, paths, constants), never copying them. Guides call it by
# its absolute path from the baseline folder: modules/<Module>/scripts/<name>.
# Rule enforcement belongs in wiring/hooks/, not here.
#
#   example-tool.sh <input>            print the result
#   example-tool.sh <input> --dry-run  show what would change without writing

set -euo pipefail

INPUT="${1:?usage: example-tool.sh <input> [--dry-run]}"
DRY_RUN="${2:-}"

# <The tool's work: e.g. normalize a file's line endings.>
if [ "$DRY_RUN" = "--dry-run" ]; then
  echo "would process: $INPUT"
else
  echo "processed: $INPUT"
fi
