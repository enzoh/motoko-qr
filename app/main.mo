/**
 * Module      : main.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Prelude "mo:stdlib/prelude.mo";
import QR "../src/qr.mo";

let qrEncode = QR.QR.qrEncode;
let qrShow = QR.QR.qrShow;
let qrVersion = QR.QR.qrVersion;

actor App {

  public func example() : async Text {
    let result = qrEncode(qrVersion(1), #M, #Numeric, "01234567");
    switch result {
      case (?matrix) {
        qrShow(matrix)
      };
      case _ {
        Prelude.printLn("Error: Invalid input!");
        Prelude.unreachable()
      }
    }
  };

}
