# ArrayFire-MATLAB
How to connect ArrayFire with MATLAB

## Introduction
[ArrayFire](http://arrayfire.com/) is a hardware neutral parallel computing library with different APIs (Fortran, C, C++, etc.). On the other hand, [MATLAB](http://www.mathworks.com/) is very good for prototyping and for visualization. That's why I wanted to connect ArrayFire with MATLAB. One method would be to save the results obtained with ArrayFire to disk. However, it is very slow for huge amount of scientific data. Since I am not an expert, I asked it on the [ArrayFire group](https://groups.google.com/forum/#!forum/arrayfire-users). An answer has come one day later from Eric. We had a [discussion](https://groups.google.com/forum/#!topic/arrayfire-users/ZrOtYG4DMbo) and I managed to crete a link between ArrayFire and MATLAB. Here is what I have done. Note, that other approaches exist, see e.g. [this entry](https://groups.google.com/forum/#!topic/arrayfire-users/pfiw67fbEOc). Many thanks to Eric!

## Required software
You will need the following:
* ArrayFire (download from their [home page](http://arrayfire.com/login/?redirect_to=http%3A%2F%2Farrayfire.com%2Fdownload) or from [Jenkins](http://ci.arrayfire.org/view/ArrayFire%20-%20Windows/))
* [Visual Studio 2013](https://www.visualstudio.com/) (perhaps older Visual Studio also works with ArrayFire. As for MATLAB, versions above R2014a support Visual Studio 2013. For the supported compilers, regarding R2015a, see [MathWorks](http://www.mathworks.com/support/compilers/R2015a/index.html) and for previous versions, see [this page] (http://www.mathworks.com/support/sysreq/previous_releases.html). There is however an [unofficial method](http://www.mathworks.com/matlabcentral/fileexchange/44408-matlab-mex-support-for-visual-studio-2013--and-mbuild-?s_tid=srchtitle) to use VS2013 with older MATLAB.)
* [MATLAB](http://www.mathworks.com/products/matlab/)

## Steps


## Remarks


## Further functionalities


## Open questions
