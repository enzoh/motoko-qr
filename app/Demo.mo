/**
 * Module     : Demo.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import QR "canister:qr";

actor {

/* BUG: rejected as cyclic
  type ErrorCorrection_ = QR.ErrorCorrection;
  type Mode = QR.Mode;
  type Version = QR.Version;
*/

  public func encode(
    version : QR.Version,
    level : QR.ErrorCorrection,
    mode : QR.Mode,
    text : Text
  ) : async Text {
    let result = await QR.encode(version, level, mode, text);
    switch result {
      case (?matrix) "\n" # (await QR.show(matrix));
      case _ "Error: Invalid input!";
    }
  };

}
