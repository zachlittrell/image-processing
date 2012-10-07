(* ::Package:: *)

BeginPackage["Morphology`"]
Needs["Sets`","~/image-processing/src/mathematica/Sets.m"]
(* Functions for converting between Images and arrays of coordinates*)
coordsToArray::usage =
  "coordsToArray[xs,on,off,rows,columns] takes an array of
   pairs of indices, and returns a rows x columns array, arr,
   where for each pair of indices, x and y, arr[x][y] = on.
   All other indices are set to off."
coordsToArray[xs_, on_, off_, rows_, columns_] := 
 Module[{arr = ConstantArray[off, {rows, columns}]},
         Do[With[{x = First[xy],
                  y = Last[xy]},
                 If[x > 0 && x <= rows && y > 0 && y <= columns,
                   arr[[x]][[y]] = on]], 
            {xy, xs}];
         arr]

arrayCoords::usage=
  "arrayCoords[xs,on] takes a 2-dimensional array, and returns
   an array of pairs of indices, for all x and y such that
   array[x][y] = on."
arrayCoords[xs_,on_]:=
  Select[With[{height = Length[xs]},
              If[height > 0,
                 Tuples[{Range[height],Range[Length[xs[[1]]]]}],
                {}]],
         xs[[First[#]]][[Last[#]]]==on &]

imageDataCoords::usage=
  "imageDataCoords[xs,on] returns the coordinates of 'on' pixels in
   xs, translated such that the center of the image is at 0,0."
imageDataCoords[xs_,on_]:=
  With[{rows = Length[xs]},
        reflectY[translate[swapXY[arrayCoords[xs,on]],
                          -Ceiling[If[rows > 0,Length[First[xs]],0]/2],
                          -Ceiling[rows/2]]]]        

coordsToImageData::usage=
  "coordsToImageData[xs,on,off,width,height]
   returns a 2 dimensional array,arr, that maps
   each pair of coordinates in xs, x and y, to a cell,
   setting it to 'on', translated such that 0,0 corresponds to 
   arr[[width/2]][[height/2]]."
coordsToImageData[xs_,on_,off_,width_,height_]:=
  coordsToArray[swapXY[translate[reflectY[xs],
                                 Ceiling[width/2],
                                 Ceiling[height/2]]],
                on,off,height,width]

imageCoords::usage=
  "imageCoords[i,on] returns imageDataCoords[ImageData[i],on]"
imageCoords[i_,on_]:= imageDataCoords[ImageData[i],on]

imageCoord::usage=
  "imageCoord[x,y,width,height] returns the pair of indices as a coordinate
   on the image, as per imageDataCoords."
imageCoord[x_,y_,width_,height_] := {y-Ceiling[width/2],-x+Ceiling[height/2]}

coordsToImage::usage=
  "coordsToImage[xs,on,off,width,height] returns 
   Image[coordsToImageData[xs,on,off,width,height]]"
coordsToImage[xs_,on_,off_,width_,height_]:=
  Image[coordsToImageData[xs,on,off,width,height]]

onImage::usage=
  "onImage[f,a,on,off] applies f to image a, passing it
   through imageCoords using 'on,' and returns the resulting
   set as an image, with coordinates represented by 'on' and all
   other pixels represented by 'off.'

   onImage[f,a,b,on,off] applies f to image a, passing it
   through imageCoords using 'on', and set of coordinates b,
   and returns the resulting set as an image, with coordinates
   represented by 'on', and all other pixels represented by 'off.'"
onImage[f_,a_,on_,off_] :=
  With[{dimension = ImageDimensions[a]},
    coordsToImage[f[imageCoords[a,on]],on,off,First[dimension],
                                              Last[dimension]]]
onImage[f_,a_,b_,on_,off_] :=
  With[{dimension = ImageDimensions[a]},
    coordsToImage[f[imageCoords[a,on],b],on,off,First[dimension],
                                                Last[dimension]]]

(* Coordinate Set Functions   *)

reflect::usage=
  "reflect[xs] returns the set of coordinates xs reflected
   at the origin."
reflect[xs_]:= Minus /@ xs

reflectY::usage=
  "reflectY[xs] returns the set of coordinates xs reflected
   over the x axis"
reflectY[xs_]:={First[#],-Last[#]} & /@ xs

swapXY::usage=
  "swapXY[xs] returns the set of coordinates xs with each pair,
   x and y, swapped"
swapXY[xs_]:= Reverse /@ xs

translate::usage=
  "translate[xs,zx,zy] returns the set of coordinates xs translated
   such that the origin is at zx,zy.
   translate[xs,z] returns translate[xs,{z[1],z[2]}]."
translate[xs_,z_] := translate[xs,z[[1]],z[[2]]]
translate[xs_,zx_,zy_] := {First[#]+zx,Last[#]+zy} & /@ xs

dilate::usage=
  "dilate[A,B] returns the dilation of A by B."
dilate[A_,B_]:= Fold[Union[#1,translate[A,#2]]&,{},B]

erode::usage=
  "erode[A,B] returns the erosion of A by B."
erode[A_,B_] := If[Length[B] == 0,
                    {},
                    Fold[Intersection[#1,translate[A,-#2]]&,
                         translate[A,-First[B]],Rest[B]]]

open::usage=
  "open[A,B] returns the opening of A by B"
open[A_,B_]:=dilate[erode[A,B],B]

close::usage=
  "close[A,B] returns the closing of A by B"
close[A_,B_]:=erode[dilate[A,B],B]

hitOrMissTransform::usage=
  "hitOrMissTransform[A,B1,B2] returns the Hit-or-Miss Transformation
   of A by B1 and B2.

   hitOrMissTransform[A,Bs] returns the Hit-or-Miss Transformation
   of A by Bs[1] and Bs[2]."
hitOrMissTransform[A_,B1_,B2_]:=Complement[erode[A,B1],dilate[A,reflect[B2]]]
hitOrMissTransform[A_,Bs_]:=hitOrMissTransform[A,First[Bs],Last[Bs]]

extractBoundary::usage=
  "extractBoundary[A,B] returns the boundary of A, using
   B as the structuring element to create the boundary."
extractBoundary[A_,B_]:=Complement[A,erode[A,B]]

extractDilatedBoundary::usage=
  "extractDilatedBoundary[A,B] returns the boundary of A, using
   B as the structuring element to create the boudnary.
   extractDilatedBoundary differs from extractBoundary in that
   it uses dilation instead of erosion to find the boundary."
extractDilatedBoundary[A_,B_]:=Complement[dilate[A,B],A]

fillRegion::usage=
  "fillRegion[A,B,p] returns the region in A that contains p
   filled in, using B to progressively fill the region in."
fillRegion[A_,B_,p_] := convergeSet[Complement[dilate[#,B],A]&,{p}]

addFilledRegion::usage=
  "addFilledRegion[A,B,p] returns A with the region in A that contains
   p filled in, using B to progressively fill the region in."
addFilledRegion[A_,B_,p_] := Union[A,fillRegion[A,B,p]]

extractConnectedComponent::usage=
  "extractConnectedComponent[A,B,p] returns all the points conntected to p
   in A, using B to progressively find the connected component."
extractConnectedComponent[A_,B_,p_]:= convergeSet[dilate[#,B]\[Intersection]A&,{p}]

convexSetStep::usage=
  "convexSetStep[A,bs] returns the limit of applying hitOrMissTransform
   on A with the pair of structuring elements bs, unioned with the previous
   iteration."
convexSetStep[A_,bs_] := convergeSet[Union[hitOrMissTransform[#,bs],#]&,A]                           
                                          
convexSet::usage=
  "convexHull[A,Bs] returns a convex set of A using the pairs of sets in Bs as the structuring
   elements."
convexSet[A_,Bs_]:= Union @@ ((convexSetStep[A,#] &) /@ Bs)

thinStep::usage=
  "thinStep[A,bs] returns A thinned by the pair of structuring elements in bs"
thinStep[A_,bs_]:= Complement[A,hitOrMissTransform[A,bs]]

thin::usage=
  "thin[A,Bs] returns A thinned by the pairs of sets in Bs as the structuring elements."
thin[A_,Bs_]:= convergeSet[Fold[thinStep,#,Bs]&,A]

thickenStep::usage=
  "thickenStep[A,Bs] returns A thickened by the pair of structuring elements in bs"
thickenStep[A_,bs_]:= Union[A, hitOrMissTransform[A,bs]]

thicken::usage=
  "thicken[A,Bs] returns A thickened by the pairs of sets in Bs as the structuring elements."
thicken[A_,Bs_] := convergeSet[Fold[thickenStep,#,Bs]&,A]

skeleton::usage=
  "skeleton[A,B] returns the skeleton of A, using B as a structuring element."
skeleton[A_,B_]:= Union@@(Complement[#,open[#,B]]& /@
                         Most[NestWhileList[erode[#,B]&,A,#!={}&]])

EndPackage[]
