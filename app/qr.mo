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
import EightBit "../src/eight-bit";
import Kanji "../src/kanji";
import List "mo:stdlib/list";
import Mask "../src/mask";
import Numeric "../src/numeric";
import Option "mo:stdlib/option";
import Symbol "../src/symbol";
import Version "../src/version";

actor {

  type List<T> = List.List<T>;

  public type ErrorCorrection = Common.ErrorCorrection;
  public type Matrix = Common.Matrix;
  public type Mode = Common.Mode;
  public type Version = Version.Version;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async ?Matrix {
    Option.bind<List<Bool>, Matrix>(
      switch mode {
        case (#Alphanumeric) Alphanumeric.encode(version, text);
        case (#EightBit) EightBit.encode(version, text);
        case (#Kanji) Kanji.encode(version, text);
        case (#Numeric) Numeric.encode(version, text);
      },
      func (data) {
        Option.map<List<Bool>, Matrix>(
          func (code) {
            let (matrix, mask) = Mask.generate(version, level, code);
            { unbox =
              Symbol.freeze(
              Symbol.applyVersions(version,
              Symbol.applyFormats(version, level, mask, matrix)))
            }
          },
          Block.interleave(version, level, data)
        )
      }
    )
  };

  public func show(matrix : Matrix) : async Text {
    Array.foldl<[Bool], Text>(func (accum1, row) {
      Array.foldl<Bool, Text>(func (accum2, col) {
        let text = if col "##" else "  ";
        text # accum2
      }, "\n", row) # accum1
    }, "", matrix.unbox)
  };

  public func version(n : Nat) : async Version {
    Version.new(n)
  };

}
