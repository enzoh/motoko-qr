/**
 * Module     : symbol.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import Iter "mo:stdlib/iter";
import List "mo:stdlib/list";
import Prelude "mo:stdlib/prelude";
import Prim "mo:prim";
import Version "version";

module {

  type Coordinate = (Nat, Nat);
  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Matrix = Common.Matrix;
  type Version = Version.Version;

  public func symbolize(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : Matrix {
    ////////////////////////////////////////////////////////////////////////////
    let text = List.foldLeft<Bool, Text>(data, "", func (test, accum) {
        accum # (if test "1" else "0")
    });
    Prelude.printLn(text);
    ////////////////////////////////////////////////////////////////////////////
    { unbox = [] }
  };

  func trace(version : Version) : List<Coordinate> {

    let w = Common.info(version).width;
    let t = w - 7;

    let up = List.concat<Nat>(List.map<Nat, List<Nat>>(
      Iter.toList<Nat>(Iter.range(0, w - 1)),
      func (i) { List.replicate<Nat>(2, i) }
    ));
    let down = List.rev<Nat>(up);

    func rowwise(n : Nat, is : List<Nat>) : List<Nat> {
      List.concat<Nat>(List.replicate<List<Nat>>(n * w, is))
    };

    func columnwise(is : List<Nat>) : List<Nat> {
      List.concat<Nat>(
        List.concat<List<Nat>>(
          List.map<List<Nat>, List<List<Nat>>>(
            List.chunksOf<Nat>(2, is),
            func (chunk) {
              List.replicate<List<Nat>>(w, chunk)
            }
          )
        )
      )
    };

    let rows1 = rowwise(w - t, List.append<Nat>(up, down));
    let rows2 = rowwise(6, List.append<Nat>(down, up));

    let cols1 = columnwise(Iter.toList<Nat>(Iter.range(0, t - 1)));
    let cols2 = columnwise(Iter.toList<Nat>(Iter.range(t + 1, w - 1)));

    let pairs = List.append<Coordinate>(
      List.zip<Nat, Nat>(rows1, cols1),
      List.zip<Nat, Nat>(rows2, cols2) 
    );

    List.filter<Coordinate>(pairs, func (pair) { pair.0 != t })
  };

}
