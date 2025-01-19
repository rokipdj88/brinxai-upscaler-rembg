#!/bin/bash
# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fungsi untuk mencetak waktu saat ini
print_time() {
  echo -e "${BLUE}$(date +"%Y-%m-%d | %H:%M:%S")${NC}"
}

# Banner
echo -e "${RED}"
echo -e ' ███╗   ███╗  █████╗        ██╗ ██╗ ██╗  ██╗  █████╗  ██╗  ██╗  █████╗'
echo -e ' ████╗ ████║ ██╔══██╗       ██║ ██║ ██║ ██╔╝ ██╔══██╗ ██║  ██║ ██╔══██║'
echo -e ' ██╔████╔██║ ███████║       ██║ ██║ █████╔╝  ███████║  █████╔╝ ██║  ██║'
echo -e ' ██║╚██╔╝██║ ██╔══██║  ██║  ██║ ██║ ██╔═██╗  ██╔══██║    ██╔╝  ██║  ██║'
echo -e ' ██║ ╚═╝ ██║ ██║  ██║   █████╔╝ ██║ ██║  ██╗ ██║  ██║    ██║    █████╔╝'
echo -e ' ╚═╝     ╚═╝ ╚═╝  ╚═╝   ╚════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚════╝'
echo -e "${NC}"

echo -e "${BLUE}Join our Telegram channel: https://t.me/NTExhaust${NC}"
echo -e "${RED}-----------------------------------------------------${NC}"
echo -e "${BLUE}Buy VPS 40K on Telegram Store: https://t.me/candrapn${NC}"
sleep 5

# Pilihan untuk menjalankan node
print_time
echo -e "${BLUE}Pilih node yang ingin dijalankan:${NC}"
echo "1. Jalankan hanya Upscaler"
echo "2. Jalankan hanya Rembg"
echo "3. Jalankan keduanya (Upscaler dan Rembg)"
read -p "Masukkan pilihan Anda (1/2/3): " NODE_CHOICE

# Update dan Upgrade Sistem
print_time
echo -e "Memperbarui sistem..."
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y ca-certificates curl

# Periksa Apakah Docker Sudah Terinstal
print_time
if command -v docker &>/dev/null; then
  echo -e "${BLUE}Docker sudah terinstal.${NC} Melanjutkan ke langkah berikutnya..."
else
  echo -e "${RED}Docker belum terinstal.${NC} Menginstal Docker sekarang..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  docker version
fi

# Menambahkan Pengguna ke Grup Docker (tanpa perintah `newgrp docker`)
sudo groupadd docker &>/dev/null || true
sudo usermod -aG docker $USER

# Menjalankan node sesuai pilihan
if [[ $NODE_CHOICE -eq 1 ]]; then
  print_time
  echo -e "Menjalankan BrinxAI Upscaler Node..."
  docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
elif [[ $NODE_CHOICE -eq 2 ]]; then
  print_time
  echo -e "Menjalankan BrinxAI Rembg Node..."
  docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:4000:4000 admier/brinxai_nodes-rembg:latest
elif [[ $NODE_CHOICE -eq 3 ]]; then
  print_time
  echo -e "Menjalankan BrinxAI Upscaler Node..."
  docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest

  print_time
  echo -e "Menjalankan BrinxAI Rembg Node..."
  docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:4000:4000 admier/brinxai_nodes-rembg:latest
else
  echo -e "${RED}Pilihan tidak valid. Silakan jalankan ulang skrip.${NC}"
  exit 1
fi

print_time
echo -e "${BLUE}Selesai! Proses sesuai pilihan Anda telah selesai.${NC}"
