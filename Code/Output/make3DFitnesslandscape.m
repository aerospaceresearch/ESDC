function [landscape] = make3DFitnesslandscape(input, data, config)
%F_span, c_e_span, m_0, eta_PPU, prop_type,m_struct, I_tot,index, Descriptions)
landscape = struct();

%make x-y grids
for i=1:size(input,2)
    fieldname = strcat('case',num2str(i));
    c_e_min =   config.(char(input(i).propulsion_type)).c_e_min;
    c_e_max =   config.(char(input(i).propulsion_type)).c_e_max;
    F_min   =   config.(char(input(i).propulsion_type)).F_min;
    F_max   =   config.(char(input(i).propulsion_type)).F_max;
    
    F_span   = linspace(F_min, F_max, config.res_landscape);  
    c_e_span = linspace(c_e_min, c_e_max,config.res_landscape);
    [landscape .(fieldname).F_grid, landscape .(fieldname).c_e_grid] = meshgrid(F_span, c_e_span);
end

%for i=1:size(input,2)
     %   analysis(j).c_e = c_e;
     %   analysis(j).m_dot= input(j).F./c_e;
     %   analysis(j).P_jet_ref = 1/2.*analysis(j).m_dot.*c_e.^2;
     %   analysis(j).PPU_P = analysis(j).P_jet_ref./( analysis(j).PPU_eff*analysis(j).eff);
%end

figure('Name','Mass Fraction EP System Fitness Landscape for F, c_e');
view(-142,30)
for j=1:size(input,2)
mu_EP_mesh = [];
    for i=1:size(F_mesh,1)
            input(j)
        
        F_col = F_mesh(:,i);
        c_e_col = c_e_mesh(:,i);

        %mu_EP_col = calculateMassFraction(F_col, c_e_col, m_0, eta_PPU, prop_type,m_struct, I_tot,j);
        input
        
        
            EP_data = scale_EPsystem (input_grid_col)
            mu_EP_col = EP_data.mu_EP;
        mu_EP_mesh = [mu_EP_mesh mu_EP_col];
    end

mesh_handle = mesh(F_mesh,c_e_mesh,mu_EP_mesh, 'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);%transparent faces, opaque
hold on;
xlabel('F / N');
ylabel('c_e / m/s');
zlabel('\mu_{EP} / - ');

set(mesh_handle, 'FaceColor',map(j,:),'edgecolor',map(j,:));
mesh_collector{end+1} = mu_EP_mesh;

end

legend(Descriptions);

%colormap
map = [ 0.      0.      1.
        0       0.5000  0.
        1.0000  0.      0.
        0       0.7500  0.7500
        0.7500  0       0.7500
        0.7500  0.7500  0
        0.2500  0.2500  0.2500
        0.      1.      0.];
colormap(map);
hold off

%inital min mesh with 1s
mu_min_mesh = ones(size(mesh_collector{1},1),size(mesh_collector{1},2));
index_matrix = ones(size(mesh_collector{1},1),size(mesh_collector{1},2));

%Total minimum mesh
for i=1:size(mesh_collector,2)
    %prop-type
   new_min_mesh = min(mu_min_mesh,mesh_collector{i});
   
    for j=1:size(mesh_collector{1},1)
        for k=1:size(mesh_collector{1},2)
            if new_min_mesh(j,k)<mu_min_mesh(j,k)
                index_matrix(j,k) = i;
            end
        end
    end    
    mu_min_mesh = new_min_mesh;                       %shift reference mesh to get min of all meshes

end


%preallocate
color_matrix_concept = zeros(size(mesh_collector{1},1), size(mesh_collector{1},2),3);
color_matrix_propellant = zeros(size(mesh_collector{1},1), size(mesh_collector{1},2),3);

    for j=1:size(mesh_collector{1},1)
        for k=1:size(mesh_collector{1},2)
            switch index_matrix(j,k)
                case 1 %NH3
                    color_conc = [0. 0. 1.];
                    color_prop = [0. 0.5 0.];
                case 2 %He
                    color_conc = [0    0.5000   0];
                    color_prop = [0.5 0. 0.5];
                case 3 %NH3
                    color_conc = [ 1.0000         0         0];
                    color_prop = [0. 0.5 0.];
                case 4 %He
                    color_conc = [0    0.7500    0.7500];
                    color_prop = [0.5 0. 0.5];
                case 5 %NH3
                    color_conc = [ 0.7500         0    0.7500];
                    color_prop = [0. 0.5 0.];
                case 6 %NH3
                    color_conc = [ 0.7500    0.7500         0];
                    color_prop = [0. 0.5 0.];

                case 7 %HE
                    color_conc = [0.2500    0.2500    0.2500];
                    color_prop = [0.5 0. 0.5];
                case 8 %HE
                    color_conc = [0. 0. 1.];
                    color_prop = [0.5 0. 0.5];
            end
            color_matrix_concept(j,k,:) = color_conc;
            color_matrix_propellant(j,k,:) = color_prop;

        end
    end

figure('Name','Mass Fraction EP System Combined Minimal Fitness Landscape');
mesh(F_mesh,c_e_mesh,mu_min_mesh, color_matrix_concept,'FaceAlpha', 0., 'EdgeAlpha', 1.);
xlabel('F / N');
ylabel('c_e / m/s');
zlabel('\mu_{EP} / - ');
view(-142,30)
legend;

%color according to propellant
figure('Name','Mass Fraction EP System Combined Minimal Fitness Landscape');
mesh(F_mesh,c_e_mesh,mu_min_mesh, color_matrix_propellant,'FaceAlpha', 0., 'EdgeAlpha', 1.);
xlabel('F / N');
ylabel('c_e / m/s');
zlabel('\mu_{EP} / - ');
view(-142,30)

x_mesh = F_mesh;
y_mesh = c_e_mesh;
z_mesh = mu_min_mesh;
colors = color_matrix_propellant;

end
