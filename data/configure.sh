#!/bin/bash

build_arch=$1
version=$2
if [ $version = 'latest' ]; then
    version=`curl -s https://api.github.com/repos/fatedier/frp/releases/latest | grep browser_download_url | cut -d '"' -f4 | cut -d '_' -f2 | head -1`
fi
frp_url="https://github.com/fatedier/frp/releases/download/"
app_path="/usr/src"

function select_machine() {
    local machine;
    case $build_arch in
        "aarch64")
            machine="arm64"
        ;;
        "amd64")
            machine="amd64"
        ;;
        "armhf")
            machine="arm"
        ;;
        "armv7")
            machine="arm"
        ;;
        "i386")
            machine="386"
        ;;
    esac;

    echo "$machine"
}

function install() {
    local machine=$(select_machine)
    local file_name="frp_${version}_linux_${machine}.tar.gz"
    local file_url="${frp_url}v${version}/${file_name}"
    local file_dir=$(echo ${file_name} | sed 's/.tar.gz//')

    mkdir -p /tmp/$file_dir
    mkdir -p $app_path
    curl -o /tmp/${file_name} -sSL $file_url
    tar xzf /tmp/${file_name} -C /tmp

    ls -la /tmp/${file_dir}
    cp -f /tmp/${file_dir}/frpc ${app_path}/
    rm -rf /tmp/${file_name}
    rm -rf /tmp/${file_dir}
    ls -la $app_path
}

install
