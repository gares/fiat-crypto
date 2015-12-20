Require Import Crypto.Galois.Galois Crypto.Galois.GaloisTheory Crypto.Galois.ComputationalGaloisField.
Require Import Tactics.VerdiTactics.
Require Import Logic.Eqdep_dec.
Require Import BinNums NArith.

Module GaloisDefs (M : Modulus).
  Module Export GT := GaloisTheory M.
  Open Scope GF_scope.
End GaloisDefs.

Module Type TwistedEdwardsParams (M : Modulus).
  Module Export GFDefs := GaloisDefs M.
  Parameter a : GF.
  Axiom a_nonzero : a <> 0.
  Axiom a_square : exists x, x * x = a.
  Parameter d : GF.
  Axiom d_nonsquare : forall x, x * x <> d.
End TwistedEdwardsParams.

Module CompleteTwistedEdwardsCurve (M : Modulus) (Import P : TwistedEdwardsParams M).
  (** Twisted Ewdwards curves with complete addition laws. References:
  * <https://eprint.iacr.org/2008/013.pdf>
  * <http://ed25519.cr.yp.to/ed25519-20110926.pdf>
  * <https://eprint.iacr.org/2015/677.pdf>
  *)
  Definition onCurve P := let '(x,y) := P in a*x^2 + y^2 = 1 + d*x^2*y^2.
  Definition point := { P | onCurve P}.
  Definition mkPoint := exist onCurve.

  Definition projX (P:point) := fst (proj1_sig P).
  Definition projY (P:point) := snd (proj1_sig P).

  Definition checkOnCurve x y : if Zbool.Zeq_bool (a*x^2 + y^2) (1 + d*x^2*y^2) then point else True.
    break_if. exists (x, y). exact (GFdecidable  _ _ Heqb). trivial.
  Defined.
  Hint Unfold onCurve mkPoint.

  Definition zero : point. exists (0, 1).
    abstract (unfold onCurve; ring).
  Defined.

  Definition unifiedAdd' (P1' P2' : (GF*GF)) :=
    let '(x1, y1) := P1' in
    let '(x2, y2) := P2' in
    (((x1*y2  +  y1*x2)/(1 + d*x1*x2*y1*y2)) , ((y1*y2 - a*x1*x2)/(1 - d*x1*x2*y1*y2))).

  Definition unifiedAdd (P1 P2 : point) : point. refine (
    let 'exist P1' pf1 := P1 in
    let 'exist P2' pf2 := P2 in
    mkPoint (unifiedAdd' P1' P2') _).
  Proof.
    destruct P1' as [x1 y1], P2' as [x2 y2]; unfold unifiedAdd', onCurve.
    admit. (* field will likely work here, but I have not done this by hand *)
  Defined.
  Local Infix "+" := unifiedAdd.

  Fixpoint scalarMult (n:nat) (P : point) : point :=
    match n with 
    | O => zero
    | S n' => P + scalarMult n' P
    end
  .

  Fixpoint doubleAndAdd' (p : positive) (P : point) : point :=
    match p with
    | 1%positive => P
    | xO q => doubleAndAdd' q (P + P)
    | xI q => P + doubleAndAdd' q (P + P)
    end.

  Definition doubleAndAdd (n : nat) (P : point) : point :=
    match N.of_nat n with
    | N0 => zero
    | Npos p => doubleAndAdd' p P
    end.

End CompleteTwistedEdwardsCurve.


Module Type CompleteTwistedEdwardsPointFormat (M : Modulus) (Import P : TwistedEdwardsParams M).
  Module Curve := CompleteTwistedEdwardsCurve M P.
  Parameter point : Type.
  Parameter encode : (GF*GF) -> point.
  Parameter decode : point -> (GF*GF).
  Parameter unifiedAdd : point -> point -> point.

  Parameter rep : point -> (GF*GF) -> Prop.
  Local Notation "P '~=' rP" := (rep P rP) (at level 70).

  Axiom encode_rep: forall P, encode P ~= P.
  Axiom decode_rep : forall P rP, P ~= rP -> decode P = rP.
  Axiom unifiedAdd_rep: forall P Q rP rQ, Curve.onCurve rP -> Curve.onCurve rQ ->
    P ~= rP -> Q ~= rQ -> (unifiedAdd P Q) ~= (Curve.unifiedAdd' rP rQ).
End CompleteTwistedEdwardsPointFormat.

Module CompleteTwistedEdwardsFacts (M : Modulus) (Import P : TwistedEdwardsParams M).
  Module Import Curve := CompleteTwistedEdwardsCurve M P.
  Lemma twistedAddCompletePlus : forall (P1 P2:point),
    let '(x1, y1) := proj1_sig P1 in
    let '(x2, y2) := proj1_sig P2 in
    (1 + d*x1*x2*y1*y2) <> 0.
    (* "Twisted Edwards Curves" <http://eprint.iacr.org/2008/013.pdf> section 6 *)
  Admitted.
  Lemma twistedAddCompleteMinus : forall (P1 P2:point),
    let '(x1, y1) := proj1_sig P1 in
    let '(x2, y2) := proj1_sig P2 in
    (1 - d*x1*x2*y1*y2) <> 0.
    (* "Twisted Edwards Curves" <http://eprint.iacr.org/2008/013.pdf> section 6 *)
  Admitted.

  Lemma point_eq : forall x1 x2 y1 y2,
    x1 = x2 -> y1 = y2 ->
    forall p1 p2,
    mkPoint (x1, y1) p1 = mkPoint (x2, y2) p2.
  Proof.
    intros; subst; f_equal.
    apply (UIP_dec). (* this is a hack. We actually don't care about the equality of the proofs. However, we *can* prove it, and knowing it lets us use the universal equality instead of a type-specific equivalence, which makes many things nicer. *)
    admit. (* GF_eq_dec *)
  Qed.
  Hint Resolve point_eq.

  Hint Unfold unifiedAdd onCurve.
  Ltac twisted := autounfold; intros;
                  repeat (match goal with
                             | [ x : point |- _ ] => destruct x; unfold onCurve in *
                             | [ x : (GF*GF)%type |- _ ] => destruct x
                             | [  |- exist _ _ _ = exist _ _ _ ] => eapply point_eq
                         end; simpl; repeat (ring || f_equal)).
  Local Infix "+" := unifiedAdd.
  Lemma twistedAddComm : forall A B, (A+B = B+A).
  Proof.
    twisted.
  Qed.

  Lemma twistedAddAssoc : forall A B C, A+(B+C) = (A+B)+C.
  Proof.
    (* http://math.rice.edu/~friedl/papers/AAELLIPTIC.PDF *)
  Admitted.

  Lemma zeroIsIdentity : forall P, P + zero = P.
  Proof.
    twisted.
    (* the denominators are 1 and numerators are equal *)
  Admitted.
  Hint Resolve zeroIsIdentity.

  Lemma scalarMult_double : forall n P, scalarMult (n * 2) P = scalarMult n (P + P).
  Proof.
    induction n; intros; simpl; auto.
    rewrite twistedAddAssoc.
    f_equal; auto.
  Qed.

  Lemma doubleAndAdd'_spec :
    forall p P, scalarMult (Pos.to_nat p) P = doubleAndAdd' p P.
  Proof.
    induction p; intros; simpl; auto. {
      f_equal.
      rewrite Pnat.Pmult_nat_mult.
      rewrite scalarMult_double.
      apply IHp.
    } {
      rewrite Pnat.Pos2Nat.inj_xO.
      rewrite Mult.mult_comm.
      rewrite scalarMult_double.
      apply IHp.
    }
  Qed.

  Lemma doubleAndAdd_spec :
    forall n P, scalarMult n P = doubleAndAdd n P.
  Proof.
    destruct n; auto; intros.
    unfold doubleAndAdd; simpl.
    rewrite <- doubleAndAdd'_spec.
    rewrite Pnat.SuccNat2Pos.id_succ; auto.
  Qed.
End CompleteTwistedEdwardsFacts.

Module Type Minus1Params (Import M : Modulus) <: TwistedEdwardsParams M.
  Module Export GFDefs := GaloisDefs M.
  Open Scope GF_scope.
  Definition a := inject (- 1).
  Axiom a_nonzero : a <> 0.
  Axiom a_square : exists x, x * x = a.
  Parameter d : GF.
  Axiom d_nonsquare : forall x, x * x <> d.
End Minus1Params.

Module Minus1Format (M : Modulus) (Import P : Minus1Params M) <: CompleteTwistedEdwardsPointFormat M P.
  Module Import Facts := CompleteTwistedEdwardsFacts M P.
  Module Import Curve := Facts.Curve.
  (** [projective] represents a point on an elliptic curve using projective
  * Edwards coordinates for twisted edwards curves with a=-1 (see
  * <https://hyperelliptic.org/EFD/g1p/auto-edwards-projective.html>
  * <https://en.wikipedia.org/wiki/Edwards_curve#Projective_homogeneous_coordinates>) *)
  Record projective := mkProjective {projectiveX : GF; projectiveY : GF; projectiveZ : GF}.
  Local Notation "'(' X ',' Y ',' Z ')'" := (mkProjective X Y Z).

  Definition twistedToProjective (P : (GF*GF)) : projective :=
    let '(x, y) := P in (x, y, 1).

  Definition projectiveToTwisted (P : projective) : GF * GF :=
    let 'mkProjective X Y Z := P in
    pair (X/Z) (Y/Z).
  Hint Unfold projectiveToTwisted twistedToProjective.

  Lemma GFdiv_1 : forall x, x/1 = x.
  Admitted.
  Hint Resolve GFdiv_1.

  Lemma twistedProjectiveInv P : projectiveToTwisted (twistedToProjective P) = P.
  Proof.
    twisted; eapply GFdiv_1.
  Qed.

  (** [extended] represents a point on an elliptic curve using extended projective
  * Edwards coordinates with twist a=-1 (see <https://eprint.iacr.org/2008/522.pdf>). *)
  Record extended := mkExtended {extendedToProjective : projective; extendedT : GF}.

  Definition point := extended.
  Local Notation "'(' X ',' Y ',' Z ',' T ')'" := (mkExtended (X, Y, Z) T).
  Definition extendedValid (P : point) : Prop :=
    let pP := extendedToProjective P in
    let X := projectiveX pP in
    let Y := projectiveY pP in
    let Z := projectiveZ pP in
    let T := extendedT P in
    T = X*Y/Z.


  Definition twistedToExtended (P : (GF*GF)) : point :=
    let '(x, y) := P in (x, y, 1, x*y).
  Definition encode P := let '(x, y) := P in twistedToExtended (x, y).

  Definition decode (P : point) :=
    projectiveToTwisted (extendedToProjective P).
  Local Hint Unfold extendedValid twistedToExtended decode projectiveToTwisted Curve.unifiedAdd'.

  Lemma twistedExtendedInv : forall P,
    decode (twistedToExtended P) = P.
  Proof.
    twisted; eapply GFdiv_1.
  Qed.

  Lemma twistedToExtendedValid : forall P, extendedValid (twistedToExtended P).
  Proof.
    autounfold.
    destruct P.
    simpl.
    rewrite GFdiv_1; reflexivity.
  Qed.

  Definition rep (P:point) (rP:(GF*GF)) : Prop :=
    decode P = rP /\ extendedValid P.
  Local Notation "P '~=' rP" := (rep P rP) (at level 70).
  Ltac rep := repeat progress (intros; autounfold; subst; auto; match goal with
                           | [ x : rep ?a ?b |- _ ] => destruct x
                           end).

  Lemma encode_rep : forall P, encode P ~= P.
  Proof.
    split.
    apply twistedExtendedInv.
    apply twistedToExtendedValid.
  Qed.

  Lemma decode_rep : forall P rP, P ~= rP -> decode P = rP.
  Proof.
    rep.
  Qed.


  Local Notation "2" := (1+1).
  (** Second equation from <http://eprint.iacr.org/2008/522.pdf> section 3.1, also <https://www.hyperelliptic.org/EFD/g1p/auto-twisted-extended-1.html#addition-add-2008-hwcd-3> and <https://tools.ietf.org/html/draft-josefsson-eddsa-ed25519-03> *)
  Definition unifiedAdd (P1 P2 : point) : point :=
    let k := 2 * d in
    let pP1 := extendedToProjective P1 in
    let X1 := projectiveX pP1 in
    let Y1 := projectiveY pP1 in
    let Z1 := projectiveZ pP1 in
    let T1 := extendedT P1 in
    let pP2 := extendedToProjective P2 in
    let X2 := projectiveX pP2 in
    let Y2 := projectiveY pP2 in
    let Z2 := projectiveZ pP2 in
    let T2 := extendedT P2 in
    let  A := (Y1-X1)*(Y2-X2) in
    let  B := (Y1+X1)*(Y2+X2) in
    let  C := T1*k*T2 in
    let  D := Z1*2*Z2 in
    let  E := B-A in
    let  F := D-C in
    let  G := D+C in
    let  H := B+A in
    let X3 := E*F in
    let Y3 := G*H in
    let T3 := E*H in
    let Z3 := F*G in
    mkExtended (mkProjective X3 Y3 Z3) T3.

  Delimit Scope extendedM1_scope with extendedM1.
  Infix "+" := unifiedAdd : extendedM1_scope.

  Lemma unifiedAddCon : forall (P1 P2:point)
    (hv1:extendedValid P1) (hv2:extendedValid P2),
    extendedValid (P1 + P2)%extendedM1.
  Proof.
    intros.
    remember ((P1+P2)%extendedM1) as P3.
    destruct P1 as [[X1 Y1 Z1] T1].
    destruct P2 as [[X2 Y2 Z2] T2].
    destruct P3 as [[X3 Y3 Z3] T3].
    unfold extendedValid, extendedToProjective, projectiveToTwisted in *.
    invcs HeqP3.
    subst.
    (* field. -- fails. but it works in sage:
sage -c 'var("d X1 X2 Y1 Y2 Z1 Z2");
print(bool((((Y1 + X1) * (Y2 + X2) - (Y1 - X1) * (Y2 - X2)) *
((Y1 + X1) * (Y2 + X2) - (Y1 - X1) * (Y2 - X2)) ==
((Y1 + X1) * (Y2 + X2) - (Y1 - X1) * (Y2 - X2)) *
(2 * Z1 * Z2 - 2 * ((0 - d) / a) * (X1 * Y1 / Z1) * (X2 * Y2 / Z2)) *
((2 * Z1 * Z2 + 2 * ((0 - d) / a) * (X1 * Y1 / Z1) * (X2 * Y2 / Z2)) *
((Y1 + X1) * (Y2 + X2) - (Y1 - X1) * (Y2 - X2))) /
((2 * Z1 * Z2 - 2 * ((0 - d) / a) * (X1 * Y1 / Z1) * (X2 * Y2 / Z2)) *
(2 * Z1 * Z2 + 2 * ((0 - d) / a) * (X1 * Y1 / Z1) * (X2 * Y2 / Z2))))))'
      Outputs:
        True
    *)
  Admitted.

  Ltac extended0 := repeat progress (autounfold; simpl); intros;
                    repeat match goal with
                           | [ x : Curve.point |- _ ] => destruct x
                           | [ x : point |- _ ] => destruct x
                           | [ x : projective |- _ ] => destruct x
                           end; simpl in *; subst.

  Ltac extended := extended0; repeat (ring || f_equal)(*; field*).

  Lemma unifiedAddToTwisted : forall (P1 P2 : point) tP1 tP2
    (P1con : extendedValid P1) (P1on : Curve.onCurve tP1) (P1rep : decode P1 = tP1)
    (P2con : extendedValid P2) (P2on : Curve.onCurve tP2) (P2rep : decode P2 = tP2),
    decode (P1 + P2)%extendedM1 = Curve.unifiedAdd' tP1 tP2.
  Proof.
    extended0.
    apply f_equal2.
    (* case 1 verified by hand: follows from field and completeness of edwards addition *)
  Admitted.

  Lemma unifiedAdd_rep: forall P Q rP rQ, Curve.onCurve rP -> Curve.onCurve rQ ->
    P ~= rP -> Q ~= rQ -> (unifiedAdd P Q) ~= (Curve.unifiedAdd' rP rQ).
  Proof.
    split; rep.
    apply unifiedAddToTwisted; auto.
    apply unifiedAddCon; auto.
  Qed.
End Minus1Format.


(*
(** [precomputed] represents a point on an elliptic curve using "precomputed"
* Edwards coordinates, as used for fixed-base scalar multiplication
* (see <http://ed25519.cr.yp.to/ed25519-20110926.pdf> section 4: addition). *)
Record precomputed := mkPrecomputed {precomputedSum : GF;
                                   precomputedDifference : GF;
                                   precomputed2dxy : GF}.
Definition twistedToPrecomputed (d:GF) (P : twisted) : precomputed :=
let x := twistedX P in
let y := twistedY P in
mkPrecomputed (y+x) (y-x) (2*d*x*y).
*)

Module WeirstrassMontgomery (Import M : Modulus).
  Module Import GT := GaloisTheory M.
  Local Open Scope GF_scope.
  Local Notation "2" := (1+1).
  Local Notation "3" := (1+1+1).
  Local Notation "4" := (1+1+1+1).
  Local Notation "27" := (3*3*3).
  (** [weierstrass] represents a point on an elliptic curve using Weierstrass
  * coordinates (<http://cs.ucsb.edu/~koc/ccs130h/2013/EllipticHyperelliptic-CohenFrey.pdf>) definition 13.1*)
  Record weierstrass := mkWeierstrass {weierstrassX : GF; weierstrassY : GF}.
  Definition weierstrassOnCurve (a1 a2 a3 a4 a5 a6:GF) (P : weierstrass) : Prop :=
  let x := weierstrassX P in
  let y := weierstrassY P in
  y^2 + a1*x*y + a3*y = x^3 + a2*x^2 + a4*x + a6.

  (** [montgomery] represents a point on an elliptic curve using Montgomery
  * coordinates (see <https://en.wikipedia.org/wiki/Montgomery_curve>) *)
  Record montgomery := mkMontgomery {montgomeryX : GF; montgomeryY : GF}.
  Definition montgomeryOnCurve (B A:GF) (P : montgomery) : Prop :=
  let x := montgomeryX P in
  let y := montgomeryY P in
  B*y^2 = x^3 + A*x^2 + x.

  (** see <http://cs.ucsb.edu/~koc/ccs130h/2013/EllipticHyperelliptic-CohenFrey.pdf> section 13.2.3.c and <https://en.wikipedia.org/wiki/Montgomery_curve#Equivalence_with_Weierstrass_curves> *)
  Definition montgomeryToWeierstrass (B A:GF) (P : montgomery) : weierstrass :=
  let x := montgomeryX P in
  let y := montgomeryY P in
  mkWeierstrass (x/B + A/(3*B)) (y/B).

  Lemma montgomeryToWeierstrassOnCurve : forall (B A:GF) (P:montgomery),
  let a4 := 1/B^2 - A^2/(3*B^2) in
  let a6 := 0- A^3/(27*B^3) - a4*A/(3*B) in
  let P' := montgomeryToWeierstrass B A P in
  montgomeryOnCurve B A P -> weierstrassOnCurve 0 0 0 a4 0 a6 P'.
  Proof.
  intros.
  unfold montgomeryToWeierstrass, montgomeryOnCurve, weierstrassOnCurve in *.
  remember (weierstrassY P') as y in *.
  remember (weierstrassX P') as x in *.
  remember (montgomeryX P) as u in *.
  remember (montgomeryY P) as v in *.
  clear Hequ Heqv Heqy Heqx P'.
  (* This is not currently important and makes field run out of memory. Maybe
  * because I transcribed it incorrectly... *)
  Abort.


  (* from <http://www.hyperelliptic.org/EFD/g1p/auto-montgom.html> *)
  Definition montgomeryAddDistinct (B A:GF) (P1 P2:montgomery) : montgomery :=
  let x1 := montgomeryX P1 in
  let y1 := montgomeryY P1 in
  let x2 := montgomeryX P2 in
  let y2 := montgomeryY P2 in
  mkMontgomery
  (B*(y2-y1)^2/(x2-x1)^2-A-x1-x2)
  ((2*x1+x2+A)*(y2-y1)/(x2-x1)-B*(y2-y1)^3/(x2-x1)^3-y1).
  Definition montgomeryDouble (B A:GF) (P1:montgomery) : montgomery :=
  let x1 := montgomeryX P1 in
  let y1 := montgomeryY P1 in
  mkMontgomery
  (B*(3*x1^2+2*A*x1+1)^2/(2*B*y1)^2-A-x1-x1)
  ((2*x1+x1+A)*(3*x1^2+2*A*x1+1)/(2*B*y1)-B*(3*x1^2+2*A*x1+1)^3/(2*B*y1)^3-y1).
  Definition montgomeryNegate P := mkMontgomery (montgomeryX P) (0-montgomeryY P).

  (** [montgomeryXFrac] represents a point on an elliptic curve using Montgomery x
  * coordinate stored as fraction as in
  * <http://cr.yp.to/ecdh/curve25519-20060209.pdf> appendix B. *)
  Record montgomeryXFrac := mkMontgomeryXFrac {montgomeryXFracX : GF; montgomeryXFracZ : GF}.
  Definition montgomeryToMontgomeryXFrac P := mkMontgomeryXFrac (montgomeryX P) 1.
  Definition montgomeryXFracToMontgomeryX P : GF := (montgomeryXFracX P) / (montgomeryXFracZ P).

  (* from <http://www.hyperelliptic.org/EFD/g1p/auto-montgom-xz.html#ladder-mladd-1987-m>,
  * also appears in <https://tools.ietf.org/html/draft-josefsson-tls-curve25519-06#appendix-A.1.3> *)
  Definition montgomeryDifferentialDoubleAndAdd (a : GF)
  (X1 : GF) (P2 P3 : montgomeryXFrac) : (montgomeryXFrac * montgomeryXFrac) :=
    let X2 := montgomeryXFracX P2 in
    let Z2 := montgomeryXFracZ P2 in
    let X3 := montgomeryXFracX P3 in
    let Z3 := montgomeryXFracZ P3 in
    let A  := X2 + Z2 in
    let AA := A^2 in
    let B  := X2 - Z2 in
    let BB := B^2 in
    let E  := AA - BB in
    let C  := X3 + Z3 in
    let D  := X3 - Z3 in
    let DA := D * A in
    let CB := C * B in
    let X5 := (DA + CB)^2 in
    let Z5 := X1 * (DA - CB)^2 in
    let X4 := AA * BB in
    let Z4 := E * (BB + (a-2)/4 * E) in
    (mkMontgomeryXFrac X4 Z4, mkMontgomeryXFrac X5 Z5).

  (*
  (* <https://eprint.iacr.org/2008/013.pdf> Theorem 3.2. *)
  (* TODO: exceptional points *)
  Definition twistedToMontfomery (a d:GF) (P : twisted) : montgomery :=
  let x := twistedX P in
  let y := twistedY P in
  mkMontgomery ((1+y)/(1-y)) ((1+y)/((1-y)*x)).
  Definition montgomeryToTwisted (B A:GF) (P : montgomery) : twisted :=
  let X := montgomeryX P in
  let Y := montgomeryY P in
  mkTwisted (X/Y) ((X-1)/(X+1)).
  *)

End WeirstrassMontgomery.
