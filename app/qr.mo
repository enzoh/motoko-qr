/**
 * Module     : qr.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Alphanumeric "../src/alphanumeric";
import Common "../src/common";
import Generic "../src/generic";
import List "mo:stdlib/list";
import Numeric "../src/numeric";
import Option "mo:stdlib/option";
import Prelude "mo:stdlib/prelude";
import Version "../src/version";

actor {

  type List<T> = List.List<T>;

  public type Version = Version.Version;

  public type ErrorCorrection = Common.ErrorCorrection;

  public type Mode = Common.Mode;

  public type Matrix = Common.Matrix;

  func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : ?Matrix {
    Option.map<List<Bool>, Matrix>(
      func (data) {
        Generic.encode(version, level, data)
      },
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
      }
    )
  };

  func show(matrix : Matrix) : Text {
    var accum = "";
    for (row in matrix.unbox.vals()) {
      for (val in row.vals()) {
        if val {
          accum #= "██"
        } else {
          accum #= "  "
        }
      };
      accum #= "\n"
    };
    accum
  };

  func version(n : Nat) : Version {
    Version.new(n)
  };

  public func demo() : async Text {
    let result = encode(version(1), #Q, #Alphanumeric, "HELLO WORLD");
    switch result {
      case (?matrix) show(matrix);
      case _ "Error: Invalid input!"
    }
  };

}
