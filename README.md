# layout
Simple tool to calculate application layouts

Layouts are lists of items that default to being layed out vertically*. 
  e.g '(a b c) All three items occupy equal amounts of vertical space, and full horizontal.
  
If an item is a proper list direction of layout is switched, i.e., each level of nesting flips between horizontal and vertical layout. 
  e.g. '(a b (c d)) A+B both occupy 33% vertically, C+D occupy the last vertical third, with 50% of width.
  
If an item is a cons the cdr is a parameter, INTEGER=PIXEL REAL=PERCENTAGE 
  e.g. (a (b . 60)) B takes up 60 pixels vertically, remainder to A
       (a (b . 0.6)) B takes up 60 percent of vertical height remainder to A

The main function is CALC-LAYOUT (layout size &optional (horizontal nil)(x 0)(y 0))
which returns a list of (item (width . height)(x . y))
  size is a cons, e.g. '(1920 . 1080)
  If horizontal is true, we start laying out horizontally first, caveat width and height need to be switched.
  
CALC-SIZES is provided if you just want dimensions, though i really don't see a need for it, so it might disappear.

GENERATE-LAYOUT (number &key (type (or :phi :grid)))
Generates a layout that will accomadate NUMBER of views based on phi(default) or grid layout. Numbers that are not squares have
the remainder dumped into a column on the right.

\* default direction of layout may change. Widescreens make horizontal layouts logical for desktops, applications seem to be more vertical layouts.

EXAMPLES

    (calc-layout '(a b c) '(1920 . 1080))
    
    ((A (1920 . 360) (0 . 0)) (B (1920 . 360) (0 . 360)) (C (1920 . 360) (0 . 720)))
!['(A B C)](https://i.imgur.com/RJhE954.png)

    (calc-layout '(a b c) '(1080 . 1920) t)
    
    ((A (640 . 1080) (0 . 0)) (B (640 . 1080) (640 . 0))
    (C (640 . 1080) (1280 . 0)))
!['(A B C)](https://i.imgur.com/Fkcy2Vu.png)

    (calc-layout '((a b c))'(1920 . 1080))
    
    ((A (640 . 1080) (0 . 0)) (B (640 . 1080) (640 . 0))
    (C (640 . 1080) (1280 . 0)))
!['((A B C))](https://i.imgur.com/oilyRXr.png)

    (calc-layout '((a . 0.80) (b c d))'(1920 . 1080))
    
    ((A (1920 . 864) (0 . 0)) (B (640 . 216) (0 . 864)) (C (640 . 216) (640 . 864))
    (D (640 . 216) (1280 . 864)))
!['((A . .80)(B C D))](https://i.imgur.com/zePdbOk.png)

    (calc-layout '((a (b (c d) (e . 100))))'(1920 . 1080))
    
    ((A (960 . 1080) (0 . 0)) (B (960 . 490) (960 . 0)) (C (480 . 490) (960 . 490))
    (D (480 . 490) (1440 . 490)) (E (960 . 100) (960 . 980)))
!['((A (B (C D)(E . 100))))](https://i.imgur.com/3B4CUSX.png)

(generate-layout 5)

![generate-layout 5](https://i.imgur.com/nXe9lpl.png)

(generate-layout 12 :type :grid)

![generate-layout 12 :type :grid](https://i.imgur.com/ggXhBFK.png)

(generate-layout 15 :type :grid)

![generate-layout 15 :type :grid](https://i.imgur.com/mQRCFQw.png)
