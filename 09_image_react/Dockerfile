# ===============================================
# 阶段 1: 构建 (BUILDER STAGE)
# 使用 Node.js 镜像来安装依赖和构建应用
# ===============================================
FROM node:18-alpine AS builder

# 如果需要代理，在构建命令中传入 ARG，这里接收并设置为环境变量
ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

WORKDIR /app

# 复制依赖文件并安装 (利用 Docker 层缓存加速)
COPY package.json package-lock.json ./
RUN npm install

# 复制源代码 (包含所有 TSX 文件)
COPY . .

# 执行构建命令 (会自动处理 TSX 编译)
RUN npm run build
