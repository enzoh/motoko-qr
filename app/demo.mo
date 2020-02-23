/**
 * Module     : demo.mo
 * Copyright  : 2020 DFINITY Stiftung
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : Enzo Haussecker <enzo@dfinity.org>
 * Stability  : Stable
 */

import Option "mo:stdlib/option";
import Prelude "mo:stdlib/prelude";
import QR "canister:qr";

actor {

  type Matrix = QR.Matrix;

  let examples = [
    {
      version = 1;
      level = #M;
      mode = #Numeric;
      text = "01234567"
    },
    {
      version = 1;
      level = #Q;
      mode = #Alphanumeric;
      text = "HELLO WORLD"
    },
    {
      version = 2;
      level = #M;
      mode = #Alphanumeric;
      text = "HTTP://SDK.DFINITY.ORG"
    },
    {
      version = 8;
      level = #H;
      mode = #Alphanumeric;
      text = "I AM ALONE AND FEEL THE CHARM OF EXISTENCE IN THIS SPOT WHICH WAS CREATED FOR THE BLISS OF SOULS LIKE MINE"
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
        example.text
      );
      if Option.isSome<Matrix>(result) {
        let matrix = Option.unwrap<Matrix>(result);
        await QR.show(matrix)
      } else {
        "Error: Invalid input!"
      }
    } else {
      Prelude.printLn("Error: Example does not exist!");
      Prelude.unreachable()
    }
  };

  public func example1() : async Text { await run(0) };
  public func example2() : async Text { await run(1) };
  public func example3() : async Text { await run(2) };
  public func example4() : async Text { await run(3) };

}
