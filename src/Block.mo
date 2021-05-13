/**
 * Module     : Block.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Common "Common";
import Galois "Galois";
import List "mo:base/List";
import Nat "Nat";
import Option "mo:base/Option";
import Version "Version";

module {

  type Block = List<Bool>;
  type Blocks = List<Block>;
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
    Option.map<Blocks, List<Bool>>(
      toBlocks(version, level, data),
      func (blocks) {

        // Calculate the codewords for each data block, as well as the
        // corresponding error correction codewords.
        let (blockCodewords, errorCodewords) =
          List.foldRight<Block, (List<Codewords>, List<Codewords>)>(
            blocks,
            (List.nil<Codewords>(), List.nil<Codewords>()),
            func (block, accum) {
              let a = List.chunks<Bool>(8, block);
              let b = List.chunks<Bool>(8, correction(version, level, block));
              ( List.push<Codewords>(a, accum.0),
                List.push<Codewords>(b, accum.1)
              )
            }
          );

        List.flatten<Bool>(List.fromArray<List<Bool>>([
          flatten(blockCodewords),
          flatten(errorCodewords),
          List.replicate<Bool>(Common.remainder(version), false)
        ]))
      }
    )
  };

  func toBlocks(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?Blocks {
    Option.map<List<Bool>, Blocks>(
      toTarget(version, level, data),
      func (target) {

        func go(
          accum : Blocks,
          chunks : List<List<Bool>>,
          sizes : List<Nat>
        ) : Blocks {
          switch sizes {
            case (null) List.reverse<Block>(accum);
            case (?(h, t)) {
              let (a, b) = List.split<List<Bool>>(h, chunks);
              go(List.push<Block>(List.flatten<Bool>(a), accum), b, t)
            }
          }
        };

        go(
          List.nil<Block>(),
          List.chunks<Bool>(8, target),
          List.fromArray<Nat>(Common.blockSizes(version, level))
        )
      }
    )
  };

  func toTarget(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?List<Bool> {

    let dataSize = List.size<Bool>(data);
    let targetSize = Common.targetSize(version, level);
    if (dataSize > targetSize) null else {

      let zeroPadSize : Nat =
        if (dataSize + 7 > targetSize) {
          targetSize - dataSize
        } else {
          8 - dataSize % 8
        };
      let zeroPad = List.replicate<Bool>(zeroPadSize, false);

      var fillPadSize : Nat = targetSize - dataSize - zeroPadSize;
      var fillPad = List.nil<Bool>();
      while (fillPadSize > 0) {
        let chunk = List.take<Bool>(Nat.natToBits(60433), fillPadSize);
        fillPadSize -= List.size<Bool>(chunk);
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
    let chunksIn = List.chunks<Bool>(8, data);
    let elemsIn = List.map<List<Bool>, Elem>(chunksIn, Galois.elemFromBits);
    let errorSize = Common.errorSize(version, level);
    let errorPoly = Common.errorPoly(version, level);
    let dataPoly = Galois.polyPadRight(errorSize, { unbox = elemsIn });
    let resultPoly = Galois.polyDivMod(dataPoly, errorPoly).1;
    let elemsOut = Galois.polyTrim(resultPoly).unbox;
    let chunksOut = List.map<Elem, List<Bool>>(elemsOut, Galois.elemToBits);
    List.flatten<Bool>(chunksOut)
  };

  func flatten(data : List<Codewords>) : List<Bool> {
    func go<X>(xss : List<List<X>>, accum : List<X>) : List<X> {
      switch (List.pop<List<X>>(xss)) {
        case (null, _) List.reverse<X>(accum);
        case (?h1, t1) {
          switch (List.pop<X>(h1)) {
            case (null, _) go<X>(t1, accum);
            case (?h2, t2) go<X>(
              List.append<List<X>>(t1, List.make<List<X>>(t2)),
              List.push<X>(h2, accum)
            )
          }
        }
      }
    };
    List.flatten<Bool>(go<List<Bool>>(data, List.nil<List<Bool>>()))
  };

}
