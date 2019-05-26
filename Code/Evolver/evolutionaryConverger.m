function [population_history] = evolutionaryConverger(population, data, config)

%t_start = now;
%datetime('now');
convergence = 0;

population_history = {};                                                        % todo: safe to file after predetermined number of gens?

%todo: add video here?
current_population = population.initial;
population_history{end+1}= current_population;
generation = 0;

while convergence == 0
    generation = generation +1;
    
    lineages = numel(fieldnames(current_population));
    
    for i = 1:lineages
        lineage_old = current_population.(strcat('lineage',num2str(i)));
        lineage_mutated = mutator(lineage_old);
        if lineage_mutated.mu_EP <= lineage_old.mu_EP
            current_population.(strcat('lineage',num2str(i))) = lineage_mutated;
        else
            lineage_old.convergence_indicator = lineage_old.convergence_indicator+1; 
        end
    end
    
    %TODO include transfer time? --> likely as requirement

    population_history{end+1}= current_population;
    
    %TODO: Convergence test here for convergence indicator of certain
    %height ...maybe 10...better higher? alternative time out? max number
    %of gens
    
    %lineage terminator here
    
    if lineages == 0
        convergence = 1;
    end
end
end



%Evolver 



%     gen_frame = figure('Name', 'Converger Full History');
%     mesh(x_mesh,y_mesh, z_mesh, colors, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.5);
%     view(-142,30)
%     xlim([0.01 0.1])
%     ylim([0 max(get_c_e_span())])
%     zlim([0 1])
%     xlabel('F / N');
%     ylabel('c_e / m/s');
%     zlabel('\mu_{EP} / - ');
%     hold on
%     for i=1:size(current_population,1)
%         %mutator
%         F           = mutate_F(current_population(i, 1));
%         c_e         = mutate_c_e(current_population(i, 2));
%         prop_type   = mutate_prop(current_population(i, 3));
%            if prop_type==1
%               eta_PPU_current = eta_PPU(1);
%               I_tot_in = I_tot(1);
%               m_struct_in = m_struct(1);
%               
%           else
%               eta_PPU_current = eta_PPU(2);        
%               I_tot_in = I_tot(2);
%               m_struct_in = m_struct(2);
%           end
%           new_mu=   calculateMassFraction(F, c_e, m_0, eta_PPU_current, prop_type,m_struct_in, I_tot_in,1);
% 
%    % plot3([current_population(i, 1)], [current_population(i, 2)] ,[new_mu],'rx','LineWidth',2);
%      %  set(gcf,'PaperPositionMode','auto')
% 
%                
%         %selector
%         if new_mu <= current_mu(i)
%             new_population(i,:) = [F c_e prop_type new_mu];
%             current_mu(i) = new_mu;
%             
%         else
%             new_population(i,:) = current_population(i,:);
%         end
%     end
%     hold off
%     framename= sprintf('frame%03d', generation);
%     print(gen_frame, framename,'-dpng')
%     close all
    

%have convergence when epsilon final is reached.

%iterate convergence distance once hyperspace velocity is low
%     if generation == 10
%     title = strcat('Mass fraction EP System with ', num2str(size(inital_population,1)),' inital seed points for',num2str(generation),' generations');
%     figure('Name', title);
%     mesh(x_mesh,y_mesh, z_mesh, colors, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.5);
%     view(-142,30)
%     hold on
% 
% for i=1:size(population_history{1},1)
% x=[];
% y=[];
% z=[];
%     for k=1:numel(population_history)
%       pop=  population_history{k};
% 
%         x = [x pop(i,1)];
%         y = [y pop(i,2)];
%         z = [z pop(i,4)];   
%     end
%     plot3(x,y,z,'color',rand(1,3));
% end
%     xlabel('F / N');
%     ylabel('c_e / m/s');
%     zlabel('\mu_{EP} / - ');
%     
%     hold off
%     end
    
%     if generation == 100
%    title = strcat('Mass fraction EP System with ', num2str(size(inital_population,1)),' inital seed points for',num2str(generation),' generations');
%     figure('Name', title);
%     mesh(x_mesh,y_mesh, z_mesh, colors, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.5);
%     view(-142,30)
%     hold on
% 
% 
% 
%     for i=1:size(population_history{1},1)
%     x=[];
%     y=[];
%     z=[];
%         for k=1:numel(population_history)
%           pop=  population_history{k};
% 
%             x = [x pop(i,1)];
%             y = [y pop(i,2)];
%             z = [z pop(i,4)];   
%         end
%     plot3(x,y,z,'color',rand(1,3));
%     end
%     xlabel('F / N');
%     ylabel('c_e / m/s');
%     zlabel('\mu_{EP} / - ');
%     
%     hold off     
%     end
    
  %  if generation == 1000
%         hold off
%         title = strcat('Mass fraction EP System with ', num2str(size(inital_population,1)),' inital seed points for',num2str(generation),' generations');
%     figure('Name', title);
%     mesh(x_mesh,y_mesh, z_mesh, colors, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.5);
%     view(-142,30)
%     hold on



% for i=1:size(population_history{1},1)
% x=[];
% y=[];
% z=[];
%     for k=1:numel(population_history)
%       pop=  population_history{k};
% 
%         x = [x pop(i,1)];
%         y = [y pop(i,2)];
%         z = [z pop(i,4)];   
%     end
%     plot3(x,y,z,'color',rand(1,3));
% 
% 
% end
%     xlabel('F / N');
%     ylabel('c_e / m/s');
%     zlabel('\mu_{EP} / - ');
%     
%     hold off
    %convergence =1;
   % end
%end

% [global_min  glob_min_index]= min(z);
% mu_min = global_min;
% F_min = x(glob_min_index);
% c_e_min = y(glob_min_index);

%close(video)
% t_end = now;
% datetime('now');
% dt = t_start - t_end;
% end


