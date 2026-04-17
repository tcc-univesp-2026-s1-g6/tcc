FROM node:22-slim

# Instala Python 3 e dependências de compilação para libs científicas
RUN apt-get update && apt-get install -y \
    python3 python3-pip build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dependências Node
COPY package*.json ./
RUN npm install

# Dependências Python
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Código da aplicação
COPY . .

# GEMINI_API_KEY é embutida no bundle pelo Vite em build time
ARG GEMINI_API_KEY
ENV GEMINI_API_KEY=$GEMINI_API_KEY

RUN npm run build

ENV NODE_ENV=production
ENV COMANDO_PYTHON=python3

EXPOSE 3000

CMD ["npm", "start"]
