/**
 * Module     : block.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Common "common";
import List "mo:stdlib/list";
import Nat "nat";
import Prelude "mo:stdlib/prelude";

module {

  type List<T> = List.List<T>;

  public func interleave(
    version : Common.Version,
    level : Common.ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let info = Common.info(version);
    Prelude.unreachable()
  };

  public func appendPadCodewords(
    version : Common.Version,
    level : Common.ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let targetLen = Common.targetDataLen(version, level);
    // Calculate base bits.
    let baseBuf = List.take<Bool>(data, targetLen);
    let baseBufLen = List.len<Bool>(baseBuf);
    // Calculate pad bits.
    let padBufLen =
      if (baseBufLen + 7 > targetLen) {
        targetLen - baseBufLen
      } else {
        8 - baseBufLen % 8
      };
    let padBuf = List.replicate<Bool>(padBufLen, false);
    // Calculate fill bits.
    var fillBufLen = targetLen - baseBufLen - padBufLen;
    var fillBuf = List.nil<Bool>();
    while (fillBufLen > 0) {
      let chunk = List.take<Bool>(Nat.natToBits(60433), fillBufLen);
      fillBufLen -= List.len<Bool>(chunk);
      fillBuf := List.append<Bool>(fillBuf, chunk);
    };
    // Concatenate results from above.
    List.append<Bool>(baseBuf, List.append<Bool>(padBuf, fillBuf))
  };

}
