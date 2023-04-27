# nali-api
Get the geographic location of the ip by http request, based on zu1k/nali.

### Run.
```shell
python app.py
```

### Request.
```shell
curl http://127.0.0.1:8080/8.8.8.8
```

### Respose.
```shell
[
  {
    "addr": "美国加利福尼亚州圣克拉拉县山景市 谷歌公司DNS服务器",
    "ip": "8.8.8.8"
  }
]
```