/**
 * Module     : generic.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import List "mo:stdlib/list";
import Prelude "mo:stdlib/prelude";

module {

  type List<T> = List.List<T>;

  public func genericEncode(
    version : Common.Version,
    level : Common.ErrorCorrection,
    data : List<Bool>
  ) : Common.Matrix {
    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
