library Set
version 0.9

%left_assoc __intersection__  %[ Should go to StructuredDatatypes ]%
%left_assoc __+__

%prec({__isIn__, __subset__, __disjoint__,__ :: __ --> __} 
		 < {__union__, __intersection__, __\\__, __*__, 
		    __disjointUnion__} )%

%prec {__+__} < {__*__,__div__}


logic CASL

spec Bool = 
  sort Bool
  ops False, True : Bool;
end

spec Nat = 
  sort Nat
  ops __+__,__*__,__div__ : Nat*Nat->Nat;
      0,1,2 : Nat
  pred __<__ : Nat*Nat;
end

spec List =
  free type List[Elem] ::= nil | cons(Elem; List[Elem])
end

logic HasCASL


%{ Typed sets are represented by predicates over the type.
   Set membership is just holding of the predicate: x isIn s <=> s x
   Note that for disjoint unions and products, the type changes.  }%

spec Set = Bool then
  var S,T : Type
  type Set S := S ->? Unit;
  ops emptySet : Set S;
      {__} : S -> Set S;
      __isIn__ : S * Set S ->? Unit;
      __subset__ :Pred( Set(S) * Set(S) );
      __union__, __intersection__, __\\__  : Set S * Set S -> Set S;
      __disjoint__ : Pred( Set(S) * Set(S) );
      __*__ : Set S -> Set T -> Set (S*T);
      __disjointUnion__ :  Set S -> Set S -> Set (S*Bool);
      injl,injr : S -> S*Bool;
  forall x,x':S; y:T; s,s':Set S; t:Set(T) 
  . not (x isIn emptySet)
  . x isIn {x'} <=> x=x'
  . x isIn s <=> s x
  . s subset s' <=> forall x:S . (x isIn s) => (x isIn s')
  . (x isIn (s union s')) <=> ((x isIn s) \/ (x isIn s'))
  . (x isIn (s intersection s')) <=> ((x isIn s) /\ (x isIn s'))
  . x isIn s \\ s' <=> x isIn s /\ not (x isIn s')
  . (s disjoint s') <=> ((s intersection s') = emptySet)
  %% . ((x,y) isIn (s * t)) <=> ((x isIn s) /\ (y isIn t))
  . (injl x) = (x,false)
  . (injr x) = (x,true)
  %%. (s disjointUnion s') = ((s * {false}) union (s' * {true}))
end

%{ Relations and partial equivalence relations (PERs) }%
spec Relation =
  Set
then
  var S : Type
  ops reflexive, symmetric, transitive : Pred(Set(S*S))
  forall r:Set(S*S)
  . (reflexive r) <=> (forall x:S . r(x,x))
  . (symmetric r) <=> forall x,y:S . (r(x,y)) => (r(y,x))
  . (transitive r) <=> forall x,y,z:S . ((r(x,y)) /\ (r(y,z))) => (r(x,y))
  type PER S := Set(S*S)
  %% = { r : Set(S*S) . (symmetric r) /\ (transitive r) }    %% Christian!
  op dom : PER S -> Set S
  %%forall x:S; r: PER S
  %%. (x isIn (dom r)) <=> ((x,x) isIn r)
end

