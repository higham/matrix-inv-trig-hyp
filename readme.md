matrix-inv-trig-hyp
================

This repository contains MATLAB functions to compute the
matrix inverse cosine,
matrix inverse sine,
matrix hyperbolic inverse cosine, and 
matrix hyperbolic inverse sine.

The algorithm for the matrix cosine is based on Schur decomposition and
Padé approximation.  The algorithms for the other functions call that for
the matrix cosine.  The algorithms are from

M. Aprahamian and N. J. Higham, "[Matrix Inverse Trigonometric and Inverse
Hyperbolic Functions: Theory and
Algorithms](http://eprints.ma.man.ac.uk/2432/)",
MIMS EPrint 2016.4, Manchester Institute for Mathematical Sciences, The
University of Manchester, UK, January 2016.

The main functions are

* `acosm`: principal inverse cosine of a matrix.
* `asinm`: principal inverse sine of a matrix.
* `asinhm`: principal inverse matrix hyperbolic sine of a matrix.
* `acoshm`: principal inverse hyperbolic cosine of a matrix.
* `test`: test script.  Run this to check that the functions are working correctly.

Other M-files:

* `normam`: Used by the other functions to estimate the norm of a matrix
  power.

Requirements
-------------

The codes have been developed and tested
under MATLAB 2015a--2016a.

License
-------

See `license.txt` for licensing information.
