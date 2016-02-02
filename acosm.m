function [X,s,k] = acosm(A)
%ACOSM    Matrix inverse cosine.
%   X = ACOSM(A) is the principal inverse cosine of A.
%   It is computed using a Schur-Pade algorithm.
%   A must not have any eigenvalues -1 or 1, which are the branch points
%   of the inverse cosine.
%   [X,s,k] = ACOSM(A) also returns the number of matrix square roots
%   computed, s, and the degree k of the Pade approximant.

%   Reference: 
%   Mary Aprahamian and Nicholas J. Higham, Matrix Inverse Trigonometric
%   and Inverse Hyperbolic Functions: Theory and Algorithms, MIMS EPrint
%   2016.4, Manchester Institute for Mathematical Sciences, The University
%   of Manchester, UK, January 2016.

%   Mary Aprahamian and Nicholas J. Higham, 2016.

% Beta values for the backward error analysis.
beta = [
       0.000034417071046415217986245346897329 % k = 1 
       0.0048073208159246079833592811213284   % k = 2
       0.039685094175296891265086732537040    % k = 3
       0.12626296307484495705748967600730     % k = 4
       0.25856709354018920888034068632229     % k = 5 
       0.41651907456618813178965004708519     % k = 6
       0.58094728632346892770457098427310     % k = 7
       0.73899705203727405842323086839582     % k = 8
       0.88388572591099798454310939259983     % k = 9
       1.0130257593927427175036884824325      % k = 10
       1.1262696124522980383857102343082      % k = 11
       1.2246991572795774103025945840993      % k = 12
];

[W,T] = schur(A,'complex');
d = diag(T);

if any( imag(d) == 0 & real(d) == -1 | real(d) == 1)
   msg = ['Input must not have an eigenvalues 1 or -1. ' ...
          'Result may be unreliable.'];
   warning(msg)
end

n = length(A);
I = eye(n);
s = 0;
k = 0;

% Compute lower bound on the number of square roots required.
d = diag(T);
while norm(1-d,inf) > beta(8) 
   s = s + 1;
   d = sqrt((1+d)/2);
end

for i = 1:s
   T = sqrtm((I+T)/2);
end

% Determine degree of approximant.
while k == 0
   Z = I - T;   
   d2 = (normAm(Z,2))^(1/2);
   d3 = (normAm(Z,3))^(1/3);
   a2 = max(d2,d3);
   if a2 <= beta(1), k = 1; break; end
   if a2 <= beta(2), k = 2; break; end
   d4 = (normAm(Z,4))^(1/4);
   a3 = max(d3, d4);
   if a3 <= beta(3), k = 3; break; end   
   if a3 <= beta(4), k = 4; break; end       
   if a3 <= beta(5), k = 5; break; end      
   d5 = (normAm(Z,5))^(1/5);
   a4 = max(d4, d5);
   a4 = min(a3, a4);
   if a4 <= beta(6), k = 6; break; end 
   if a4 <= beta(7), k = 7; break; end    
   if a4 <= beta(8), k = 8; break; end   

   T = sqrtm((I+T)/2); 
   s = s + 1;
  
end

