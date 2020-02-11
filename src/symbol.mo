/**
 * Module     : generic.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import List "mo:stdlib/list";
import Version "version";

module {

  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Matrix = Common.Matrix;
  type Version = Version.Version;

  public func symbolize(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : Matrix {
    { unbox = [] }
  };
}
