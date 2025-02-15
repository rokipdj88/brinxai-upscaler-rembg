# 👉 BrinXAI - upcaler & rembg Automation installation

how to run brinxai node only upscaler and rembg only

spesification :

![brinxai](https://github.com/user-attachments/assets/2addd6d8-428a-4b77-b542-e3017cc0b3e6)


  
Official and Source : [BrinxAI Dasboard](https://workers.brinxai.com/dashboard.php)


### ⚠️ Important Notes

Add your worker on dasboard

Port open : 5011

Delay need more than 10 minutes to show your node is active


### ✨ AUTO INSTALLATION

## How to run Script


copy and paste this command into your terminal:

```bash
wget https://github.com/rokipdj88/brinxai-upscaler-rembg/raw/main/brinxai.sh -O brinxai.sh && chmod +x brinxai.sh && ./brinxai.sh
```

## If you want add some model here command

Turn on manual node model

For 'text-ui' service
```bash
docker run -d --name text-ui --network brinxai-network --cpus=4 --memory=4096m -p 127.0.0.1:5000:5000 admier/brinxai_nodes-text-ui:latest
```

For 'stable-diffusion' service
```bash
docker run -d --name stable-diffusion --network brinxai-network --cpus=8 --memory=8192m -p 127.0.0.1:5050:5050 admier/brinxai_nodes-stabled:latest
```

For 'rembg' service
```bash
docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:7000:7000 admier/brinxai_nodes-rembg:latest
```

For 'upscaler' service
```bash
docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
```

For 'Relay node' 1194/udp Port
```bash
sudo docker run -d --name brinxai_relay --cap-add=NET_ADMIN -p 1194:1194/udp admier/brinxai_nodes-relay:latest
```


## 🎨 Understanding the Colors

The tool uses a variety of colors to make the output easy to read:

- 🟢 Green: Successful operations
- 🔵 Blue: General information
- 🟡 Yellow: Warnings or important notices
- 🔴 Red: Errors or failed operations
- 🟣 Magenta: Highlighted information
- 🟠 Cyan: Balance information


## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/yourusername/brinxai-upscaler-rembg/issues) if you want to contribute.


Enjoy using the Automation installation! If you have any questions or run into any issues, please don't hesitate to reach out or open an issue on GitHub.! ✨
