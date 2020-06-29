/**
 * Module     : Version.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import List "mo:base/List";
import Nat "../src/Nat";
import Version "../src/Version";

actor {

  func runAnnexDTest() {
    let bits = Version.encode(#Version 7);
    let n = List.size<Bool>(bits);
    assert (Nat.natFromBits(bits) == 31892);
    assert (n == 18)
  };

  let tests = [runAnnexDTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
