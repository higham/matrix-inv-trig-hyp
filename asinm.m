function X = asinm(A)
%asinm    Matrix inverse sine.
%   X = asinm(A) is the principal inverse sine of A.
%   A must not have any eigenvalues -1 or 1, which are the branch points
%   of the inverse sine.

%   Reference: 
%   Mary Aprahamian and Nicholas J. Higham, Matrix Inverse Trigonometric
%   and Inverse Hyperbolic Functions: Theory and Algorithms, MIMS EPrint
%   2016.4, Manchester Institute for Mathematical Sciences, The University
%   of Manchester, UK, January 2016.

%   Mary Aprahamian and Nicholas J. Higham, 2016.

X = (pi/2)*eye(size(A)) - acosm(A);
