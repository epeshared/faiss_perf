# faiss_perf

This is the docker file to setup faiss runtime eviroment. The steps are:

* run build_conda.sh （to use some data, you may modify the build_conda.sh to specify the data location)

After entry the docker container
* run run_conda.sh
* run run_conda_env.sh
* run build_faiss.sh

You maybe build oneDNN by manually
