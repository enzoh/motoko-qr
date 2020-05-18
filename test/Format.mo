/**
 * Module     : Format.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Format "../src/Format";
import List "mo:base/List";
import Nat "../src/Nat";

actor {

  func runAnnexCTest() {
    let mask = List.fromArray<Bool>([true, false, true]);
    let bits = Format.encode(#M, mask);
    let n = List.len<Bool>(bits);
    assert (Nat.natFromBits(bits) == 16590);
    assert (n == 15)
  };

  let tests = [runAnnexCTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
