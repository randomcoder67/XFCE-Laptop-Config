// Note, this c code is adapted from javascript code which isn't mine. The original source is Stephen R. Schmitt (2004), and I sourced the js from here: https://codepen.io/lulunac27/pen/NRoyxE. All of the equations here are identical to there, only translated into c. That linked website is a very helpful explanation of how the code works. 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>

#define LOCATION_FILE_PATH "/Programs/output/updated/curLocation.csv"

static double RAD;
static double EPS;
static double DEG;
static double XhEarth;
static double YhEarth;
static double ZhEarth;
static double cy;
static double ecl;
static int year, month, day, hour, minute, second;
static double lat;
static double lon;

// Initialises necessary values that are the same for every planet
void initValues() {
	RAD = M_PI/180;
	EPS = 0.00000000001;
	DEG = 180/M_PI;
	ecl = 23.439281*RAD;
	
	time_t time_raw;
	struct tm *time_struct;
	time(&time_raw);
	time_raw = time_raw - 3600;
	time_struct = localtime(&time_raw);
	//printf("%d, %d, %d, %d, %d, %d\n", time_struct->tm_year+1900, time_struct->tm_mon+1, time_struct->tm_mday, time_struct->tm_hour, time_struct->tm_min, time_struct->tm_sec);
	
	year = time_struct->tm_year+1900; month = time_struct->tm_mon+1; day = time_struct->tm_mday;
	hour = time_struct->tm_hour; minute = time_struct->tm_min; second = time_struct->tm_sec;
	//year = 2023; month = 8; day = 2; hour = 18; minute = 07; second = 00;
	
	double h = hour + minute/60.0; //+ second/3600.0;
	double dayNumber = 367 * year - floor(7 * floor(year + (month + 9)/12)/4) + floor(275 * month/9) + day - 730531.5 + h/24;
	cy = dayNumber/36525.0;
	
	// Get length of filename and make filename string
	int lengthFileName = strlen(getenv("HOME")) + strlen(LOCATION_FILE_PATH) + 1;
	char locationFileName[lengthFileName];
	strcpy(locationFileName, getenv("HOME")); strcat(locationFileName, LOCATION_FILE_PATH);
	
	// Open file 
	FILE *locationFile;
	locationFile = fopen(locationFileName, "r");
	
	// Make buffer to hold contens and get contents
	char locationFileContents[22];
	fgets(locationFileContents, 22, locationFile);
	
	// Strip trailing newline
	locationFileContents[strcspn(locationFileContents, "\n")] = 0;
	
	// Split string into seperate lat and lon
	char* latString;
	char* lonString;
	latString = strtok(locationFileContents, "|");
	lonString = strtok(NULL, "|");
	
	// Convert lat and lon string to double 
	lat = atof(latString);
	lon = atof(lonString);
}

int abs_floor(double x) {
	if (x >= 0) return floor(x);
	else return ceil(x);
}

double mod2pi(double x) {
	double b = x/(2*M_PI);
	double a = (2*M_PI)*(b-abs_floor(b));
	if (a < 0) a = (2*M_PI) + a;
	return a;
}

double getMST(double lon) {
	if (month == 1 || month == 2) {
		year = year - 1;
		month = month + 12;
	}
	int a = floor(year/100);
	int b = 2 - a + floor(a/4);
	int c = floor(365.25*year);
	int d = floor(30.6001*(month+1));
	
	double jd = b + c + d - 730550.5 + day + (hour + minute/60.0 + second/3600.0)/24.0;
	double jt = jd/36525.0;
	double mst = 280.46061837 + 360.98564736629*jd + 0.000387933*jt*jt - jt*jt*jt/38710000 + lon;
	
	if (mst > 0.0) {
		while (mst > 360.0) {
			mst = mst - 360.0;
		}
	} else {
		while (mst < 0.0) {
			mst = mst + 360.0;
		}
	}
	return mst;
}

