#!/bin/bash
# kde_install_chromeos.sh
# Automated build + install of KDE Plasma + X11/XWayland on ChromeOS (custom)

set -e

# --- Variables ---
PREFIX=/usr/local
BUILD_DIR=$HOME/build-kde

# --- Dependencies (using crew if available) ---
if command -v crew >/dev/null 2>&1; then
    echo "[*] Installing dependencies via crew..."
    crew install cmake ninja git gcc g++ pkg-config \
        flatpak xorg-server xorg-x11-utils xorg-x11-apps \
        dbus qt5 plasma-desktop
fi

# --- Prepare build directory ---
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# --- Clone and build X11 / XWayland ---
echo "[*] Cloning X.Org (X11 + XWayland)..."
git clone https://gitlab.freedesktop.org/xorg/xserver.git
cd xserver
./autogen.sh --prefix=$PREFIX --enable-xwayland
make -j$(nproc)
sudo make install
cd ..

# --- Clone and build KDE Plasma ---
echo "[*] Cloning KDE Plasma..."
git clone https://invent.kde.org/plasma/plasma-desktop.git
mkdir plasma-desktop-build && cd plasma-desktop-build
cmake ../plasma-desktop -DCMAKE_INSTALL_PREFIX=$PREFIX -GNinja
ninja
sudo ninja install
cd ..

# --- Create session launcher ---
echo "[*] Creating KDE launcher script..."
cat <<EOF | sudo tee /usr/local/bin/start-kde.sh
#!/bin/bash
export XDG_SESSION_TYPE=x11
export DISPLAY=:1
$PREFIX/bin/Xorg :1 vt$(fgconsole) &
sleep 3
dbus-launch --exit-with-session startplasma-x11
EOF

sudo chmod +x /usr/local/bin/start-kde.sh

echo "[*] KDE Plasma installed. Run 'start-kde.sh' to launch on :1"
