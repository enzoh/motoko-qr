/**
 * Module      : version.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Version "../src/version.mo";

let versionEncode = Version.Version.versionEncode;
let versionNew = Common.Common.versionNew;

actor Test {

  func runAnnexDTest() {
    let bits = versionEncode(versionNew(7));
    let n = List.len<Bool>(bits);
    assert (Nat.natFromBits(bits) == 31892);
    assert (n == 18)
  };

  let tests = [runAnnexDTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
