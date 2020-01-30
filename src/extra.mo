/**
 * Module      : extra.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";
import Option "mo:stdlib/option.mo";
import Prim "mo:prim";

type List<T> = List.List<T>;

module Extra {

  public func textToList(text : Text) : List<Char> {
    let get = text.chars().next;
    List.tabulate<Char>(text.len(), func _ {
      Option.unwrap<Char>(get())
    })
  };

  public func isDigit(char : Char) : Bool {
    Prim.charToWord32(char) - Prim.charToWord32('0') <= (9 : Word32)
  };

}
