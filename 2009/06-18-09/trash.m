clc

d1 = [NaN, 1, 1, 1, 1, NaN, 0, 0, 0, 0]';
d2 = d1;
d = [d1 d2]

nanind = find(isnan(d));

dnew = d;
dnew(nanind) = dnew(nanind+1);

d
dnew