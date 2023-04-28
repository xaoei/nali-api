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