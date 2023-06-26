FROM julia:1.9.1

# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    python3 \
    python3-dev \
    python3-distutils \
    python3-pip \
    python3-venv \
    curl \
    ca-certificates \
    git \
    wget \
    zip \
    libjpeg-dev \
    vim \
    openssh-server \
    tree \
    sudo \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up
#RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3

# sudo
RUN echo "%${USER}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

USER ${NB_USER}

# Install Python libraries
ENV VIRTUAL_ENV=${HOME}/.venv/default
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install \
    jupyter-book \
    jupytext \
    sparse-ir \
    xprec \
    matplotlib \
    ghp-import \
    jupyterlab

# Install default Julia packages
RUN . ${HOME}/.venv/default/bin/activate && \
    mkdir -p ${HOME}/.julia/config && \
    echo '\
    # set environment variables\n\
    ENV["PYTHON"]=Sys.which("python3")\n\
    ENV["JUPYTER"]=Sys.which("jupyter")\n\
    ' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl
RUN julia -e 'using Pkg; Pkg.add(["IJulia", "Plots", "Revise", "FFTW", "Roots", "OMEinsum", "GR", "FastGaussQuadrature", "LaTeXStrings", "SparseIR"])'

RUN echo "export PATH=$HOME/.local/bin:\$PATH" >> ${HOME}/.bashrc
RUN echo "source ${VIRTUAL_ENV}/bin/activate" >> ${HOME}/.bashrc
ENV PATH $HOME/.local/bin:$PATH

WORKDIR /home/$NB_USER
RUN git clone https://github.com/SpM-lab/sparse-ir-tutorial --branch main --depth 1
WORKDIR /home/$NB_USER/sparse-ir-tutorial/src


EXPOSE 8888
CMD ["jupyter","lab","--ip","0.0.0.0"]
