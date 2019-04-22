# layout
Simple tool to calculate application layouts

Layouts are lists of items that default to being layed out vertically. 
  e.g '(a b c) All three items occupy equal amounts of vertical space, and full horizontal.
  
If an item is a list, that list is layed out horizontally. 
  e.g. '(a b (c d)) A+B both occupy 33% vertically, C+D occupy the last vertical third, with 50% of width.
  
If an item is a cons the cdr is a parameter, INTEGER=PIXEL REAL=PERCENTAGE 
  e.g. (a (b . 60)) B takes up 60 pixels vertically, remainder to A
       (a (b . .6)) B takes up 60 percent of vertical height remainder to A

The main function is CALC-LAYOUTS (layout size &optional (horizontal nil)(x 0)(y 0))
which returns a list of (item (width . height)(x . y))
  size is a cons, e.g. '(1920 . 1080)
  If horizontal is true, we start laying out horizontally first.
  
calc-sizes is provided if you just want dimensions, though i really don't see a need for it, so it might disappear.
