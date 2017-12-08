/*
Author: Robert Hijmans
Date: June 2016

License: GNU General Public License (GNU GPL) v. 2
*/


using namespace std;
#include <vector>
#include <algorithm>
#include <iostream>


double LIMIT(double min, double max, double v) {
  if (v < min) {
    v = min;
  } else if (v > max) {
    v = max;
  }
  return(v);
}

double AFGEN(std::vector<double> xy, double x) {
  int n = xy.size();
  if(n == 0){
    //cout << "input empty matrix for AFGEN" << endl;
    throw "error";
    exit(0);
  }
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
