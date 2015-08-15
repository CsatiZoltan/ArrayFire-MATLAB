#include "myfunc.h"
#include "mex.h"
#include "arrayfire.h"

using namespace af;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
	//Check usage
	timer::start(); // start timing
	if (nrhs != 1)
		mexErrMsgTxt("Invalid number of input arguments.  There must be exactly one.");

	if (nlhs != 1)
		mexErrMsgTxt("Invalid number of output arguments.  There must be exactly one.");

	if (!mxIsSingle(prhs[0]))
		mexErrMsgTxt("Input must be of class single but is not.");
	double elapsedTime = timer::stop();
	mexPrintf("Error checking done in %g seconds.\n\n", elapsedTime);

	timer::start(); // start timing
	//Get input
	float *in = (float*)mxGetData(prhs[0]);
	int numRows = (int)mxGetM(prhs[0]);
	int numCols = (int)mxGetN(prhs[0]);

	//Create output
	plhs[0] = mxCreateNumericMatrix(numRows, numCols, mxSINGLE_CLASS, mxREAL);
	float *out = (float*)mxGetData(plhs[0]);

	//Create array object
	array input(numRows, numCols, in, afHost);
	elapsedTime = timer::stop();
	mexPrintf("Variable creation done in %g seconds.\n\n", elapsedTime);

	//Use myfunc
	timer::start(); // start timing
	array output = myfunc(input);
	elapsedTime = timer::stop();
	mexPrintf("Algorithm done in %g seconds.\n\n", elapsedTime);

	//Copy result to host
	timer::start(); // start timing
	output.host((void*)out);
	elapsedTime = timer::stop();
	mexPrintf("Copying to the host done in %g seconds.\n\n", elapsedTime);
}
