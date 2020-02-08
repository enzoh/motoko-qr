/**
 * Module     : version.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Common "../src/common";
import List "mo:stdlib/list";
import Nat "../src/nat";
import Version "../src/version";

actor {

  func runAnnexDTest() {
    let bits = Version.encode(Common.versionNew(7));
    let n = List.len<Bool>(bits);
    assert (Nat.natFromBits(bits) == 31892);
    assert (n == 18)
  };

  let tests = [runAnnexDTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
