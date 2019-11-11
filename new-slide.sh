#!/bin/bash

set -eu

link() {
    src_path="$1"
    dst_path="$2"
    dst_dir=$(dirname "${dst_path}")
    mkdir -p "${dst_dir}"
    ln -frsv "${src_path}" "${dst_path}"
}
copy() {
    src_path="$1"
    dst_path="$2"
    cp -iv "${src_path}" "${dst_path}"
}

top_dir=$(cd "$(dirname "$(realpath "$0")")"; pwd -P)
current_dir=$(pwd -P)
target_dir="${current_dir}/$1"
mkdir "${target_dir}"
link "${top_dir}"/js "${target_dir}"/js
link "${top_dir}"/css "${target_dir}"/css
link "${top_dir}"/fonts "${target_dir}"/fonts
copy "${top_dir}"/index.html "${target_dir}"/index.html
copy "${top_dir}"/css/reset.css "${target_dir}"/reset.css
copy "${top_dir}"/css/main.css "${target_dir}"/main.css
copy "${top_dir}"/css/title.css "${target_dir}"/title.css
copy "${top_dir}"/css/common.css "${target_dir}"/common.css
copy "${top_dir}"/css/layout.css "${target_dir}"/layout.css
copy "${top_dir}"/js/remark-latest.min.js "${target_dir}"/remark-latest.min.js
copy "${top_dir}"/js/slide.js "${target_dir}"/slide.js
