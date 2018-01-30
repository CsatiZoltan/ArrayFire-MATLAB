# ArrayFire-MATLAB
How to connect ArrayFire with MATLAB

## Introduction
[ArrayFire](http://arrayfire.com/) is a hardware neutral parallel computing library with different APIs (Fortran, C, C++, etc.). On the other hand, [MATLAB](http://www.mathworks.com/) is very good for prototyping and for visualization. That's why I wanted to connect ArrayFire with MATLAB. One method would be to save the results obtained with ArrayFire to disk. However, it is very slow for huge amount of scientific data. Since I am not an expert, I asked it on the [ArrayFire group](https://groups.google.com/forum/#!forum/arrayfire-users). An answer has come one day later from Eric. We had a [discussion](https://groups.google.com/forum/#!topic/arrayfire-users/ZrOtYG4DMbo) and I managed to crete a link between ArrayFire and MATLAB. Here is what I have done. Note, that other approaches exist, see e.g. [this entry](https://groups.google.com/forum/#!topic/arrayfire-users/pfiw67fbEOc). Many thanks to Eric!

## Required software
You will need the following:
* ArrayFire (download from their [home page](http://arrayfire.com/login/?redirect_to=http%3A%2F%2Farrayfire.com%2Fdownload) or from [Jenkins](http://ci.arrayfire.org/view/ArrayFire%20-%20Windows/))
* [Visual Studio 2013](https://www.visualstudio.com/) (perhaps older Visual Studio also works with ArrayFire. As for MATLAB, versions above R2014a support Visual Studio 2013. For the supported compilers, regarding R2015a, see [MathWorks](http://www.mathworks.com/support/compilers/R2015a/index.html) and for previous versions, see [this page](http://www.mathworks.com/support/sysreq/previous_releases.html). There is however an [unofficial method](http://www.mathworks.com/matlabcentral/fileexchange/44408-matlab-mex-support-for-visual-studio-2013--and-mbuild-?s_tid=srchtitle) to use VS2013 with older MATLAB.)
* [MATLAB](http://www.mathworks.com/products/matlab/)

## Steps
* Write your computational routine. It can include several functions. In our example, there is a simple function myfunc.cpp, which takes a matrix as input, performs the QR decomposition, and returns matrix R as output. To type your code, edit an available Visual Studio project with ArrayFire set up, like helloworld in the examples folder (or create your own).
* Open the Project Properties dialog box and click on Configuration Properties -> General. Change the Target Extension to .lib and select the Static library (.lib) in the Configuration Type.
* If you don't want to debug your code, then choose the Release configuration. If you intend to debug, then switch to the Debug configuration. You have to change the Runtime Library entry in Configuration Properties -> C/C++ -> Code Generation to Multi-threaded DLL (/MD). It is important, otherwise in will conflict with MATLAB.
* Compile the .cpp file to object file (.obj) by right clicking on the source file and selecting Compile or by hitting Ctrl+F7. The linking will be done from within MATLAB.
* Now, write the MEX wrapper. This function generally contains input processing, checking for input types and sizes, allocating output variables, and calling the computational routine you wrote before (see myfunc_mex.cpp in our example).
* Copy the .obj and .h files from the Visual Studio project to the same directory where your MEX wrapper C++ file is (the header should be included in your MEX wrapper .cpp file). If you copy them into the working directory of MATLAB, you don't have set the path.
* Open MATLAB and type
```Matlab
mex -g myfunc_mex.cpp ...
       myfunc.obj ...
       -I'C:\Program Files\ArrayFire\v3\include' ...
       -L'C:\Program Files\ArrayFire\v3\lib' ...
       -lafcuda ...
       -largeArrayDims
```
where the `-I` flag gives the ArrayFire include directory (change if you installed ArrayFire elsewhere), the `-L` flag gives the ArrayFire library directory (change if you installed ArrayFire elsewhere), use `-lafcuda` if you use the CUDA backend and `-lafopencl` if you apply the OpenCL backend. Finally, the `-largeArrayDims` flag is recommended on 64 bit systems, see the [official answer](http://www.mathworks.com/matlabcentral/answers/99144-how-do-i-update-mex-files-to-use-the-large-array-handling-api-largearraydims). If the don't want to debug, the `-g` flag should be omitted. For debugging, create a breakpoint in Visual Studio within the computational routine (`myfunc.cpp`, in our example). Then go to Debug -> Attach to Process and select the MATLAB process (see also [here](http://www.mathworks.com/help/matlab/matlab_external/debugging-on-microsoft-windows-platforms.html)). When you get to the breakpoint in `myfunc.cpp`, Visual Studio will stop.  You can then step through, inspect variables on the host, etc. as you normally might.

## Remarks
* The mxGPUArray object defined by MATLAB is not used, since every MEX function operations are done on the host.
* Even if you use the CPU backend of ArrayFire, the linking from MATLAB must contain either the `-lafcuda` or the `-lafopencl` flag, otherwise you bump into the "..." MATLAB error.
* If problems occur in your MEX wrapper and it crashes MATLAB, then a great help is to put `mexPrintf()` statements into the wrapper code to decide where the bug is.
* Since we omitted the linking of `myfunc.cpp`, the nvvm64_30_0.dll file was not copied when the CUDA backend was used. It is needed if you distribute your mex file, so copy it from %CUDA_PATH%\nvvm\bin where your mex file is. Likewise with afcuda.dll from %AF_PATH%\lib.

## Open questions
* What if a dll project had been chosen instead of a lib (as far as the generated mex is concerned)?
* If we use the `mex` command for the CUDA version with the `-lafopencl` flag or the OpenCL version with the `-lafcuda` flag, the .mexw64 file created properly and there is no runtime error either. Shouldn't the improper flag cause an error?
* How can we free up the GPU memory? The variables remain allocated after the mex file had run.

## Conclusions
A link between the ArrayFire library and MATLAB has been successfully created. From my experiences, the overhead for calling the generated mex file is negligible, therefore we gained a very efficient combination of ArrayFire-MATLAB usage. If anyone has questions about the setup or finds answers to my questions or just has personnal comments, please send e-mail to csati_zoltan@freemail.hu.
