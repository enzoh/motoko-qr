/**
 * Module     : alphanumeric.mo
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
import Option "mo:stdlib/option";
import Prelude "mo:stdlib/prelude";
import Prim "mo:prim";
import Text "mo:stdlib/text";
import Trie "mo:stdlib/trie";
import Util "util";

module {

  type List<T> = List.List<T>;
  type Trie<K, V> = Trie.Trie<K, V>;

  public func encode(
    version : Common.Version,
    text : Text
  ) : ?List<Bool> {

    // Define mode and character count indicators.
    let mi = List.fromArray<Bool>([false, false, true, false]);
    let cci = Util.bitPadLeftTo(
      Common.cciLen(version, #Alphanumeric),
      Nat.natToBits(text.len())
    );

    // Define function to render output.
    let header = List.append<Bool>(mi, cci);
    let footer = List.replicate<Bool>(4, false);
    func render(body : List<Bool>) : List<Bool> {
      List.append<Bool>(header, List.append<Bool>(body, footer))
    };

    // Transliterate input text.
    let table = genTable();
    let transliteration = List.foldRight<Char, ?List<Nat>>(
      Iter.toList<Char>(Text.toIter(text)),
      ?List.nil<Nat>(),
      func (char, accum) {
        Option.bind<List<Nat>, List<Nat>>(
          accum,
          func (values) {
            Option.map<Nat, List<Nat>>(
              func (value) {
                List.push<Nat>(value, values)
              },
              Trie.find<Char, Nat>(table, keyChar(char), eqChar)
            )
          }
        )
      }
    );

    //
    Option.map<List<Bool>, List<Bool>>(
      render,
      Option.map<List<Nat>, List<Bool>>(
        func (values) {
          List.foldRight<List<Nat>, List<Bool>>(
            List.chunksOf<Nat>(2, values),
            List.nil<Bool>(),
            func (chunk, accum) {
              List.append<Bool>(
                Option.unwrap<List<Bool>>(parseChunk(chunk)),
                accum
              )
            }
          )
        },
        transliteration
      )
    )
  };

  func genTable() : Trie<Char, Nat> {
    let chars = [
      '0', '1', '2', '3', '4', '5', '6', '7', '8',
      '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
      'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q',
      'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
      ' ', '$', '%', '*', '+', '-', '.', '/', ':'
    ];
    Array.foldl<Char, (Trie<Char, Nat>, Nat)>(
      func (accum, char) {
        let table = Trie.insert<Char, Nat>(
          accum.0,
          keyChar(char),
          eqChar,
          accum.1
        ).0;
        let i = accum.1 + 1;
        (table, i)
      },
      (Trie.empty<Char, Nat>(), 0),
      chars
    ).0
  };

  func eqChar(a : Char, b : Char) : Bool {
    a == b
  };

  func keyChar(char : Char) : Trie.Key<Char> {
    { key = char; hash = Prim.charToWord32(char) };
  };

  func parseChunk(chunk : List<Nat>) : ?List<Bool> {
    switch chunk {
      case (?(x, null)) {
        ?Util.bitPadLeftTo(6, Nat.natToBits(x))
      };
      case (?(x, ?(y, null))) {
        ?Util.bitPadLeftTo(11, Nat.natToBits(x * 45 + y))
      };
      case _ null
    }
  };

}
