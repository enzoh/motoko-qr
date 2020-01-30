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

type ErrorCorrection = Common.Common.ErrorCorrection;
type List<T> = List.List<T>;
type Matrix = Common.Common.Matrix;
type Version = Common.Common.Version;

module Generic {

  public func genericEncode(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?Matrix {
    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
