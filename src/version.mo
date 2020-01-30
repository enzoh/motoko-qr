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

module {

  type List<T> = List.List<T>;

  public func versionEncode(version : Common.Version) : List<Bool> {
    let input = Nat.natToBits(version.unbox);
    let poly1 = Galois.polyFromBits(Util.bitPadRight(12, input));
    let poly2 = Galois.polyFromBits(Nat.natToBits(7973));
    Util.bitPadLeftTo(18, Galois.polyToBits(Galois.polyAdd(poly1, Galois.polyDivMod(poly1, poly2).1)))
  };

}
