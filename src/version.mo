/**
 * Module     : version.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Galois "galois";
import List "mo:stdlib/list";
import Nat "nat";
import Prelude "mo:stdlib/prelude";
import Util "util";

module {

  type List<T> = List.List<T>;

  public type Version = { unbox : Nat };

  public func new(n : Nat) : Version {
    if (n > 40 or n == 0) {
      Prelude.printLn("Error: Invalid version!");
      Prelude.unreachable()
    };
    { unbox = n }
  };

  public func encode(version : Version) : List<Bool> {
    let input = Nat.natToBits(version.unbox);
    let poly1 = Galois.polyFromBits(Util.padRight(12, input));
    let poly2 = Galois.polyFromBits(Nat.natToBits(7973));
    Util.padLeftTo(18, Galois.polyToBits(Galois.polyAdd(poly1, Galois.polyDivMod(poly1, poly2).1)))
  };

}
