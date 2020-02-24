/**
 * Module     : demo.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Option "mo:stdlib/option";
import QR "canister:qr";

actor {

  type ErrorCorrection = QR.ErrorCorrection;
  type Matrix = QR.Matrix;
  type Mode = QR.Mode;
  type Version = QR.Version;

  public func encode(
    n : Nat,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async Text {
    let version = await QR.version(n);
    let result = await QR.encode(version, level, mode, text);
    if (Option.isSome<Matrix>(result)) {
      let matrix = Option.unwrap<Matrix>(result);
      await QR.show(matrix)
    } else {
      "Error: Invalid input!"
    }
  };

}
