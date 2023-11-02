docker build . -t faiss_perf
docker run --privileged --cap-add=SYS_ADMIN -v /home/xtang/faiss_perf/deep1b:/home/deep1b -v /home/xtang/faiss_perf/sift1M:/home/sift1M  --name faiss_perf -t -i faiss_perf

