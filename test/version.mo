/**
 * Module      : version.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Nat "../src/nat.mo";
import Spec "../src/spec.mo";
import Version "../src/version.mo";

let encode = Version.Version.encode;
let natFromBits = Nat.Nat.natFromBits;
let versionNew = Spec.Spec.versionNew;

actor UnitTester {

  func runAnnexDTest() {
    assert (natFromBits(encode(versionNew(7))) == 31892)
  };

  let tests = [runAnnexDTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
