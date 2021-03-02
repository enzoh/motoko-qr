The QR Package

[![Build Status](https://github.com/enzoh/motoko-qr/workflows/build/badge.svg)](https://github.com/enzoh/motoko-qr/actions?query=workflow%3Abuild)

This package implements a QR-code generator for the Motoko programming language.

### Prerequisites

- [DFINITY SDK](https://sdk.dfinity.org/docs/download.html) v0.6.24

### Usage

Generate a QR-code.
```motoko
public func encode(
  version : { #Version : Nat },
  level : { #L; #M; #Q; #H },
  mode : { #Alphanumeric; #EightBit; #Kanji; #Numeric },
  text : Text
) : ?{ #Matrix : [[Bool]] }
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
dfx canister call demo encode '(variant{Version = 1}, variant{Q}, variant{Alphanumeric}, "HELLO WORLD")' | sed 's/#/█/g'
```
