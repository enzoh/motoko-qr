/**
 * Module     : extra.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import List "mo:stdlib/list";
import Option "mo:stdlib/option";
import Prim "mo:prim";

module {

  type List<T> = List.List<T>;

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
