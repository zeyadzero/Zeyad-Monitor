# Zeyad Monitor

Official public APT repository for Zeyad Monitor.

## Supported Systems

- Ubuntu
- Debian
- Linux Mint

## Installation

### 1. Configure the repository (first time only)

```bash
curl -fsSL https://zeyadzero.github.io/Zeyad-Monitor/setup.sh | sudo bash
```

### 2. Install Zeyad Monitor

```bash
sudo apt install zeyad-monitor
```

### Updates

```bash
sudo apt update
sudo apt upgrade
```

## Remove

```bash
sudo apt remove zeyad-monitor
```

To remove the repository:

```bash
sudo rm -f /etc/apt/sources.list.d/zeyad-monitor.list
sudo rm -f /etc/apt/keyrings/zeyad-monitor.gpg
sudo apt update
```

## Repository Information

| Property | Value |
|---|---|
| Package | zeyad-monitor |
| Version | 6.0 |
| Distribution | stable |
| Component | main |
| Architecture | all |

### GPG Fingerprint

`D3E76CD1541772F410F71194273439D3D720600E`

## Links

- [APT Repository](https://zeyadzero.github.io/Zeyad-Monitor/)
- [GitHub Repository](https://github.com/zeyadzero/Zeyad-Monitor)
