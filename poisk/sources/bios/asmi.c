#include <stdio.h>
#include <string.h>

main()
{
	char 	mass[133];
	char	str[100],name[13];
	int	i,finc = 0,
		kk = 0;
	int 	len = 0;
	FILE   *in,*out,*incl;
	in = fopen("bios.lst","rt");
	out = fopen("bios.asm","wt");
	for (i = 0; i <= 99; i ++) {
		str[i] = 0;
	}
	for (;;)
	{
		if (fgets(mass,133,in) == 0) break;
		len = strlen(mass);
		if (len >= 100) len = 99;
		if (len > 32) {
			for (i = 0; i <= len; i ++) {
				str[i] = mass[i+32];
			}
			kk = strncmp(str,"INCLUDE",7);
			if (kk == 0) {
				if (finc > 0) {
					fclose(incl);
					finc --;
				}
				finc ++;
				fputs(str,out);
				for (i = 0; i < 12; i ++) {
					name[i] = str[i+8];
				}
				name[12] = 0;
				incl = fopen(name,"wt");
			}
			if (finc > 0) fputs(str,incl);
			else fputs(str,out);
			for (i = 0; i <= len; i ++) {
				str[i] = 0;
			}
		}
	}
	fclose(in);
	fclose(out);
	fclose(incl);
	return(0);
}