% Pade coefficients obtained with Mathematica.
% For better efficiency the Pade approximants should be wvaluated 
% using the Paterson-Stockmeyer algorithm.
   if k == 1
      p = [1, -(17/120)];
      q = [1, -(9/40)];
      P = p(1)*I + p(2)*Z;
      Q = q(1)*I + q(2)*Z;
  elseif k == 2
      Z2 = Z^2;
      p = [1, -(1709/4392), 69049/3689280];
      q = [1, -(2075/4392), 1075/27328];
      P = p(1)*I + p(2)*Z + p(3)*Z2;
      Q = q(1)*I + q(2)*Z + q(3)*Z2;
  elseif k == 3
      Z2 = Z^2; Z3 = Z2*Z;
      p = [1, -(186989305/293002008), 2144939481/21486813920, ...
           -(17487984593/7219569477120)];
      q = [1, -(70468713/97667336), 606797625/4297362784, ...
          -(1287365485/206273413632)];
      P = p(1)*I + p(2)*Z + p(3)*Z2 + p(4)*Z3;
      Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3;
  elseif k == 4
       Z2 = Z^2; Z3 = Z2*Z; Z4 = Z3*Z;
      p = [1, -(332823264741023/374923934564952), ...
            1216564693834647/4998985794199360, ...
            -(38612161091258861/1819630829088567040), ...
            4474275508260072601/14411476166381450956800];
      q = [1, -(121355641984923/124974644854984), ...
           1527352516809819/4998985794199360, ...
           -(1770455820964005/51989452259673344), ...
           8596257701967495/9150143597702508544];
      P = p(1)*I + p(2)*Z + p(3)*Z2 +p(4)*Z3 + p(5)*Z4;
      Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3 + q(5)*Z4;
  elseif k == 5
         Z2 = Z^2; Z3 = Z2*Z; Z4 = Z3*Z; Z5 = Z4*Z;

      p = [1, -(58408840506068100794657/51351916471581509266616), ...
           5637079585097388589397509/12544539595200625835130480, ...
           -(76420896885568103392577325/1061546817300532959559485952), ...
           2164169259550891749786095645/535019595919468611617980919808, ...
           -(72656495057270062160905547273/1836187253195616275072910516781056)];
      q = [1, -(188064500636099679700625/154055749414744527799848), ...
          1038803334533919394904475/1951372825920097352131408, ...
          -(15019884514284095172978405/151649545328647565651355136), ...
          8772089953313841301500045/1213196362629180525210841088, ...
          -(17260124839300021332999411/126172421713434774621927473152)];
      P = p(1)*I + p(2)*Z + p(3)*Z2 + p(4)*Z3 + p(5)*Z4 + p(6)*Z5;
      Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3 + q(5)*Z4 + q(6)*Z5;
  
  elseif k == 6
         Z2 = Z^2; Z3 = Z2*Z; Z4 = Z3*Z; Z5 = Z4*Z; Z6 = Z5*Z;
      p = [1, -(48612811065193217720717677178392447/...
           35043004675835228059435480541076600), ...
           1542880498363289248597622552896377147/...
           2149304286784560654312042806519364800, ...
           -(25629388878535757822653318119825725571/...
           150451300074919245801842996456355536000), ...
           59997700449506246047746748284324063301/...
           3293078056039832452110739506436709971968, ...
           -(3929590045745452902082508393999567898951/...
           5473827524261765942619629224032575686737920), ...
           17667852791636166403806066845986733616137/...
           3516129209702263770200373595672689794069299200];
      q = [1, -(17177687151615384464112433518938499/...
           11681001558611742686478493513692200), ...
           70638889839100585257826495902581175/...
           85972171471382426172481712260774592, ...
           -(260976433493184241308750702390067677/...
           1203610400599353966414743971650844288), ...
           7106212846910135271370912693952576463/...
           261355401273002575564344405272754759680, ...
           -(100234105411492207380201907281393735693/...
           71088669146256700553501678234189294632960), ...
           55355990129067361992384874772991295329/...
           2843546765850268022140067129367571785318400];
      P = p(1)*I + p(2)*Z + p(3)*Z2 +p(4)*Z3 + p(5)*Z4 + p(6)*Z5 + p(7)*Z6;
      Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3 + q(5)*Z4 + q(6)*Z5 + q(7)*Z6;

   elseif k == 7
          Z2 = Z^2; Z3 = Z2*Z; Z4 = Z3*Z; Z5 = Z4*Z;
          Z6 = Z5*Z; Z7 = Z6*Z;
      p = [1, -(1082952669856670305232490338045418848070498948953/...
           661507427938744864128416329062731330540847695064), ...
           13876145906756107384307929550029253006204181876899/...
           13230148558774897282568326581254626610816953901280, ...
           -(98366660154192250602861500267730278087677117389883/...
           296355327716557699129530515420103636082299767388672), ...
           1884313028291819311160793416578950069561939837008293/...
           35054601621329967839893038109692258668020601056831488, ...
           -(2367297798698201018428326744261846097250903579874313/...
           571260174569821698131590250676466437552928313518735360), ...
           1845679084897198071802023263679950337997494619781679271/...
           15238936416824563619358301527045418688161915691425784463360, ...
           -(79144743009521206858753467871114218624584738476217627873/...
           124349721161288439133963740460690616495401232042034401221017600)];

      q = [1, -(379359429617188570192175010711326597427412085625/...
           220502475979581621376138776354243776846949231688), ...
           3104975553873004182244129696037472348877684883875/...
           2646029711754979456513665316250925322163390780256, ...
           -(1765128220697054184659383369213961843572170113093/...
           4379635384973759100436411557932566050477336463872), ...
           94828127676038566674270241884531524885809746547767/...
           1298318578567776586662705115173787358074837076178944, ...
           -(345574329884682063091643739674218034320877483019561/...
           51932743142711063466508204606951494322993483047157760), ...
           204174928419895468697492194475986012175134296634435/...
           789377695769208164690924710025662713709500942316797952, ...
           -(1169745299169007506801757447043625066673474575104985/...
           429421466498449241591863042253960516257968512620338085888)];

      P = p(1)*I + p(2)*Z + p(3)*Z2 + p(4)*Z3 + p(5)*Z4 + p(6)*Z5 + ...
          p(7)*Z6 + p(8)*Z7;
      Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3 + q(5)*Z4 + q(6)*Z5 + ...
          q(7)*Z6 + q(8)*Z7;  

  elseif k == 8
         Z2 = Z^2; Z3 = Z2*Z; Z4 = Z3*Z; Z5 = Z4*Z;
         Z6 = Z5*Z; Z7 = Z6*Z; Z8 = Z7*Z;
