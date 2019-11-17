/**
 * Module      : format.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Galois "../src/galois.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Spec "../src/spec.mo";
import Util "../src/util.mo";

type ErrorCorrection = Spec.Spec.ErrorCorrection;
type List<T> = List.List<T>;

let bitPadLeftTo = Util.Util.bitPadLeftTo;
let bitPadRight = Util.Util.bitPadRight;
let natFromBits = Nat.Nat.natFromBits;
let natToBits = Nat.Nat.natToBits;
let natXor = Nat.Nat.natXor;
let polyAdd = Galois.Galois.polyAdd;
let polyDivMod = Galois.Galois.polyDivMod;
let polyFromBits = Galois.Galois.polyFromBits;
let polyToBits = Galois.Galois.polyToBits;

module Format {

  public func encode(level : ErrorCorrection, mask : List<Bool>) : List<Bool> {
    let input = List.append<Bool>(Spec.Spec.ecToBits(level), mask);
    let poly1 = polyFromBits(bitPadRight(10, input));
    let poly2 = polyFromBits(natToBits(1335));
    bitPadLeftTo(15, natToBits(natXor(natFromBits(polyToBits(polyAdd(poly1, polyDivMod(poly1, poly2).1))), 21522)))
  };

}
