#!/bin/bash

readonly katex_api_url='https://api.github.com/repos/Khan/KaTeX/releases/latest'
readonly katex_archive='katex.tar.gz'
readonly remark_url='https://remarkjs.com/downloads/remark-latest.min.js'
readonly remark_file='remark-latest.min.js'

remove_archive() {
    local error_msg='failed to clean: please remove extracted files manually'
    local archive="$1"
    if test -f "${archive}"; then
        local prefix=$(tar -tf "${archive}" | cut -f 1 -d / | uniq)
        if [[ "${prefix}" =~ $'\n' ]]; then
            echo "${error_msg}" >&2
        elif test -d "${prefix}"; then
            rm -r "${prefix}"
        fi
        rm "${archive}"
    fi
}
atexit() {
    remove_archive "${katex_archive}"
}
url_from_api() {
    local filter='.assets [] .browser_download_url'
    local url="$1"
    local name="$2"
    wget -O - "${url}" | jq "${filter}" | tr -d '"' | fgrep "${name}"
}
extract() {
    archive="$1"
    target="$2"
    pattern='/'$(<<<"${target}" sed -e 's/\./\\\./g')'$'
    target_path=$(tar -tf "${archive}" | grep "${pattern}")
    tar -zxf "${archive}" "${target_path}"
    mv "${target_path}" "${target}"
}

if ! which jq &>/dev/null; then
    echo '`jq` not found: apt install jq' >&2
    exit
fi
wget -O "${remark_file}" "${remark_url}"
katex_url=$(url_from_api "${katex_api_url}" "${katex_archive}")
trap atexit EXIT
wget -O "${katex_archive}" "${katex_url}"
for target in 'katex.min.js' 'auto-render.min.js'; do
    extract "${katex_archive}" "${target}"
done
