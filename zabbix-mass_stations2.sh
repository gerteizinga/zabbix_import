clear

# this script will combine all text files is the current folder into 1 file with all nodes, 
# after that the file will be devided into two new files, 
# 1 for the nodes that use a proxy and 
# 1 for the nodes that don't need a proxy
#
#
# based on these 2 newly created files, two xml files are created for the nodes 
# and these files will be imported into into Zabbix
#
# after the import the temp files will be deleted  
#
# This script is based on arponix zabbix-mass_stations.sh (https://github.com/arponix/zabbix_import_multiple_hosts)
#
# the import script is untouched OsamaOracle/Zabbix-import (https://github.com/OsamaOracle/Zabbix-import)
#



# create variables for username, password and main part of the filename
filename=$(date +"%Y%m%dT%H%M")
username="[zabbix username"
password="[zabbix password]"

# combine all text files into 1 file
cat *.txt > "$filename".org

# copy nodes file to new  nodes files (one with and one without proxy)
awk -F '\t' '{if ($3) print $0;}' < "$filename.org" > "$filename-1.nds"


# get the input files
f_input_1="$filename-1.nds"

# create output file name
f_output_1="$filename-1.xml"

printf "<?xml version='1.0' encoding='UTF-8'?> \n" >> $f_output_1;
printf "<zabbix_export> \n" >> $f_output_1;
printf "\t<version>5.2</version> \n" >> $f_output_1;
printf "\t<date>"`date +"%Y-%m-%dT%TZ"`"</date> \n" >> $f_output_1;
printf "\t<hosts> \n" >> $f_output_1;



awk  -v Group=${f_group%%*( )} 'BEGIN {FS = " "} {IP=$1; hostname=$2; proxy=$3; group1=$4; group2=$5;  community=$6; template=$7}

  {
         printf "<host>\n"; 
         printf "\t<host>"hostname"</host>\n";
         printf "\t<name>"hostname"</name>\n";
         printf "\t<proxy>\n";
         printf "\t<name>"proxy"</name>\n";
         printf "\t</proxy>\n";

         printf "\t<groups>\n";
         printf "\t<group>\n";
         printf "\t<name>"group1"</name>\n";
         printf "\t</group>\n";
         printf "\t<group>\n";
         printf "\t<name>"group2"</name>\n";
         printf "\t</group>\n";
         printf "\t</groups>\n";

         printf "\t<templates>\n";
         printf "\t<template>\n";
         printf "\t<name>"template"</name>\n";
         printf "\t</template>\n";
         printf "\t</templates>\n";

         printf "\t<interfaces>\n";
         printf "\t<interface>\n";
         printf "\t<type>SNMP</type>\n";
         printf "\t<port>161</port>\n";
         printf "\t<details>\n";
         printf "\t<community>{$SNMP_COMMUNITY}</community>\n";
         printf "\t</details>\n";

         printf "\t<ip>"IP"</ip>";
         printf "\t<interface_ref>if1</interface_ref>\n";
         printf "\t</interface>\n";
         printf "\t</interfaces>\n";

         printf "\t<macros>\n";
         printf "\t<macro>\n";
         printf "\t<macro>{$SNMP_COMMUNITY}</macro>";
         printf "\t<value>"community"</value>";
         printf "\t</macro>\n";
         printf "\t</macros>\n";

         printf "\t<inventory_mode>DISABLED</inventory_mode>\n";
         printf "</host>\n";    
}
' $f_input_1 >>$f_output_1

printf "\n \t</hosts> \n" >> $f_output_1;
printf "</zabbix_export>  \n" >> $f_output_1;

# copy nodes file to new  nodes files (one with and one without proxy)
awk -F '\t' '$3==""'   < "$filename.org" > "$filename-2.nds"


# get the input files
# f_input_2=""$(date +"%Y%m%dT%H%M-2").nds""

f_input_2="$filename-2.nds"

# create output file name
# f_output_2="$(date +"%Y%m%dT%H%M-2").xml"

f_output_2="$filename-2.xml"






printf "<?xml version='1.0' encoding='UTF-8'?> \n" >> $f_output_2;
printf "<zabbix_export> \n" >> $f_output_2;
printf "\t<version>5.2</version> \n" >> $f_output_2;
printf "\t<date>"`date +"%Y-%m-%dT%TZ"`"</date> \n" >> $f_output_2;
printf "\t<hosts> \n" >> $f_output_2;

awk  -v Group=${f_group%%*( )} 'BEGIN {FS = " "} {IP=$1; hostname=$2;  group1=$3; group2=$4;  community=$5; template=$6}

{
         printf "<host>\n"; 
         printf "\t<host>"hostname"</host>\n";
         printf "\t<name>"hostname"</name>\n";

         printf "\t<groups>\n";
         printf "\t<group>\n";
         printf "\t<name>"group1"</name>\n";
         printf "\t</group>\n";
         printf "\t<group>\n";
         printf "\t<name>"group2"</name>\n";
         printf "\t</group>\n";
         printf "\t</groups>\n";

         printf "\t<templates>\n";
         printf "\t<template>\n";
         printf "\t<name>"template"</name>\n";
         printf "\t</template>\n";
         printf "\t</templates>\n";

         printf "\t<interfaces>\n";
         printf "\t<interface>\n";
         printf "\t<type>SNMP</type>\n";
         printf "\t<port>161</port>\n";
         printf "\t<details>\n";
         printf "\t<community>{$SNMP_COMMUNITY}</community>\n";
         printf "\t</details>\n";

         printf "\t<ip>"IP"</ip>";
         printf "\t<interface_ref>if1</interface_ref>\n";
         printf "\t</interface>\n";
         printf "\t</interfaces>\n";

         printf "\t<macros>\n";
         printf "\t<macro>\n";
         printf "\t<macro>{$SNMP_COMMUNITY}</macro>";
         printf "\t<value>"community"</value>";
         printf "\t</macro>\n";
         printf "\t</macros>\n";

         printf "\t<inventory_mode>DISABLED</inventory_mode>\n";
         printf "</host>\n"; 

}
' $f_input_2 >>$f_output_2

printf "\n \t</hosts> \n" >> $f_output_2;
printf "</zabbix_export>  \n" >> $f_output_2;



./Zabbix-Import-Script#1.py -u "$username" -p "$password" "$filename-1.xml"
./Zabbix-Import-Script#1.py -u "$username" -p "$password" "$filename-2.xml"

rm /scripts/massimport/2022*.*
