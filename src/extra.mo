/**
 * Module      : extra.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";
import Option "mo:stdlib/option.mo";

type List<T> = List.List<T>;

module Extra {

  public func chunksOf<X>(n : Nat, xs : List<X>) : List<List<X>> {
    let (l, r) = List.splitAt<X>(n, xs);
    if (List.isNil<X>(l)) {
      List.nil<List<X>>()
    } else {
      List.push<List<X>>(l, chunksOf<X>(n, r))
    }
  };

  public func textToList(text : Text) : List<Char> {
    let get = text.chars().next;
    List.tabulate<Char>(text.len(), func _ {
      Option.unwrap<Char>(get())
    })
  };

  public func isDigit(char : Char) : Bool {
    charToWord32(char) - charToWord32('0') <= (9 : Word32)
  };

}
