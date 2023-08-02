
void cintstr(int num, int width, char* toReturn) { // pass in string with length width 
	char finalChar[width];
	int lenA = (int)((ceil(log10(num))+1)*sizeof(char));
	char strA[width+1];
	finalChar[width] = '\0';
	sprintf(strA, "%d", num);
	for (int i=0; i<width-lenA+1; i++) {
		finalChar[i] = ' ';
	}
	for (int i=0; i<lenA-1; i++) {
		finalChar[i+width-lenA+1] = strA[i];
	}
	strcpy(toReturn, finalChar);
}

void frealstr(double num, int width, int fract, char* toReturn) { // pass in string with length width 
	int tempInt = round(num);
	int lenB = (int)((ceil(log10(tempInt))+1)*sizeof(char)) + 1 + fract;
	char strA[10];
	sprintf(strA, "%.*g", fract+(int)((ceil(log10(tempInt))+1)*sizeof(char))-1, num);
	int lenA = strlen(strA);
	char real[width+1];
	real[width] = '\0';
	
	for (int i=0; i<width-lenA; i++) {
		real[i] = ' ';
	}
	for (int i=0; i<lenA; i++) {
		real[i+width-lenA] = strA[i];
	}
	strcpy(toReturn, real);
}

void dec2str(double x, char* toReturn) {
	double decA = fabs(x);
	char sgn;
	if (x < 0) {
		sgn = '-';
	} else {
		sgn = ' ';
	}
	
	int d = floor(decA);
	double m = 60*(decA-d);
	
	char cintstrA[3];
	cintstr(d, 2, cintstrA);
	
	char frealstrA[5];
	frealstr(m, 4, 1, frealstrA);
	
	char final[11];
	final[10] = '\0';
	final[0] = sgn; final[1] = cintstrA[0]; final[2] = cintstrA[1]; final[3] = 'h'; final[4] = ' ';
	final[5] = frealstrA[0]; final[6] = frealstrA[1]; final[7] = frealstrA[2]; final[8] = frealstrA[3];
	final[9] = 'm';
	strcpy(toReturn, final);
}

void ha2str(double x, char* toReturn) {
	double ra = x/15;
	int h = floor(ra);
	double m = 60*(ra-h);
	
	char cintstrA[4];
	cintstr(h, 3, cintstrA);
	
	char frealstrA[5];
	frealstr(m, 4, 1, frealstrA);
	
	char final[11];
	final[10] = '\0';
	final[0] = cintstrA[0]; final[1] = cintstrA[1]; final[2] = cintstrA[2]; final[3] = 'h';
	final[4] = ' '; final[5] = frealstrA[0]; final[6] = frealstrA[1]; final[7] = frealstrA[2]; 
	final[8] = frealstrA[3]; final[9] = 'm';
	
	strcpy(toReturn, final);
}

void degr2str(double x, char* toReturn) { // insert string of length 12
	double dec = fabs(x);
	//printf("%f\n", x);
	char sgn;
	if (x < 0) {
		sgn = '-';
	} else {
		sgn = ' ';
	}
	
	int d = floor(dec);
	double m = 60*(dec-d);
	
	char cintstrA[4];
	cintstr(d, 3, cintstrA);
	
	char frealstrA[5];
	frealstr(m, 4, 1, frealstrA);
	
	char final[12];
	final[11] = '\0';
	final[0] = sgn; final[1] = cintstrA[0]; final[2] = cintstrA[1]; final[3] = cintstrA[2];
	final[4] = 'd'; final[5] = ' '; final[6] = frealstrA[0]; final[7] = frealstrA[1];
	final[8] = frealstrA[2]; final[9] = frealstrA[3]; final[10] = '\'';
	
	strcpy(toReturn, final);
}
