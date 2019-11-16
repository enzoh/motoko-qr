/**
 * Module      : spec.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

module Spec {

  type ErrorCorrection = { #L; #M; #Q; #H };

  type Matrix = { unbox : [[Bool]] };

  type Mode = { #Alphanumeric; #EightBit; #Kanji; #Numeric };

  type Version = { unbox : Nat };

}
