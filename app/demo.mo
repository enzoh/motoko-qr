/**
 * Module     : demo.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import QR "canister:qr";

actor {

  type ErrorCorrection = QR.ErrorCorrection;
  type Mode = QR.Mode;
  type Version = QR.Version;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async Text {
    let result = await QR.encode(version, level, mode, text);
    switch result {
      case (?matrix) await QR.show(matrix);
      case _ "Error: Invalid input!";
    }
  };

}
