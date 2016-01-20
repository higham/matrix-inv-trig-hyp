function X = asinhm(A)
%asinhm    Matrix inverse hyperbolic sine.
%   X = asinhm(A) is the principal inverse hyperbolic sine of A.
%   A must not have any eigenvalues -i or i, which are the branch points
%   of the inverse hyperbolic sine.

%   Reference: 
%   Mary Aprahamian and Nicholas J. Higham, Matrix Inverse Trigonometric
%   and Inverse Hyperbolic Functions: Theory and Algorithms, MIMS EPrint
%   2016.4, Manchester Institute for Mathematical Sciences, The University
%   of Manchester, UK, January 2016.

%   Mary Aprahamian and Nicholas J. Higham, 2016.

X = 1i * asinm(-1i*A);
