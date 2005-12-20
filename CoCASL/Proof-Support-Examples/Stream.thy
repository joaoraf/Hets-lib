theory Stream = Main:

use tactics

method_setup circular_coinduction = "build_tactic (circular_coinduction_fun)" "coinduction,init,repeat(breakup,close_or_step),force_finish"
method_setup coinduction = "build_tactic (coinduction_fun)" "rule_tac R=?Rzero in ga_cogenerated, instantiate_tac Rzero %s1.?R,step"
method_setup init = "build_tactic (init_fun)" "(simp|(solve,blast))?,init2_fun?"
method_setup breakup = "build_tactic (breakup_fun)" "simp,((exE|conjE)+)?,disjE"
method_setup solve= "build_tactic (solve_fun 1)" "((exE|conjE|conjI)+)?,(simp)?,((exE|conjE|conjI)+)?,(simp)?"
method_setup step = "build_tactic (step_fun)" "((disjI2)+)?,inst r (rcs union (trans r))"
method_setup close= "build_tactic (close_fun)" "((disjI1|disjI2)+)?,((exE|conjE)+)?,force_solve|solve,disji1+,blast"
method_setup close_or_step= "build_tactic (close_or_step_fun)" "try to close current subgoal, if this fails, step"
method_setup force_finish = "build_tactic (force_finish_fun)" "force: inst r false,solve1"
(*method_setup first_then = "build_tactic (first_then_fun)" "repeat disji2,exi,exi,conji, then execute force_tac the same number of times"*)

typedecl "Elem"
typedecl "Stream"
consts
"identity" :: "Elem => Elem"
"cons" :: "Elem => Stream => Stream"
"hd" :: "Stream => Elem"
"tl" :: "Stream => Stream"
"first" :: "Stream => Stream"
"second" :: "Stream => Stream"
"third" :: "Stream => Stream"
"zip3" :: "Stream => Stream => Stream => Stream"
"even" :: "Stream => Stream"
"zip" :: "Stream => Stream => Stream"
"Odd" :: "Stream => Stream"
"const" :: "Elem => Stream"
"swap" :: "Elem => Elem => Stream"
"iterate" :: "(Elem => Elem) => Elem => Stream"
"map" :: "(Elem => Elem) => Stream => Stream"
"one" :: "Stream => Stream"
"two" :: "Stream => Stream"
"three" :: "Stream => Stream"
"four" :: "Stream => Stream"
"zip4" :: "Stream => Stream => Stream => Stream => Stream"

consts
  BinRelImage :: "('a => 'b) => ('a => 'a => bool) => ('b => 'b => bool)"
  Trans_Stream :: "('a => 'a => bool) => ('b => 'b => bool)"
  union :: "('a => 'a => bool)  => ('a => 'a => bool) => ('a => 'a => bool)" (infixl 20)
defs
  BinRelImage_def [simp] : "BinRelImage f R == %x y . EX u v . R u v & x = f u & y = f v"
  Trans_Stream_def [simp] : "Trans_Stream R == (BinRelImage tl R)"
  union_def [simp] : "R union S == % x y . R x y | S x y"

axioms

one_hd [simp]: "!! s :: Stream . (hd (one s)) = (hd s)"
one_tl [simp]: "!! s :: Stream . (tl (one s)) = one (tl (tl (tl (tl s))))"
two_hd [simp]: "!! s :: Stream . (hd (two s)) = (hd (tl s))"
two_tl [simp]: "!! s :: Stream . (tl (two s)) = two (tl (tl (tl (tl s))))"
three_hd [simp]: "!! s :: Stream . (hd (three s)) = (hd (tl (tl s)))"
three_tl [simp]: "!! s :: Stream . (tl (three s)) = three (tl (tl (tl (tl s))))"
four_hd [simp]: "!! s :: Stream . (hd (four s)) = (hd (tl (tl (tl s))))"
four_tl [simp]: "!! s :: Stream . (tl (four s)) = four (tl (tl (tl (tl s))))"
zip4_hd [simp]: "!! s1 :: Stream . !! s2 :: Stream . !! s3 :: Stream . !! s4 :: Stream . (hd (zip4 s1 s2 s3 s4)) = (hd s1)"
zip4_tl [simp]: "!! s1 :: Stream . !! s2 :: Stream . !! s3 :: Stream . !! s4 :: Stream . (tl (zip4 s1 s2 s3 s4)) = zip4 s2 s3 s4 (tl s1)"

first_hd [simp]: "!! s :: Stream . (hd (first s)) = (hd s)"
first_tl [simp]: "!! s :: Stream . (tl (first s)) = first (tl (tl (tl s)))"
second_hd [simp]: "!! s :: Stream . (hd (second s)) = (hd (tl s))"
second_tl [simp]: "!! s :: Stream . (tl (second s)) = second (tl (tl (tl s)))"
third_hd [simp]: "!! s :: Stream . (hd (third s)) = (hd (tl (tl s)))"
third_tl [simp]: "!! s :: Stream . (tl (third s)) = third (tl (tl (tl s)))"
zip3_hd [simp]: "!! s1 :: Stream . !! s2 :: Stream . !! s3 :: Stream . (hd (zip3 s1 s2 s3)) = (hd s1)"
zip3_tl [simp]: "!! s1 :: Stream . !! s2 :: Stream . !! s3 :: Stream . (tl (zip3 s1 s2 s3)) = zip3 s2 s3 (tl s1)"

