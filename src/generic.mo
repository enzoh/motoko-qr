/**
 * Module      : generic.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import List "mo:stdlib/list.mo";
import Prelude "mo:stdlib/prelude.mo";

module {

  type List<T> = List.List<T>;

  public func genericEncode(
    version : Common.Version,
    level : Common.ErrorCorrection,
    data : List<Bool>
  ) : ?Common.Matrix {
    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
