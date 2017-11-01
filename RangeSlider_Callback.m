function RangeSlider_Callback(~,~)

global jRangeSlider
global AXES1_HANDLE AXES2_HANDLE AXES3_HANDLE

v1 = get(jRangeSlider,'LowValue');
v2 = get(jRangeSlider,'HighValue');
vmin = get(jRangeSlider,'Minimum');
vmax = get(jRangeSlider,'Maximum');

rg = vmax - vmin;

if v1 + rg/42 <= v2
    set(AXES1_HANDLE,'CLim',[v1,v2])
    set(AXES2_HANDLE,'CLim',[v1,v2])
    set(AXES3_HANDLE,'CLim',[v1,v2])
else
    if v1 > vmax - rg/42
        set(jRangeSlider,'LowValue',v2 - rg/42);
        set(AXES1_HANDLE,'CLim',[v2-rg/42,v2])
        set(AXES2_HANDLE,'CLim',[v2-rg/42,v2])
        set(AXES3_HANDLE,'CLim',[v2-rg/42,v2])
    else
        set(jRangeSlider,'HighValue',v1 + rg/42);
        set(AXES1_HANDLE,'CLim',[v1,v1+rg/42])
        set(AXES2_HANDLE,'CLim',[v1,v1+rg/42])
        set(AXES3_HANDLE,'CLim',[v1,v1+rg/42])
    end
end