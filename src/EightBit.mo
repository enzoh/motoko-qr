/**
 * Module     : EightBit.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Experimental
 */

import Debug "mo:base/Debug";
import List "mo:base/List";
import Prelude "mo:base/Prelude";
import Version "Version";

module {

  type List<T> = List.List<T>;
  type Version = Version.Version;

  public func encode(version : Version, text : Text) : ?List<Bool> {
    Debug.print("Error: Eight-bit mode is not yet implemented!");
    Prelude.unreachable()
  };

}
