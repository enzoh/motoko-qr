/**
 * Module     : Galois.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Galois "../src/Galois";
import Iter "mo:base/Iter";

actor {

  func runElemMulDivTests() {
    for (i in Iter.range(1, 255)) {
      for (j in Iter.range(1, 255)) {
        let a = Galois.elemNew(i);
        let b = Galois.elemNew(j);
        let c = Galois.elemMul(a, b);
        let d = Galois.elemDiv(c, b);
        assert Galois.elemEq(a, d)
      }
    }
  };

  type PolyDivModTest = {
    dividend : [Nat];
    divisor : [Nat];
    quotient : [Nat];
    remainder : [Nat]
  };

  let polyDivModTests = [
    { dividend = [1];
      divisor = [1];
      quotient = [1];
      remainder = [0]
    },
    { dividend = [0,1];
      divisor = [1];
      quotient = [1];
      remainder = [0]
    },
    { dividend = [1];
      divisor = [0,1];
      quotient = [1];
      remainder = [0]
    },
    { dividend = [1,0,1];
      divisor = [1,0];
      quotient = [1,0];
      remainder = [1]
    },
    { dividend = [1,0,1,0,0,0,0,0,0,0,0,0,0];
      divisor = [1,0,1,0,0,1,1,0,1,1,1];
      quotient = [1,0,0];
      remainder = [1,1,0,1,1,1,0,0]
    },
    { dividend = [44,58,244,45,105,194,184,25,50,91];
      divisor = [1,11,44,88,120,254];
      quotient = [44,51,0,2,16];
      remainder = [0]
    },
    { dividend = [64,24,172,195,0,0,0,0,0,0];
      divisor = [1,31,198,63,147,116];
      quotient = [64,139,153,19,90];
      remainder = [134,13,34,174,48]
    }
  ];

  func runPolyDivModTests() {
    for (test in polyDivModTests.vals()) {
      let expectQuotient = Galois.polyNew(test.quotient);
      let expectRemainder = Galois.polyNew(test.remainder);
      let (actualQuotient, actualRemainder) = Galois.polyDivMod(
        Galois.polyNew(test.dividend),
        Galois.polyNew(test.divisor)
      );
      assert Galois.polyEq(expectQuotient, actualQuotient);
      assert Galois.polyEq(expectRemainder, actualRemainder)
    }
  };

  let tests = [
    runElemMulDivTests,
    runPolyDivModTests
  ];

  public func run() {
    for (test in tests.vals()) test()
  };

}
