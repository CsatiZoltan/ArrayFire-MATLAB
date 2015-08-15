function mexAF(gateway, objFile, backend, config)
%MEXAF  Create a mex function from a compiled ArrayFire function.
%   Inputs:
%     gateway : name of the .cpp or .c mex gateway function
%     objFile : name of the .obj file
%     backend : 'CPU', 'CUDA' or 'OpenCL'
%     config  : 'Release' or 'Debug'
%
%   See also   MEX

%   For more details, see https://github.com/CsatiZoltan/ArrayFire-MATLAB
%
%   Zoltan Csati
%   2015/08/15


% Check architecture
if ~strcmp(computer('arch'), 'win64')
   error('MATLAB:mexAF', '64 bit Windows is required.'); 
end

% Folder operations
origFolder = pwd;
thisFileFolder = mfilename('fullpath');
[folder, name, ~] = fileparts(which(thisFileFolder));
cd(folder);
mexFile = [name, '.mexw64'];
AFroot = getenv('AF_PATH');
if isempty(AFroot)
    error('MATLAB:mexAF', ['ArrayFire installation location not found.',...
        ' Check that AF_PATH is added to your environmental variables.']);
end
AFinc = ['-I' AFroot '\include'];
AFlib = ['-L' AFroot '\lib'];
longInt = '-largeArrayDims';

% Select the backend
switch lower(backend)
    case 'cpu'
        library = '-lafcpu';
    case 'cuda'
        library = '-lafcuda';
    case 'opencl'
        library = '-lafopencl';
    otherwise
        error('MATLAB:mexAF', 'Invalid backend.');
end

% Select the configuration
switch lower(config)
    case 'debug'
        debugFlag = '-g';
    case 'release'
        debugFlag = '';
    otherwise
        error('MATLAB:mexAF', 'Invalid configuration.');
end

% Create the .mexw64 file through linking with mex
try
    mex(longInt, debugFlag, AFinc, AFlib, library, objFile, gateway);
    afterBuildHelp(backend, config)
    cd(origFolder); % restore the original working directory
catch mexError
    cd(origFolder); % restore the original working directory
    rethrow(mexError);
end

end


function afterBuildHelp(backend, config)
% Advices about how to use the created mex function.

switch lower(backend)
    case 'cpu'
        disp(['For the distribution of the mex file, do not forget ', ...
        'to attach "afcpu.dll" from %AF_PATH%\lib.']);
    case 'cuda'
        disp(['For the distribution of the mex file, do not forget ', ...
        'to attach "nvvm64_30_0.dll" from %CUDA_PATH%\nvvm\bin and ', ...
        '"afcuda.dll" from %AF_PATH%\lib.']);
    case 'opencl'
        disp(['For the distribution of the mex file, do not forget ', ...
        'to attach "afopencl.dll" from %AF_PATH%\lib.']);
end

if strcmpi(config, 'debug')
   disp(['For debugging, create a breakpoint in Visual Studio within ', ...
       'the computational routine. Then go to Debug -> Attach ', ...
       'to Process and select the MATLAB process.']); 
end

end