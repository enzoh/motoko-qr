/**
 * Module     : main.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Prelude "mo:stdlib/prelude";
import QR "../src/qr";

actor {

  public func example1() : async Text {
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

  public func example2() : async Text {
    let result = QR.qrEncode(QR.qrVersion(1), #Q, #Alphanumeric, "HELLO WORLD");
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
