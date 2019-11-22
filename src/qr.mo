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

type List<T> = List.List<T>;

let genericEncode = Generic.Generic.genericEncode;
let numericEncode = Numeric.Numeric.numericEncode;
let versionNew = Common.Common.versionNew;

module QR {

  public type Version = Common.Common.Version;

  public type ErrorCorrection = Common.Common.ErrorCorrection;

  public type Mode = Common.Common.Mode;

  public type Matrix = Common.Common.Matrix;

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
          numericEncode(version, text)
        };
      },
      func (data) {
        genericEncode(version, level, data)
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

  public let qrVersion = versionNew;

}
