(* See https://github.com/coq/platform/issues/178#issuecomment-1211112651 *)
Require Import Rewriter.Util.plugins.RewriterBuild.
Require Import Coq.Arith.Arith.
Make rew0nat := Rewriter For (Nat.add_0_r, Nat.add_0_l).
