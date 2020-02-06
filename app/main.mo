/**
 * Module     : main.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Prelude "mo:stdlib/prelude.mo";
import QR "../src/qr.mo";

actor {

  public func example() : async Text {
    let result = QR.qrEncode(QR.qrVersion(1), #M, #Numeric, "01234567");
    switch result {
      case (?matrix) {
        QR.qrShow(matrix)
      };
      case _ {
        Prelude.printLn("Error: Invalid input!");
        Prelude.unreachable()
      }
    }
  };

}
