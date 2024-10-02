# docker-images

<https://hub.docker.com/r/vicalloy/>

```bash
├── Dockerfile-python  # 用于构建包含 Python 3.10 和 Poetry 的 Docker 镜像。
└── mlc-llm-rk3588  # https://hub.docker.com/r/vicalloy/mlc-llm-rk3588/
    ├── Dockerfile  # 用于构建适用于 rk3588 设备的 mlc-llm 镜像，并包含特定模型。
    └── Dockerfile-base  # 用于构建基础的 mlc-llm 镜像，适用于 rk3588 设备。
```
