# 定义变量 MODEL，值为 Llama-2-7b-chat-hf-q4f16_1
build-mlc-llm:MODEL=Llama-2-7b-chat-hf-q4f16_1

# 定义变量 MODEL_LOCAL_ID，值为 FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1
build-mlc-llm:MODEL_LOCAL_ID=FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1

# 定义一个目标 build-mlc-llm-FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1，并指向 build-mlc-llm 目标
build-mlc-llm-FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1: build-mlc-llm

# 定义目标 build-mlc-llm
build-mlc-llm:
	# 启用 Docker BuildKit 以加速构建过程
	DOCKER_BUILDKIT=1 \
	# 使用 Docker 构建命令
	docker build \
		# 指定 Dockerfile 的路径为 mlc-llm-rk3588/Dockerfile
		-f mlc-llm-rk3588/Dockerfile \
		# 传递构建参数 MODEL_LOCAL_ID，其值为之前定义的 MODEL_LOCAL_ID 变量
		--build-arg MODEL_LOCAL_ID=${MODEL_LOCAL_ID} \
		# 传递构建参数 MODEL，其值为之前定义的 MODEL 变量
		--build-arg MODEL=${MODEL} \
		# 指定构建平台为 Linux ARM64 架构
		--platform linux/arm64 \
		# 指定构建的 Docker 镜像的名称和标签
		-t vicalloy/mlc-llm-rk3588:${MODEL_LOCAL_ID} \
		# 指定上下文路径为当前目录
		.
