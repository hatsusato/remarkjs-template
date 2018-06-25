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
link "${top_dir}/js" "${target_dir}/js"
link "${top_dir}/css" "${target_dir}/css"
link "${top_dir}/fonts" "${target_dir}/fonts"
copy "${top_dir}/main.css" "${target_dir}/main.css"
copy "${top_dir}/index.html" "${target_dir}/index.html"
