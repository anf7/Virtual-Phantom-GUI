function rotmat = rotdimCS(th)

rotmat = ...
    [1,0,0;...
    0,cosd(th),-sind(th);...
    0,sind(th),cosd(th)];