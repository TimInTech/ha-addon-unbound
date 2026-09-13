#!/usr/bin/env bash
# Compares the Alpine packages of a freshly built image with unbound/apk-packages.txt.
# On a difference it updates the list, bumps the patch version and adds a changelog entry.
# Usage (from the repository root): .github/scripts/package-update.sh IMAGE
# Writes changed=true|false and version=X.Y.Z to $GITHUB_OUTPUT when that variable is set.
set -euo pipefail

image=${1:?usage: .github/scripts/package-update.sh IMAGE}
lock=unbound/apk-packages.txt
config=unbound/config.yaml
changelog=unbound/CHANGELOG.md

output() {
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "$1" >>"$GITHUB_OUTPUT"
    fi
}

current=$(docker run --rm --entrypoint sh "$image" -c 'apk info -v 2>/dev/null | sort')
[ -n "$current" ] || { echo "error: no packages reported by $image" >&2; exit 1; }
previous=$(cat "$lock")

if [ "$current" = "$previous" ]; then
    echo "No package changes."
    output changed=false
    exit 0
fi

version=$(sed -nE 's/^version: "([0-9]+\.[0-9]+\.[0-9]+)"$/\1/p' "$config")
[ -n "$version" ] || { echo "error: cannot read version from $config" >&2; exit 1; }
IFS=. read -r major minor patch <<<"$version"
next="$major.$minor.$((patch + 1))"

[ "$(head -n 1 "$changelog")" = "# Changelog" ] || { echo "error: unexpected header in $changelog" >&2; exit 1; }

changes=$(awk '
    function pkg_name(s,    n) { n = s; sub(/-[^-]+-r[0-9]+$/, "", n); return n }
    NR == FNR { n = pkg_name($0); old[n] = substr($0, length(n) + 2); next }
    { n = pkg_name($0); new[n] = substr($0, length(n) + 2) }
    END {
        for (n in new) {
            if (!(n in old)) printf "  - `%s` %s (added)\n", n, new[n]
            else if (old[n] != new[n]) printf "  - `%s` %s → %s\n", n, old[n], new[n]
        }
        for (n in old) if (!(n in new)) printf "  - `%s` %s (removed)\n", n, old[n]
    }' <(printf '%s\n' "$previous") <(printf '%s\n' "$current") | sort)

printf '%s\n' "$current" >"$lock"
sed -i -E "s/^version: \"$version\"$/version: \"$next\"/" "$config"
{
    printf '# Changelog\n\n## %s\n\n- Rebuilt with updated Alpine packages:\n%s\n\n' "$next" "$changes"
    tail -n +3 "$changelog"
} >"$changelog.tmp"
mv "$changelog.tmp" "$changelog"

echo "Package changes detected, prepared $next:"
printf '%s\n' "$changes"
output changed=true
output "version=$next"
