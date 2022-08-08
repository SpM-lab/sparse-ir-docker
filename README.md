# sparse-ir Docker Image

This builds the [shinaoka/sparse-ir](https://hub.docker.com/repository/docker/shinaoka/sparse-ir) docker hub image which includes [sparse-ir libraries and their tutotrials](https://spm-lab.github.io/sparse-ir-tutorial/).

One can run a Jupyterlab environment as

```
docker run --rm -p 8888:8888 shinaoka/sparse-ir
```

, or can run a shell as

```
docker run --rm -ti shinaoka/sparse-ir bash
```

The Jupyter notebook will be accessible at [http://localhost:8888](http://localhost:8888), where you should pass the token provided on the command line.
If you want the state of the virtual machine to be stored, drop `--rm` from the commands above.
A summary of useful docker commands can be found [here](https://www.docker.com/sites/default/files/Docker_CheatSheet_08.09.2016_0.pdf).