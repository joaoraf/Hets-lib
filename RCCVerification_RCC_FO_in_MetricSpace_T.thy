theory RCCVerification_RCC_FO_in_MetricSpace_T
imports "$HETS_LIB/Isabelle/MainHC"
uses "$HETS_LIB/Isabelle/prelude"
begin

ML "Header.initialize
    [\"C_non_null\", \"C_sym\", \"C_id\", \"C_non_triv\", \"refl\",
     \"trans\", \"antisym\", \"dichotomy_TotalOrder\",
     \"Field_unary_minus_idef\", \"FWO_plus_left\", \"FWO_times_left\",
     \"FWO_plus_right\", \"FWO_times_right\", \"FWO_plus\",
     \"geq_def_ExtPartialOrder\", \"less_def_ExtPartialOrder\",
     \"greater_def_ExtPartialOrder\", \"ga_comm_inf\", \"ga_comm_sup\",
     \"inf_def_ExtPartialOrder\", \"sup_def_ExtPartialOrder\",
     \"ga_comm_min\", \"ga_comm_max\", \"ga_assoc_min\",
     \"ga_assoc_max\", \"min_def_ExtTotalOrder\",
     \"max_def_ExtTotalOrder\", \"min_inf_relation\",
     \"max_sup_relation\", \"Real_ub_def\", \"Real_lb_def\",
     \"Real_inf_def\", \"Real_sup_def\", \"Real_isBounded_def\",
     \"completeness\", \"Real_inj_0\", \"Real_inj_suc\",
     \"Real_archimedian\", \"Real_abs_def\", \"Real_sqr_def\",
     \"Real_sqrt_dom\", \"Real_sqrt_idef\", \"Real_2_def\",
     \"Real_minus_def\", \"Real_divide_dom\", \"Real_divide_idef\",
     \"Real_half_idef\", \"one_greater_zero\", \"zero_leq_one\",
     \"half_gt_zero\", \"half_plus_minus\", \"add_monotone\",
     \"sub_leq\", \"half_leq\", \"half_leq_zero\", \"comm_add\",
     \"Real_half_plus\", \"Real_half_minus\", \"Real_minus_half\",
     \"Real_half_monot\", \"MS_pos_definite\", \"MS_symm\",
     \"MS_triangle\", \"MS_pos\", \"MS_zero\", \"EMSCB_rep_pos\",
     \"EMSCB_rep_0\", \"EMSCB_rep_inj\", \"Ax4\", \"EMSCB_center\",
     \"EMSCB_closed\", \"def_nonempty\", \"C_def\"]"

typedecl ClosedBall
typedecl Real
typedecl S

datatype Nat = X0X1 ("0''") | X_suc "Nat" ("suc/'(_')" [10] 999)

consts
X0X2 :: "Real" ("0''''")
X1 :: "Real" ("1''")
X2 :: "Real" ("2")
XMinus__X :: "Real => Real" ("(-''/ _)" [56] 56)
XVBar__XVBar :: "Real => Real" ("(|/ _/ |)" [10] 999)
X__C__X :: "ClosedBall => ClosedBall => bool" ("(_/ C/ _)" [44,44] 42)
X__XGtXEq__X :: "Real => Real => bool" ("(_/ >=''/ _)" [44,44] 42)
X__XGt__X :: "Real => Real => bool" ("(_/ >''/ _)" [44,44] 42)
X__XLtXEq__XX1 :: "Real => Real => bool" ("(_/ <=''/ _)" [44,44] 42)
X__XLtXEq__XX2 :: "Real => (Real => bool) => bool" ("(_/ <=''''/ _)" [44,44] 42)
X__XLtXEq__XX3 :: "(Real => bool) => Real => bool" ("(_/ <='_3/ _)" [44,44] 42)
X__XLt__X :: "Real => Real => bool" ("(_/ <''/ _)" [44,44] 42)
X__XMinus__X :: "Real => Real => Real" ("(_/ -''/ _)" [54,54] 52)
X__XPlus__X :: "Real => Real => Real" ("(_/ +''/ _)" [54,54] 52)
X__XSlash__X :: "Real => Real => Real option" ("(_/ '/''/ _)" [54,54] 52)
X__Xx__X :: "Real => Real => Real" ("(_/ *''/ _)" [54,54] 52)
X_closedBall :: "S => Real => ClosedBall" ("closedBall/'(_,/ _')" [10,10] 999)
X_d :: "S => S => Real" ("d/'(_,/ _')" [10,10] 999)
X_half :: "Real => Real" ("half/'(_')" [10] 999)
X_inj :: "Nat => Real" ("inj''/'(_')" [10] 999)
X_isBounded :: "(Real => bool) => bool" ("isBounded/'(_')" [10] 999)
X_max :: "Real => Real => Real" ("max''/'(_,/ _')" [10,10] 999)
X_min :: "Real => Real => Real" ("min''/'(_,/ _')" [10,10] 999)
X_nonempty :: "ClosedBall => bool" ("nonempty/'(_')" [10] 999)
infX1 :: "Real => Real => Real option" ("inf''/'(_,/ _')" [10,10] 999)
infX2 :: "(Real => bool) => Real option" ("inf''''/'(_')" [10] 999)
rep :: "ClosedBall => S => bool"
sqr__X :: "Real => Real" ("(sqr/ _)" [56] 56)
sqrt__X :: "Real => Real option" ("(sqrt/ _)" [56] 56)
supX1 :: "Real => Real => Real option" ("sup''/'(_,/ _')" [10,10] 999)
supX2 :: "(Real => bool) => Real option" ("sup''''/'(_')" [10] 999)

instance ClosedBall:: type
by intro_classes
instance Nat:: type
by intro_classes
instance Real:: type
by intro_classes
instance S:: type
by intro_classes

axioms
refl [rule_format] : "ALL x. x <=' x"

trans [rule_format] :
"ALL x. ALL y. ALL z. x <=' y & y <=' z --> x <=' z"

antisym [rule_format] : "ALL x. ALL y. x <=' y & y <=' x --> x = y"

dichotomy_TotalOrder [rule_format] :
"ALL x. ALL y. x <=' y | y <=' x"

Field_unary_minus_idef [rule_format] : "ALL x. -' x +' x = 0''"

FWO_plus_left [rule_format] :
"ALL a. ALL b. ALL c. a <=' b --> a +' c <=' b +' c"

FWO_times_left [rule_format] :
"ALL a. ALL b. ALL c. a <=' b & 0'' <=' c --> a *' c <=' b *' c"

FWO_plus_right [rule_format] :
"ALL a. ALL b. ALL c. b <=' c --> a +' b <=' a +' c"

FWO_times_right [rule_format] :
"ALL a. ALL b. ALL c. b <=' c & 0'' <=' a --> a *' b <=' a *' c"

FWO_plus [rule_format] :
"ALL a.
 ALL b. ALL c. ALL X_d. a <=' c & b <=' X_d --> a +' b <=' c +' X_d"

geq_def_ExtPartialOrder [rule_format] :
"ALL x. ALL y. (x >=' y) = (y <=' x)"

less_def_ExtPartialOrder [rule_format] :
"ALL x. ALL y. (x <' y) = (x <=' y & ~ x = y)"

greater_def_ExtPartialOrder [rule_format] :
"ALL x. ALL y. (x >' y) = (y <' x)"

ga_comm_inf [rule_format] : "ALL x. ALL y. inf'(x, y) = inf'(y, x)"

ga_comm_sup [rule_format] : "ALL x. ALL y. sup'(x, y) = sup'(y, x)"

inf_def_ExtPartialOrder [rule_format] :
"ALL x.
 ALL y.
 ALL z.
 inf'(x, y) = Some z =
 (z <=' x & z <=' y & (ALL t. t <=' x & t <=' y --> t <=' z))"

sup_def_ExtPartialOrder [rule_format] :
"ALL x.
 ALL y.
 ALL z.
 sup'(x, y) = Some z =
 (x <=' z & y <=' z & (ALL t. x <=' t & y <=' t --> z <=' t))"

ga_comm_min [rule_format] : "ALL x. ALL y. min'(x, y) = min'(y, x)"

ga_comm_max [rule_format] : "ALL x. ALL y. max'(x, y) = max'(y, x)"

ga_assoc_min [rule_format] :
"ALL x. ALL y. ALL z. min'(x, min'(y, z)) = min'(min'(x, y), z)"

ga_assoc_max [rule_format] :
"ALL x. ALL y. ALL z. max'(x, max'(y, z)) = max'(max'(x, y), z)"

min_def_ExtTotalOrder [rule_format] :
"ALL x. ALL y. min'(x, y) = (if x <=' y then x else y)"

max_def_ExtTotalOrder [rule_format] :
"ALL x. ALL y. max'(x, y) = (if x <=' y then y else x)"

min_inf_relation [rule_format] :
"ALL x. ALL y. Some (min'(x, y)) = inf'(x, y)"

max_sup_relation [rule_format] :
"ALL x. ALL y. Some (max'(x, y)) = sup'(x, y)"

Real_ub_def [rule_format] :
"ALL M. ALL r. (M <=_3 r) = (ALL s. M s --> s <=' r)"

Real_lb_def [rule_format] :
"ALL M. ALL r. (r <='' M) = (ALL s. M s --> r <=' s)"

Real_inf_def [rule_format] :
"ALL M.
 ALL r.
 inf''(M) = Some r = (r <='' M & (ALL s. s <='' M --> s <=' r))"

Real_sup_def [rule_format] :
"ALL M.
 ALL r.
 sup''(M) = Some r = (M <=_3 r & (ALL s. M <=_3 s --> r <=' s))"

Real_isBounded_def [rule_format] :
"ALL M. isBounded(M) = (EX ub. EX lb. lb <='' M & M <=_3 ub)"

completeness [rule_format] :
"ALL M. isBounded(M) --> defOp (inf''(M)) & defOp (sup''(M))"

Real_inj_0 [rule_format] : "inj'(0') = 0''"

Real_inj_suc [rule_format] :
"ALL X_n. inj'(suc(X_n)) = 1' +' inj'(X_n)"

Real_archimedian [rule_format] : "ALL r. EX X_n. r <=' inj'(X_n)"

Real_abs_def [rule_format] : "ALL r. | r | = max'(r, -' r)"

Real_sqr_def [rule_format] : "ALL r. sqr r = r *' r"

Real_sqrt_dom [rule_format] : "ALL r. defOp (sqrt r) = (r >=' 0'')"

Real_sqrt_idef [rule_format] : "ALL r. sqrt sqr r = Some ( | r | )"

Real_2_def [rule_format] : "2 = 1' +' 1'"

Real_minus_def [rule_format] :
"ALL r. ALL r'. r -' r' = r +' -' r'"

Real_divide_dom [rule_format] : "ALL r. ~ defOp (r /' 0'')"

Real_divide_idef [rule_format] :
"ALL r.
 ALL r'.
 ALL r''. (~ r' = 0'' --> r /' r' = Some r'') = (r'' *' r' = r)"

Real_half_idef [rule_format] : "ALL r. 2 *' half(r) = r"

one_greater_zero [rule_format] : "1' >' 0''"

zero_leq_one [rule_format] : "0'' <=' 1'"

half_gt_zero [rule_format] : "ALL r. r >' 0'' --> half(r) >' 0''"

half_plus_minus [rule_format] :
"ALL r. ALL s. r <=' s --> s +' half(r -' s) <=' s"

add_monotone [rule_format] :
"ALL a.
 ALL b. ALL c. ALL e. a <=' b & c <=' e --> a +' c <=' b +' e"

sub_leq [rule_format] : "ALL a. ALL b. ~ a <=' b --> a -' b >' 0''"

half_leq [rule_format] :
"ALL a. ALL b. a <=' half(a -' b) +' b --> a <=' b"

half_leq_zero [rule_format] :
"ALL r. 0'' <=' r --> 0'' <=' half(r)"

comm_add [rule_format] : "ALL a. ALL b. a +' b = b +' a"

Real_half_plus [rule_format] :
"ALL r. ALL s. half(r +' s) = half(r) +' half(s)"

Real_half_minus [rule_format] :
"ALL r. ALL s. half(r -' s) = half(r) -' half(s)"

Real_minus_half [rule_format] : "ALL r. r -' half(r) = half(r)"

Real_half_monot [rule_format] :
"ALL r. ALL s. (half(r) <=' half(s)) = (r <=' s)"

MS_pos_definite [rule_format] :
"ALL x. ALL y. d(x, y) = 0'' = (x = y)"

MS_symm [rule_format] : "ALL x. ALL y. d(x, y) = d(y, x)"

MS_triangle [rule_format] :
"ALL x. ALL y. ALL z. d(x, z) <=' d(x, y) +' d(y, z)"

MS_pos [rule_format] : "ALL x. ALL y. 0'' <=' d(x, y)"

MS_zero [rule_format] : "ALL x. d(x, x) = 0''"

EMSCB_rep_pos [rule_format] :
"ALL r.
 ALL x.
 ALL y. r >' 0'' --> rep (closedBall(x, r)) y = (d(x, y) <=' r)"

EMSCB_rep_0 [rule_format] :
"ALL r. ALL x. ALL y. ~ r >' 0'' --> ~ rep (closedBall(x, r)) y"

EMSCB_rep_inj [rule_format] :
"ALL a. ALL b. rep a = rep b --> a = b"

Ax4 [rule_format] : "ALL a. EX z. EX t. a = closedBall(z, t)"

EMSCB_center [rule_format] :
"ALL r. ALL x. r >' 0'' --> rep (closedBall(x, r)) x"

EMSCB_closed [rule_format] :
"ALL a.
 ALL x.
 ~ rep a x -->
 (EX r. ALL y. ~ (rep (closedBall(x, r)) y & ~ rep a y))"

def_nonempty [rule_format] : "ALL x. nonempty(x) = (x C x)"

C_def [rule_format] :
"ALL x. ALL y. (x C y) = (EX s. rep x s & rep y s)"

declare refl [simp]
declare dichotomy_TotalOrder [simp]
declare Field_unary_minus_idef [simp]
declare FWO_plus_left [simp]
declare FWO_plus_right [simp]
declare min_inf_relation [simp]
declare max_sup_relation [simp]
declare completeness [simp]
declare Real_inj_0 [simp]
declare Real_divide_dom [simp]
declare Real_divide_idef [simp]
declare Real_half_idef [simp]
declare one_greater_zero [simp]
declare zero_leq_one [simp]
declare half_plus_minus [simp]
declare sub_leq [simp]
declare half_leq_zero [simp]
declare Real_minus_half [simp]
declare Real_half_monot [simp]
declare MS_pos_definite [simp]
declare MS_triangle [simp]
declare MS_pos [simp]
declare MS_zero [simp]
declare EMSCB_rep_pos [simp]
declare EMSCB_rep_0 [simp]
declare EMSCB_center [simp]
declare EMSCB_closed [simp]

theorem C_non_null : "ALL x. ALL y. x C y --> x C x"
using C_def by auto

ML "Header.record \"C_non_null\""

theorem C_sym : "ALL x. ALL y. x C y --> y C x"
using C_def by auto

ML "Header.record \"C_sym\""

lemma swap : "A --> B=D ==> B ==> A-->D"
by auto

lemma impLemma : "[| A; A==>B; B-->D|] ==> D"
by auto

lemma reflLemma : "x=y ==> x <=' y"
using refl by auto

lemma MS_triangle_rev :
"d(x, z) <=' (d(x, y) +' d(z, y))"
by (simp add: MS_symm)

lemma C_id_lemma : "!!x y xa. \ 
       ALL z. (EX s. rep z s & rep x s) = (EX s. rep z s & rep y s) \
       ==> rep x xa ==> rep y xa"
apply (erule contrapos_pp)
apply (subst not_all)
thm Ax4 [THEN allI, of "%x. x"]
apply (insert Ax4 [THEN allI, of "%x. x"])
apply (frule_tac x="x" in spec)
apply (drule_tac x="y" in spec)
apply (erule exE)
apply (erule exE)
apply (erule exE)
apply (erule exE)
apply (subst not_iff)
apply (case_tac "ta >' 0''")
apply (rule_tac x="closedBall(xa, half (d(za, xa) -' ta))" in exI)
apply(auto)
thm EMSCB_rep_pos [THEN sym]
apply((drule EMSCB_rep_pos [THEN sym])+)
apply(rule_tac P="d(za, xa) <=' ta" in notE)
apply(assumption)
apply(rule half_leq)
apply(rule trans)
apply(rule conjI)
defer
apply(rule add_monotone)
apply(rule conjI)
apply(erule mp)
back
apply(insert sub_leq [THEN mp])
apply(rule half_gt_zero [THEN mp])
apply(rule sub_leq [THEN mp])
apply(assumption+)

apply(rule_tac x="xa" in exI)
apply simp
apply(rule EMSCB_rep_pos [THEN mp, THEN iffD2])
apply(rule half_gt_zero [THEN mp])
apply(rule sub_leq [THEN mp])
apply(assumption)
apply simp
apply(rule half_leq_zero [THEN mp])
apply(drule sub_leq [THEN mp])
apply(simp add: greater_def_ExtPartialOrder
                less_def_ExtPartialOrder)
apply(rule trans [THEN spec, THEN spec, THEN spec, THEN mp])
apply(rule conjI)
defer
apply(rule MS_triangle_rev)
apply(rule reflLemma)
apply(rule MS_symm)
done

theorem C_id : "ALL x. ALL y. (ALL z. (z C x) = (z C y)) --> x = y"
apply (auto simp add: C_def)
apply (rule EMSCB_rep_inj [THEN mp])
apply (rule ext)
apply (auto)
apply (rule_tac x="x" in C_id_lemma)
apply(auto)
apply (rule_tac x="y" in C_id_lemma)
apply(auto)
done

ML "Header.record \"C_id\""

theorem C_non_triv : "EX x. x C x"
apply (simp add: C_def)
apply (rule exI)
apply (rule exI)
apply (rule EMSCB_rep_pos [THEN mp, THEN iffD2])
apply(rule one_greater_zero)
apply(rule iffD2)
apply(rule arg_cong)
back
back
defer
apply(rule zero_leq_one)
apply auto
done

ML "Header.record \"C_non_triv\""

end
