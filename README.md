# ❄️ NixOS Configuration (Sway-based setup)

This repository contains my full **NixOS system configuration**, designed for a modern Wayland desktop using **Sway** as the window manager.

It includes system configuration, desktop environment setup, security tweaks, virtualization, and performance optimizations.

---

## 🖥️ System Overview

- **OS:** NixOS (unstable + LTS specialisation)
- **WM:** Sway (Wayland compositor)
- **Display Manager:** greetd + tuigreet
- **Shell:** Starship enabled
- **Audio:** PipeWire
- **Networking:** NetworkManager + VPN plugins + Tailscale
- **Security:** AppArmor + TPM2 + Polkit
- **Virtualisation:** libvirt + QEMU + Podman

---

## 📦 Desktop Environment

### Wayland / Sway setup

- Sway window manager
- Waybar status bar
- Rofi launcher menus
- Mako notifications
- Foot terminal
- Thunar file manager
- Zathura PDF viewer
- MPV media player
- grim + slurp screenshots
- wl-clipboard support

Extra tools:
- nwg-look (GTK theming)
- brightnessctl (laptop brightness control)
- pavucontrol (audio control)

---

## 🎨 Theming & Fonts

- Papirus icon theme
- JetBrains Mono Nerd Font
- GTK + Qt support via Sway wrapper features
- Qt applications supported via system integration

---

## 🔐 Security Features

- AppArmor enabled with profiles
- TPM2 support
- Polkit authentication agent
- SSH agent enabled
- Firewall enabled with custom ports
- Secure default system configuration

---

## 🌐 Networking

- NetworkManager (default)
- OpenVPN / OpenConnect / VPNC support
- Tailscale VPN enabled
- Avahi (local network discovery)
- LocalSend support (port 53317 open)

---

## 🧠 Virtualisation & Containers

- Podman (Docker-compatible)
- libvirt + QEMU/KVM
- virt-manager GUI support
- SPICE USB redirection enabled
- distrobox support included

---

## ⚙️ Special Features

### 🧪 Dual kernel setup
- Default: latest Linux kernel
- Specialisation: LTS kernel (`boot.kernelPackages = linuxPackages`)

### ♻️ System maintenance
- Automatic garbage collection (weekly)
- Auto store optimisation
- TRIM enabled for SSDs
- zram swap enabled (50% RAM)

---

## 🧑‍💻 User Configuration

User: `nanda-kumudhan`

Groups:
- wheel (sudo)
- networkmanager
- libvirtd
- kvm
- dialout
- adbusers

---

## 🚪 Login System

- `greetd` display manager
- `tuigreet` TUI login screen
- Directly launches Sway session

---

## 📂 Repository Structure (typical)


---

## 🚀 Apply configuration

```bash
sudo nixos-rebuild switch
