/**
 * Module      : format.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Format "../src/format.mo";
import Nat "../src/nat.mo";

let encode = Format.Format.encode;
let natFromBits = Nat.Nat.natFromBits;

actor Test {

  func runAnnexCTest() {
    let mask = ?(true, ?(false, ?(true, null)));
    assert (natFromBits(encode(#M, mask)) == 16590);
  };

  let tests = [runAnnexCTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
