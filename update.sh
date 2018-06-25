#!/bin/bash

set -eu

readonly katex_api_url='https://api.github.com/repos/Khan/KaTeX/releases'
readonly katex_archive='katex.tar.gz'
readonly remark_url='https://remarkjs.com/downloads/remark-latest.min.js'
readonly remark_file='remark-latest.min.js'
readonly targets=('katex.min.css' 'katex.min.js' 'auto-render.min.js' 'fonts/')
readonly atexit_err='failed to clean: please remove extracted files manually'

atexit() {
    if test -f "${katex_archive}"; then
        local prefix=$(tar -tf "${katex_archive}" | cut -f 1 -d / | uniq)
        if [[ "${prefix}" =~ $'\n' ]]; then
            echo "${atexit_err}" >&2
        elif test -d "${prefix}"; then
            rm -r "${prefix}"
        fi
        rm "${katex_archive}"
    fi
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
    pattern='/'$(<<<"${target}" sed -e 's/\./\\\./g')'$'
    target_path=$(tar -tf "${archive}" | grep "${pattern}")
    if [[ "${target}" =~ /$ ]]; then
        target="${target%/}"
    else
        target="${target##*.}/${target}"
    fi
    tar -zxf "${archive}" "${target_path}"
    mv "${target_path}" "${target}"
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
