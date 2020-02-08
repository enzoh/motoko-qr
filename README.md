## QR Code Generator

[![Build Status](https://travis-ci.org/enzoh/qr.svg?branch=master)](https://travis-ci.org/enzoh/qr?branch=master)

### Prerequisites

- [DFINITY SDK](https://sdk.dfinity.org)

### Demo

Start a local internet computer.

```bash
dfx start
```

Execute the following commands in another tab.

```bash
dfx build
dfx canister install --all
dfx canister call qr encode '(record{unbox = 1}, variant{L}, variant{Alphanumeric}, "HTTPS://SDK.DFINITY.ORG")'
```
