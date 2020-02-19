/**
 * Module     : qr.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Alphanumeric "../src/alphanumeric";
import Array "mo:stdlib/array";
import Block "../src/block";
import Common "../src/common";
import List "mo:stdlib/list";
import Mask "../src/mask";
import Numeric "../src/numeric";
import Option "mo:stdlib/option";
import Prelude "mo:stdlib/prelude";
import Symbol "../src/symbol";
import Version "../src/version";

actor {

  type List<T> = List.List<T>;

  public type Version = Version.Version;

  public type ErrorCorrection = Common.ErrorCorrection;

  public type Mode = Common.Mode;

  public type Matrix = Common.Matrix;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async ?Matrix {
    Option.bind<List<Bool>, Matrix>(
      switch mode {
        case (#Alphanumeric) Alphanumeric.encode(version, text);
        case (#EightBit) {
          Prelude.printLn("Error: 8-bit mode is not yet implemented!");
          Prelude.unreachable()
        };
        case (#Kanji) {
          Prelude.printLn("Error: Kanji mode is not yet implemented!");
          Prelude.unreachable()
        };
        case (#Numeric) Numeric.encode(version, text);
      },
      func (data) {
        Option.map<List<Bool>, Matrix>(
          func (code) {
            Option.map<Matrix, Matrix>(
              func (symbol) {
                Mask.mask(version, level, symbol)
              },
              Symbol.symbolize(version, code)
            )
          },
          Block.interleave(version, level, data)
        )
      }
    )
  };

  public func show(matrix : Matrix) : async Text {
    Array.foldl<[Bool], Text>(func (accum1, row) {
      Array.foldl<Bool, Text>(func (accum2, bit) {
        if bit {
          "##" # accum2
        } else {
          "  " # accum2
        }
      }, "\n", row) # accum1
    }, "", matrix.unbox)
  };

  public func version(n : Nat) : async Version {
    Version.new(n)
  };

}
