/**
 * Module     : block.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Common "common";
import Galois "galois";
import List "mo:stdlib/list";
import Nat "nat";
import Version "version";

module {

  type Codewords = List<List<Bool>>;
  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Version = Version.Version;

  public func interleave(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {

    // Calculate the codewords for each data block, as well as the
    // corresponding error correction codewords.
    let (blockCodewords, correctionCodewords) =
      List.foldRight<List<Bool>, (List<Codewords>, List<Codewords>)>(
        toBlocks(version, level, data),
        (List.nil<Codewords>(), List.nil<Codewords>()),
        func (block, accum) {
          let a = List.chunksOf<Bool>(8, block);
          let b = List.chunksOf<Bool>(8, correction(version, level, block));
          (List.push<Codewords>(a, accum.0), List.push<Codewords>(b, accum.1))
        }
      );

    List.concat<Bool>(List.fromArray<List<Bool>>([
      flatten(blockCodewords),
      flatten(correctionCodewords),
      List.replicate<Bool>(Common.info(version).remainder, false)
    ]))
  };

  func toBlocks(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<List<Bool>> {

    func go(
      accum : List<List<Bool>>,
      chunks : List<List<Bool>>,
      sizes : List<Nat>
    ) : List<List<Bool>> {
      switch sizes {
        case (null) List.rev<List<Bool>>(accum);
        case (?(h, t)) {
          let (a, b) = List.splitAt<List<Bool>>(h, chunks);
          go(List.push<List<Bool>>(List.concat<Bool>(a), accum), b, t)
        }
      }
    };

    go(
      List.nil<List<Bool>>(),
      List.chunksOf<Bool>(8, toTarget(version, level, data)),
      List.fromArray<Nat>(Common.blockSizes(version, level))
    )
  };

  func toTarget(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {

    let targetSize = Common.targetSize(version, level);
    let baseBuf = List.take<Bool>(data, targetSize);
    let baseBufSize = List.len<Bool>(baseBuf);

    let zeroPadSize =
      if (baseBufSize + 7 > targetSize) {
        targetSize - baseBufSize
      } else {
        8 - baseBufSize % 8
      };
    let zeroPad = List.replicate<Bool>(zeroPadSize, false);

    var fillPadSize = targetSize - baseBufSize - zeroPadSize;
    var fillPad = List.nil<Bool>();
    while (fillPadSize > 0) {
      let chunk = List.take<Bool>(Nat.natToBits(60433), fillPadSize);
      fillPadSize -= List.len<Bool>(chunk);
      fillPad := List.append<Bool>(fillPad, chunk);
    };

    List.append<Bool>(baseBuf, List.append<Bool>(zeroPad, fillPad))
  };

  func correction(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let correctionSize = Common.correctionSize(version, level);
    Galois.polyToBits(Galois.polyTrim(Galois.polyDivMod(
      Galois.polyPadRight(correctionSize, Galois.polyFromBits(data)),
      Common.correctionPoly(version, level)
    ).1))
  };

  func flatten(data : List<Codewords>) : List<Bool> {
    func go<X>(xss : List<List<X>>, accum : List<X>) : List<X> {
      switch (List.pop<List<X>>(xss)) {
        case (null, _) List.rev<X>(accum);
        case (?h1, t1) {
          switch (List.pop<X>(h1)) {
            case (null, _) go<X>(t1, accum);
            case (?h2, t2) go<X>(
              List.append<List<X>>(t1, List.singleton<List<X>>(t2)),
              List.push<X>(h2, accum)
            )
          }
        }
      }
    };
    List.concat<Bool>(go<List<Bool>>(data, List.nil<List<Bool>>()))
  };

}
