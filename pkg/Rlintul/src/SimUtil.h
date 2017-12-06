
typedef std::vector<std::vector<double> > DMatrix;

double clamp(double min, double max, double v);
double approx(std::vector<double> xy, double x);
double approx(std::vector<std::vector<double> > xy, double x);
double LINT(std::vector<std::vector<double> > xy, double x);

std::vector<std::vector<double> > matrix(int nrow, int ncol);

double min3(double a, double b, double c);
double min4(double a, double b, double c, double d);
double max3(double a, double b, double c);
double max4(double a, double b, double c, double d);
double INSW(double x, double y1, double y2);
int REAAND(double x1, double x2);
double NOTNUL(double x);