Odd_hd [simp]: "!! s :: Stream . (hd (Odd s)) = (hd s)"
Odd_tl [simp]: "!! s :: Stream . (tl (Odd s)) = Odd (tl (tl s))" 
even_hd [simp]: "!! s :: Stream . (hd (even s)) = (hd (tl s))"
even_tl [simp]: "!! s :: Stream . (tl (even s)) = even (tl (tl s))"
zip_hd [simp]: "!! s1 :: Stream . !! s2 :: Stream . (hd (zip s1 s2)) = (hd s1)"
zip_tl [simp]: "!! s1 :: Stream . !! s2 :: Stream . (tl (zip s1 s2)) = zip s2 (tl s1)"

identity_1 [simp]: "!! e :: Elem . (identity e) = (e)"
map_hd [simp]: "!! f :: Elem => Elem . !! s :: Stream . (hd (map f s)) = (f (hd s))"
map_tl [simp]: "!! f :: Elem => Elem . !! s :: Stream . (tl (map f s)) = (map f (tl s))"
iterate_hd [simp] : "!! f :: (Elem => Elem) . !! e :: Elem . (hd (iterate f e)) = e"
iterate_tl [simp] : "!! f :: (Elem => Elem) . !! e :: Elem . (tl (iterate f e)) = (iterate f (f e))"
const_hd [simp] : "!! e :: Elem . (hd (const e)) = e"
const_tl [simp] : "!! e :: Elem . (tl (const e)) = const e"
swap_hd [simp] : "!! e1 :: Elem . !! e :: Elem . (hd (swap e1 e2)) = e1"
swap_tl [simp] : "!! e1 :: Elem . !! e :: Elem . (tl (swap e1 e2)) = (swap e2 e1)"

ga_cogenerated_Stream: "!! R :: Stream => Stream => bool . !! u :: Stream . !! v :: Stream . ! x :: Stream . ! y :: Stream . R x y --> (hd x = hd y & R (tl x) (tl y))  ==> R u v ==> u = v"


theorem Stream_Zip2: "!! s :: Stream . zip (Odd s) (even s) = s"
apply(coinduction)
apply(init)
apply(breakup)
apply(close_or_step)
apply(force_finish)
done

theorem Stream_Zip2a: "!! s :: Stream . zip (Odd s) (even s) = s"
apply(circular_coinduction)
done


theorem Stream_Zip3: "!! s :: Stream . ((zip3 (first s) (second s)) (third s)) = s"
apply(coinduction)
apply(init)
apply(breakup)
apply(close_or_step)
apply(breakup)
apply(close_or_step)
apply(force_finish)
done

theorem Stream_Zip3a: "!! s :: Stream . ((zip3 (first s) (second s)) (third s)) = s"
apply(circular_coinduction)
done

theorem Stream_Zip4: "!! s :: Stream . ((zip4 (one s) (two s)) (three s) (four s)) = s"
apply(circular_coinduction)
(*
apply(coinduction)
apply(init)
apply(breakup)
apply(close_or_step)
apply(breakup)
apply(close_or_step)
apply(breakup)
apply(close_or_step)
apply(breakup)
apply(close_or_step)
apply(force_finish)
*)
done 

theorem Stream_Iter_Const: "!! e :: Elem . const e = iterate identity e"
apply(circular_coinduction)
done

theorem Stream_Even_Const: "!! e :: Elem . const e = even (const e)"
apply(circular_coinduction)
done

theorem Stream_Odd_Swap: "!! e :: Elem . !! f :: Elem . const e = Odd (swap e f)"
apply(circular_coinduction)
done

theorem Stream_Swap_Const: "!! e :: Elem . const e = swap e e"
apply(circular_coinduction)
done

theorem Stream_Iter_Const: "!! e :: Elem . const e = map identity (const e)"
apply(circular_coinduction)
done

theorem Stream_Iter_Map: "!! e :: Elem . !! f :: (Elem => Elem) . (iterate f (f e)) = (map f (iterate f e))"
apply(circular_coinduction)
done

theorem Stream_Const_Swap: "!! a :: Elem . !! b :: Elem . (zip (const a) (const b)) = (swap a b)"
apply(circular_coinduction)
done

theorem cogenerated_Odd_even: 
"!! R :: Stream => Stream => bool . !! u :: Stream . !! v :: Stream . ! x :: Stream . ! y :: Stream . \
 R x y --> (hd x = hd y & R (Odd x) (Odd y) & R (even x) (even y))  ==> R u v ==> u = v"
(*apply(tactic "compose_tac (true,get_ctxt_thm \"ga_cogenerated_Stream\",1) 1")*)
apply(rule_tac R=R in ga_cogenerated_Stream)
apply(init)
apply(simp)
apply(init)
apply(rule conjI)
apply(simp)
apply(breakup)
end
