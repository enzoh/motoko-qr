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

  let maskRefs = [
    [false, false, false],
    [false, false, true],
    [false, true, false],
    [false, true, true],
    [true, false, false],
    [true, false, true],
    [true, true, false],
    [true, true, true]
  ];

  public func generate(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ([var [var Bool]], List<Bool>) {
    // TODO: Implement masking!
    let maskRef = List.fromArray<Bool>([false, true, true]);
    let mask = List.map<(Nat, Nat), Bool>(Symbol.pathCoords(version), func (a, b) {
      let w = Common.info(version).width;
      func fix(n : Nat) : Nat { w - 1 - n };
      let i = fix(a);
      let j = fix(b);
      // (i+j) % 2 == 0
      // i % 2 == 0
      // j % 3 == 0
      (i+j) % 3 == 0
      // ((i / 2) + (j / 3)) % 2 == 0
      // (i*j) % 2 + (i*j) % 3 == 0
      // ((i*j) % 2 + (i*j) % 3) % 2 == 0
      // ((i*j) % 3 + (i+j) % 2) % 2 == 0
    });
    let matrix = Symbol.symbolize(
      version,
      List.zipWith<Bool, Bool, Bool>(mask, data, func (x, y) { x != y })
    );
    (matrix, maskRef)
  };

}
