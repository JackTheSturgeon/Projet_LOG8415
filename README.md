# Projet_LOG8415
Scripts:
run.sh: Sert à lancer les instances et configurer le groupe de sécurité (notamment les règles entrantes et sortantes)
setup_master.sh: Commandes pour setup le master node dans le cluster mySQL
setup_slave.sh: Commandes pour setup un slave node dans le cluster mySQL
 install mysql.sh: Fichier du configuration de mySQL en standalone. On y retrouve les commandes pour installer sakila et faire le benchmark avec sysbench. Il faut faire tourner ce script sur la machine mySQL standalone

Fichiers de configuration:
config.ini: Configuration du cluster sur le master node (nombre de répliques et adresses des nodes). Ajouter les adresse IP privées requise dans ce fichier. A mettre dans /var/lib/mysql-cluster/ sur le master sous le nom config.ini
my.cnf_master: Configuration du cluster sur le master. Ajouter l'adresse IP privée du master. A mettre dans /etc/mysql/ sur le master sous le nom my.cnf
my.cnf: Configuration du cluster sur un slave. Ajouter l'adresse IP privée du master. A mettre dans /etc/mysql/ sur un node slave sous le nom my.cnf
ndb_mgmd.service: Fichier de configuration qui sert a lancer le cluster sous forme de service. A ajouter tel quel dans /etc/systemd/system/ du master.
ndbd_slave.service: Fichier de configuration qui sert a lancer la connection du node au master en tant que service. A ajouter tel quel dans /etc/systemd/system/ du slave