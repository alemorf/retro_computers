// Разархиватор MegaLZ
// (с) b2m, alemorf, группа mayhem...

void unmlz(bc, de)
{
    a = 0x80;
UNLD:
    bits = a;
    unmlzInput();
    goto UNSTA;
UNST3:	
    a = *hl; hl++; *bc = a; bc++;
UNST2:
    a = *hl; hl++; *bc = a; bc++;
UNST1:
    a = *hl;
UNSTA:
    *bc = a; bc++;
ULOOP:
    a = bits;    
    a += a;
    if (flag_z) { unmlzInput(); a <<@= 1;	}

    // Несжатый байт
	if (flag_c) goto UNLD;
	
    a += a;	if (flag_z) { unmlzInput(); a <<@= 1; }

    if (flag_nc)
    {
        a += a; if (flag_z) { unmlzInput(); a <<@= 1; }

        // Копирование одного байта
        if (flag_nc)
        {
            getBits(a, hl = 0x3FFF); // 2 бита
            bits = a;
            hl += bc;
            goto UNST1;
        }

        // Копирование двух байт
        bits = a;
        unmlzInput();
	    l = a;
	    h = 0xFF;
	    hl += bc;
	    goto UNST2;
	}

    a += a; if (flag_z) { unmlzInput(); a <<@= 1; }

    // Копирование трёх байт
    if (flag_nc)
    {
        getBigD(a);
        hl += bc;
        goto UNST3;	
    }	

    h = 0;
    do
    {
        h++;
        a += a; if (flag_z) { unmlzInput(); a <<@= 1; }
    } while(flag_nc);

    push(a)
    {
        a = h;
        if (a >= 8) goto UNEXIT;
        
        a = 0;
        do
        {    
            a >>@= 1;
	    } while(flag_nz h--);
	    h = a;
	    l = 1;
	}
	
	getBits();
	hl++;
	hl++;
	
	push(hl);
	getBigD();
	swap(hl, de);
    swap(*sp, hl);
	swap(hl, de);
	hl += bc;

    // LDIR
    do
    {
      a = *hl; hl++; *bc = a; bc++;
    } while(flag_nz e--);
    
    pop (de);
	
	goto ULOOP;
	
UNEXIT:
    pop(a);
}

void getBits(hl)
{
    while()
    {
        a += a;
        if (flag_z) { unmlzInput(); a <<@= 1; }
        if (flag_nc)
        {
            hl += hl;
            if (flag_c) return;
            continue;
        }
        hl += hl;
        l++;
        if (flag_c) return;
	}
    noreturn;
}

void getBigD()
{
    a += a;
    if (flag_z) { unmlzInput(); a <<@= 1; }

    if (flag_nc)
    {
        bits = a;
        unmlzInput();
        l = a;
        h = 0xFF;
        return;
    }

    getBits(a, hl = 0x1FFF); // 7 бит
    bits = a;

    h = l;
    h--;

    unmlzInput();
    l = a;
}

uint8_t bits = 0x80;

void unmlzInput(de)
{
    push(bc)
    {
        readRomByte(c, de);
    }
}
