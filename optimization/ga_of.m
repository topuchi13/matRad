function step_val = ga_of(set,~,ct,cst,pln)
%GA_OF Summary of this function goes here
%   Detailed explanation goes here

pln.bixelWidth      = 10; % [mm] / also corresponds to lateral spot spacing for particles
pln.gantryAngles    = set; % [°]
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


%% generate steering file
stf = matRad_generateStf(ct,cst,pln);

[~,~,~,of_value] = matRad_BaoFunc(ct,stf,cst,pln);

step_val = of_value;


end

