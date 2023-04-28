# nali-api
通过http请求获取IP的地理位置,基于[zu1k/nali](https://github.com/zu1k/nali.git).

[中文](README_zh.md)|[English](README.md)

### 快速部署.
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/rQNQTh?referralCode=TF5qcU)

### 运行.
```shell
python app.py
```

### 请求示例.
```shell
curl http://127.0.0.1/8.8.8.8
```

### 返回示例.
```shell
[
  {
    "addr": "美国加利福尼亚州圣克拉拉县山景市 谷歌公司DNS服务器",
    "ip": "8.8.8.8"
  }
]
```

### 使用Docker运行.
```shell
docker run -d --name nali-api --restart always -p 8080:80 reallester/nali-api:latest
```

### 使用Compose运行.
```
version: '3'
services:
  nali-api:
    image: reallester/nali-api:latest
    container_name: nali-api
    restart: always
    environment:
      NALI_UPDATE: "false"
      IP_UPDATE: "true"
    ports:
      - "8080:80"
```

### 参数.
| 参数名称          | 环境变量名       | 默认值     | 描述                         |
|---------------|-------------|---------|----------------------------|
| --listen-host | LISTEN_HOST | 0.0.0.0 | 服务器将使用的主机名.（在docker环境中无效）  |
| --listen-port | LISTEN_PORT | 80      | 服务器将使用的监听端口.（在docker环境中无效） |
| --nali-update | NALI_UPDATE | false   | 是否强制更新nali程序.              |
| --ipdb-update | IPDB_UPDATE | false    | 是否强制更新IP地址数据库.             |