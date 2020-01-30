/**
 * Module      : version.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import Galois "../src/galois.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Prelude "mo:stdlib/prelude.mo";
import Util "../src/util.mo";

type List<T> = List.List<T>;
type Version = Common.Common.Version;

let bitPadLeftTo = Util.Util.bitPadLeftTo;
let bitPadRight = Util.Util.bitPadRight;
let polyAdd = Galois.Galois.polyAdd;
let polyDivMod = Galois.Galois.polyDivMod;
let polyFromBits = Galois.Galois.polyFromBits;
let polyToBits = Galois.Galois.polyToBits;

module Version {

  public func versionEncode(version : Version) : List<Bool> {
    let poly1 = polyFromBits(bitPadRight(12, Nat.natToBits(version.unbox)));
    let poly2 = polyFromBits(Nat.natToBits(7973));
    bitPadLeftTo(18, polyToBits(polyAdd(poly1, polyDivMod(poly1, poly2).1)))
  };

}
