(* ::Package:: *)

BeginPackage["Sets`"]

equalSetsQ::usage=
  "equalSetsQ[xs,ys] returns true if xs is a subset of ys
   and ys is a subset of xs."
equalSetsQ[xs_,ys_]:=Length[xs]==Length[ys]&&Complement[xs,ys]=={}

some::usage=
  "some[f,xs] returns True iff f returns true for at least one element in xs."
some[f_,xs_] := Select[xs,f,1] != {}

convergeSet::usage=
  "convergeSet[f,xs] repeatedly applies f to xs and returns the result when 
   the result set is the same as the input set."
convergeSet[f_,xs_]:= Last[NestWhile[With[{last = Last[#]},
                                          {last,f[last]}]&,
                                     {{},xs},
                                   !equalSetsQ[First[#],Last[#]]&]]

EndPackage[]
