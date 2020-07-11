The QR Package

[![Build Status](https://github.com/enzoh/motoko-qr/workflows/build/badge.svg)](https://github.com/enzoh/motoko-qr/actions?query=workflow%3Abuild)

This package implements a QR-code generator for the Motoko programming language.

### Prerequisites

- [DFINITY SDK](https://sdk.dfinity.org/docs/download.html) v0.5.11
- [Vessel](https://github.com/kritzcreek/vessel/releases/tag/v0.4.1) v0.4.1 (Optional)

### Usage

Generate a QR-code.
```motoko
public func encode(
  version : Version,
  level : ErrorCorrection,
  mode : Mode,
  text : Text
) : ?Matrix
 ```

### Demo

Start a local internet computer.

```
dfx start
```

Execute the following commands in another tab.

```
dfx canister create --all
dfx build
dfx canister install --all
dfx canister call demo encode \
  '(variant{Version = 2}, variant{M}, variant{Alphanumeric}, "HTTPS://SDK.DFINITY.ORG")' \
  | sed 's/[(")]//g' \
  | sed 's/#/█/g'
```

Observe the following result.

![Result](img/demo.png)
