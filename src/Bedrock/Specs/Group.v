Require Import bedrock2.Semantics.
Require Import Rupicola.Lib.Api. Import bedrock2.WeakestPrecondition.
Require Import Crypto.Algebra.Group.
Require Import Crypto.Algebra.Hierarchy.
Require Import Crypto.Algebra.ScalarMult.
Require Import Crypto.Arithmetic.PrimeFieldTheorems.
Require Import Crypto.Bedrock.Specs.ScalarField.

Class GroupParameters :=
  { (** mathematical parameters **)
    G : Type;
    eq : G -> G -> Prop;
    add : G -> G -> G;
    zero : G;
    opp : G -> G;
    scalarmult : Z -> G -> G;

    (** function names for bedrock2 **)
    scmul : string;
  }.

Class GroupParameters_ok {group_parameters : GroupParameters} :=
  { group_ok : @group G eq add zero opp;
    scalarmult_ok : @is_scalarmult G eq add zero opp scalarmult;
  }.

Class GroupRepresentation {G : Type} {width} {BW:Bitwidth.Bitwidth width} {word : word width} {mem : map.map word byte} :=
  { gelem : Type;
    grepresents : gelem -> G -> Prop;
    GElem : word -> gelem -> mem -> Prop;
  }.

Section FunctionSpecs.
  Context {width: Z} {BW: Bitwidth width} {word: word.word width} {mem: map.map word Byte.byte}.
  Context {locals: map.map String.string word}.
  Context {env: map.map String.string (list String.string * list String.string * Syntax.cmd)}.
  Context {ext_spec: bedrock2.Semantics.ExtSpec}.
  Context {scalar_field_parameters : ScalarFieldParameters}
          {scalar_representaton : ScalarRepresentation}.
  Context {group_parameters : GroupParameters}
          {group_representaton : GroupRepresentation (G:=G)}.

  (* N.B. spec_of_scmul has only one separation-logic condition for now because
     using multiple results in problems with stack allocation. Should be further
     looked into. *)
  Instance spec_of_scmul : spec_of scmul :=
    fnspec! scmul (pout px pk : word)
          / (x out : gelem) (k : scalar) (X : G) R,
    { requires tr mem :=
        grepresents x X
        /\ (GElem pout out * GElem px x * Scalar pk k * R)%sep mem;
      ensures tr' mem' :=
        tr = tr' /\
        exists (xk : gelem),
          grepresents xk (scalarmult (F.to_Z (sceval k)) X)
          /\ (GElem pout xk * GElem px x * Scalar pk k * R)%sep mem' }.
End FunctionSpecs.

Existing Instance spec_of_scmul.
