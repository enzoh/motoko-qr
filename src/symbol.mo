/**
 * Module     : symbol.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Array "mo:stdlib/array";
import Common "common";
import Iter "mo:stdlib/iter";
import List "mo:stdlib/list";
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
    //let text = List.foldLeft<Bool, Text>(data, "", func (test, accum) {
    //    accum # (if test "1" else "0")
    //});
    //Prelude.printLn(text);
    ////////////////////////////////////////////////////////////////////////////
    //let text2 = List.foldLeft<Coordinate, Text>(finderCoords({ unbox = 1 }), "", func (coordinate, accum) {
    //    accum # debug_show(coordinate)
    //});
    //Prelude.printLn(text2);
    { unbox = freeze(applyFinders(version, init(version))) }
  };

  func init(version : Version) : [var [var Bool]] {
    let w = Common.info(version).width;
    let matrix = Array.init<[var Bool]>(w, [var]);
    for (i in Iter.range(0, w - 1)) {
      matrix[i] := Array.init<Bool>(w, false)
    };
    matrix
  };

  func apply(
    setters : List<(Coordinate, Bool)>,
    matrix : [var [var Bool]]
  ) : [var [var Bool]] {
    List.iter<(Coordinate, Bool)>(setters, func (setter) {
      matrix[setter.0.0][setter.0.1] := setter.1
    });
    matrix
  };

  func freeze(matrix : [var [var Bool]]) : [[Bool]] {
    Array.map<[var Bool], [Bool]>(
      func (row) { Array.freeze<Bool>(row) },
      Array.freeze<[var Bool]>(matrix)
    )
  };

  func applyFinders(
    version : Version,
    matrix : [var [var Bool]]
  ) : [var [var Bool]] {
    apply(finders(version), matrix)
  };

  func finders(version : Version) : List<(Coordinate, Bool)> {
    List.concat<(Coordinate, Bool)>(List.fromArray<List<(Coordinate, Bool)>>([
      finderTL(version),
      finderTR(version),
      finderBL(version)
    ]))
  };

  func finderCoords(version : Version) : List<Coordinate> {
    List.concat<Coordinate>(List.fromArray<List<Coordinate>>([
      finderTLCoords(version),
      finderTRCoords(version),
      finderBLCoords(version)
    ]))
  };

  func finderTL(version : Version) : List<(Coordinate, Bool)> {
    let coords = finderTLCoords(version);
    List.zip<Coordinate, Bool>(coords, finderPattern())
  };

  func finderTLCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let v = w - 8;
    var coords = List.nil<Coordinate>();
    for (i in Iter.range(v, w - 1)) {
      for (j in Iter.range(v, w - 1)) {
        coords := List.push<Coordinate>((i, j), coords)
      }
    };
    coords
  };

  func finderTR(version : Version) : List<(Coordinate, Bool)> {
    let coords = finderTRCoords(version);
    List.zip<Coordinate, Bool>(coords, finderPattern())
  };

  func finderTRCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let r = w - 8;
    var coords = List.nil<Coordinate>();
    for (i in Iter.range(r, w - 1)) {
      for (j in Iter.range(0, 7)) {
        coords := List.push<Coordinate>((i, j), coords)
      }
    };
    coords
  };

  func finderBL(version : Version) : List<(Coordinate, Bool)> {
    let coords = finderBLCoords(version);
    List.zip<Coordinate, Bool>(coords, finderPattern())
  };

  func finderBLCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let c = w - 8;
    var coords = List.nil<Coordinate>();
    for (i in Iter.range(0, 7)) {
      for (j in Iter.range(c, w - 1)) {
        coords := List.push<Coordinate>((i, j), coords)
      }
    };
    coords
  };

  func finderPattern() : List<Bool> {
    //List.replicate<Bool>(64, true)
    List.replicate<Bool>(64, false)
    /*
    List.fromArray<Bool>([
      true, true, true, true, true, true, true, false,
      true, false, false, false, false, false, true, false,
      true, false, true, true, true, false, true, false,
      true, false, true, true, true, false, true, false,
      true, false, true, true, true, false, true, false,
      true, false, false, false, false, false, true, false,
      true, true, true, true, true, true, true, false,
      false, false, false, false, false, false, false, false
    ])
    */
  };

  func traceCoords(version : Version) : List<Coordinate> {

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

    let coords = List.append<Coordinate>(
      List.zip<Nat, Nat>(rows1, cols1),
      List.zip<Nat, Nat>(rows2, cols2)
    );

    List.filter<Coordinate>(coords, func (coord) { coord.0 != t })
  };

}
