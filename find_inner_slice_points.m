function bmask = find_inner_slice_points(dataarray,slicenum,dim,slicesize)

global r1 r2 r3 DICOM

bmask = false(slicesize);

v1 = dataarray(1);
v2 = dataarray(2);
v3 = dataarray(3);

ang1 = dataarray(4);
ang2 = dataarray(5);
ang3 = dataarray(6);

v7 = dataarray(7);
v8 = dataarray(8);
v9 = dataarray(9);
scalemat = [2/v8,0,0;0,2/v7,0;0,0,2/v9];

if get(r1,'Value')
    maxdim = max([(v7/2),(v8/2),(v9/2)]);
elseif get(r2,'Value')
    maxdim = sqrt(max([(v7/2),(v8/2)])^2 + (v9/2)^2);
elseif get(r3,'Value')
    maxdim = sqrt((v7/2)^2 + (v8/2)^2 + (v9/2)^2);
end

if dim == 1
    testCind = (DICOM.C >= v1 - maxdim) & (DICOM.C <= v1 + maxdim);
    testSind = (DICOM.S >= v3 - maxdim) & (DICOM.S <= v3 + maxdim);
    R1 = slicenum;
    R2 = slicenum;
    C1 = find(testCind,1,'first');
    C2 = find(testCind,1,'last');
    S1 = find(testSind,1,'first');
    S2 = find(testSind,1,'last');
elseif dim == 2
    testRind = (DICOM.R >= v2 - maxdim) & (DICOM.R <= v2 + maxdim);
    testSind = (DICOM.S >= v3 - maxdim) & (DICOM.S <= v3 + maxdim);
    R1 = find(testRind,1,'first');
    R2 = find(testRind,1,'last');
    C1 = slicenum;
    C2 = slicenum;
    S1 = find(testSind,1,'first');
    S2 = find(testSind,1,'last');
else
    testRind = (DICOM.R >= v2 - maxdim) & (DICOM.R <= v2 + maxdim);
    testCind = (DICOM.C >= v1 - maxdim) & (DICOM.C <= v1 + maxdim);
    R1 = find(testRind,1,'first');
    R2 = find(testRind,1,'last');
    C1 = find(testCind,1,'first');
    C2 = find(testCind,1,'last');
    S1 = slicenum;
    S2 = slicenum;
end

if ~isempty(R1) && ~isempty(R2) && ~isempty(C1) && ~isempty(C2) && ~isempty(S1) && ~isempty(S2) 
    [meshR,meshC,meshS] = ndgrid(single(DICOM.R(R1:R2)),single(DICOM.C(C1:C2)),single(DICOM.S(S1:S2)));
    rcs = ([meshR(:),meshC(:),meshS(:)])';
    

%     rotmat = rotdimRC(-ang2)*rotdimRS(ang1)*rotdimRC(ang3);
    rotmat = rotdimRC(-ang3)*rotdimRS(-ang1)*rotdimRC(-ang2);

    rcs(1,:) = rcs(1,:) - v2*ones(1,size(rcs,2));
    rcs(2,:) = rcs(2,:) - v1*ones(1,size(rcs,2));
    rcs(3,:) = rcs(3,:) - v3*ones(1,size(rcs,2));

    scalerotatemat = scalemat*rotmat;

    rcs = scalerotatemat*rcs;

    if get(r1,'Value')
        rcs_binary = sum(rcs.^2,1) <= 1;
    elseif get(r2,'Value')
        rcs_binary = sum(rcs(1:2,:).^2,1) <= 1 & abs(rcs(3,:)) <= 1;
    elseif get(r3,'Value')
        rcs_binary = all(abs(rcs) <= 1);
    end

    if dim == 1
        imgpart = squeeze(reshape(rcs_binary,[1,C2-C1+1,S2-S1+1]));
        bmask(C1:C2,S1:S2) = imgpart;  
    elseif dim == 2
        imgpart = squeeze(reshape(rcs_binary,[R2-R1+1,1,S2-S1+1]));
        bmask(R1:R2,S1:S2) = imgpart;  
    else
        imgpart = squeeze(reshape(rcs_binary,[R2-R1+1,C2-C1+1,1]));
        bmask(R1:R2,C1:C2) = imgpart;
    end
    
end    
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
    