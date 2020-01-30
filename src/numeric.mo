/**
 * Module      : numeric.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import Extra "../src/extra.mo";
import List "mo:stdlib/list.mo";
import Nat "../src/nat.mo";
import Option "mo:stdlib/option.mo";
import Prelude "mo:stdlib/prelude.mo";
import Prim "mo:prim";
import Util "../src/util.mo";

module {

  type List<T> = List.List<T>;

  public func numericEncode(
    version : Common.Version,
    text : Text
  ) : ?List<Bool> {

    // Define mode and character count indicators.
    let mi = Util.bitPadLeft(3, List.singleton<Bool>(true));
    let cci = Util.bitPadLeftTo(Common.cciLen(version, #Numeric), Nat.natToBits(text.len()));

    // Define metadata and terminator.
    let header = List.append<Bool>(mi, cci);
    let footer = List.replicate<Bool>(4, false);

    // 
    func render(bits : List<Bool>) : List<Bool> {
      List.append<Bool>(header, List.append<Bool>(bits, footer))
    };

    // 
    let chunks = List.chunksOf<Char>(3, Extra.textToList(text));

    // 
    func step(chunk : List<Char>, accum : ?List<Bool>) : ?List<Bool> {
      switch (parse(chunk), accum) {
        case (?a, ?b) { ?List.append<Bool>(a, b) };
        case _ null
      }
    };

    // 
    Option.map<List<Bool>, List<Bool>>(
      render,
      List.foldRight<List<Char>, ?List<Bool>>(chunks, ?null, step)
    )

  };

  func parse(chunk : List<Char>) : ?List<Bool> {

    // 
    let p = switch (List.len<Char>(chunk)) {
      case 3 ?10;
      case 2 ?07;
      case 1 ?04;
      case _ null
    };

    //
    let n = List.foldLeft<Char, ?Nat>(chunk, ?0, func (char, accum) {
      if (Extra.isDigit(char)) {
        Option.map<Nat, Nat>(func (a) {
          let b = Prim.word32ToNat(
            Prim.charToWord32(char) - Prim.charToWord32('0')
          );
          10 * a + b
        }, accum)
      } else {
        null
      }
    });

    // 
    switch (p, n) {
      case (?a, ?b) { ?Util.bitPadLeftTo(a, Nat.natToBits(b)) };
      case _ null
    }

  };

}
