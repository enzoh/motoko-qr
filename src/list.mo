/**
 * Module      : list.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import List "mo:stdlib/list.mo";

type List<T> = List.List<T>;

module List2 {

  public func splitAt<X>(n : Nat, xs : List<X>) : (List<X>, List<X>) {
    if (n == 0) {
      (List.nil<X>(), xs)
    } else {
      func rec(n : Nat, xs : List<X>) : (List<X>, List<X>) {
        switch (List.pop<X>(xs)) {
          case (null, _) {
            (List.nil<X>(), List.nil<X>())
          };
          case (?h, t) {
            if (n == 1) {
              (List.singleton<X>(h), t)
            } else {
              let (l, r) = rec(n - 1, t);
              (List.push<X>(h, l), r)
            }
          }
        }
      };
      rec(n, xs)
    }
  };

  public func chunksOf<X>(n : Nat, xs : List<X>) : List<List<X>> {
    let (l, r) = splitAt<X>(n, xs);
    if (List.isNil<X>(l)) {
      List.nil<List<X>>()
    } else {
      List.push<List<X>>(l, chunksOf<X>(n, r))
    }
  };

}
