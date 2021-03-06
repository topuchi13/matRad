% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad script
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pack
clear
close all
clc

% load patient data, i.e. ct, voi, cst

%load iskandurov.mat
%load Mehmed.mat
%load HEAD_AND_NECK
%load TG119.mat
%load PROSTATE.mat
%load LIVER.mat
%load BOXPHANTOM.mat
load mikaberidze.mat


global of_value;

% Fill plan with equispaced fields
fields = 5;
xa = 0;

%define angular distance between fields
for c=1:fields
xa=xa+(360./fields);
arr(c)=xa;
end

% meta information for treatment plan
pln.bixelWidth      = 15; % [mm] / also corresponds to lateral spot spacing for particles
% randperm(360,fields); % [°]
pln.gantryAngles    = arr;
pln.couchAngles     = zeros(size(pln.gantryAngles)); % [°]
pln.numOfBeams      = numel(pln.gantryAngles);
pln.numOfVoxels     = prod(ct.cubeDim);
pln.isoCenter       = ones(pln.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);
pln.voxelDimensions = ct.cubeDim;
pln.radiationMode   = 'photons';     % either photons / protons / carbon
pln.bioOptimization = 'none';        % none: physical optimization;             const_RBExD; constant RBE of 1.1;
                                     % LEMIV_effect: effect-based optimization; LEMIV_RBExD: optimization of RBE-weighted dose
pln.numOfFractions  = 30;
pln.runSequencing   = false; % 1/true: run sequencing, 0/false: don't / will be ignored for particles and also triggered by runDAO below
pln.runDAO          = false; % 1/true: run DAO, 0/false: don't / will be ignored for particles
pln.machine         = 'Generic';

%% initial visualization and change objective function settings if desired
matRadGUI

%% generate steering file
stf = matRad_generateStf(ct,cst,pln);

%% dose calculation
% if strcmp(pln.radiationMode,'photons')
%     dij = matRad_calcPhotonDose(ct,stf,pln,cst);
%     %dij = matRad_calcPhotonDoseVmc(ct,stf,pln,cst);
% elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
%     dij = matRad_calcParticleDose(ct,stf,pln,cst);
% end

%% inverse planning for imrt
%[resultGUI, info, of_value] = matRad_fluenceOptimization(dij,cst,pln);

%fprintf('final objective function value...\n');
%of_value


%% BAO
%[resultGUI,dij,info,of_value] = matRad_BaoFunc(ct,stf,cst,pln);

%Generates random set of fields
%while of_value > 12
%     fields = fields + 1;
%     pln.gantryAngles    = randperm(360,fields); % [°]
%     pln.couchAngles     = zeros(size(pln.gantryAngles)); % [°]
%     pln.numOfBeams      = numel(pln.gantryAngles);
%     pln.isoCenter       = ones(pln.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);
%     
%     stf = matRad_generateStf(ct,cst,pln);
%     
%     dij = matRad_calcPhotonDose(ct,stf,pln,cst);
%     [resultGUI,info,of_value] = matRad_BaoFunc(dij,cst,pln);

% define the problem structure
fit_fun = @(set) ga_of(set,fields,ct,cst,pln);
problem.fitnessfcn = fit_fun;
problem.nvars = fields;
problem.Aineq = [];
problem.Bineq = [];
problem.Aeq = [];
problem.Beq = [];
problem.lb = zeros(1,fields);
problem.ub = 360*ones(fields,1);
problem.nonlcon = [];
problem.rngstate = [];
problem.intcon = 1:fields;

problem.options.FunctionTolerance = 2;
problem.options.MaxStallGenerations = 3;
problem.options.PopulationSize = 10;
problem.options.InitialPopulationMatrix = arr;
problem.options.StallTest = 'geometricWeighted';
problem.options.UseParallel = true;
    tic
    [x,fval] = ga(problem);
    toc
%end


%% sequencing
if strcmp(pln.radiationMode,'photons') && (pln.runSequencing || pln.runDAO)
    %resultGUI = matRad_xiaLeafSequencing(resultGUI,stf,dij,5);
    %resultGUI = matRad_engelLeafSequencing(resultGUI,stf,dij,5);
    resultGUI = matRad_siochiLeafSequencing(resultGUI,stf,dij,5);
end

%% DAO
if strcmp(pln.radiationMode,'photons') && pln.runDAO
   resultGUI = matRad_directApertureOptimization(dij,cst,resultGUI.apertureInfo,resultGUI,pln);
   matRad_visApertureInfo(resultGUI.apertureInfo);
end

%% start gui for visualization of result
matRadGUI

%% dvh
%matRad_calcDVH(resultGUI,cst,pln);