%{ Partial maps and endomaps }%  
spec Map =
  Set then
  var S,T,U : Type
  type Map S := S->?S
  ops dom : (S->?T) -> Set S;
      range : (S->?T) -> Set T; 
      image : (S->?T) -> Set S -> Set T;
      emptyMap : (S->?T);
      __ :: __ --> __ : Pred ( (S->?T) * Pred(S) * Pred(T) );
      __ [__/__] : (S->?T) * S * T -> (S->?T);
      __ - __ : (S->?T) * S -> (S->?T);
      __o__ : (T->?U) * (S->?T) -> (S->?U);
      __||__ : (S->?T) * Set S -> (S->?T);
      undef__ : S ->?T;
      ker : (S->?T) -> Pred (S*S);
      injective : Pred(S->?T)
  forall f,g:S->?T; h:T->?U; s,s':Set S; t:Set T; x,x':S; y:T
  . x isIn dom f <=> def (f x)
  . y isIn range f <=> exists x:S . f x = y
  . y isIn image f s <=> exists x:S . x isIn s /\ f x = y
  . not def (emptyMap x)
  . f :: s --> t <=> (forall x:S . x isIn s => f x isIn t) 
  . f[x/y] x' = if x=x' then y else (f x)
  . (f - x) x' = if x=x' then undef() else (f x)
  . (s intersection s') x = if s x = s' x then s x else undef()
  . def (s union s') <=> (forall x:S. def (s x) /\ def (s' x) => s x = s' x)
  . def (s union s') => (s union s') x = if def (s x) then s x else (s' x)
  . (h o g) x = h(g(x))
  . (f || s) x = if x isIn s then f x else undef()
  %% the kernel is a PER with same domain as the function, hence the existential equation
  . (x,x') isIn ker f <=> f x =e= f x'
  %% injectivity only for values in the domain, hence the existential equation
  . injective f <=> (forall x,y:S . f x =e= f y => x=y)
end

spec SetCategory =
  Map
then
  type SetS := Set S
  type MapS := Set S * Map S * Set S
  ops dom (a,f,b):MapS = a
      cod (a,f,b):MapS = b
      __o__ : MapS * MapS ->? MapS
  forall a,b,c : SetS; f,g : MapS
  . def f o g <=> cod g = dom f
  . (b,g,c) o (a,f,b) = (a,g o f,c)
end

view CategoryofSets : Category -> SetCategory =
     Ob |-> SetS, Mor |-> MapS, __o__, dom, cod
end


%{ If we want to iterate the constructions product, disjoint union
   and quotients on sets, we need to circumvent the problem that
   the type of the sets changes with each construction.
   This means that we need a specific type S which comes with
   the possibility to represent the result of the above mentioned
   operations again in S.
   The following specification states the abstract requirement that
   such representations exists for a given type S. }%
spec SetRepresentation =
  Map and Relation
then
  type S;
  ops pair : S*S->S;   %% represent S*S in S
      inl,inr : S->S;  %% represent S disjointUnion S in S, with left and right injection
      %% represent quotient by a PER, yields the quotient map
      %% the quotient is then the image of the quotient map
      coeq: PER S -> Map S; 
  . injective pair
  . injective inl
  . injective inr
  . (range inl) disjoint (range inr);
  forall r:PER S
  . ker (coeq r) = r 
end

%{ Some sample set representation for the natural numbers ... }%
spec Nat_SetRepresentation =
  Map and Nat and Relation
then
  ops pair : Nat*Nat->Nat;   
      inl,inr : Nat->Nat; 
      coeq: PER Nat -> Map Nat; 
      min : Pred Nat ->? Nat
  forall r:PER Nat; m,n:Nat
  %% Use Cantor's diagonalization for pairs of natural numbers
  . pair(m,n) = ((m+n)*(m+n+1)+2*m) div 2
  %% Use even and odd numbers as two copies of the natural numbers
  . inl m = 2*m
  . inr m = 2*m+1
  %% choose the minimal element as representative of an equivalence class
  . min p = n <=> (p n /\ forall m:Nat . m<n => not p m) 
  . coeq r n = min (\ m:Nat . (m,n) isIn r) 
end

%{ ... and the statement that this is indeed a set representation }%
view v : SetRepresentation to Nat_SetRepresentation = S |-> Nat
end

%{ Given a set representation, we now can define coproducts,
   while staying within the same type of sets.
   Note that __*__ is now overloaded: for two given S-sets,
   We also specify the mediating morphisms that exist by the
   respective (co)universal properties of the constructions. }%
spec SetCoproduct[SetRepresentation] given Map = %def
  SetCategory
then
  type CPCocone := {(h,k) : MapS * MapS . cod h = cod k}
  ops __coproduct__ : SetS * SetS -> (CPCoconce * (CPCocone ->? MapS));
  forall ,s1,s2:SetS
  . s1 coproduct s2 = 
       let copr = (image inl s1) union (image inr s2)
           med c = let (f,g) = c 
                   in \y -> case y of (inl x) -> f x
                                      (inr x) -> g x
       in (((s1,inl,copr),(s2,inr,copr)),med)
end


view SetHasCoproducts [SetRepresentation] given Map : 
        Coproduct[Category] -> SetCoproduct[SetRepresentation] =
     Ob |-> SetS, Mor |-> MapS, id, __o__, dom, cod, __coproduct__
end     


%{ Given a set representation, we now can define coequalizers,
   while staying within the same type of sets.
   Note that __*__ is now overloaded: for two given S-sets,
   We also specify the mediating morphisms that exist by the
   respective (co)universal properties of the constructions. }%
spec SetCoequalizer[SetRepresentation] given Map = %def
  SetCategory
then
  type CEDiagram = {(f,g) : Mor * Mor . dom f = dom g /\ cod f = cod g};
  ops coequalizer : CEDiagram -> (MapS * (MapS -> MapS))
  forall s1,s2,t:SetS; f,g,h : MapS
  . coequalizer d = 
       let (f,g) = d
           r = \x:S . f x = g x
           c = coeq r 
           med h = (dom h,\x:S . h(@y . coeq y = x),range c)
       in
       ((cod f, c, range c),med)
end


view SetHasCoequalizers [SetRepresentation] given Map : 
        Coequalizer[Category] -> SetCoequalizer[SetRepresentation] =
     Ob |-> SetS, Mor |-> MapS, id, __o__, dom, cod, __coequalizer__
end     

spec SetPushOut [SetRepresentation] =
  PushoutAsCoequalizerOfCoproduct[view SetHasCoproducts][view SetHasCoequalizers]
end
