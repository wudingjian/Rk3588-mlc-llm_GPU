#!/bin/bash
# 将传递给脚本的所有参数保存到 cmd 变量中
cmd=$@

# 如果命令包含 "mlc_chat.gradio"，则追加设备和路径参数
if [[ $@ == *"mlc_chat.gradio"* ]]; then
  cmd="${cmd} --device mali --artifact-path dist/prebuilt/"
fi

# 如果命令包含 "mlc_chat.rest"，则追加设备和模型参数
if [[ $@ == *"mlc_chat.rest"* ]]; then
  cmd="${cmd} --device mali  --model ${MODEL_LOCAL_ID}"
fi

# 如果没有传递任何命令，则默认执行 CLI 命令
if [[ $@ == "" ]]; then
  cmd="./build/mlc_chat_cli --device mali --model ${MODEL_LOCAL_ID}"
fi

# 输出最终的命令（调试用，已注释掉）
# echo ${cmd}

# 执行最终的命令
exec ${cmd}
