/**
 * Module     : Generic.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Alphanumeric "Alphanumeric";
import Common "Common";
import EightBit "EightBit";
import Kanji "Kanji";
import List "mo:base/List";
import Numeric "Numeric";
import Version "Version";

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
