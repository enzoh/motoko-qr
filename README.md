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
dfx canister create demo
dfx build
dfx canister install demo
dfx canister call demo encode '(variant{Version = 1}, variant{Q}, variant{Alphanumeric}, "HELLO WORLD")' | sed 's/#/█/g'
```
