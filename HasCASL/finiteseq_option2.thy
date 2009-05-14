theory Functions_gn_n3
imports "$HETS_LIB/Isabelle/MainHC"
uses "$HETS_LIB/Isabelle/prelude"
begin

ML "Header.initialize
    [\"Ax1\", \"Ax2\", \"Ax3\", \"Ax4\", \"Ax5\", \"Ax6\", \"Ax7\",
     \"Ax8\", \"Ax9\", \"Ax10\", \"Ax11\", \"Ax12\", \"Ax13\", \"Ax14\",
     \"Ax15\"]"

typedecl ('a1) Seq

consts
X_all :: "(nat => 'S partial) => ('S => bool) => bool" ("all''/'(_,/ _')" [3,3] 999)
X_concat :: "(nat => 'S partial) * (nat => 'S partial) => nat => 'S partial"
X_empty :: "(nat => 'S partial) => bool" ("empty''/'(_')" [3] 999)
X_even :: "nat => bool" ("even''/'(_')" [3] 999)
X_filter :: "(nat => 'S partial) => ('S => bool) => nat => 'S partial"
X_finite :: "(nat => 'S partial) => bool" ("finite''/'(_')" [3] 999)
X_h :: "(nat => 'S partial) => 'S partial" ("h/'(_')" [3] 999)
X_head :: "(nat => 'S partial) => 'S partial" ("head/'(_')" [3] 999)
X_length :: "(nat => 'S partial) => nat partial" ("length''/'(_')" [3] 999)
X_minX2 :: "(nat => bool) => nat partial" ("min''''/'(_')" [3] 999)
X_start :: "(nat => 'S partial) => nat partial" ("start/'(_')" [3] 999)
nf :: "(nat => 'S partial) => nat => 'S partial"
t :: "(nat => 'S partial) => nat => 'S partial"
tail :: "(nat => 'S partial) => nat => 'S partial"
X__o__X :: "('b => 'c partial) * ('a => 'b partial) => 'a => 'c partial"
X_map :: "('S => 'S partial) => (nat => 'S partial) => nat => 'S partial"


axioms
Ax1 [rule_format] :
"ALL Q.
 min''(Q) =
 (if Q 0 then makePartial 0 else min''(% m. Q (m + 1)))"

Ax2 [rule_format] : "ALL Q. defOp (min''(Q)) = (EX m. Q m)"

Ax3 [rule_format] : "ALL s. X_start(s) = min''(% m. defOp (s m))"

Ax4 [rule_format] : "ALL s. head(s) = s 0"

Ax5 [rule_format] : "ALL s. tail s = (% x. s (x + 1))"

Ax6 [rule_format] : "ALL s. head(nf s) = h(s)"

Ax7 [rule_format] : "ALL s. tail (nf s) = nf (t s)"

Ax8 [rule_format] :
"ALL P.
 ALL s.
 head(X_filter s P) =
 resOp (head(s), bool2partial (lift2bool P (head(s))))"

Ax9 [rule_format] :
"ALL P. ALL s. tail (X_filter s P) = X_filter (tail s) P"

Ax10 [rule_format] :
 "ALL s. 
  h(s) = 
   restrictOp (s (makeTotal (X_start s))) (defOp (X_start s))" 


Ax10_monadic [rule_format] :
"ALL s.
 h(s) =
  ((lift2partial s) (X_start s))"

Ax11 [rule_format] :
"ALL s.
 t s =
 (% k. restrictOp (s (k + 1 + makeTotal (X_start s))) (defOp (X_start s)))"

Ax11_monadic [rule_format] :
"ALL s.
 t s =
 (% k. (lift2partial s) ((mapPartial ((op +) (k + 1))) (X_start s)))"

Ax12 [rule_format] :
"ALL s. finite'(s) = (EX X_n. ALL m. m > X_n --> ~ defOp (s m))"

Ax13 [rule_format] : "ALL s. empty'(s) = (ALL m. ~ defOp (s m))"

Ax14 [rule_format] :
"ALL s.
 ALL s2.
 head(X_concat (s, s2)) =
 (if ~ empty'(s) then head(s) else head(s2))"

Ax15 [rule_format] :
"ALL s.
 ALL s2.
 tail (X_concat (s, s2)) =
 (if ~ empty'(s) then X_concat (tail s, s2) else tail s2)"


Ax16 [rule_format] :
"ALL f.
 ALL s.
 X_head(X_map f s) = (restrictOp (f (makeTotal (X_head s))) (defOp (X_head s)))"

Ax16_monadic [rule_format] :
"ALL f.
 ALL s.
 X_head(X_map f s) =(lift2partial f) (X_head s)"


Ax17 [rule_format] :
"ALL f. ALL s. tail (X_map f s) = X_map f (tail s)"

o_def [rule_format] :
"ALL f.
 ALL g.
 X__o__X (g, f) =
 (% x. restrictOp (g (makeTotal (f x))) (defOp (f x)))"

o_def_monadic [rule_format] : 
"ALL f. 
 ALL g. 
 X__o__X (g,f) = 
 (%x. lift2partial g (f x))"

theorem coinduct: "[|R u v ==> (head(u)=head(v) & (R (tail u) (tail v)));  R u v|] ==> u=v"
apply (rule ext)
apply (induct_tac x)
sorry

theorem restrict1 : "restrictOp (restrictOp a (defOp b)) c = restrictOp (restrictOp a c) (defOp (restrictOp b c))"
apply (case_tac c)
apply (simp add: restrictOp_def)
apply (simp add: restrictOp_def)
done

theorem restrict_trivial_rule[simp]: "b ==> restrictOp u b = u"
apply (simp add: restrictOp_def)
done

theorem restrict_trivial [simp]: "restrictOp u True = u"
apply (simp)
done

theorem restrict_assoc[simp] : "restrictOp a (defOp (restrictOp b c)) = restrictOp (restrictOp a (defOp b)) c"
apply (case_tac c)
apply (simp add: restrictOp_def)
apply (simp add: restrictOp_def noneOp_def defOp.simps)
sorry


theorem restrict_out[simp] : "restrictOp (u b) b = restrictOp (u True) b"
apply (case_tac "b")
apply (simp add: restrictOp_def)
apply (simp add: restrictOp_def)
done

theorem mkpartial_cancel [simp]: "makeTotal(makePartial x) = x"
apply (simp add: makeTotal_def makePartial_def)
done

theorem mkpartial_cancel2 [simp]: "defOp(x) ==> makePartial(makeTotal x) = x"
apply (simp add: makeTotal_def makePartial_def)
apply (case_tac x)
apply (simp)
apply (simp)
done

theorem mkpartial_cancel3 [simp] : "((makePartial x) = (makePartial y)) = (x = y)"
apply (simp add: makePartial_def)
done


theorem defOp_trivial [simp]: "defOp(makePartial x) = True"
apply (simp add: makePartial_def makeTotal_def)
done

(* Some more stuff about removing extraneous restrictions *)

theorem total_restrict2 [simp]: 
"(c ==> b) ==> restrictOp (u (makeTotal  (restrictOp a b))) c = 
	   restrictOp (u (makeTotal a)) c"
apply (simp add: makeTotal_def restrictOp_def defOp.simps undefinedOp_def)
done

theorem def_restrict [simp]:
"defOp (restrictOp a b) = (defOp a & b)"
apply (simp add:  restrictOp_def defOp.simps undefinedOp_def split: split_if)
done

theorem total_restrict [simp]: 
"restrictOp (u (makeTotal  (restrictOp a b))) (defOp (restrictOp a b)) = 
	   restrictOp (u (makeTotal a)) (defOp a & b)"
apply simp
done

lemma restrictOp_cong [cong]:
  "b = b' ==> (b' ==> a = a') ==> restrictOp a b = restrictOp a' b'"
  apply (simp add: restrictOp_def defOp.simps undefinedOp_def)
done


lemma double_defop: "defOp(head(X_filter (X_filter a P) P)) = defOp(head(X_filter a P))"
apply (simp add: Ax8 resOp_def bool2partial_def)
apply (auto)
done

theorem defop_filter2: "((defOp (head(a))) & (P (makeTotal (head(a))))) = defOp(head(X_filter a P))"
apply (simp add: Ax8 bool2partial_def resOp_def lift2bool_def)
done

lemma double_filter_head[simp]: "head(X_filter (X_filter a P) P) = head(X_filter a P)"
(*apply (case_tac "defOp(a 0) & P(makeTotal (a 0))")*)
apply (simp add: Ax8 resOp_def bool2partial_def lift2bool_def)
apply (simp add: defop_filter2 cong: conj_cong)
done

theorem filter_double : "ALL P. ALL s. X_filter s P=X_filter (X_filter s P) P"
apply (auto)
apply (rule_tac R="(%x y. EX a. (x=X_filter a P) & y=(X_filter (X_filter a P) P))" in coinduct)
apply (auto)
apply (rule_tac x="tail a" in exI)
apply (simp add: Ax9)
done

lemma defophead1: "defOp (X_head (X_map f s)) = (defOp (f(makeTotal (X_head s))) & defOp (X_head s))"
apply (simp add: Ax16)
done

lemma defophead2: "defOp (X_head s) ==> head (X_map f s) = f(makeTotal (X_head s))"
apply (simp add: Ax16)
done

lemma test: "((restrictOp a c) = (restrictOp b c)) = (c --> (a = b))"
apply (simp add: restrictOp_def)
done

lemma res_overlap[simp]: "restrictOp (restrictOp a b) c = restrictOp a (b & c)"
apply (simp add: restrictOp_def)
done


theorem Ax4_1v1 :
"ALL f.
 ALL g.
 ALL s.
 head(X_map (X__o__X (f, g)) s) = head(((X_map f) o (X_map g)) s)"
apply (auto simp add: o_def Ax16) 
done

theorem Ax4_1_monadic :
"ALL f.
 ALL g.
 ALL s.
 head(X_map (X__o__X (f, g)) s) = head(((X_map f) o (X_map g)) s)"
apply (auto)
apply (simp only: o_def_monadic Ax16_monadic)
apply (simp)
done

theorem Ax4_1v2: 
"ALL f.
 ALL g.
 ALL s.
 head(X_map (X__o__X (f, g)) s) = head(((X_map f) o (X_map g)) s)"
apply (auto)
apply (simp add: Ax16 o_def)
apply (case_tac "defOp (head(s))")
apply (simp)
apply (simp)
apply (simp add: restrictOp_def)
done

theorem Ax4_1v3: 
"ALL f.
 ALL g.
 ALL s.
 head(X_map (X__o__X (f, g)) s) = head(((X_map f) o (X_map g)) s)"
apply (auto)
apply (simp only: Ax16 o_def)
apply (subst def_restrict)
apply (subst restrictOp_cong)
apply (simp)
apply (subst restrict_assoc)
apply (simp)
done



theorem Ax4_1 :
"ALL f.
 ALL g.
 X_map (X__o__X (f, g)) = (X_map f) o (X_map g)"
apply (auto)
apply (rule ext)
apply (simp only: o_def comp_def)
oops








lemma asd: "(defOp (X_start (nf s))) = defOp (X_start s)"
apply (subst Ax3)
apply (subst Ax3)
apply (subst Ax2)
apply (subst Ax2)
sorry

lemma asd2: "(EX m. defOp (nf s m)) = (EX m. defOp (s m))"
sorry

lemma asd2: "h(X_filter (nf s) P) = h(X_filter s P)"
apply (rule_tac R="(%x y. EX a. (x=nf a) & (y=nf a))" in coinduct)
apply (simp add: Ax10)
apply (simp only: Ax3)
apply (simp only: Ax2)
apply (subst asd2)

theorem filter_nfcom: "ALL P. ALL s. nf (X_filter (nf s) P) = nf (X_filter s P)"
apply (auto)
apply (rule_tac R="(%x y. EX a. (x=nf (X_filter (nf s) P)) & (y=nf (X_filter s P)))" in coinduct)
apply (simp add: Ax6)
apply clarify
apply (rule conjI)
apply (auto)
apply (simp add: Ax6 Ax8 resOp_def bool2partial_def lift2bool_def Ax10 cong: conj_cong)
apply (subst Ax10)
apply (auto)
apply (simp add: bisim2)
apply (rule_tac x="s" in exI)
apply (auto)
done


lemma asd: "h(X_filter s P)=min'' (% m. (defOp (s m) & P (makeTotal (s m))))"
apply (subst Ax10)
apply (simp add: Ax3)
apply (subst Ax1)

lemma asd: "P (makeTotal (head(nf s))) ==> head(nf (X_filter s P)) = head(X_filter (nf s) P)"
apply (simp only: Ax6)
apply (simp only: bool2partial_def lift2bool_def resOp_def)
apply clarsimp
apply (simp only: Ax6)
apply (auto)
apply (subst Ax10)
apply (simp)
apply (simp only: Ax6)

apply (simp add: Ax6 Ax8)

end
