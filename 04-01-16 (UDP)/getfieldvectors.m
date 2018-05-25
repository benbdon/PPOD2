function [X,Y,Vx,Vy] = getfieldvectors(fieldname)

x=-10:2:10;
y = x;
[X Y] = meshgrid(x,y);

switch fieldname
    case 'TransX'
        Vx = 1+X*0;
        Vy = X*0;
    case 'TransY'
        Vx = X*0;
        Vy = 1+X*0;
    case 'TransNegX'
        Vx = -1+X*0;
        Vy = X*0;
    case 'TransNegY'
        Vx = X*0;
        Vy = -1+X*0;
    case 'LineSinkX'
        Vx = -X/10;
        Vy = X*0;
    case 'LineSinkY'
        Vx = 0*X;
        Vy = -Y/10;
    case 'Sink'
        Vx = -X/10;
        Vy = -Y/10;
    case 'Whirlpool'
        Vx = 1/10*(-X+Y);
        Vy = 1/10*(-X-Y);
    case 'Centrifuge'
        Vx = 1/10*(X-Y);
        Vy = 1/10*(X+Y);
    case 'Source'
        Vx = X/10;
        Vy = Y/10;
    case 'Circle'
        Vx = Y/10;
        Vy = -X/10;
    case 'LineSourceX'
        Vx = X/10;
        Vy = 0*Y;
    case 'LineSourceY'
        Vx = 0*X;
        Vy = Y/10;
    case 'ShearX'
        Vx = Y/10;
        Vy = 0*X;
    case 'ShearY'
        Vx = 0*X;
        Vy = X/10;
    case 'Saddle'
        Vx = 1/10*X;
        Vy = 1/10*-Y;
    case 'SqueezeTransY'
        Vx = -X/10;
        Vy = 1+0*X;
    otherwise
        Vx = 0*X;
        Vy = 0*Y;
end