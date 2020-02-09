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
import Version "version";

module {

  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Matrix = Common.Matrix;
  type Version = Version.Version;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : Matrix {
    //Prelude.printLn(List.foldLeft<Bool, Text>(data, "", func (test, accum) { accum # (if test "1" else "0") }));
    Prelude.printLn(List.foldLeft<List<List<Bool>>, Text>(Block.toBlocks(version, level, data), "", func (block, accum1) {
      let foobar = List.foldLeft<Bool, Text>(List.concat<Bool>(block), "", func (test, accum2) { accum2 # (if test "1" else "0") });
      accum1 # foobar # "\n"
    }));
    //let _ = Block.genPadCodewords(version, level, data);
    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
