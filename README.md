# Zeyad Monitor

RAM / CPU / GPU monitor for Linux Mint & Ubuntu: per-app usage with logos, panel indicator,
Waydroid (Android) apps with real names, and an "Explain" view showing what each process is,
what it needs and what needs it.

*Developed by Zeyad Hossam.*

## Install (Linux Mint / Ubuntu / Debian)

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://USERNAME.github.io/REPO/key.gpg | sudo tee /etc/apt/keyrings/zeyad-monitor.gpg >/dev/null
echo "deb [signed-by=/etc/apt/keyrings/zeyad-monitor.gpg] https://USERNAME.github.io/REPO stable main" \
  | sudo tee /etc/apt/sources.list.d/zeyad-monitor.list
sudo apt update
sudo apt install zeyad-monitor
```

Updates arrive with the normal `sudo apt update && sudo apt upgrade`.

## Remove

```bash
sudo apt remove zeyad-monitor
sudo rm /etc/apt/sources.list.d/zeyad-monitor.list /etc/apt/keyrings/zeyad-monitor.gpg
```

## Without the repo

Download the `.deb` from the Releases page, then `sudo apt install ./zeyad-monitor_*_all.deb`.
