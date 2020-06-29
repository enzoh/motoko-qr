/**
 * Module     : Alphanumeric.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Array "mo:base/Array";
import Common "Common";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "Nat";
import Option "mo:base/Option";
import Prelude "mo:base/Prelude";
import Prim "mo:prim";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Util "Util";
import Version "Version";

module {

  type List<T> = List.List<T>;
  type Trie<K, V> = Trie.Trie<K, V>;
  type Version = Version.Version;

  public func encode(version : Version, text : Text) : ?List<Bool> {

    let mi = List.fromArray<Bool>([false, false, true, false]);
    let cci = Util.padLeftTo(
      Common.cciLen(version, #Alphanumeric),
      Nat.natToBits(text.size())
    );

    func format(body : List<Bool>) : List<Bool> {
      let header = List.append<Bool>(mi, cci);
      let footer = List.replicate<Bool>(4, false);
      List.append<Bool>(header, List.append<Bool>(body, footer))
    };

    let table = genTable();
    let transliteration = List.foldRight<Char, ?List<Nat>>(
      Iter.toList<Char>(Text.toIter(text)),
      ?List.nil<Nat>(),
      func (char, accum) {
        Option.chain<List<Nat>, List<Nat>>(
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

    Option.map<List<Bool>, List<Bool>>(
      format,
      Option.map<List<Nat>, List<Bool>>(
        func (values) {
          List.foldRight<List<Nat>, List<Bool>>(
            List.chunks<Nat>(2, values),
            List.nil<Bool>(),
            func (chunk, accum) {
              List.append<Bool>(encodeChunkOrTrap(chunk), accum)
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
    Array.foldLeft<Char, (Trie<Char, Nat>, Nat)>(
      chars,
      (Trie.empty<Char, Nat>(), 0),
      func (accum, char) {
        let table = Trie.replace<Char, Nat>(
          accum.0,
          keyChar(char),
          eqChar,
          ?accum.1
        ).0;
        let i = accum.1 + 1;
        (table, i)
      }
    ).0
  };

  func keyChar(char : Char) : Trie.Key<Char> {
    { key = char; hash = Prim.charToWord32(char) };
  };

  func eqChar(a : Char, b : Char) : Bool {
    a == b
  };

  func encodeChunkOrTrap(chunk : List<Nat>) : List<Bool> {
    switch chunk {
      case (?(x, null)) Util.padLeftTo(6, Nat.natToBits(x));
      case (?(x, ?(y, null))) Util.padLeftTo(11, Nat.natToBits(x * 45 + y));
      case _ {
        Debug.print("Error: Invalid chunk size!");
        Prelude.unreachable();
      }
    }
  };

}
