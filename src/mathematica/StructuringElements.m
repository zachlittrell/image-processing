(* ::Package:: *)

BeginPackage["StructuringElements`"]
cross = Image[{{0,1,0},{1,1,1},{0,1,0}}]
sphere = Image[{{1.`,0.`,0.`,0.`,1.`},{0.`,0.`,0.`,0.`,0.`},{0.`,0.`,0.`,0.`,0.`},{0.`,0.`,0.`,0.`,0.`},{1.`,0.`,0.`,0.`,1.`}}]
convexHullHit1 = {{-1,1},{-1,0},{-1,-1}}
convexHullMiss1 = {{0,1},{0,-1},{1,1},{1,0},{1,-1}}
convexHullHit2 = {{-1,1},{0,1},{1,1}}
convexHullMiss2 = {{-1,0},{1,0},{-1,-1},{0,-1},{1,-1}}
convexHullHit3 = {{1,1},{1,0},{1,-1}}
convexHullMiss3 = {{-1,1},{0,1},{-1,0},{-1,-1},{0,-1}}
convexHullHit4 = {{-1,-1},{0,-1},{1,-1}}
convexHullMiss4 = {{-1,1},{0,1},{1,1},{-1,0},{1,0}}
convexHullBoxPairs = {{convexHullHit1, convexHullMiss1},
                      {convexHullHit2, convexHullMiss2},
                      {convexHullHit3, convexHullMiss3},
                      {convexHullHit4, convexHullMiss4}}
EndPackage[]


(* ::Title:: *)
(**)
