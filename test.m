% TEST   Brief test of new matrix inverse trigonometric sine functions.

n = 5;
rng(n);
coshmdef = @(x) (expm(x) + expm(-x))/2;
cosmdef = @(x) coshmdef(1i*x);
sinhmdef = @(x) (expm(x) - expm(-x))/2;
sinmdef = @(x) 1i*sinhmdef(-1i*x);

v = ver;
if any(strcmp('Symbolic Math Toolbox', {v.Name})) && ...
   license('test', 'symbolic_toolbox')
   % If the Symbolic Math Toolbox is available we'll use it to compute
   % high precision results.
   coshmdef = @(x) double( (expm(vpa(x)) + expm(-vpa(x)))/2 );
   sinhmdef = @(x) double( (expm(vpa(x)) - expm(-vpa(x)))/2 );
end

disp('Norms of cosm(acosm(A))-A, etc., for inverse functions computed') 
disp('from the new algorithms and functions computed from their')
disp('definitions with EXPM (complex arithmetic).') 
fprintf('Random A of size %g.\n', n) 
disp('Normwise relative differences: should be of order 1e-14.')
disp(' acosm      asinm      acoshm     asinhm')
for k = 1:4

    B = randn(n);

    A = cosmdef(B);
    rescos = norm(cosmdef(acosm(A)) - A,1);

    A = coshmdef(B);
    rescosh = norm(coshmdef(acoshm(A)) - A,1);

    A = sinmdef(B);
    ressin = norm(sinmdef(asinm(A)) - A,1);

    A = sinhmdef(B);
    ressinh = norm(sinhmdef(asinhm(A)) - A,1);
    
    fprintf('%9.2e  %9.2e  %9.2e  %9.2e\n', rescos, ressin, rescosh, ressinh)
end
