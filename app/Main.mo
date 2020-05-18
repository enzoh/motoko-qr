/**
 * Module     : Main.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import QR "../src/QR";

actor {

  public type ErrorCorrection = QR.ErrorCorrection;
  public type Matrix = QR.Matrix;
  public type Mode = QR.Mode;
  public type Version = QR.Version;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async ?Matrix {
    QR.encode(version, level, mode, text)
  };

  public func show(matrix : Matrix) : async Text {
    QR.show(matrix)
  };

}
