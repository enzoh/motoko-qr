/**
 * Module     : demo.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Prelude "mo:stdlib/prelude";
import QR "canister:qr";

actor {

  let examples = [
    {
      version = 1;
      level = #M;
      mode = #Numeric;
      input = "01234567"
    },
    {
      version = 1;
      level = #Q;
      mode = #Alphanumeric;
      input = "HELLO WORLD"
    },
    {
      version = 1;
      level = #M;
      mode = #Alphanumeric;
      input = "HTTP://SDK.DFINITY.ORG"
    }
  ];

  func run(i : Nat) : async Text {
    if (i < examples.len()) {
      let example = examples[i];
      let version = await QR.version(example.version);
      let result = await QR.encode(
        version,
        example.level,
        example.mode,
        example.input
      );
      switch result {
        case (?matrix) await QR.show(matrix);
        case _ "Error: Invalid input!"
      }
    } else {
      Prelude.printLn("Error: Example does not exist!");
      Prelude.unreachable()
    }
  };

  public func example1() : async Text { await run(0) };
  public func example2() : async Text { await run(1) };
  public func example3() : async Text { await run(2) };

}
