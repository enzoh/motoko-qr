/**
 * Module      : format.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";

import Galois "../src/galois.mo";
import Nat "../src/nat.mo";
import Spec "../src/spec.mo";
import Util "../src/util.mo";

type ErrorCorrection = Spec.Spec.ErrorCorrection;
type List<T> = List.List<T>;

module Format {

  public func encode(level : ErrorCorrection, mask : List<Bool>) : List<Bool> {
    let input = List.append<Bool>(Spec.Spec.ecToBits(level), mask);
    let poly1 = Galois.Galois.polyFromBits(Util.Util.padRight(10, input));
    let poly2 = Galois.Galois.polyNew([1,0,1,0,0,1,1,0,1,1,1]);
    Util.Util.padLeftTo(
      15,
      Nat.Nat.natToBits(
        Nat.Nat.natXor(
          Nat.Nat.natFromBits(
            Galois.Galois.polyToBits(
              Galois.Galois.polyAdd(
                poly1,
                Galois.Galois.polyDivMod(poly1, poly2).1
              )
            )
          ),
          21522
        )
      )
    )
  };

}
