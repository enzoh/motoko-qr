/**
 * Module      : format.mo
 * Copyright   : 2020 DFINITY Stiftung
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Stable
 */

import Common "../src/common.mo";
import Galois "../src/galois.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Util "../src/util.mo";

module {

  type List<T> = List.List<T>;

  public func formatEncode(
    level : Common.ErrorCorrection,
    mask : List<Bool>
  ) : List<Bool> {
    let input = List.append<Bool>(Common.getECIBits(level), mask);
    let poly1 = Galois.polyFromBits(Util.bitPadRight(10, input));
    let poly2 = Galois.polyFromBits(Nat.natToBits(1335));
    Util.bitPadLeftTo(15, Nat.natToBits(Nat.natXor(Nat.natFromBits(Galois.polyToBits(Galois.polyAdd(poly1, Galois.polyDivMod(poly1, poly2).1))), 21522)))
  };

}
