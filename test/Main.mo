/**
 * Module     : Main.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Format "canister:format";
import Galois "canister:galois";
import Version "canister:version";

actor {

  public func run() {
    Format.run();
    Galois.run();
    Version.run()
  };

}
