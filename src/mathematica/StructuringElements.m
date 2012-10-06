(* ::Package:: *)

BeginPackage["StructuringElements`"]
Needs["Morphology`","~/image-processing/src/mathematica/Morphology.m"]
cross = Image[{{0,1,0},{1,1,1},{0,1,0}}]
crossCoords = imageCoords[cross,1]
sphere = Image[{{1,0,0,0,1},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}}]
sphereCoords = imageCoords[sphere,0]
convexSetHit1 = {{-1,1},{-1,0},{-1,-1}}
convexSetHit2 = {{-1,1},{0,1},{1,1}}
convexSetHit3 = {{1,1},{1,0},{1,-1}}
convexSetHit4 = {{-1,-1},{0,-1},{1,-1}}
convexSetMiss = {{0,0}}
convexSetBoxPairs = {{convexSetHit1, convexSetMiss},
                     {convexSetHit2, convexSetMiss},
                     {convexSetHit3, convexSetMiss},
                     {convexSetHit4, convexSetMiss}}
EndPackage[]


(* ::Title:: *)
(**)
