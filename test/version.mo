/**
 * Module      : version.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Spec "../src/spec.mo";
import Version "../src/version.mo";

let encode = Version.Version.encode;
let natFromBits = Nat.Nat.natFromBits;
let versionNew = Spec.Spec.versionNew;

actor Test {

  func runAnnexDTest() {
    let bits = encode(versionNew(7));
    let n = List.len<Bool>(bits);
    assert (natFromBits(bits) == 31892);
    assert (n == 18)
  };

  let tests = [runAnnexDTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
