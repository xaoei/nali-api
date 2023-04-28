# nali-api
Get the geographic location of the ip by http request, based on [zu1k/nali](https://github.com/zu1k/nali.git).

[中文](README_zh.md)|[English](README.md)

### Deploy.
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/rQNQTh?referralCode=TF5qcU)

### Run.
```shell
python app.py
```

### Request.
```shell
curl http://127.0.0.1/8.8.8.8
```

### Response.
```shell
[
  {
    "addr": "美国加利福尼亚州圣克拉拉县山景市 谷歌公司DNS服务器",
    "ip": "8.8.8.8"
  }
]
```

### Run With Docker.
```shell
docker run -d --name nali-api --restart always -p 8080:80 reallester/nali-api:latest
```

### Run with Compose.
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

### Params.
| Parameter     | Environment Variable | Default | Description                                                             |
|---------------|----------------------|---------|-------------------------------------------------------------------------|
| --listen-host | LISTEN_HOST          | 0.0.0.0 | The hostname that the server will use (cannot be used in Docker).       |
| --listen-port | LISTEN_PORT          | 80      | The listening port that the server will use (cannot be used in Docker). |
| --nali-update | NALI_UPDATE          | false   | Indicates whether to force an update of Nali or not.                    |
| --ipdb-update | IPDB_UPDATE          | false    | Indicates whether to force an update of the IP database or not.         |

