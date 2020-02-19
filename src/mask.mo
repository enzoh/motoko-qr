/**
 * Module     : mask.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";

module {

  type Matrix = Common.Matrix;

  public func mask(matrix : Matrix) : Matrix {
    matrix
  };

}
