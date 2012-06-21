(* ::Package:: *)

BeginPackage["Morphology`"]

cartesianProduct::usage=
  "cartesianProduct[xs,ys] returns the list
  {{x,y} | for all x in xs, for all y in}"
cartesianProduct[xs_,ys_]:=Flatten[Outer[List,xs,ys],1]

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
   over the y axis at the origin."
reflect[xs_]:= -# &/@ xs

reflectY::usage=
  "reflectY[xs] returns the set of coordinates xs reflected
   over the x axis"
reflectY[xs_]:={#[[1]],-#[[2]]} & /@ xs

swapXY::usage=
  "swapXY[xs] returns the set of coordinates xs with each pair,
   x and y, swapped"
swapXY[xs_]:={#[[2]],#[[1]]} & /@ xs

translate::usage=
  "translate[xs,zx,zy] returns the set of coordinates xs translated
   such that the origin is at zx,zy."
translate[xs_,zx_,zy_] := {#[[1]]+zx,#[[2]]+zy} & /@ xs

dilate::usage=
  "dilate[A,B,on,xrange,yrange] returns the set of coordinates
   in xrange x yrange such that B, reflected and translated
   by the coordinates, intersects with A.
   
   dilate[A,B,on,startx,endx,starty,endy] returns 
   dilate[A,B,on,{startx...endx},{starty...endy}]"
dilate[A_,B_,on_,startx_,endx_,starty_,endy_]:=
  dilate[A,B,on,Range[startx,endx],Range[starty,endy]];
dilate[A_,B_,on_,xrange_,yrange_]:=
  Select[cartesianProduct[xrange,yrange],
         Intersection[translate[reflect[B],#[[1]],#[[2]]],A] != {}]



imageDataCoords::usage=
  "imageDataCoords[xs,on] returns the coordinates of 'on' pixels in
   xs, translated such that the center of the image is at 0,0."
imageDataCoords[xs_,on_]:=
  With[{height = Length[xs]},
        translate[reflectY[swapXY[arrayCoords[xs,on]]],
                  -Ceiling[height/2],
                  -Ceiling[If[height > 0,Length[xs[[1]]],0]/2]]]        

coordsToImageData::usage=
  "coordsToImageData[xs,on,off,width,height]
   returns a 2 dimensional array,arr, that maps
   each pair of coordinates in xs, x and y, to a cell,
   setting it to 'on', translated such that 0,0 corresponds to 
   arr[[width/2]][[height/2]]."
coordsToImageData[xs_,on_,off_,width_,height_]:=
  coordsToArray[swapXY[reflectY[translate[xs,
                                          Ceiling[height/2],
                                          Ceiling[width/2]]]],
                on,off,height,width]

imageCoords::usage=
  "imageCoords[i,on] returns imageDataCoords[ImageData[i],on]"
imageCoords[i_,on_]:= imageDataCoords[ImageData[i],on]

coordsToImage::usage=
  "coordsToImage[xs,on,off,width,height] returns 
   Image[coordsToImageData[xs,on,off,width,height]]"
coordsToImage[xs_,on_,off_,width_,height_]:=
  Image[coordsToImageData[xs,on,off,width,height]]

EndPackage[]



