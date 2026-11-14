## Installation

### 1. Install the repository signing key

```bash
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://zeyadzero.github.io/Zeyad-Monitor/key.gpg \
  | sudo tee /etc/apt/keyrings/zeyad-monitor.gpg > /dev/null

sudo chmod 644 /etc/apt/keyrings/zeyad-monitor.gpg
```

### 2. Add the APT repository

```bash
echo "deb [signed-by=/etc/apt/keyrings/zeyad-monitor.gpg] https://zeyadzero.github.io/Zeyad-Monitor stable main" \
  | sudo tee /etc/apt/sources.list.d/zeyad-monitor.list
```

### 3. Update package lists

```bash
sudo apt update
```

### 4. Install Zeyad Monitor

```bash
sudo apt install zeyad-monitor
```

### Updates

Receive updates through the normal APT workflow:

```bash
sudo apt update
sudo apt upgrade
```

## Remove

Remove the application:

```bash
sudo apt remove zeyad-monitor
```

Remove the repository and its signing key:

```bash
sudo rm -f /etc/apt/sources.list.d/zeyad-monitor.list
sudo rm -f /etc/apt/keyrings/zeyad-monitor.gpg
sudo apt update
```

## Install Without Adding the Repository

Download the `.deb` package directly from the [Zeyad Monitor APT Repository](https://zeyadzero.github.io/Zeyad-Monitor/pool/main/zeyad-monitor_6.0_all.deb), then install it:

```bash
sudo apt install ./zeyad-monitor_6.0_all.deb
```
