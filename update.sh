#!/bin/bash

set -eu

readonly katex_api_url='https://api.github.com/repos/Khan/KaTeX/releases'
readonly katex_archive='katex.tar.gz'
readonly remark_url='https://remarkjs.com/downloads/remark-latest.min.js'
readonly remark_file='remark-latest.min.js'
readonly targets=('katex.min.css' 'katex.min.js' 'auto-render.min.js' 'fonts/')

atexit() {
    rm -f "${katex_archive}"
}
url_from_api() {
    local filter='.[0] .assets [] .browser_download_url'
    local url="$1"
    local name="$2"
    wget -O - "${url}" | jq "${filter}" | tr -d '"' | fgrep "${name}"
}
extract() {
    archive="$1"
    target="$2"
    dest="${target##*.}"
    pattern=$(<<<"${target}" sed -e 's/\./\\\./g')'$'
    target_path=$(tar -tf "${archive}" | grep "${pattern}")
    tar -zxf "${archive}" "${target_path}"
    if [[ "${target}" != "${dest}" ]]; then
        mv "${target_path}" "${dest}"
    fi
}

if ! which jq &>/dev/null; then
    echo '`jq` not found: apt install jq' >&2
    exit
fi
cd "$(dirname "$(realpath "$0")")"
wget -O "js/${remark_file}" "${remark_url}"
katex_url=$(url_from_api "${katex_api_url}" "${katex_archive}")
trap atexit EXIT
wget -O "${katex_archive}" "${katex_url}"
for target in "${targets[@]}"; do
    extract "${katex_archive}" "${target}"
done
