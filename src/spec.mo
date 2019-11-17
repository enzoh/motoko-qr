/**
 * Module      : spec.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";

type List<T> = List.List<T>;

module Spec {

  public type ErrorCorrection = { #L; #M; #Q; #H };

  public type Matrix = { unbox : [[Bool]] };

  public type Mode = { #Alphanumeric; #EightBit; #Kanji; #Numeric };

  public type Version = { unbox : Nat };

  public func ecToBits(level : ErrorCorrection) : List<Bool> {
    switch (level) {
      case (#L) { ?(false, ?(true, null)) };
      case (#M) { ?(false, ?(false, null)) };
      case (#Q) { ?(true, ?(true, null)) };
      case (#H) { ?(true, ?(false, null)) }
    }
  };

}
