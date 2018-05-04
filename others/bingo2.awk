nawk '
BEGIN {
  FS="[ :]+"
  ARGV[1]="-"
 check=0
 for(i=0;i<=ARGC;i++)
 {
  if(ARGV[i]=="-d")
  {
   check=1
  }
 }
 if(check==0)
 {
  srand()
  i=1
  while(i<=4)
  {
   same=0
   ind=int(rand()*rand()*10)
   for(j=1;j<i;j++)
   {
    if(ind==num[j]){
     same=1
	}
   }
   if(same==0)
   {
    num[i]=ind
    i++
   }
  }
  printf("Press Enter To Start")
  getline start
  "date"| getline
  printf("Start Time is: %2dÂI%2d¤À%2d¬í\n",$4,$5,$6)
  sttime=$4*3600+$5*60+$6
	printf("\t%d\t%d\t%d\t%d",num[1],num[2],num[3],num[4])
  printf("\n")
  end=0
  while(end == 0)
  {
   printf("Please Enter 4 Number")
   getline gnum
   reptnum=0
   if( length(gnum)<5)
   {
    for(i=1;i<=4;i++)
    {
     inum[i]=substr(gnum,i,1)
    }
    for(i=1;i<=4;i++)
    {
     for(j=i+1;j<=4;j++)
     {
      if(inum[i] == inum[j])
      {
       reptnum=1
      }
     }
    }
    if(reptnum == 1)
    {
     printf("The Numbers Repeat!!")
     printf("Press Enter to continue.")
     read key
    }
    else
    {
     a=0
     b=0
     for(i=1;i<=4;i++)
     {
      for(j=1;j<=4;j++)
      {
       if (i==j)
       {
        if(num[i]==inum[j])
         a++
       }
       else
       {
        if(num[i]==inum[j])
        {
         b++
        }
       }
      }
     }
    }
	printf("\t%d\t%d\t%d\t%d",inum[1],inum[2],inum[3],inum[4])
    printf("%dA %dB",a,b)
    printf("\n")
   }
   else
   {
    printf("Input Error!!")
   }
   if(a==4)
   {
    end=1
   }
   else
   {
    end=0
   }
  }
  "/usr/bin/date"|getline
  printf("End Time is: %2dÂI%2d¤À%2d¬í\n",$4,$5,$6)
  edtime=$4*3600+$5*60+$6
  ttime=edtime-sttime
  printf("[1;5;37mTotal Time is[m %d",ttime)
  printf("\n")
  printf("Please Enter Your Name:")
  getline username
  printf("%s : %d\n",username,ttimes) >> "score.txt"
 }
 else
 {
  srand()
  i=1
  while(i <= 4)
  {
   same = 0
   ind = int ( rand()* rand() * 10 )
   for( j = 1 ; j <= i ; j++ )
   {
    if (num[j] == ind)
    {
     same = 1
    }
    if (same == 0)
    {
     num[i] = ind
     i++
    }
   }
   printf("The Randam Number is:")
   for(i=1;i<=4;i++)
   {
    printf("%d",num[i])
   }
   printf("\n")
  }
 }
}
' $*
