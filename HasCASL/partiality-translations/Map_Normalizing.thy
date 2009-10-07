theory Map_Map_E2
imports "$HETS_ISABELLE_LIB/MainHC" "List" "$HETS_LIB/Isabelle/RestrictOpProps"
uses "$HETS_ISABELLE_LIB/prelude"
begin

ML "Header.initialize
    [\"Ax1\", \"Ax2\", \"Ax3\", \"Ax4\", \"Ax1_5\", \"Ax2_6\"]"


consts
X_filter :: "'a list => ('a => bool) => 'a list"
X_map :: "('a => 'b partial) => 'a list => 'b list partial"

axioms
Ax1 [rule_format] :
"ALL (f :: 'a => 'b partial). X_map f [] = makePartial []"

Ax2 [rule_format] :
"ALL (f :: 'a => 'b partial).
 ALL (l :: 'a list).
 ALL (x :: 'a).
 X_map f (Cons x l) =
 restrictOp
 (makePartial (Cons (makeTotal (f x)) (makeTotal (X_map f l))))
 (defOp (f x) & defOp (X_map f l))"

Ax3 [rule_format] :
"ALL (P :: 'a => bool).
 ALL (l :: 'a list).
 ALL (x :: 'a).
 X_filter (Cons x l) P =
 (if P x then Cons x (X_filter l P) else X_filter l P)"

Ax4 [rule_format] : "ALL (P :: 'a => bool). X_filter [] P = []"

declare Ax1 [simp]
declare Ax4 [simp]

theorem Ax1_5 :
"ALL (P :: 'a => bool).
 ALL (f :: 'a => 'a partial).
 ALL (l :: 'a list).
 defOp (X_map f l) --> defOp (X_map f (X_filter l P))"
apply (rule allI)
apply (rule allI)
apply (rule allI)
apply (induct_tac l)
apply (simp add: Ax1 Ax2 Ax3 Ax4)
apply (simp add: Ax1 Ax2 Ax3 Ax4)
done

ML "Header.record \"Ax1_5\""

theorem Ax2_6 :
"ALL (Q :: 'a => bool).
 ALL (f :: 'a => 'a partial).
 ALL (l :: 'a list).
 defOp (X_map f l) -->
 X_map f (X_filter l Q) =
 restrictOp (makePartial (X_filter (makeTotal (X_map f l)) Q))
 (defOp (X_map f l))"
apply (rule allI)
apply (rule allI)
apply (rule allI)
apply (induct_tac l)
apply (simp)
apply (rule impI)
apply (simp)
apply (subst Ax2)
apply (subst Ax3)
apply (simp)
apply (auto)
apply (subst (asm) Ax2)
apply (simp)

(* apply Ax1_5 somewhere *) 
ML "Header.record \"Ax2_6\""

end
