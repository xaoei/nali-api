FROM python:3.8-slim-buster

# 安装curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 安装依赖包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用程序代码到容器中
COPY . .

# 声明端口
EXPOSE 80

# 启动应用程序
CMD ["python", "app.py"]