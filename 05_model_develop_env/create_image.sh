
#!/bin/bash

# 构建 Docker 镜像并打上标签
# -t: 给镜像命名和版本号
# -f: 指定 Dockerfile 的路径
# .: 构建上下文，代表当前目录

echo "Starting Docker image build for model_notebook:202508..."


docker build --no-cache \
  -t model_notebook:202511 \
  -f notebook_Dockderfile \
  .
# 检查构建是否成功
if [ $? -eq 0 ]; then
  echo "✅ Docker image built successfully."
else
  echo "❌ Docker image build failed."
fi
