#!/bin/bash

REPO_AUTHOR="zu1k"
REPO_NAME="nali"

OS=$(uname -s)
ARCH=$(uname -m)

VERSION=$(curl --silent "https://api.github.com/repos/$REPO_AUTHOR/$REPO_NAME/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')


if [[ "$OS" == "Darwin" ]]; then
  if [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="darwin-amd64"
  else
    PLATFORM="darwin-arm64"
  fi
elif [[ "$OS" == "FreeBSD" ]]; then
  if [[ "$ARCH" == "i386" ]]; then
    PLATFORM="freebsd-386"
  else
    PLATFORM="freebsd-amd64"
  fi
elif [[ "$OS" == "Linux" ]]; then
  if [[ "$ARCH" == "i386" ]]; then
    PLATFORM="linux-386"
  elif [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="linux-amd64"
  elif [[ "$ARCH" == "armv5l" ]]; then
    PLATFORM="linux-armv5"
  elif [[ "$ARCH" == "armv6l" ]]; then
    PLATFORM="linux-armv6"
  elif [[ "$ARCH" == "armv7l" ]]; then
    PLATFORM="linux-armv7"
  elif [[ "$ARCH" == "aarch64" ]]; then
    PLATFORM="linux-armv8"
  elif [[ "$ARCH" == "mips" && "$(uname -o)" == "GNU/Linux" ]]; then
    PLATFORM="linux-mips-softfloat"
  elif [[ "$ARCH" == "mipsel" && "$(uname -o)" == "GNU/Linux" ]]; then
    PLATFORM="linux-mipsle-softfloat"
  elif [[ "$ARCH" == "mips64" && "$(uname -o)" == "GNU/Linux" ]]; then
    PLATFORM="linux-mips64"
  elif [[ "$ARCH" == "mips64el" && "$(uname -o)" == "GNU/Linux" ]]; then
    PLATFORM="linux-mips64le"
  elif [[ "$ARCH" == "mips" && "$(uname -o)" == "MIPS-HardFloat-Linux" ]]; then
    PLATFORM="linux-mips-hardfloat"
  elif [[ "$ARCH" == "mipsel" && "$(uname -o)" == "MIPS-HardFloat-Linux" ]]; then
    PLATFORM="linux-mipsle-hardfloat"
  else
    echo "Unsupported platform: $OS $ARCH"
    exit 1
  fi
else
  echo "Unsupported platform: $OS $ARCH"
  exit 1
fi

EXEC_NAME="nali-$PLATFORM-$VERSION"
FILE_NAME="$EXEC_NAME.gz"
SHA256_FILE_NAME="$FILE_NAME.sha256"

rm -rf nali-*

FILE_URL="https://github.com/$REPO_AUTHOR/$REPO_NAME/releases/download/$VERSION/$FILE_NAME"
SHA256_FILE_URL="https://github.com/$REPO_AUTHOR/$REPO_NAME/releases/download/$VERSION/$SHA256_FILE_NAME"


# 下载release包
echo "Downloading ${FILE_URL}"
curl -L -o "${FILE_NAME}" "${FILE_URL}"

# 下载sha256包
echo "Downloading ${SHA256_FILE_URL}"
curl -L -o "${SHA256_FILE_NAME}" "${SHA256_FILE_URL}"

# 计算sha256值并与校验文件进行比对
if [[ "$(sha256sum $FILE_NAME)" != "$(cat $SHA256_FILE_NAME)" ]]; then
  echo "Sha256 comparison failed, exiting"
  exit 1
fi

# 解压文件
if ! gzip -d $FILE_NAME; then
  echo "Decompression failed, exiting"
  exit 1
fi

# 删除sha256文件
rm $SHA256_FILE_NAME

# 增加执行权限
chmod +x $EXEC_NAME

# 更新ip地址库
./$EXEC_NAME update

# 重命名
mv $EXEC_NAME nali