p = [1, -(492402936197048218834369762077203447579679762850266586469733205/...
260945122506169136974528270987172295794856685445900872069410696), ...
1400062217945993393770522099217949663478187732933899333620479607391/...
970715855722949189545245168072280940356866869858751244098207789120, ...
-(5068715786375711839747734461903125370074008671271720961087895131/...
8856319309300285860953686772897968826976954172709362930840605440), ...
86313790917340403535005988293457578304286246863452045478331693919905/...
687902203502866683849372284923367671479077147629357972544940850704384,...
 -967236929639941329716578389026462848668492186060699105502722202662857/...
 64859350615984573048655101149917523310884416776482323125665851637841920,...
 33060546125975094049289004475406198677702512470319793165952429060608477/...
 37923982964617468579026956032369552741244239427173397468500441962108813312, ...
-223857342435662231572915086959928856144304467642733377136393913560608733/...
11377194889385240573708086809710865822373271828152019240550132588632643993600, ...
85163807747673835880940990161512099688907893195611933557171626610770844841/...
1058352177390172619128621067386543582260451238542013437832935533924963074860646400];

q = [1, -(514148363072562313582247117992801138895917819970758325808850763/...
260945122506169136974528270987172295794856685445900872069410696), ...
34249939737859609192823230197652505531205133406999618417652932175/...
21571463460509981989894337068272909785708152663527805424404617536, ...
-(58094206413454968932928737048906533695875252590096541063549103055/...
86285853842039927959577348273091639142832610654111221697618470144), ...
15812549714797741467943768564642434052082156360991253509551361428575/...
98271743357552383407053183560481095925582449661336853220705835814912, ...
-(1566209227127848181565741614046198384717633249051450126143029991037/...
72793883968557321042261617452208219204135147897286557941263582085120),...
 20041801494011475957610929202070330157768362007077325180507837931289/...
13394074650214547071776137611206312333560867213100726661192499103662080,...
-1456522302341498030047698792429758582323797716385924949950536772475/...
32145779160514912972262730266895149600546081311441743986861997848788992,...
2451358366551961587327437507853135356388850686593484738470016892911/...
6514877909864355695711913334090750319044005812452193448004031564021235712];

   P =  p(1)*I + p(2)*Z + p(3)*Z2 + p(4)*Z3 + p(5)*Z4 + p(6)*Z5 + p(7)*Z6 ...  
        + p(8)*Z7 + p(9)*Z8;
   Q = q(1)*I + q(2)*Z + q(3)*Z2 + q(4)*Z3 + q(5)*Z4 + q(6)*Z5 + q(7)*Z6 ...
       + q(8)*Z7 + q(9)*Z8;
  
end
  
S1 = Q\P;
S2 = S1*sqrt(2)*(sqrtm(Z));
S2 = 2^s*S2; % Scale back.
X = W*S2*W';  
