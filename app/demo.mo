/**
 * Module     : main.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Prelude "mo:stdlib/prelude";
import QR "canister:qr";

actor {

  public func example1() : async Text {
    let version = await QR.version(1);
    let result = await QR.encode(version, #M, #Numeric, "01234567");
    switch result {
      case (?matrix) await QR.show(matrix);
      case _ "Error: Invalid input!"
    }
  };

  public func example2() : async Text {
    let version = await QR.version(1);
    let result = await QR.encode(version, #Q, #Alphanumeric, "HELLO WORLD");
    switch result {
      case (?matrix) await QR.show(matrix);
      case _ "Error: Invalid input!"
    }
  };

}
