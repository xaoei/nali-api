#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import argparse
import subprocess

from flask import Flask, send_from_directory

# 初始化 Flask 应用程序
app = Flask(__name__)

# 获取项目目录路径
project_dir = os.path.dirname(os.path.abspath(__file__))

# 创建解析器对象，并添加命令行参数
parser = argparse.ArgumentParser(description='Start the nali web service.')
parser.add_argument('--listen-host', type=str, default=os.getenv('LISTEN_HOST', '0.0.0.0'),
                    help='The hostname that the server will use. Default is 0.0.0.0')
parser.add_argument('--listen-port', type=int, default=os.getenv('LISTEN_PORT', 80),
                    help='The listening port that the server will use. Default is 80')
parser.add_argument('--nali-update', type=str, default=os.getenv('NALI_UPDATE', "false"),
                    help='Whether to force update nali or not.')
parser.add_argument('--ipdb-update', type=str, default=os.getenv('IPDB_UPDATE', "false"),
                    help='Whether to force update IP database or not.')

# 解析命令行参数
# 如果当前运行环境是 gunicorn，使用默认参数启动应用程序
if 'SERVER_SOFTWARE' in os.environ and os.environ['SERVER_SOFTWARE'].startswith('gunicorn/'):
    print('Running under Gunicorn!')
    args = parser.parse_args(args=[])
else:
    print('Not running under Gunicorn!')
    args = parser.parse_args()

# 将更新标识转为布尔类型
args.nali_update = args.nali_update.lower() == "true"
args.ipdb_update = args.ipdb_update.lower() == "true"

# 打印启动参数
print(f"listen-host: {args.listen_host}")
print(f"listen-port: {args.listen_port}")
print(f"nali-update: {args.nali_update}")
print(f"ipdb-update: {args.ipdb_update}")

# 更新 nali
if not os.path.exists(f'{project_dir}/scripts/nali') or args.nali_update:
    subprocess.run(['/bin/bash', 'downloads.sh'], cwd=f'{project_dir}/scripts', stdout=subprocess.PIPE)
elif args.ipdb_update:
    subprocess.run([f'{project_dir}/scripts/nali', 'update'], stdout=subprocess.PIPE)


@app.route('/')
def index():
    """默认路由"""
    return {
        "code": 0,
        "msg": "Service is running."
    }


@app.route('/favicon.ico')
def favicon():
    """处理favicon请求"""
    return send_from_directory(os.path.join(app.root_path, 'static', 'images'), 'favicon.ico', mimetype='image/vnd.microsoft.icon')


@app.route('/<ip>')
def nali(ip):
    """查询 IP 地址信息"""
    if not ip:
        return 'Please provide an IP address.'
    # 提取 IP 地址
    ips = re.findall(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}?)+', ip)

    if len(ips) <= 0:
        return {
            "code": "1",
            "msg": "Not receiving any ip."
        }

    # 调用 nali 查询 IP 地址信息
    cmd_result = subprocess.run([f'{project_dir}/scripts/nali', ' '.join(ips)], stdout=subprocess.PIPE)
    ip_info_str_list = cmd_result.stdout.decode().split('  ')
    ip_info_str_list = [(el.strip()) for el in ip_info_str_list]
    result = []
    for ip_info_str in ip_info_str_list:
        split_columns = ip_info_str.split(' [')
        split_columns[1] = split_columns[1].rstrip(']')
        result.append({
            'ip': split_columns[0],
            'addr': split_columns[1].strip()
        })
    return {
        "code": "1",
        "msg": "Not receiving any ip.",
        "data": result
    }


if __name__ == '__main__':
    app.run(host=args.listen_host, port=args.listen_port)
