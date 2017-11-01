function [xdata,ydata] = objfront(Vec1,Vec2,frontVec,hullmatchptsflp)

I = find(hullmatchptsflp == 1,1,'first');

if ~isempty(I)
    I = I + length(Vec1);
    V1ptsrep = repmat(Vec1,1,3);
    V2ptsrep = repmat(Vec2,1,3);
    V3ptsrep = repmat(frontVec,1,3);
    if V3ptsrep(round(I + (length(Vec1) - 1)/4)) <= V3ptsrep(round(I - (length(Vec1) - 1)/4))
        xdata = [V1ptsrep(1,I:round(I+(length(Vec1)-1)/2)),fliplr(V1ptsrep(1,I:round(I+(length(Vec1)-1)/2)))];
        ydata = [V2ptsrep(1,I:round(I+(length(Vec1)-1)/2)),fliplr(V2ptsrep(1,I:round(I+(length(Vec1)-1)/2)))];
    else
        xdata = [V1ptsrep(1,round(I-(length(Vec1)-1)/2):I),fliplr(V1ptsrep(1,round(I-(length(Vec1)-1)/2):I))];
        ydata = [V2ptsrep(1,round(I-(length(Vec1)-1)/2):I),fliplr(V2ptsrep(1,round(I-(length(Vec1)-1)/2):I))];
    end
else
    xdata = [Vec1,fliplr(Vec1)];
    ydata = [Vec2,fliplr(Vec2)];
end