void toHorizon(double ra, double dec, double lat, double lon, double *returnArray) {
	 double ha = getMST(lon) - ra;
	 if (ha < 0) {
		ha = ha + 360;
	}
	ha = ha*RAD;
	dec = dec*RAD;
	lat = lat*RAD;
	
	double sin_alt = sin(dec)*sin(lat) + cos(dec)*cos(lat)*cos(ha);
	double alt = asin(sin_alt);
	
	double cos_az = (sin(dec) - sin(alt)*sin(lat))/(cos(alt)*cos(lat));
	double az = acos(cos_az);
	
	double altToReturn = alt*DEG;
	double azToReturn = az*DEG;
	if (sin(ha) > 0) {
		azToReturn = 360 - azToReturn;
	}
	
	returnArray[0] = altToReturn;
	returnArray[1] = azToReturn;
}

// Function to do the calculation for a planet
void doPlanet(double* XhGeneric, double* YhGeneric, double* ZhGeneric, double* planetArray, bool earth) {
	double aEarth = planetArray[0] + planetArray[1] * cy;
	double eEarth = planetArray[2] + planetArray[3] * cy;
	double iEarth = (planetArray[4] + planetArray[5] * cy / 3600)*RAD;
	double OEarth = (planetArray[6] + planetArray[7] * cy / 3600)*RAD;
	double wEarth = (planetArray[8] + planetArray[9] * cy / 3600)*RAD;
	double LEarth = mod2pi((planetArray[10] + planetArray[11] * cy / 3600)*RAD);
	
	double MEarth = mod2pi(LEarth - wEarth);

	double EEarth = MEarth + eEarth*sin(MEarth)*(1.0 + eEarth*cos(MEarth));

	double E1Earth = EEarth + 100;

	while (fabs(EEarth - E1Earth) > EPS) {
		E1Earth = EEarth;
		EEarth = E1Earth - (E1Earth - eEarth*sin(E1Earth) - MEarth)/(1 - eEarth*cos(E1Earth));
	}

	double VEarth = 2*atan(sqrt((1+eEarth)/(1-eEarth))*tan(0.5*EEarth));

	if (VEarth < 0) {
		VEarth = VEarth + (2*M_PI);
	}

	double REarth = (aEarth*(1-eEarth*eEarth))/(1+eEarth*cos(VEarth));
	
	if (earth) {
		*XhGeneric = REarth*cos(VEarth+wEarth);
		*YhGeneric = REarth*sin(VEarth+wEarth);
		*ZhGeneric = 0.0;
	} else {
		*XhGeneric = REarth*(cos(OEarth)*cos(VEarth+wEarth-OEarth)-sin(OEarth)*sin(VEarth+wEarth-OEarth)*cos(iEarth));
		*YhGeneric = REarth*(sin(OEarth)*cos(VEarth+wEarth-OEarth)+cos(OEarth)*sin(VEarth+wEarth-OEarth)*cos(iEarth));
		*ZhGeneric = REarth*(sin(VEarth+wEarth-OEarth)*sin(iEarth));
	}
}

void doInSky(double XhPlanet, double YhPlanet, double ZhPlanet, char* planetName) {
	double Xg = XhPlanet - XhEarth;
	double Yg = YhPlanet - YhEarth;
	double Zg = ZhPlanet - ZhEarth;
	
	double Xeq = Xg;
	double Yeq = Yg*cos(ecl) - Zg*sin(ecl);
	double Zeq = Yg*sin(ecl) + Zg*cos(ecl);
	//double distance = sqrt(Xeq*Xeq + Yeq*Yeq + Zeq*Zeq);
	double ra = mod2pi(atan2(Yeq, Xeq))*DEG;
	double dec = atan(Zeq/sqrt(Xeq*Xeq + Yeq*Yeq))*DEG;
	
	double result[2];
	toHorizon(ra, dec, lat, lon, result);
	printf("%s:\n  Altitude: %0.1f°\n  Azimuth:  %0.1f°\n", planetName, result[0], result[1]);
}

