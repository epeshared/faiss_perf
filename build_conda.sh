docker build -t faiss_perf_conda -f Dockerfile.conda .
docker run --privileged --cap-add=SYS_ADMIN -v /home/xtang/faiss_perf/deep1b:/home/deep1b -v /home/xtang/faiss_perf/sift1M:/home/sift1M  --name faiss_perf_conda -t -i faiss_perf_conda

