this script will combine all text files is the current folder into 1 file with all nodes, 
after that the file will be devided into two new files, 
 1 for the nodes that use a proxy and 
 1 for the nodes that don't need a proxy


based on these 2 newly created files, two xml files are created for the nodes 
and these files will be imported into into Zabbix

after the import the temp files will be deleted  

This script is based on arponix zabbix-mass_stations.sh (https://github.com/arponix/zabbix_import_multiple_hosts)

the import script is untouched OsamaOracle/Zabbix-import (https://github.com/OsamaOracle/Zabbix-import)
