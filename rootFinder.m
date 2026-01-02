% Finds the roots of a polynomial around a target number using Eignvalues.
function roots = rootFinder(polynomial)

A = diag(ones(2,1),-1);
A(1,:) = -polynomial(2:4)./polynomial(1);
roots = eig(A);