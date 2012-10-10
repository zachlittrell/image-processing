(* ::Package:: *)

BeginPackage["StructuringElements`"]
Needs["Morphology`","~/image-processing/src/mathematica/Morphology.m"]

(* Structuring Element Methods *)
dualStructuringElements::usage=
  "dualStructuringElements[B1,B2] returns the structuring elements
   in coordinate-form in a single array-form structure, with B1 corresponding
   to +1, and B2 corresponding to -1"
dualStructuringElements[B1_,B2_,width_,height_]:= 
  coordsToImageData[B1,1,0,width,height]+
  coordsToImageData[B2,-1,0,width,height]

(* Common Structuring Elements *)
cross = Image[{{0,1,0},{1,1,1},{0,1,0}}]
crossCoords = imageCoords[cross,1]
sphere = Image[{{1,0,0,0,1},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}}]
sphereCoords = imageCoords[sphere,0]
convexSetHit1 = {{-1,1},{-1,0},{-1,-1}}
convexSetHit2 = {{-1,1},{0,1},{1,1}}
convexSetHit3 = {{1,1},{1,0},{1,-1}}
convexSetHit4 = {{-1,-1},{0,-1},{1,-1}}
convexSetMiss = {{0,0}}
convexSetPairs = {{convexSetHit1, convexSetMiss},
                  {convexSetHit2, convexSetMiss},
                  {convexSetHit3, convexSetMiss},
                  {convexSetHit4, convexSetMiss}}

thinningHit1 = {{0,0},{-1,-1},{0,-1},{1,-1}}
thinningMiss1 = {{-1,1},{0,1},{1,1}}

thinningHit2 = {{-1,0},{0,0},{-1,-1},{0,-1}}
thinningMiss2 = {{0,1},{1,1},{1,0}}

thinningHit3 = {{-1,1},{-1,0},{-1,-1},{0,0}}
thinningMiss3 = {{1,1},{1,0},{1,-1}}

thinningHit4 = {{-1,1},{0,1},{0,0},{-1,0}}
thinningMiss4 = {{0,-1},{1,-1},{1,0}}

thinningHit5 = {{-1,1},{0,1},{1,1},{0,0}}
thinningMiss5 = {{-1,-1},{0,-1},{1,-1}}

thinningHit6 = {{0,1},{1,1},{0,0},{1,0}}
thinningMiss6 = {{-1,0},{-1,-1},{0,-1}}

thinningHit7 = {{1,1},{1,0},{1,-1},{0,0}}
thinningMiss7 = {{-1,1},{-1,0},{-1,-1}}

thinningHit8 = {{0,0},{1,0},{0,-1},{1,-1}}
thinningMiss8 = {{-1,0},{-1,1},{0,1}}

thinningPairs = {{thinningHit1, thinningMiss1},
                 {thinningHit2, thinningMiss2},
                 {thinningHit3, thinningMiss3},
                 {thinningHit4, thinningMiss4},
                 {thinningHit5, thinningMiss5},
                 {thinningHit6, thinningMiss6},
                 {thinningHit7, thinningMiss7},
                 {thinningHit8, thinningMiss8}}

pruningHit1={{-1,0},{0,0}}
pruningMiss1={{0,1},{1,1},{1,0},{0,-1},{1,-1}}

pruningHit2 = {{0,0},{0,-1}}
pruningMiss2= {{-1,1},{0,1},{1,1},{-1,0},{1,0}}

pruningHit3 = {{0,0},{1,0}}
prunningMiss3={{-1,1},{0,1},{-1,0},{-1,-1},{0,-1}}

pruningHit4 ={{0,1},{0,0}}
pruningMiss4 = {{-1,0},{1,0},{-1,-1},{0,-1},{1,-1}}

pruningHit5 = {{-1,1},{0,0}}
pruningMiss5 ={{0,1},{1,1},{-1,0},{1,0},{-1,-1},{0,-1},{1,-1}}

pruningHit6 = {{0,0},{-1,-1}}
pruningMiss6 = {{-1,1},{0,1},{1,1},{-1,0},{1,0},{0,-1},{1,-1}}

pruningHit7 = {{0,0},{1,-1}}
pruningMiss7 = {{-1,1},{0,1},{1,1},{-1,0},{1,0},{-1,-1},{0,-1}}

pruningHit8 = {{1,1},{0,0}}
pruningMiss8={{-1,1},{0,1},{-1,0},{1,0},{-1,-1},{0,-1},{1,-1}}

pruningPairs = {{pruningHit1, pruningMiss1},
                {pruningHit2, pruningMiss2},
                {pruningHit3, pruningMiss3},
                {pruningHit4, pruningMiss4},
                {pruningHit5, pruningMiss5},
                {pruningHit6, pruningMiss6},
                {pruningHit7, pruningMiss7},
                {pruningHit8, pruningMiss8}}
EndPackage[]
