#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import argparse
import subprocess
from flask import Flask, request

app = Flask(__name__)


@app.route('/<ip>')
def nali(ip):
    if not ip:
        return 'Please provide an IP address.'
    ips = re.findall("(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}?)+", ip)

    cmd_result = subprocess.run(['./scripts/nali', " ".join(ips)], stdout=subprocess.PIPE)
    ip_info_str_list = cmd_result.stdout.decode().split("  ")
    ip_info_str_list = [(el.strip()) for el in ip_info_str_list]
    result = []
    for ip_info_str in ip_info_str_list:
        split_columns = ip_info_str.split(" [")
        split_columns[1] = split_columns[1].rstrip(']')
        result.append({
            'ip': split_columns[0],
            "addr": split_columns[1].strip()
        })
    return result


if __name__ == '__main__':
    project_dir = os.path.dirname(os.path.abspath(__file__))

    # 创建解析器对象，并添加一个命令行参数
    parser = argparse.ArgumentParser()
    parser.add_argument("--listen-host", type=str, help="The hostname that the server will use.",
                        default=os.getenv("LISTEN_HOST", "0.0.0.0"))
    parser.add_argument("--listen-port", type=int, help="The listening port that the server will use.",
                        default=os.getenv("LISTEN_PORT", 8080))
    parser.add_argument("--nali-update", type=bool, help="Nali forced updates.",
                        default=os.getenv("NALI_UPDATE", False))
    parser.add_argument("--ip-update", type=bool, help="IP db forced updates.",
                        default=os.getenv("IP_UPDATE", False))
    # 解析命令行参数
    args = parser.parse_args()

    if not os.path.exists(f"{project_dir}/scripts/nali") or args.nali_update:
        subprocess.run(['/bin/bash', 'downloads.sh'], cwd=f"{project_dir}/scripts", stdout=subprocess.PIPE)
    elif args.ip_update:
        # 更新一下
        subprocess.run([f'{project_dir}/scripts/nali', "update"], stdout=subprocess.PIPE)

    app.run(host=args.listen_host, port=args.listen_port)
