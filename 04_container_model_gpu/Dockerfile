# =======================================================
# STAGE 1: 基础环境 (CUDA 12.1.1 + cuDNN 8 + Ubuntu 22.04)
# =======================================================
# 基础镜像已更新为精确版本
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 设置工作目录
WORKDIR /app

# 复制依赖文件。请确保 requirements.txt 在 Dockerfile 同级目录
COPY requirements.txt /app/

# 1. 定义代理构建参数 (BUILD ARGS)
ARG HTTP_PROXY
ARG HTTPS_PROXY

# 2. 将代理参数转化为环境变量 (RUNTIME ENVS)
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}

# 3. 安装系统依赖和工具 (核心步骤)
RUN \
    # 临时配置 apt 代理
    if [ ! -z "${HTTP_PROXY}" ]; then \
        echo "Acquire::http::Proxy \"${HTTP_PROXY}\";" > /etc/apt/apt.conf.d/proxy.conf; \
        echo "Acquire::https::Proxy \"${HTTPS_PROXY}\";" >> /etc/apt/apt.conf.d/proxy.conf; \
    fi && \
    
    # === 关键修复：设置 DEBIAN_FRONTEND 和 ACCEPT_EULA 以避免交互式安装 ===
    export DEBIAN_FRONTEND=noninteractive && \
    export ACCEPT_EULA=Y && \
    # ----------------------------------------------------------------------
    
    # === 关键修复：强制 APT 忽略 NVIDIA 源的 SSL 证书错误 ===
    echo 'Acquire::https::developer.download.nvidia.com::Verify-Peer "false";' > /etc/apt/apt.conf.d/99no-nvidia-ssl-check && \
    # ----------------------------------------------------------------------
    
    # 第一次更新 & 安装核心工具和驱动依赖
    apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    wget \
    build-essential \
    pkg-config \
    # ----------------------------------------------------
    && \
    
    # 强制 curl 使用 ENV 变量，下载 GPG 密钥
    export http_proxy=${HTTP_PROXY} && export https_proxy=${HTTPS_PROXY} && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
    # Ubuntu 22.04 的代号是 jammy
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" > /etc/apt/sources.list.d/mssql-tools.list && \
    
    # 第二次更新 (加载 Microsoft 源) & 安装 Python 和 ODBC 驱动
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    msodbcsql18 \
    mssql-tools18 \
    unixodbc-dev \
    # ----------------------------------------------------
    && \
    
    # 清理缓存，减小镜像体积并清除 apt 代理配置
    rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/apt/apt.conf.d/proxy.conf

# 4. 设置 Python 别名
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# 4.5. 配置 pip 信任 PyPI 源 (解决 'trusted-host' 重复定义错误)
RUN mkdir -p /root/.pip && \
    echo "[global]" >> /root/.pip/pip.conf && \
    # 关键修复：将所有 trusted-host 域名写在同一行，用空格分隔
    echo "trusted-host = pypi.org files.pythonhosted.org" >> /root/.pip/pip.conf

# 5. 安装 Python 依赖 (通过 requirements.txt)
RUN pip install --no-cache-dir \
    -r requirements.txt \ 
    --extra-index-url https://download.pytorch.org/whl/cu121 \
    --trusted-host download.pytorch.org

# 6. 复制项目代码
COPY . /app

# 定义容器启动时默认执行的命令
CMD ["bash"]
