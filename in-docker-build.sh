set -eux -o pipefail

apk add \
  jq \
  gcc \
  python3 python3-dev \
  py3-lxml libxslt-dev \
  musl-dev

PKG_FILENAME=$(jq -r ".versions[\"${PKG_VERSION}\"].${TARGETARCH}.filename" /pkg-info.json)
PKG_DIGEST=$(jq -r ".versions[\"${PKG_VERSION}\"].${TARGETARCH}.digest" /pkg-info.json)
PKG_DL_URL=$(jq -r ".versions[\"${PKG_VERSION}\"].${TARGETARCH}.download_url" /pkg-info.json)

PKG_ARCH_FILE=/tmp/$PKG_FILENAME

wget -O ${PKG_ARCH_FILE} $PKG_DL_URL

case $PKG_DIGEST in
  sha256:*)
    echo "${PKG_DIGEST#sha256:} ${PKG_ARCH_FILE}" | sha256sum -c -
    ;;
  sha512:*)
    echo "${PKG_DIGEST#sha512:} ${PKG_ARCH_FILE}" | sha512sum -c -
    ;;
  *)
    echo "Unsupported digest format \`$PKG_DIGEST\`" >&2
    exit 1
    ;;
esac

mkdir -p /opt/bazarr
unzip -d /opt/bazarr ${PKG_ARCH_FILE}

rm ${PKG_ARCH_FILE}

cd /opt/bazarr
python3 -m venv .venv
source .venv/bin/activate

python3 -m pip install -r requirements.txt
