(* ::Package:: *)

BeginPackage["Morphology`"]

cartesianProduct::usage=
  "cartesianProduct[xs,ys] returns the list
  {{x,y} | for all x in xs, for all y in ys}"
cartesianProduct[xs_,ys_]:=Flatten[Outer[List,xs,ys],1]

some::usage=
  "some[f,xs] returns True iff f returns true for at least one element in xs."
some[f_,xs_] := Select[xs,f,1] != {}

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
                 cartesianProduct[Range[height],Range[Length[xs[[1]]]]],
                {}]],
         xs[[#[[1]]]][[Last[#]]]==on &]


reflect::usage=
  "reflect[xs] returns the set of coordinates xs reflected
   at the origin."
reflect[xs_]:= -# & /@ xs

reflectY::usage=
  "reflectY[xs] returns the set of coordinates xs reflected
   over the x axis"
reflectY[xs_]:={#[[1]],-#[[2]]} & /@ xs

swapXY::usage=
  "swapXY[xs] returns the set of coordinates xs with each pair,
   x and y, swapped"
swapXY[xs_]:= {#[[2]],#[[1]]} & /@ xs

translate::usage=
  "translate[xs,zx,zy] returns the set of coordinates xs translated
   such that the origin is at zx,zy.
   translate[xs,z] returns translate[xs,{z[1],z[2]}]."
translate[xs_,z_] := translate[xs,z[[1]],z[[2]]]
translate[xs_,zx_,zy_] := {#[[1]]+zx,#[[2]]+zy} & /@ xs

dilate::usage=
  "dilate[A,B] returns the dilation of A by B."
dilate[A_,B_]:= Union @@ (translate[A, #] &) /@ B

erode::usage=
  "erode[A,B] returns the erosion of A by B."
erode[A_,B_] := Intersection @@ (translate[A,-#] &) /@ B

imageDataCoords::usage=
  "imageDataCoords[xs,on] returns the coordinates of 'on' pixels in
   xs, translated such that the center of the image is at 0,0."
imageDataCoords[xs_,on_]:=
  With[{rows = Length[xs]},
        reflectY[translate[swapXY[arrayCoords[xs,on]],
                          -Ceiling[rows/2],
                          -Ceiling[If[rows > 0,Length[xs[[1]]],0]/2]]]]        

coordsToImageData::usage=
  "coordsToImageData[xs,on,off,width,height]
   returns a 2 dimensional array,arr, that maps
   each pair of coordinates in xs, x and y, to a cell,
   setting it to 'on', translated such that 0,0 corresponds to 
   arr[[width/2]][[height/2]]."
coordsToImageData[xs_,on_,off_,width_,height_]:=
  coordsToArray[swapXY[translate[reflectY[xs],
                                 Ceiling[height/2],
                                 Ceiling[width/2]]],
                on,off,height,width]

imageCoords::usage=
  "imageCoords[i,on] returns imageDataCoords[ImageData[i],on]"
imageCoords[i_,on_]:= imageDataCoords[ImageData[i],on]

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
    coordsToImage[f[imageCoords[a,on]],on,off,dimension[[1]],
                                              dimension[[2]]]]
onImage[f_,a_,b_,on_,off_] :=
  With[{dimension = ImageDimensions[a]},
    coordsToImage[f[imageCoords[a,on],b],on,off,dimension[[1]],
                                                dimension[[2]]]]

EndPackage[]
