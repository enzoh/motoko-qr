/**
 * Module     : Util.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import List "mo:base/List";

module {

  type List<T> = List.List<T>;

  public func padLeft(n : Nat, bits : List<Bool>) : List<Bool> {
    List.append<Bool>(List.replicate<Bool>(n, false), bits)
  };

  public func padRight(n : Nat, bits : List<Bool>) : List<Bool> {
    List.append<Bool>(bits, List.replicate<Bool>(n, false))
  };

  public func padLeftTo(n : Nat, bits : List<Bool>) : List<Bool> {
    let m = List.size<Bool>(bits);
    if (m > n) bits else padLeft(n - m, bits)
  };

  public func padRightTo(n : Nat, bits : List<Bool>) : List<Bool> {
    let m = List.size<Bool>(bits);
    if (m > n) bits else padRight(n - m, bits)
  };

}
