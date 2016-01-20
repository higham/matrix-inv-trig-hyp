function X = acoshm(A)
%acoshm    Matrix inverse hyperbolic cosine.
%   X = acoshm(A) is the principal inverse hyperbolic cosine of A.
%   A must not have any eigenvalues -1 or 1, which are the branch points
%   of the inverse hyperbolic cosine.

%   Reference: 
%   Mary Aprahamian and Nicholas J. Higham, Matrix Inverse Trigonometric
%   and Inverse Hyperbolic Functions: Theory and Algorithms, MIMS EPrint
%   2016.4, Manchester Institute for Mathematical Sciences, The University
%   of Manchester, UK, January 2016.

%   Mary Aprahamian and Nicholas J. Higham, 2016.

[Q,T] = schur(A,'complex');
d = diag(T);
if any( imag(d) == 0 & 0 < real(d) & real(d) <= 1 )
    X =  logm(T + sqrtm(T - eye(size(T))) * sqrtm(T + eye(size(T))));
    X = Q*X*Q'; 
else

    S = matsignt(-1i*T);
    C = acosm(T);  % Let acosm issue errors for ei'vals 1 or -1.
    X = S*C;
    X = 1i*(Q*X*Q');
end
end

%%%%%%%%%%%%%%%%%%%%%%%
function S = matsignt(T)
%matsignt    Matrix sign function of a triangular matrix.
%   S = matsign(T) computes the matrix sign function S of the
%   upper triangular matrix T using a recurrence.

%   This function is a minor adaptation of subfunction matsign 
%   of signm from The Matrix Function Toolbox at 
%   http://www.maths.manchester.ac.uk/~higham/mftoolbox    

n = length(T);
S = eye(n);
for i = 1:n
    S(i,i) = signfn(T(i,i));
end    

for p = 1:n-1
   for i = 1:n-p

      j = i+p;
      d = T(j,j) - T(i,i);

      if S(i,i) ~= -S(j,j)  % Solve via S^2 = I if we can.

         % Get S(i,j) from S^2 = I.
         k = i+1:j-1;
         S(i,j) = -S(i,k)*S(k,j) / (S(i,i)+S(j,j));

      else

         % Get S(i,j) from S*T = T*S.
         s = T(i,j)*(S(j,j)-S(i,i));
         if p > 1
            k = i+1:j-1;
            s = s + T(i,k)*S(k,j) - S(i,k)*T(k,j);
         end
         S(i,j) = s/d;

      end

   end
end
end

%%%%%%%%%%%%%%%%%%%%%
function s = signfn(z)
%SIGNFB  Sign function of complex scalar.

if z == 0
   s = 1;
elseif real(z) == 0
   s = sign(imag(z));
else % Standard case: off the imaginary axis.
   s = sign(real(z));
end   
end
