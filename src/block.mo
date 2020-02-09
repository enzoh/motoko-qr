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
import Version "version";

module {

  type ErrorCorrection = Common.ErrorCorrection;
  type List<T> = List.List<T>;
  type Version = Version.Version;

  public func interleave(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let info = Common.info(version);
    // TODO: Implement this function!
    Prelude.unreachable()
  };

  // Pad or truncate the input data to its target length.
  public func toTargetLen(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : List<Bool> {
    let targetLen = Common.targetLen(version, level);
    let baseBuf = List.take<Bool>(data, targetLen);
    let baseBufLen = List.len<Bool>(baseBuf);
    let zeroPadLen =
      if (baseBufLen + 7 > targetLen) {
        targetLen - baseBufLen
      } else {
        8 - baseBufLen % 8
      };
    let zeroPad = List.replicate<Bool>(zeroPadLen, false);
    var fillPadLen = targetLen - baseBufLen - zeroPadLen;
    var fillPad = List.nil<Bool>();
    while (fillPadLen > 0) {
      let chunk = List.take<Bool>(Nat.natToBits(60433), fillPadLen);
      fillPadLen -= List.len<Bool>(chunk);
      fillPad := List.append<Bool>(fillPad, chunk);
    };
    List.append<Bool>(baseBuf, List.append<Bool>(zeroPad, fillPad))
  };

}
