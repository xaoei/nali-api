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