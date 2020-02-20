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

    let maskRef = List.fromArray<Bool>([false, true, true]);

    let mask = List.map<(Nat, Nat), Bool>(Symbol.pathCoords(version), func (i, j) {
      let w = Common.info(version).width;
      func unnatural(n : Nat) : Nat { w - 1 - n };
      (unnatural(i) + unnatural(j)) % 3 == 0
    });

    


    let matrix = Symbol.symbolize(version, List.zipWith<Bool, Bool, Bool>(
      mask,
      data,
      func (x, y) { x != y }
    ));




    (matrix, List.fromArray<Bool>([false, true, true]))
  };

}
