The Motoko QR Package

[![Build Status](https://travis-ci.org/enzoh/motoko-qr.svg?branch=master)](https://travis-ci.org/enzoh/motoko-qr?branch=master)

### Overview

This package implements a QR-code generator.

### Demo

Start a local internet computer.

```
dfx start
```

Execute the following commands in another tab.

```
dfx build
dfx canister install --all
dfx canister call demo encode \
  '(variant{Version = 2}, variant{M}, variant{Alphanumeric}, "HTTPS://SDK.DFINITY.ORG")' \
  | sed 's/[(")]//g' \
  | sed 's/#/█/g'
```

Observe the following result.

![Result](img/demo.png)
