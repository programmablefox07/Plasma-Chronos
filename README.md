# KDE Plasma on ChromeOS
BROKEN

This project provides an **automated bash script** to build and run the **KDE Plasma desktop** and **X11/XWayland** on a custom ChromeOS installation.  
It installs KDE into `/usr/local` so the original ChromeOS UI (Ash shell) remains untouched, while still allowing you to launch a full KDE session.

---

## Features
- Automated pull + build of:
  - **X.Org X11 server** (with XWayland support)
  - **KDE Plasma Desktop**
- Installs into `/usr/local` (safe, no overwrite of ChromeOS system files).
- Provides a `start-kde.sh` launcher script to start KDE on `:1`.
- Can run **alongside ChromeOS UI** or be set up to replace it.

---

## Requirements
- A **custom ChromeOS build** with:
  - [Chromebrew (crew)](https://github.com/skycocker/chromebrew) package manager installed
  - Developer mode enabled
  - Enough storage + RAM to build KDE
- Backups of your system (recommended).

### Recommended System Specs
- **RAM**: At least **4 GB** for compiling; **8 GB+ strongly recommended** for smoother Plasma performance.  
- **CPU**: Dual-core or better (faster compile times with more cores).  
- **Storage**: 10–15 GB free for build directories and installed packages.  

---

## Installation

Clone this repository and run the install script:

```bash
git clone https://github.com/yourusername/kde-chromeos.git
cd kde-chromeos
chmod +x kde_install_chromeos.sh
./kde_install_chromeos.sh
