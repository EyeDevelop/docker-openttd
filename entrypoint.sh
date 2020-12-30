#!/bin/bash

# Make directories if not done already.
mkdir -p /data
mkdir -p /conf

# Make a user for data holding, if not done already.
if ! grep "abc" /etc/passwd > /dev/null; then
    echo "[!] User not found. Creating one..."
    groupadd --non-unique --gid "$PGID" abc
    useradd --non-unique --no-create-home --gid "$PGID" --uid "$PUID" abc
fi

# Download OpenTTD if not done already.
if [[ ! -f /data/.openttd_setup ]]; then
    echo "[!] OpenTTD not setup yet, doing so now."
    rm -rf /data/bin

    # Download the source files.
    curl -Lo /tmp/openttd.zip "https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-source.zip"
    mkdir -p /tmp/openttd
    unzip -d /tmp/openttd /tmp/openttd.zip

    # Build the source.
    cd /tmp/openttd/*/ || exit 1
    ./configure --enable-dedicated
    make -j "$(nproc)"
    cp -r bin /data/
    cd /data/bin/ || exit 1

    # Download the graphics set.
    curl -Lo /tmp/opengfx.zip "https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"
    unzip -d /data/bin/baseset/ /tmp/opengfx.zip

    # We are done installing.
    touch /data/.openttd_setup
    chown abc:abc -R /data
fi

# Launch the server.
echo "[+] Running the server..."
cd /data || exit 1
bin/openttd -D -c /data/openttd.cfg