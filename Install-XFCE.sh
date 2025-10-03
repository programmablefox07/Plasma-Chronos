#!/bin/bash
# xfce_chromeos.sh
# Automated XFCE setup on ChromeOS (runs on X11 :1)

set -e

PREFIX=/usr/local
BUILD_DIR=$HOME/build-xfce

# --- Dependencies via crew ---
echo "[*] Installing dependencies..."
crew install git cmake ninja gcc g++ pkg-config \
    xorg-server xorg-x11-utils xorg-x11-apps \
    gtk3 glib libxfce4util libxfce4ui xfconf thunar

# --- Prepare build directory ---
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# --- Clone XFCE Core Components ---
echo "[*] Cloning XFCE source..."
git clone https://gitlab.xfce.org/xfce/xfce4-session.git
git clone https://gitlab.xfce.org/xfce/xfce4-panel.git
git clone https://gitlab.xfce.org/xfce/xfdesktop.git
git clone https://gitlab.xfce.org/xfce/xfwm4.git

# --- Build and Install each component ---
for comp in xfce4-session xfce4-panel xfdesktop xfwm4; do
    echo "[*] Building $comp..."
    mkdir -p "$BUILD_DIR/$comp-build"
    cd "$BUILD_DIR/$comp-build"
    cmake "../$comp" -DCMAKE_INSTALL_PREFIX=$PREFIX -GNinja
    ninja
    sudo ninja install
    cd "$BUILD_DIR"
done

# --- Create launcher script ---
echo "[*] Creating XFCE launcher script..."
cat <<EOF | sudo tee /usr/local/bin/start-xfce.sh
#!/bin/bash
export DISPLAY=:1
$PREFIX/bin/Xorg :1 vt\$(fgconsole) &
sleep 3
$PREFIX/bin/xfce4-session
EOF

sudo chmod +x /usr/local/bin/start-xfce.sh

echo "[*] XFCE installed. Run 'start-xfce.sh' to launch on :1"
