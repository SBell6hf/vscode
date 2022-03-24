#!/use/bin/env bash

pushd "$(dirname "$0")/.."

platformString="vscode-reh-web"

os="$(bash -c 'unset OSTYPE; bash -c "echo \$OSTYPE"')"
unameM="$(uname -m)"
arch="unknown"

if [[ "$unameM" == "arm64" || "$unameM" == "aarch64" ]]; then
	arch="arm64"
fi
if [[ "$unameM" == "x86-64" || "$unameM" == "x86_64" || "$unameM" == "x64" || "$unameM" == "amd64" ]]; then
	arch="x64"
fi
if [[ "$unameM" == "armv7" || "$unameM" == "armv7l" || "$unameM" == "armhf" ]]; then
	arch="armhf"
fi
if [[ "$unameM" == "x86" || "$unameM" == "i386" || "$unameM" == "ia32" ]]; then
	arch="ia32"
fi

if [[ "$os" == "linux-musl" ]]; then
	if [[ "$arch" == "ia32" ]]; then
		platformString="$platformString-linux-alpine"
	else
		platformString="$platformString-alpine-$arch"
	fi
else
	if [[ "$os" == "darwin"* ]]; then
		platformString="$platformString-darwin"
	elif [[ "$os" == "linux-gnu" || "$os" == "linux-android" ]]; then
		platformString="$platformString-linux"
	fi
	platformString="$platformString-$arch"
fi

yarn gulp "$platformString-min"
#yarn gulp "vscode-web-min"

#pushd ../vscode-web

# port="$RANDOM"
# node vscode-bse/node_modules/@vscode/test-web/out/index.js --codeWebPath vscode-web --host localhost --port "$port" --browserType none & testWebPID=$!
# sleep 0.5
# curl "http://127.0.0.1:$port" | sed "s/http:\/\/127.0.0.1:$port\//./g" >vscode-web/index.html
# kill "$testWebPID"

# mkdir -p vscode-web/static
# ln -s '..' vscode-web/static/build

# PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 yarn add "git+https://github.com/SBell6hf/vscode-test-web.git"
# npx tsc -p .

#popd
popd
