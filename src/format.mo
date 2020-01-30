/**
 * Module      : format.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import Galois "../src/galois.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Util "../src/util.mo";

type ErrorCorrection = Common.Common.ErrorCorrection;
type List<T> = List.List<T>;

let getECIBits = Common.Common.getECIBits;
let polyAdd = Galois.Galois.polyAdd;
let polyDivMod = Galois.Galois.polyDivMod;
let polyFromBits = Galois.Galois.polyFromBits;
let polyToBits = Galois.Galois.polyToBits;

module Format {

  public func formatEncode(
    level : ErrorCorrection,
    mask : List<Bool>
  ) : List<Bool> {
    let input = List.append<Bool>(getECIBits(level), mask);
    let poly1 = polyFromBits(Util.bitPadRight(10, input));
    let poly2 = polyFromBits(Nat.natToBits(1335));
    Util.bitPadLeftTo(15, Nat.natToBits(Nat.natXor(Nat.natFromBits(polyToBits(polyAdd(poly1, polyDivMod(poly1, poly2).1))), 21522)))
  };

}
