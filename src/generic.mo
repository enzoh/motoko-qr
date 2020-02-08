/**
 * Module     : generic.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Block "block";
import Common "common";
import List "mo:stdlib/list";
import Prelude "mo:stdlib/prelude";
import Prim "mo:prim";

module {

  type List<T> = List.List<T>;

  public func encode(
    version : Common.Version,
    level : Common.ErrorCorrection,
    data : List<Bool>
  ) : Common.Matrix {
    //Prelude.printLn(List.foldLeft<Bool, Text>(data, "", func (test, accum) { accum # (if test "1" else "0") }));
    Prelude.printLn(List.foldLeft<Bool, Text>(Block.appendPadCodewords(version, level, data), "", func (test, accum) { accum # (if test "1" else "0") }));
    //let _ = Block.genPadCodewords(version, level, data);
    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
