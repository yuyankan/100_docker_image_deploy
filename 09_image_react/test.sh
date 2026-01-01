sudo docker build --network host \
  --no-cache \
  --progress=plain \
  -t react_vite_isra_tracking_fun:202511 \
  -f docker_test_image \
  .
