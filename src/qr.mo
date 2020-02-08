/**
 * Module     : qr.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Alphanumeric "alphanumeric";
import Common "common";
import Generic "generic";
import List "mo:stdlib/list";
import Numeric "numeric";
import Option "mo:stdlib/option";
import Prelude "mo:stdlib/prelude";
import Version "version";

module {

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

  public func show(matrix : Matrix) : Text {
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

  public let version = Version.new;

}
