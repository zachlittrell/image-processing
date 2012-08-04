(* ::Package:: *)

BeginPackage["Sets`"]

equalSetsQ[xs_,ys_]:=Length[xs]==Length[ys]&&Complement[xs,ys]=={}

some::usage=
  "some[f,xs] returns True iff f returns true for at least one element in xs."
some[f_,xs_] := Select[xs,f,1] != {}

EndPackage[]
