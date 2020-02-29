/**
 * Module     : qr.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Array "mo:stdlib/array";
import Block "../src/block";
import Common "../src/common";
import Generic "../src/generic";
import List "mo:stdlib/list";
import Mask "../src/mask";
import Option "mo:stdlib/option";
import Symbol "../src/symbol";
import Version "../src/version";

actor {

  type List<T> = List.List<T>;

  public type ErrorCorrection = Common.ErrorCorrection;
  public type Matrix = Common.Matrix;
  public type Mode = Common.Mode;
  public type Version = Version.Version;

  public func encode(
    version : Version,
    level : ErrorCorrection,
    mode : Mode,
    text : Text
  ) : async ?Matrix {
    Option.bind<Version, Matrix>(
      Version.new(Version.unbox(version)),
      func _ {
        Option.bind<List<Bool>, Matrix>(
          Generic.encode(version, mode, text),
          func (data) {
            Option.map<List<Bool>, Matrix>(
              func (code) {
                let (symbol, maskRef) = Mask.generate(version, level, code);
                #Matrix (
                  Symbol.freeze(
                  Symbol.applyVersions(version,
                  Symbol.applyFormats(version, level, maskRef, symbol)))
                )
              },
              Block.interleave(version, level, data)
            )
          }
        )
      }
    )
  };

  public func show(matrix : Matrix) : async Text {
    let #Matrix arrays = matrix;
    Array.foldl<[Bool], Text>(func (accum1, array) {
      Array.foldl<Bool, Text>(func (accum2, bit) {
        let text = if bit "##" else "  ";
        text # accum2
      }, "\n", array) # accum1
    }, "", arrays)
  };

}
