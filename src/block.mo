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
import Option "mo:stdlib/option";
import Version "version";

module {

  type Codewords = List<List<Bool>>;
  type Elem = Galois.Elem;
  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Version = Version.Version;

  public func interleave(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?List<Bool> {
    Option.map<List<List<Bool>>, List<Bool>>(func (blocks) {

      // Calculate the codewords for each data block, as well as the
      // corresponding error correction codewords.
      let (blockCodewords, errorCodewords) =
        List.foldRight<List<Bool>, (List<Codewords>, List<Codewords>)>(
          blocks,
          (List.nil<Codewords>(), List.nil<Codewords>()),
          func (block, accum) {
            let a = List.chunksOf<Bool>(8, block);
            let b = List.chunksOf<Bool>(8, correction(version, level, block));
            ( List.push<Codewords>(a, accum.0),
              List.push<Codewords>(b, accum.1)
            )
          }
        );

      List.concat<Bool>(List.fromArray<List<Bool>>([
        flatten(blockCodewords),
        flatten(errorCodewords),
        List.replicate<Bool>(Common.info(version).remainder, false)
      ]))

    }, toBlocks(version, level, data))
  };

  func toBlocks(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?List<List<Bool>> {
    Option.map<List<Bool>, List<List<Bool>>>(func (target) {

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
        List.chunksOf<Bool>(8, target),
        List.fromArray<Nat>(Common.blockSizes(version, level))
      )

    }, toTarget(version, level, data))
  };

  func toTarget(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?List<Bool> {

    let dataSize = List.len<Bool>(data);
    let targetSize = Common.targetSize(version, level);
    if (List.len<Bool>(data) > targetSize) null else {

      let zeroPadSize =
        if (dataSize + 7 > targetSize) {
          targetSize - dataSize
        } else {
          8 - dataSize % 8
        };
      let zeroPad = List.replicate<Bool>(zeroPadSize, false);

      var fillPadSize = targetSize - dataSize - zeroPadSize;
      var fillPad = List.nil<Bool>();
      while (fillPadSize > 0) {
        let chunk = List.take<Bool>(Nat.natToBits(60433), fillPadSize);
        fillPadSize -= List.len<Bool>(chunk);
        fillPad := List.append<Bool>(fillPad, chunk);
      };

      ?List.append<Bool>(data, List.append<Bool>(zeroPad, fillPad))
    }
  };

  func correction(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let chunksIn = List.chunksOf<Bool>(8, data);
    let elemsIn = List.map<List<Bool>, Elem>(chunksIn, Galois.elemFromBits);
    let errorSize = Common.errorSize(version, level);
    let errorPoly = Common.errorPoly(version, level);
    let dataPoly = Galois.polyPadRight(errorSize, { unbox = elemsIn });
    let resultPoly = Galois.polyDivMod(dataPoly, errorPoly).1;
    let elemsOut = Galois.polyTrim(resultPoly).unbox;
    let chunksOut = List.map<Elem, List<Bool>>(elemsOut, Galois.elemToBits);
    List.concat<Bool>(chunksOut)
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
