-- FEMM 초기화
openfemm;
newdocument(0);
mi_probdef(0, 'centimeters', 'axisymmetric', 1e-008, 30, 30);
-- 자석 속성 설정
mi_addmaterial("Magnet", 1, 1, 0, 3, 0, 0, 0, 1, 0);

-- 공기 속성 설정
mi_addmaterial("Air", 1, 1, 0, 0, 0, 0, 0, 0, 0);  -- Source Current Density: 0 A/m^2
-- 바운더리 속성 설정
mi_addboundprop("Prescribed A", 0, 0, 0, 0, 0, 0, 0, 0, 0);
mi_addnode(0, 0);
mi_addnode(10, 0);
mi_addnode(10, 10);
mi_addnode(0, 10);
mi_addsegment(0, 0, 10, 0);
mi_addsegment(10, 0, 10, 10);
mi_addsegment(10, 10, 0, 10);
mi_addsegment(0, 10, 0, 0);

-- 바운더리 설정 - 큰 사각형 정의 (0,0) to (200,200)
mi_addnode(0, 200);
mi_addnode(200, 0);
mi_addnode(200, 200);
mi_addsegment(200, 0, 200, 200);  -- 우측 바운더리
mi_addsegment(0, 200, 200, 200);  -- 상단 바운더리

-- 바운더리 속성을 선분에 적용
mi_selectsegment(200, 100);  -- (200, 0)과 (200, 200)을 잇는 선 선택
mi_setsegmentprop("Prescribed A", 0, 1, 0, 0);  -- 선택된 선에 바운더리 속성 적용
mi_clearselected();

mi_selectsegment(100, 200);  -- (0, 200)과 (200, 200)을 잇는 선 선택
mi_setsegmentprop("Prescribed A", 0, 1, 0, 0);  -- 선택된 선에 바운더리 속성 적용
mi_clearselected();

-- 전류 밀도 설정
mi_selectlabel(5, 5);  -- 작은 사각형 내부
mi_setblockprop('Air', 1, 0, '', 90, 0, 0);
-- 이게 맞는 설정일까?
mi_clearselected();

-- 전류 밀도 설정
mi_selectlabel(100,100);  -- 작은 사각형 내부
mi_setblockprop('Air', 1, 0, '', 90, 0, 0);  
-- 이게 맞는 설정일까?
mi_clearselected();

x_start = 30
x_end = 60
y_start = 0
y_end = 80

pixel_width = (x_end - x_start) / 15
pixel_height = (y_end - y_start) / 40

function generateData(current_values)
    for i = 0, 14 do
        for j = 0, 39 do
            local idx = i * 40 + j + 1
            local current_density = current_values[idx]

            x1 = x_start + i * pixel_width
            y1 = y_start + j * pixel_height
            x2 = x1 + pixel_width
            y2 = y1 + pixel_height

            label_x = (x1 + x2) / 2
            label_y = (y1 + y2) / 2
            mi_addblocklabel(label_x, label_y)
            mi_selectlabel(label_x, label_y)
            mi_setblockprop("Magnet", 1, 0, "", 90, 1, current_density)
            mi_clearselected()
        end
    end

    mi_analyze()
    mi_loadsolution()

    mo_addcontour(5, 5)
    local A, B1, B2, Sig, E, H1, H2, Je, Js, Mu1, Mu2, Pe, Ph = mo_getpointvalues(5, 5)
    local Bz_minus_Br = B2 - B1

    return Bz_minus_Br
end
]])
closefemm();
