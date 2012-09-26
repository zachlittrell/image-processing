(* ::Package:: *)





BeginPackage["StructuringElements`"]
Needs["Morphology`","~/image-processing/src/mathematica/Morphology.m"]
cross = Image[{{0,1,0},{1,1,1},{0,1,0}}]
crossCoords = imageCoords[cross,1]
sphere = Image[{{1.`,0.`,0.`,0.`,1.`},{0.`,0.`,0.`,0.`,0.`},{0.`,0.`,0.`,0.`,0.`},{0.`,0.`,0.`,0.`,0.`},{1.`,0.`,0.`,0.`,1.`}}]
sphereCoords = imageCoords[sphere,0]
convexHullMiss1 = {{-1,1},{-1,0},{-1,-1}}
convexHullMiss2 = {{-1,1},{0,1},{1,1}}
convexHullMiss3 = {{1,1},{1,0},{1,-1}}
convexHullMiss4 = {{-1,-1},{0,-1},{1,-1}}
convexHullHit = {{0,0}}
convexHullBoxPairs = {{convexHullHit, convexHullMiss1},
                      {convexHullHit, convexHullMiss2},
                      {convexHullHit, convexHullMiss3},
                      {convexHullHit, convexHullMiss4}}
EndPackage[]


(* ::Title:: *)
(**)
