/**
 * Module      : version.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Galois "../src/galois.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Prelude "mo:stdlib/prelude.mo";
import Util "../src/util.mo";

type List<T> = List.List<T>;

let bitPadLeftTo = Util.Util.bitPadLeftTo;
let bitPadRight = Util.Util.bitPadRight;
let natToBits = Nat.Nat.natToBits;
let polyAdd = Galois.Galois.polyAdd;
let polyDivMod = Galois.Galois.polyDivMod;
let polyFromBits = Galois.Galois.polyFromBits;
let polyToBits = Galois.Galois.polyToBits;

module Version {

  public type Version = { unbox : Nat };

  public func versionNew(n : Nat) : Version {
    if (n > 40 or n == 0) {
      Prelude.printLn("Error: Invalid version!");
      Prelude.unreachable()
    };
    { unbox = n }
  };

  public func encode(version : Version) : List<Bool> {
    let poly1 = polyFromBits(bitPadRight(12, natToBits(version.unbox)));
    let poly2 = polyFromBits(natToBits(7973));
    bitPadLeftTo(18, polyToBits(polyAdd(poly1, polyDivMod(poly1, poly2).1)))
  };

}
