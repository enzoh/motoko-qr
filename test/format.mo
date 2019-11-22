/**
 * Module      : format.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Format "../src/format.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";

let formatEncode = Format.Format.formatEncode;
let natFromBits = Nat.Nat.natFromBits;

actor Test {

  func runAnnexCTest() {
    let bits = formatEncode(#M, List.fromArray([true, false, true]));
    let n = List.len<Bool>(bits);
    assert (natFromBits(bits) == 16590);
    assert (n == 15)
  };

  let tests = [runAnnexCTest];

  public func run() {
    for (test in tests.vals()) test()
  };

}
