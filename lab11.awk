11.Implement and study the performance of GSM on NS2/NS3 (Using MAC layer) or
equivalent environment.
AWK Code

BEGIN {Total_no_of_pkts=0;}
{
if($1 == "r")
{
Total_no_of_pkts = Total_no_of_pkts + $6;
printf("%f %d\n",$2,Total_no_of_pkts) >> "gsm.xg"
}
}
END{}

#to run: awk -f lab11.awk Lab11.tr
