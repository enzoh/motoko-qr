/**
 * Module     : mask.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import List "mo:stdlib/list";
import Symbol "symbol";
import Version "version";

module {

  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Version = Version.Version;

  public func generate(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ([var [var Bool]], List<Bool>) {
    // TODO: Implement masking!
    let matrix = Symbol.symbolize(version, data);
    (matrix, List.fromArray<Bool>([false, true, true]))
  };

}
