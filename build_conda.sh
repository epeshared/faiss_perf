docker build -t faiss_perf_conda -f Dockerfile.conda .
docker run --privileged --cap-add=SYS_ADMIN -v /mnt/nvme0/faiss_data/deep1b:/home/deep1b -v /mnt/nvme0/faiss_data/sift1M:/home/sift1M  --name faiss_perf_conda -t -i faiss_perf_conda

