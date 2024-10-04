# 使用 Dockerfile 语法的实验特性
# syntax=docker/dockerfile:1-labs

# 定义构建参数：模型名称和模型本地 ID
ARG MODEL
ARG MODEL_LOCAL_ID
# 提示：Llama-2 需要 16GB 的显存
#ARG MODEL=RedPajama-INCITE-Chat-3B-v1-q4f16_1
#ARG MODEL=Llama-2-7b-chat-hf-q4f16_1
#ARG MODEL=Llama-2-13b-chat-hf-q4f16_1

# --------------------------------------------------------------------------- #

# 使用 Alpine Linux 作为基础镜像来获取必要的工具
FROM alpine AS fetch
# 安装 git 和 git-lfs
RUN apk add --no-cache \
    git \
    git-lfs \
    ;

# 使用空镜像（scratch）作为基础镜像来添加二进制文件
FROM scratch AS git-binary-mlc-llm-libs
# 将指定的 GitHub 仓库添加到镜像中
ADD https://github.com/mlc-ai/binary-mlc-llm-libs.git /

# --------------------------------------------------------------------------- #

# 使用空镜像（scratch）作为基础镜像来添加模型的二进制库
FROM scratch AS binary-mlc-llm-lib
# 使用构建参数 MODEL
ARG MODEL
# 从之前的阶段复制模型的二进制库文件到根目录
COPY --from=git-binary-mlc-llm-libs /${MODEL}-mali.so /

# --------------------------------------------------------------------------- #

# 从 fetch 阶段获取模型
FROM fetch AS fetch-model
# 使用构建参数 MODEL_LOCAL_ID
ARG MODEL_LOCAL_ID
# 定义 Git 仓库的 URL
ARG GIT_URL="https://huggingface.co/mlc-ai/${MODEL_LOCAL_ID}.git"
# 创建缓存目录并克隆指定的 Git 仓库
RUN mkdir -p /cache/${MODEL_LOCAL_ID}/ \
    && git clone \
      --single-branch --depth 1 \
      --separate-git-dir=/cache/${MODEL_LOCAL_ID}/git \
      ${GIT_URL} \
      /out/${MODEL_LOCAL_ID} \
    ;

# --------------------------------------------------------------------------- #

# 使用空镜像（scratch）作为基础镜像来添加模型文件
FROM scratch AS model
# 从 fetch-model 阶段复制模型文件到根目录
COPY --link --from=fetch-model /out/ /

# --------------------------------------------------------------------------- #

# 使用指定的基础镜像 vicalloy/mlc-llm-rk3588:base
FROM vicalloy/mlc-llm-rk3588:base

# 从 binary-mlc-llm-lib 阶段复制二进制库到目标路径
COPY --link --from=binary-mlc-llm-lib / /mlc-llm/dist/prebuilt/lib/
# 从 model 阶段复制模型文件到目标路径
COPY --link --from=model / /mlc-llm/dist/prebuilt/
# 复制本地的 entrypoint 脚本到容器的根目录
COPY ./mlc-llm-rk3588/entrypoint.sh /entrypoint.sh

# 设置环境变量 LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/mlc-llm/build/
# 设置工作目录
WORKDIR /mlc-llm

# 由于不能在 CMD 中插值 ARG，所以将其分配给 ENV 并在启动时解析
ARG MODEL_LOCAL_ID
ENV MODEL_LOCAL_ID=${MODEL_LOCAL_ID}

# 设置容器的入口点为 entrypoint.sh 脚本
ENTRYPOINT ["/entrypoint.sh"]
