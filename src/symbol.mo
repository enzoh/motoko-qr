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
import Nat "nat";
import Prelude "mo:stdlib/prelude";
import Util "util";
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
    //let text2 = List.foldLeft<Coordinate, Text>(finderCoords({ unbox = 1 }), "", func (coordinate, accum) {
    //    accum # debug_show(coordinate)
    //});
    //Prelude.printLn(text2);
    { unbox = freeze(applyPath(version, data, applyHardcoded(version, applyTimings(version, applyFinders(version, init(version)))))) }
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
      let i = setter.0.0;
      let j = setter.0.1;
      matrix[i][j] := setter.1
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
    let pattern = Util.padLeftTo(64, Nat.natToBits(18339425943761911296));
    List.zip<Coordinate, Bool>(coords, pattern)
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
    let pattern = Util.padLeftTo(64, Nat.natToBits(9169712971880955648));
    List.zip<Coordinate, Bool>(coords, pattern)
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
    let pattern = Util.padLeftTo(64, Nat.natToBits(71638382592819966));
    List.zip<Coordinate, Bool>(coords, pattern)
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

  func applyTimings(
    version : Version,
    matrix : [var [var Bool]]
  ) : [var [var Bool]] {
    apply(timings(version), matrix)
  };

  func timings(version : Version) : List<(Coordinate, Bool)> {
    List.append<(Coordinate, Bool)>(timingH(version), timingV(version))
  };

  func timingCoords(version : Version) : List<Coordinate> {
    List.append<Coordinate>(timingHCoords(version), timingVCoords(version))
  };

  func timingH(version : Version) : List<(Coordinate, Bool)> {
    let w = Common.info(version).width;
    let coords = timingHCoords(version);
    let pattern = List.tabulate<Bool>(w - 16, func (n) { n % 2 == 0 });
    List.zip<Coordinate, Bool>(coords, pattern)
  };

  func timingHCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let r = w - 7;
    var coords = List.nil<Coordinate>();
    for (j in Iter.range(8, w - 9)) {
      coords := List.push<Coordinate>((r, j), coords)
    };
    coords
  };

  func timingV(version : Version) : List<(Coordinate, Bool)> {
    let w = Common.info(version).width;
    let coords = timingVCoords(version);
    let pattern = List.tabulate<Bool>(w - 16, func (n) { n % 2 == 0 });
    List.zip<Coordinate, Bool>(coords, pattern)
  };

  func timingVCoords(version : Version) : List<Coordinate> {
    let coords = timingHCoords(version);
    List.map<Coordinate, Coordinate>(coords, func (a, b) { (b, a) })
  };

  func applyHardcoded(
    version : Version,
    matrix : [var [var Bool]]
  ) : [var [var Bool]] {
    apply(hardcoded(version), matrix)
  };

  func hardcoded(version : Version) : List<(Coordinate, Bool)> {
    let coords = hardcodedCoords(version);
    let pattern = List.singleton<Bool>(true);
    List.zip<Coordinate, Bool>(coords, pattern)
  };

  func hardcodedCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let c = w - 9;
    List.singleton<Coordinate>((7, c))
  };

  func formatCoords(version : Version) : List<Coordinate> {
    List.append<Coordinate>(formatHCoords(version), formatVCoords(version))
  };

  func formatHCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let r = w - 9;
    let c = w - 8;
    var coords = List.nil<Coordinate>();
    for (j in Iter.range(0, 7)) {
      coords := List.push<Coordinate>((r, j), coords)
    };
    for (j in Iter.range(c, c)) {
      coords := List.push<Coordinate>((r, j), coords)
    };
    for (j in Iter.range(c + 2, w - 1)) {
      coords := List.push<Coordinate>((r, j), coords)
    };
    List.rev<Coordinate>(coords)
  };

  func formatVCoords(version : Version) : List<Coordinate> {
    let w = Common.info(version).width;
    let c = w - 9;
    var coords = List.nil<Coordinate>();
    for (i in Iter.range(0, 6)) {
      coords := List.push<Coordinate>((i, c), coords)
    };
    for (i in Iter.range(w - 9, w - 8)) {
      coords := List.push<Coordinate>((i, c), coords)
    };
    for (i in Iter.range(w - 6, w - 1)) {
      coords := List.push<Coordinate>((i, c), coords)
    };
    coords
  };

////////////////////////////////////////////////////////////////////////////////

  // TODO: Implement version patterns!
  func versionCoords(version : Version) : List<Coordinate> {
    List.nil<Coordinate>()
  };

  // TODO: Implement alignment patterns!
  func alignmentCoords(version : Version) : List<Coordinate> {
    List.nil<Coordinate>()
  };

  //////////////////////////////////////////////////////////////////////////////

  func applyPath(
    version : Version,
    data : List<Bool>,
    matrix : [var [var Bool]]
  ) : [var [var Bool]] {
    apply(path(version, data), matrix)
  };

  func path(version : Version, data : List<Bool>) : List<(Coordinate, Bool)> {
    let coords = pathCoords(version);
    List.zip<Coordinate, Bool>(coords, data)
  };

  func pathCoords(version : Version) : List<Coordinate> {
    List.foldLeft<Coordinate, List<Coordinate>>(
      patternCoords(version),
      traceCoords(version),
      func (y, coords) {
        List.filter<Coordinate>(coords, func (x) {
          not ((x.0 == y.0) and (x.1 == y.1))
        })
      }
    )
  };

  func patternCoords(version : Version) : List<Coordinate> {
    List.concat<Coordinate>(List.fromArray<List<Coordinate>>([
      finderCoords(version),
      timingCoords(version),
      hardcodedCoords(version),
      formatCoords(version),
      versionCoords(version),
      alignmentCoords(version)
    ]))
  };

  func traceCoords(version : Version) : List<Coordinate> {

    let w = Common.info(version).width;
    let t = w - 7;

    let up = List.concat<Nat>(List.map<Nat, List<Nat>>(
      Iter.toList<Nat>(Iter.range(0, w - 1)),
      func (i) { List.replicate<Nat>(2, i) }
    ));
    let down = List.rev<Nat>(up);

    func rowwise(n : Nat, indices : List<Nat>) : List<Nat> {
      List.concat<Nat>(List.replicate<List<Nat>>(n * w, indices))
    };

    func columnwise(indices : List<Nat>) : List<Nat> {
      List.concat<Nat>(
        List.concat<List<Nat>>(
          List.map<List<Nat>, List<List<Nat>>>(
            List.chunksOf<Nat>(2, indices),
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
