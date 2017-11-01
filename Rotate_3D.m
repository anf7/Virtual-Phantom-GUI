function [newx,newy,newz] = Rotate_3D(x,y,z,axr,degr,~)

u = axr(:)/norm(axr);

radr = degr*pi/180;
cosa = cos(radr);
sina = sin(radr);
ux = u(1);
uy = u(2);
uz = u(3);

rot = [cosa+ux^2*(1-cosa), ux*uy*(1-cosa)-uz*sina, ux*uz*(1-cosa)+uy*sina; ...
       ux*uy*(1-cosa)+uz*sina, cosa+uy^2*(1-cosa), uy*uz*(1-cosa)-ux*sina; ...
       ux*uz*(1-cosa)-uy*sina, uy*uz*(1-cosa)+ux*sina, cosa+uz^2*(1-cosa)];
   
[m,n] = size(x);
newxyz = [x(:), y(:), z(:)]';

newxyz = rot*newxyz;
newx = reshape(newxyz(1,:),m,n);
newy = reshape(newxyz(2,:),m,n);
newz = reshape(newxyz(3,:),m,n);