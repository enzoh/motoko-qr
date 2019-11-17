/**
 * Module      : galois.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0 with LLVM Exception
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Galois "../src/galois.mo";

let elemDiv = Galois.Galois.elemDiv;
let elemEq = Galois.Galois.elemEq;
let elemMul = Galois.Galois.elemMul;
let elemNew = Galois.Galois.elemNew;
let polyDivMod = Galois.Galois.polyDivMod;
let polyEq = Galois.Galois.polyEq;
let polyNew = Galois.Galois.polyNew;

actor Test {

  func runElemMulDivTests() {
    for (i in range(1, 255)) {
      for (j in range(1, 255)) {
        let a = elemNew(i);
        let b = elemNew(j);
        let c = elemMul(a, b);
        let d = elemDiv(c, b);
        assert elemEq(a, d)
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
      let expectQuotient = polyNew(test.quotient);
      let expectRemainder = polyNew(test.remainder);
      let (actualQuotient, actualRemainder) = polyDivMod(
        polyNew(test.dividend),
        polyNew(test.divisor)
      );
      assert polyEq(expectQuotient, actualQuotient);
      assert polyEq(expectRemainder, actualRemainder)
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
