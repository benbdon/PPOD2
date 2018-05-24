x=-10:10;
y = x;
[X Y] = meshgrid(x,y);

J = X.^2 + Y.^2;

ind =Y  > 3*X + 1;
%J(ind) = NaN;
X(Y  > 3*X + 1) = NaN;
Y(Y  > 3*X + 1) = NaN;

figure
contour(X,Y,J)