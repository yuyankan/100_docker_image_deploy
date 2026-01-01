
echo "Starting Docker image build for kafa_producer_rtsp_minio..."

docker build --no-cache \
  -t kafa_producer_rtsp_minio:202512 \
  -f Dockerfile \
  .

# 检查构建是否成功
if [ $? -eq 0 ]; then
  echo "✅ Docker image built successfully."
else
  echo "❌ Docker image build failed."
fi
