# 使用 Python 3.8 的 slim 版本作为基础镜像，该镜像已经包含了 Python 环境
FROM python:3.8-slim-buster

# 安装 curl 工具，curl 用于在容器内下载文件等操作
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 将 requirements.txt 文件复制到容器中，并且安装依赖包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用程序代码到容器中，注意这里是将当前目录下的所有文件都复制到容器中，包括 Dockerfile 和 requirements.txt 等不必要的文件，应该根据实际情况进行调整
COPY . .

# 声明端口，该容器会监听 80 端口
EXPOSE 80

# 设置工作目录，注意这里多次设置工作目录的原因是为了让 CMD 命令的执行路径在 /app 目录下，这样可以确保应用程序可以正常启动
WORKDIR /app

# 启动应用程序，使用 gunicorn 作为 Web 服务器，-w 1 表示只启动一个 worker 进程，-t 60 表示超时时间为 60 秒，-b 0.0.0.0:80 表示监听所有 IP 地址的 80 端口，后面的 app:app 表示应用程序入口为 app.py 文件中名字为 app 的 Flask 实例
CMD ["/bin/bash", "-c", "gunicorn -w 1 -t 60 -b 0.0.0.0:80 app:app --preload"]
