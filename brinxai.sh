#!/bin/bash

# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fungsi untuk mencetak waktu saat ini
print_time() {
  echo -e "${BLUE}[$(date +"%Y-%m-%d %H:%M:%S")]${NC}"
}

# Fungsi untuk menampilkan animasi loading
loading() {
  local duration=$1
  local interval=0.2
  local end_time=$((SECONDS+duration))
  while [ $SECONDS -lt $end_time ]; do
    for s in . .. ...; do
      echo -ne "\r${BLUE}Proses sedang berjalan${s}${NC} "
      sleep $interval
    done
  done
  echo -ne "\r${BLUE}Proses selesai.             ${NC}\n"
}

# Banner
echo -e "${RED}"
echo -e " ███╗   ███╗  █████╗        ██╗ ██╗ ██╗  ██╗  █████╗  ██╗  ██╗  █████╗"
echo -e " ████╗ ████║ ██╔══██╗       ██║ ██║ ██║ ██╔╝ ██╔══██╗ ██║  ██║ ██╔══██║"
echo -e " ██╔████╔██║ ███████║       ██║ ██║ █████╔╝  ███████║  █████╔╝ ██║  ██║"
echo -e " ██║╚██╔╝██║ ██╔══██║  ██║  ██║ ██║ ██╔═██╗  ██╔══██║    ██╔╝  ██║  ██║"
echo -e " ██║ ╚═╝ ██║ ██║  ██║   █████╔╝ ██║ ██║  ██╗ ██║  ██║    ██║    █████╔╝"
echo -e " ╚═╝     ╚═╝ ╚═╝  ╚═╝   ╚════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚════╝"
echo -e "${NC}"

print_time
echo -e "${BLUE}Pilih node yang ingin dijalankan:${NC}"
echo "1. Jalankan hanya Upscaler"
echo "2. Jalankan hanya Rembg"
echo "3. Jalankan keduanya"
read -p "Masukkan pilihan Anda (1/2/3): " NODE_CHOICE

# Validasi Input
if ! [[ "$NODE_CHOICE" =~ ^[1-3]$ ]]; then
  echo -e "${RED}Pilihan tidak valid. Harap pilih 1, 2, atau 3.${NC}"
  exit 1
fi

# Update dan instalasi Docker jika diperlukan
print_time
echo -e "${BLUE}Memperbarui sistem dan memastikan Docker terinstal...${NC}"
loading 5
sudo apt-get install -y ca-certificates curl gnupg lsb-release && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  sudo apt-get update && \
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io && \
  sudo apt-mark hold docker-ce docker-ce-cli containerd.io

# Instalasi Docker Compose versi terbaru
print_time
echo -e "${BLUE}Menginstal Docker Compose versi terbaru...${NC}"
loading 5
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/"$VER"/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Pastikan Docker aktif
if ! systemctl is-active --quiet docker; then
  sudo systemctl start docker
fi

# Tambahkan pengguna ke grup Docker
sudo groupadd docker &>/dev/null || true
sudo usermod -aG docker $USER

# Clone repository dan jalankan instalasi
print_time
echo -e "${BLUE}Meng-clone repository BrinxAI Worker Nodes dan menjalankan instalasi...${NC}"
loading 5
rm -rf ~/BrinxAI-Worker-Nodes
git clone https://github.com/admier1/BrinxAI-Worker-Nodes ~/BrinxAI-Worker-Nodes
cd ~/BrinxAI-Worker-Nodes
chmod +x install_ubuntu.sh && ./install_ubuntu.sh

# Jalankan node sesuai pilihan
print_time
echo -e "${BLUE}Menjalankan node sesuai pilihan Anda...${NC}"
loading 3
docker network create brinxai-network &>/dev/null || true

case $NODE_CHOICE in
  1)
    docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m \
      -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
    ;;
  2)
    docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m \
      -p 127.0.0.1:4000:4000 admier/brinxai_nodes-rembg:latest
    ;;
  3)
    docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m \
      -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
    docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m \
      -p 127.0.0.1:4000:4000 admier/brinxai_nodes-rembg:latest
    ;;
esac

print_time
echo -e "${BLUE}Selesai! Node telah dijalankan.${NC}"
echo -e "${BLUE}Silakan cek log dengan perintah: docker logs <nama_kontainer>${NC}"
