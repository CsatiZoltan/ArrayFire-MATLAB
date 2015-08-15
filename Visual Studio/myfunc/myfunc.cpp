#include <arrayfire.h>
#include "myfunc.h"

using namespace af;

array myfunc(array in){
	/* Perform the QR decomposition of a matrix */
	array Q, R, tau;
	qr(Q, R, tau, in);
	return R;
}