int main() {
	//char strA[10];
	//sprintf(strA, "%.*g", 1+(int)((ceil(log10(10))+1)*sizeof(char))-1, 0.42974291);
	//printf("%s\n", strA);
	//exit(0);
	initValues();

	double earthArray[] = {1.00000011, -0.00000005, 0.01671022, -0.00003804, 0.00005, -46.94, -11.26064, -18228.25, 102.94719, 1198.28, 100.46435, 129597740.63};
	doPlanet(&XhEarth, &YhEarth, &ZhEarth, earthArray, true);
	
	double plutoArray[] = {39.48168677, -0.00076912, 0.24880766, 0.00006465, 17.14175, 11.07, 110.30347, -37.33, 224.06676, -132.25, 238.92881, 522747.90};
	double XhPluto, YhPluto, ZhPluto;
	doPlanet(&XhPluto, &YhPluto, &ZhPluto, plutoArray, false);
	doInSky(XhPluto, YhPluto, ZhPluto, "Pluto");
	
	double neptuneArray[] = {30.06896348, -0.00125196, 0.00858587, 0.00002510, 1.76917, -3.64, 131.72169, -151.25, 44.97135, -844.43, 304.88003, 786449.21};
	double XhNeptune, YhNeptune, ZhNeptune;
	doPlanet(&XhNeptune, &YhNeptune, &ZhNeptune, neptuneArray, false);
	doInSky(XhNeptune, YhNeptune, ZhNeptune, "Neptune");
	
	double uranusArray[] = {19.19126393, 0.00152025, 0.04716771, -0.00019150, 0.76986, -2.09, 74.22988, -1681.40, 170.96424, 1312.56, 313.23218, 1542547.79};
	double XhUranus, YhUranus, ZhUranus;
	doPlanet(&XhUranus, &YhUranus, &ZhUranus, uranusArray, false);
	doInSky(XhUranus, YhUranus, ZhUranus, "Uranus");
	
	double saturnArray[] = {9.53707032, -0.00301530, 0.05415060, -0.00036762, 2.48446, 6.11, 113.71504, -1591.05, 92.43194, -1948.89, 49.94432, 4401052.95};
	double XhSaturn, YhSaturn, ZhSaturn;
	doPlanet(&XhSaturn, &YhSaturn, &ZhSaturn, saturnArray, false);
	doInSky(XhSaturn, YhSaturn, ZhSaturn, "Saturn");
	
	double jupiterArray[] = {5.20336301, 0.00060737, 0.04839266, -0.00012880, 1.30530, -4.15, 100.55615, 1217.17, 14.75385, 839.93, 34.40438, 10925078.35};
	double XhJupiter, YhJupiter, ZhJupiter;
	doPlanet(&XhJupiter, &YhJupiter, &ZhJupiter, jupiterArray, false);
	doInSky(XhJupiter, YhJupiter, ZhJupiter, "Jupiter");
	
	double marsArray[] = {1.52366231, -0.00007221, 0.09341233, 0.00011902, 1.85061, -25.47, 49.57854, -1020.19, 336.04084, 1560.78, 355.45332, 68905103.78};
	double XhMars, YhMars, ZhMars;
	doPlanet(&XhMars, &YhMars, &ZhMars, marsArray, false);
	doInSky(XhMars, YhMars, ZhMars, "Mars");
	
	double venusArray[] = {0.72333199, 0.00000092, 0.00677323, -0.00004938, 3.39471, -2.86, 76.68069, -996.89, 131.53298, -108.80, 181.97973, 210664136.06};
	double XhVenus, YhVenus, ZhVenus;
	doPlanet(&XhVenus, &YhVenus, &ZhVenus, venusArray, false);
	doInSky(XhVenus, YhVenus, ZhVenus, "Venus");
	
	double mercuryArray[] = {0.38709893, 0.00000066, 0.20563069, 0.00002527, 7.00487, -23.51, 48.33167, -446.30, 77.45645, 573.57, 252.25084, 538101628.29};
	double XhMercury, YhMercury, ZhMercury;
	doPlanet(&XhMercury, &YhMercury, &ZhMercury, mercuryArray, false);
	doInSky(XhMercury, YhMercury, ZhMercury, "Mercury");
	
	return 0;
}
