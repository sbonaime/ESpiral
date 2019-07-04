close all
clc
clear all

addpath('../../../utils');

% changing loop initial and final values according to the files in the folder 
for j = 5 : size(dir('../../logs/normal_points'),1) - 3 
    
    files = dir('../../logs/normal_points');
    filename = ['../../logs/normal_points/' files(j).name];
    load(filename);
    
    % planned path
    lat_wp = CMD(:,10);
    lon_wp = CMD(:,11);

    % performed path
    real_lat_wp = GPS(:,7);
    real_lon_wp = GPS(:,8);

    % removing the zeros from the waypoints, when the UAV change the speed
    lat_wp = lat_wp(lat_wp ~= 0);
    lon_wp = lon_wp(lon_wp ~= 0);

    % getting the map
    coord = [43.718404, 10.432504];
    %coord = [43.718408, 10.432504];
    [XX, YY, M, Mcolor] = get_google_map(coord(1), coord(2));

    % plotting the map
    figure()
    imagesc(XX,fliplr(YY),M);
    colormap(Mcolor);
    hold on

    % plotting the planned path
    [lonutm, latutm, ~] = deg2utm(lat_wp, lon_wp);
    plot(lonutm, latutm, 'bo-','LineWidth',2);
    hold on

    % plotting the first waypoint
    plot(lonutm(1), latutm(1), 'gx','LineWidth',3);
    hold on
    
    % plotting the last waypoint
    plot(lonutm(end), latutm(end), 'rx','LineWidth',3);
    hold on
    
    % plotting the performed path
    [real_lon_utm, real_lat_utm, zone] = deg2utm(real_lat_wp, real_lon_wp);
    plot(real_lon_utm, real_lat_utm, 'w-');
    hold on;

    % plotting the area and the obstacles
    if j > 4
        [~, ~, ~, coord_area, ~] = ...
            waypoints2meters('../../area/rectangle.waypoints', '');
        area = [coord_area; coord_area(1,:)];
        [areax_utm, areay_utm, ~] = deg2utm(area(:,1), area(:,2));

    else    
        [~, ~, ~, coord_area, ~] = ...
            waypoints2meters('../../area/spiral_polygon.waypoints', '');
        area = [coord_area; coord_area(1,:)];
        [areax_utm, areay_utm, ~] = deg2utm(area(:,1), area(:,2));
    end

    % just fixing the new area with the new home location for additional
    % experiments
    plot(areax_utm + 115, areay_utm - 23, 'r-', 'LineWidth', 2);
    hold on

    set(gca,'Ydir','Normal');
    set(gca, 'XTickLabel',{'60','120','180','240','300','360','420','480','540','600','660'});
    xlabel('Meters');
    set(gca, 'YTickLabel',{'60','120','180','240','300','360','420','480','540','600'});
    ylabel('Meters');
    axis equal
end