# VSCode Better Server Edition
[Upstream readme](https://github.com/microsoft/vscode#readme)

[![Feature Requests](https://img.shields.io/github/issues/SBell6hf/vscode-bse/feature-request.svg)](https://github.com/SBell6hf/vscode-bse/issues?q=is%3Aopen+is%3Aissue+label%3Afeature-request+sort%3Areactions-%2B1-desc)
[![Bugs](https://img.shields.io/github/issues/SBell6hf/vscode-bse/bug.svg)](https://github.com/SBell6hf/vscode-bse/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Abug)
[![CI](https://github.com/SBell6hf/vscode-bse/actions/workflows/ci.yml/badge.svg)](https://github.com/SBell6hf/vscode-bse/actions/workflows/ci.yml)

## The scope of this project
This project only adds features to make VS Code run better in a server scenario. We have no intention of changing VS Code in any way or to add additional features to VS Code itself.

#### For any feature requests, bug reports, or contributions that are not specific to running VS Code in a server context, please go to [microsoft/vscode](https://github.com/microsoft/vscode)

## Additional features
* Built-in TLS (HTTPS and WSS) support
* A better 403 forbidden screen that allows the user to enter the connection token
* Contains a usable `product.json` (Open VSX is disabled by default for security, and can be enabled by removing "extensionsGallery" in product-c.json and re-generating product.json)
* Support for connection tokens containing special characters
* All configurations valid in local user settings are valid in remote user settings when running as server
* Write settings to remote user settings by default when running as server

## Why create this project
Upstream maintainers think these features are not key features for the vscode server.

## Build and run from source
``` bash
mkdir vscode-server-build
pushd vscode-server-build

git clone --depth=1 https://github.com/SBell6hf/vscode-bse
pushd vscode-bse

bash generate-product-json.sh
PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 ELECTRON_SKIP_BINARY_DOWNLOAD=1 PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 yarn

# Cross building is not supported yet due to the presence of native bindings
bash build/build-server.sh

popd
rm -rf vscode-bse
for i in *; do tar -c "$i" | brotli -q 5 -c > "$i".tar.br; rm -rf "$i"; done
popd

ls vscode-server-build/*

```
A list of avalible options can be acquired with `bin/vscode-bse-server --help`

## Development
Run the script below first.

``` bash
git clone https://github.com/SBell6hf/vscode-bse
cd vscode-bse
bash generate-product-json.sh
PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 ELECTRON_SKIP_BINARY_DOWNLOAD=1 PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 yarn
echo 'Starting compilation.'
rm out/vs/server/remoteExtensionHostAgent.js
screen -dmS vecode-bse-dev-yarn-watch yarn watch
while ! ls out/vs/server/node/remoteExtensionHostAgentServer.js 2>/dev/null >/dev/null; do sleep 2; done
sleep 3
echo "Done."
```

Then, `VSCODE_DEV=1 node out/server-main.js` to start reh server (Code Server), and `node node_modules/@vscode/test-web/out/index.js --host localhost --port 8080 --browserType none --sourcesPath .` to start web server (Code for the Web).

See also: [Upstream docs](https://github.com/microsoft/vscode#contributing)
