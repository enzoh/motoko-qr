/**
 * Module      : common.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";
import Prelude "mo:stdlib/prelude.mo";
import Version "../src/version.mo"

type List<T> = List.List<T>;
type Version = Version.Version.Version;

module Common {

  public type ErrorCorrection = { #L; #M; #Q; #H };

  public type Matrix = { unbox : [[Bool]] };

  public type Mode = { #Alphanumeric; #EightBit; #Kanji; #Numeric };

  public func getECIBits(level : ErrorCorrection) : List<Bool> {
    switch (level) {
      case (#L) { ?(false, ?(true, null)) };
      case (#M) { ?(false, ?(false, null)) };
      case (#Q) { ?(true, ?(true, null)) };
      case (#H) { ?(true, ?(false, null)) }
    }
  };

  public func getCCILen(version : Version, mode : Mode) : Nat {
    let n = version.unbox;
    let i =
      if (09 >= n and n >= 01) 0 else
      if (26 >= n and n >= 10) 1 else
      if (40 >= n and n >= 27) 2 else {
      Prelude.printLn("Error: Invalid version!");
      Prelude.unreachable()
    };
    switch mode {
      case (#Numeric) [10,12,14][i];
      case (#Alphanumeric) [9,11,13][i];
      case (#EightBit) [8,16,16][i];
      case (#Kanji) [8,10,12][i]
    }
  };

}
