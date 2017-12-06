/*
Author: Robert Hijmans
Date: April 2016

License: GNU General Public License (GNU GPL) v. 2 
*/

#include <vector>
#include <algorithm>

double clamp(double min, double max, double v) {
  if (v < min) {
    v = min;
  } else if (v > max) {
    v = max;
  }
  return(v);
}

double NOTNUL(double x) {
	return (x == 0 ? 1 : x);
}	


double INSW(double x, double y1, double y2) {
	return (x < 0 ? y1 : y2);
}	

int REAAND(double x1, double x2) {
	return( ((x1 > 0) & (x2 > 0)) ? 1 : 0 );
}	


double LINT(std::vector<std::vector<double> > xy, double x) {
  int n = xy.size();
  double y = -1;
  if (x < xy[0][0] ) {
    y = xy[0][1];
  } else if (x > xy[n-1][0]) {
    y = xy[n-1][1];
  } else {
    for(int i=1; i<n; i++) {
      if (xy[i][0] > x) {
        double slope = (xy[i][1] - xy[i-1][1]) / (xy[i][0] - xy[i-1][0]);
        y = xy[i-1][1] + (x - xy[i-1][0]) * slope;
        break;
      }
    }
  }
  return(y);
}	


double approx(std::vector<std::vector<double> > xy, double x) {
  int n = xy.size();
  double y = -1;
  if (x < xy[0][0] ) {
    y = xy[0][1];
  } else if (x > xy[n-1][0]) {
    y = xy[n-1][1];
  } else {
    for(int i=1; i<n; i++) {
      if (xy[i][0] > x) {
        double slope = (xy[i][1] - xy[i-1][1]) / (xy[i][0] - xy[i-1][0]);
        y = xy[i-1][1] + (x - xy[i-1][0]) * slope;
        break;
      }
    }
  }
  return(y);
}	


double approx(std::vector<double> xy, double x) {
  int n = xy.size();
  double y = -1;
  if (x < xy[0]) {
    y = xy[1];
  } else if (x > xy[n-2]) {
    y = xy[n-1];
  } else {
    for(int i=2; i<n; i=i+2) {
      if (xy[i] > x) {
        double slope = (xy[i+1] - xy[i-1]) / (xy[i] - xy[i-2]);
        y = xy[i-1] + (x - xy[i-2]) * slope;
        break;
      }
    }
  }
  return(y);
}	



/*
std::vector<std::vector<double> > matrix(int nrow, int ncol) {
  vector<vector<double> > mat;
  mat.resize(nrow);
  for (int i = 0; i < nrow; i++)
    mat[i].resize(ncol);
  return(mat);
} */


std::vector<std::vector<double> > matrix(int nrow, int ncol) {
	std::vector<std::vector<double> > m (nrow, std::vector<double>(ncol));
	return(m);
}



double min3(double a, double b, double c) {
  return( std::min(std::min(a, b), c) );
}

double min4(double a, double b, double c, double d) {
	double tmp = std::min(a, b);
	return( min3(tmp, c, d) );
}


double max3(double a, double b, double c) {
  return( std::max(std::max(a, b), c) );
}

double max4(double a, double b, double c, double d) {
	double tmp = std::max(a, b);
	return( max3(tmp, c, d) );
}

