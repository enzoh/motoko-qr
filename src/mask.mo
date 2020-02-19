/**
 * Module     : mask.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import Version "version";

module {

  type ErrorCorrection = Common.ErrorCorrection;
  type Matrix = Common.Matrix;
  type Version = Version.Version;

  public func mask(
    version : Version,
    level : ErrorCorrection,
    matrix : Matrix
  ) : Matrix {
    matrix
  };

}
