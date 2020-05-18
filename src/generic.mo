/**
 * Module     : generic.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Alphanumeric "../src/alphanumeric";
import Common "../src/common";
import EightBit "../src/eight-bit";
import Kanji "../src/kanji";
import List "mo:base/List";
import Numeric "../src/numeric";
import Version "../src/version";

module {

  type List<T> = List.List<T>;
  type Mode = Common.Mode;
  type Version = Version.Version;

  public func encode(
    version : Version,
    mode : Mode,
    text : Text
  ) : ?List<Bool> {
    switch mode {
      case (#Alphanumeric) Alphanumeric.encode(version, text);
      case (#EightBit) EightBit.encode(version, text);
      case (#Kanji) Kanji.encode(version, text);
      case (#Numeric) Numeric.encode(version, text)
    }
  };

}
