/**
 * Module      : qr.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import Generic "../src/generic.mo";
import List "mo:stdlib/list.mo";
import Numeric "../src/numeric.mo";
import Option "mo:stdlib/option.mo";
import Prelude "mo:stdlib/prelude.mo";

module {

  type List<T> = List.List<T>;

  public type Version = Common.Version;

  public type ErrorCorrection = Common.ErrorCorrection;

  public type Mode = Common.Mode;

  public type Matrix = Common.Matrix;

  public func qrEncode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : ?Matrix {
    Option.bind<List<Bool>, Matrix>(
      switch mode {
        case (#Alphanumeric) {
          Prelude.printLn("Error: Alphanumeric mode is not yet implemented!");
          Prelude.unreachable()
        };
        case (#EightBit) {
          Prelude.printLn("Error: 8-bit mode is not yet implemented!");
          Prelude.unreachable()
        };
        case (#Kanji) {
          Prelude.printLn("Error: Kanji mode is not yet implemented!");
          Prelude.unreachable()
        };
        case (#Numeric) {
          Numeric.numericEncode(version, text)
        };
      },
      func (data) {
        Generic.genericEncode(version, level, data)
      }
    )
  };

  public func qrShow(matrix : Matrix) : Text {
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

  public let qrVersion = Common.versionNew;

}
