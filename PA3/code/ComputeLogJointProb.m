% CS228 PA3 Winter 2011
% File: ComputeLogJointProb.m
% Copyright (C) 2011, Stanford University
% contact: Huayan Wang, huayanw@cs.stanford.edu

function logProb = ComputeLogJointProb(P, G, pose)

% pose: 10x3 matrix
% P: structral array parameters (explained in PA description)
% G: graph structure and parametrization (explained in PA description)

K = length(P.c); % number of classes


% log joint probability of class and pose (for each of the K class labels)
logProb = zeros(1, K); 


% first compute the log probabilities on the class label variable

% logProb = ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE

logProb = log(P.c);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% then compute (and accumulate) the log probabilities on body parts

for i=1:10 % for each body part
    
    for k=1:K % class label = k
        
        if size(G,3) == 1 % we only have one graph structure
            
            choice = G(i,1); % choice of parametrization
            parent = G(i,2); % parent body part, if exists
            
        else % we have multiple graph structures, one for each class (in EM)
            
            choice = G(i,1,k); % choice of parametrization
            parent = G(i,2,k); % parent body part, if exists
            
        end
        
        if choice == 0 % parametrized by (2),(3),(4)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            
            log_p_y     = log( normpdf( pose(i,1), P.clg(i).mu_y(k),     P.clg(i).sigma_y(k)     ) );
            log_p_x     = log( normpdf( pose(i,2), P.clg(i).mu_x(k),     P.clg(i).sigma_x(k)     ) );
            log_p_angle = log( normpdf( pose(i,3), P.clg(i).mu_angle(k), P.clg(i).sigma_angle(k) ) );
            
            logProb(k) = logProb(k) +  log_p_y + log_p_x + log_p_angle;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        elseif choice == 1 % parametrized by (5),(6),(7)

             %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            
            t = P.clg(i).theta;
            p = parent;
            
            log_p_y     =   log (...
                                normpdf (...
                                    pose(i,1),...
                                    t(k,1) + t(k,2) * pose(p,1) + t(k,3) * pose(p,2) + t(k,4) * pose(p,3),...
                                    P.clg(i).sigma_y(k)...
                                )...
                            );
                            
            log_p_x     =   log (...
                                normpdf (...
                                    pose(i,2),...
                                    t(k,5) + t(k,6) * pose(p,1) + t(k,7) * pose(p,2) + t(k,8) * pose(p,3),...
                                    P.clg(i).sigma_x(k)...
                                )...
                            );
            log_p_angle =   log (...
                                normpdf (...
                                    pose(i,3),...
                                    t(k,9) + t(k,10) * pose(p,1) + t(k,11) * pose(p,2) + t(k,12) * pose(p,3),...
                                    P.clg(i).sigma_angle(k)...
                                )...
                            );
            
            logProb(k) = logProb(k) +  log_p_y + log_p_x + log_p_angle;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif choice == 2 % parametrized by (8),(9),(10)

             %%%%%%%%%%%%%%%%%%%%%%%%%%%%
             % YOUR CODE HERE
             
            g = P.clg(i).gamma;
            p = parent;
            
            log_p_y     =   log (...
                                normpdf (...
                                    pose(i,1),...
                                    g(k,1) + g(k,2) * pose(p,1) + g(k,3) * pose(p,2) + g(k,4) * sin(pose(p,3)) + g(k,5) * cos(pose(p,3)),...
                                    P.clg(i).sigma_y(k)...
                                )...
                            );
                            
            log_p_x     =   log (...
                                normpdf (...
                                    pose(i,2),...
                                    g(k,6) + g(k,7) * pose(p,1) + g(k,8) * pose(p,2) + g(k,9) * sin(pose(p,3)) + g(k,10) * cos(pose(p,3)),...
                                    P.clg(i).sigma_x(k)...
                                )...
                            );
            log_p_angle =   log (...
                                normpdf (...
                                    pose(i,3),...
                                    g(k,11) + g(k,12) * pose(p,1) + g(k,13) * pose(p,2) + g(k,14) * pose(p,3),...
                                    P.clg(i).sigma_angle(k)...
                                )...
                            );
            
            logProb(k) = logProb(k) +  log_p_y + log_p_x + log_p_angle;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        end
    end
end

