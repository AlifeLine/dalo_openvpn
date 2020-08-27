
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
 
#获取服务器IP
IP=`curl -s http://members.3322.org/dyndns/getip`;
http=http:/
host=radius-1253794729.cosgz.myqcloud.com
shouquan=shouquan
wenjiann=data
 
#判断客户选项
selections=0
 
 
# 判断系统是否为root
clear
if [ $(id -u) != "0" ]; then
    echo "致命错误：必须root权限才能运行此脚本"
    exit 1
fi
 
# 判断系统是否为centos6
clear
if [ -f /etc/os-release ];then
	OS_VERSION=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
	if [ $OS_VERSION != "6" ];then
		echo -e "\n当前系统版本为：\033[1;32mCentOS $OS_VERSION\033[0m\n"
		echo "暂不支持该系统安装"
		echo "请更换 CentOS 6 系统进行安装"
		echo "$COO";
		exit 0;
	fi
elif [ -f /etc/redhat-release ];then
	OS_VERSION=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
	if [ $OS_VERSION != "6" ];then
		echo -e "\n当前系统版本为：\033[1;32mCentOS $OS_VERSION\033[0m\n"
		echo "暂不支持该系统安装"
		echo "è·更换 CentOS 6 系统进行安装"
		echo "$COO";
		exit 0;
	fi
else
	echo -e "当前系统版本为：\033[1;32m未知\033[0m\n"
	echo "暂不支持该系统安装"
	echo "请更换 CentOS 6 系统进行安装"
	echo "$COO";
fi
 
#判断tun是否可用
if [[ ! -e /dev/net/tun ]]; then
	clear
	echo "致命错误：TUN不可用"
	exit 1；
fi
 
#返回上一页选择
function returns()
{
	clear
	echo -e "\033[5;34m ${1} \033[0m"
	echo -e "\033[31m —————————————————————— \033[0m"
	echo -e "\033[5;34m 回车重新选择 \033[0m"
	read
	clear
}
 
#判断端口是否重复
function repeat_prot()
{
	repeat_prots=$1
 
	case "${repeat_prots}" in
		80 )
			returns "此端口已被占用请更换"
			New_install
			;;
		8080 )
			returns "此端口已被占用请更换"
			New_install
			;;
 
		53 )
			returns "此端口已被占用请更换"
			New_install
			;;
 
		138 )
			returns "此端口已被占用请更换"
			New_install
			;;
		137 )
			returns "此端口已被占用请更换"
			New_install
			;;
		135 )
			returns "此端口已被占用请更换"
			New_install
			;;
		443 )
			returns "此端口已被占用请更换"
			New_install
			;;
		3398 )
			returns "此端口已被占用请更换"
			New_install
			;;
	esac
}
 
#判断文件夹是否存在
function is_file()
{
	file_names=$1
 
	if [[ -d ${file_names} ]]; then
		echo -e "\033[41;30m 请先重装系统在进行安装 \033[0m"
		exit 1;
	fi
}
 
# 全新安装模块选项
function New_install_selection()
{
	clear
 
	if [[ ${selections} == 'baota' ]]; then
		echo -e "\033[41;30m 您选择的为宝塔安装模式 \033[0m"
		echo -e ""
		echo -e "\033[43;34m 请安装 httpd 或 nginx + php5.6 + mysql5.5 \033[0m"
		echo -e ""
		echo -e "\033[45;30m 不会使用的话请勿返回上一页 \033[0m"
		echo -e ""
		echo -e ""
	elif [[ ${selections} == 'qita' ]]; then
		echo -e "\033[41;30m 您选择的为其他安装模式 \033[0m"
		echo -e ""
		echo -e "\033[43;34m 请安装 httpd 或 nginx + php5.6 + mysql5.5 \033[0m"
		echo -e ""
		echo -e "\033[45;30m 不会使用的话请勿返回上一页 \033[0m"
		echo -e ""
		echo -e ""
	fi
 
	echo -e "\033[41;30m 1、最新版(流量卫士+daloradius) \033[0m"
	echo -e ""
	echo -e "\033[42;34m 2、旧版(daloradius 旧后台) \033[0m"
	echo -e ""
	echo -e "\033[45;30m 3、返回上一页 \033[0m"
	read New_install_selection_select
	case "${New_install_selection_select}" in
		1)
			New_install "llws"
			;;
 
		2)
			New_install "old_dalo"
			;;
 
		3)
			clear
			Home_Welcome
			;;
 
		*)
			returns "请输入正确的数字"
			New_install_selection
			;;
	esac
}
 
#结束
function end_install()
{
	#写入vpn文件
	echo 'case "${1}" in
	"restart" )
		#重启vpn
		setenforce 0 >/dev/null 2>&1
		sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
		ulimit -n 65535 >/dev/null 2>&1
		killall -9 radiusd >/dev/null 2>&1
		killall -9 haproxy >/dev/null 2>&1
		killall -9 openvpn >/dev/null 2>&1
		time.sh & >/dev/null 2>&1
		setsebool httpd_can_network_connect 1 >/dev/null 2>&1
		rm -rf /etc/openvpn/*.txt /etc/openvpn/ccd*/* >/dev/null 2>&1
		service mysqld stop >/dev/null 2>&1
		service mysqld start
		service httpd stop >/dev/null 2>&1
		service httpd start
		service radiusd stop >/dev/null 2>&1
		service radiusd start
		service dnsmasq stop >/dev/null 2>&1
		service dnsmasq start
		service openvpn stop >/dev/null 2>&1
		service openvpn start
		service haproxy stop >/dev/null 2>&1
		service haproxy start
		service iptables start
		setenforce 1
		;;
	"stop" )
		#停止
		setenforce 0 >/dev/null 2>&1
		sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
		ulimit -n 65535 >/dev/null 2>&1
		killall -9 radiusd >/dev/null 2>&1
		killall -9 haproxy >/dev/null 2>&1
		killall -9 openvpn >/dev/null 2>&1
		service mysqld stop
		service httpd stop
		service radiusd stop
		service dnsmasq stop
		service openvpn stop
		service haproxy stop
		;;
		
	"start" )
		#开启
		setenforce 0 >/dev/null 2>&1
		sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
		ulimit -n 65535 >/dev/null 2>&1
		killall -9 radiusd >/dev/null 2>&1
		killall -9 haproxy >/dev/null 2>&1
		killall -9 openvpn >/dev/null 2>&1
		time.sh & >/dev/null 2>&1
		setsebool httpd_can_network_connect 1 >/dev/null 2>&1
		rm -rf /etc/openvpn/*.txt /etc/openvpn/ccd*/* >/dev/null 2>&1
		service mysqld stop >/dev/null 2>&1
		service mysqld start
		service httpd stop >/dev/null 2>&1
		service httpd start
		service radiusd stop >/dev/null 2>&1
		service radiusd start
		service dnsmasq stop >/dev/null 2>&1
		service dnsmasq start
		service openvpn stop >/dev/null 2>&1
		service openvpn start
		service haproxy stop >/dev/null 2>&1
		service haproxy start
		service iptables start
		setenforce 1
		;;
		
	"remote" )
		#开通tcp remote 端口
		clear
		echo "暂未开通"
		;;
		
		
	"udp" )
		#开通udp端口
		clear
		echo "暂未开通"
		;;
	
	"http" )
		#开通http-proxy 代理端口
		mproxy -l ${2} -d >/dev/null 2>&1
		clear
		echo "成功"
		;;
		
	* )
		echo 重启命令： vpn restart
		echo 停止命令： vpn stop
		echo 开启命令： vpn start
		echo 开端口命令： vpn http 138
	;;
esac' >>/sbin/vpn
	echo "auth-user-pass
client
comp-lzo
proto tcp
dev tun
############################
remote "$IP" 1194
############################
keepalive 10 60
setenv tls-remote
key-direction 1
nobind
ns-cert-type server
persist-key
setenv CLIENT_CERT 0
verb 1
<ca>
-----BEGIN CERTIFICATE-----
MIIDyDCCAzGgAwIBAgIJAMMPpgLTPPACMA0GCSqGSIb3DQEBCwUAMIGfMQswCQYD
VQQGEwJDTjELMAkGA1UECBMCWkoxCzAJBgNVBAcTAllEMRUwEwYDVQQKEwxGb3J0
LUZ1bnN0b24xHTAbBgNVBAsTFE15T3JnYW5pemF0aW9uYWxVbml0MQswCQYDVQQD
EwJjYTEQMA4GA1UEKRMHRWFzeVJTQTEhMB8GCSqGSIb3DQEJARYSbWVAbXlob3N0
Lm15ZG9tYWluMB4XDTE2MDQwODA4Mzk1N1oXDTI2MDQwNjA4Mzk1N1owgZ8xCzAJ
BgNVBAYTAkNOMQswCQYDVQQIEwJaSjELMAkGA1UEBxMCWUQxFTATBgNVBAoTDEZv
cnQtRnVuc3RvbjEdMBsGA1UECxMUTXlPcmdhbml6YXRpb25hbFVuaXQxCzAJBgNV
BAMTAmNhMRAwDgYDVQQpEwdFYXN5UlNBMSEwHwYJKoZIhvcNAQkBFhJtZUBteWhv
c3QubXlkb21haW4wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAK5K7bd0Mb/a
Kp6FCcY3HTxIE9fwaUFofLIyRdiMengDv+Iy44+SwIzwXW8Empo3/I7b87GwNGXW
1Mi7sYx6O1yj4IDoGK6DXwm4roH5v4LT9PCbeCC+r1mhMRdcsCZXYLhnTz1ZP+ZS
SgelwfZNQXhNO6kwfQxe6aYzXroAywX9AgMBAAGjggEIMIIBBDAdBgNVHQ4EFgQU
e4hUGrEtghIYAMwDdogl1yN+N8swgdQGA1UdIwSBzDCByYAUe4hUGrEtghIYAMwD
dogl1yN+N8uhgaWkgaIwgZ8xCzAJBgNVBAYTAkNOMQswCQYDVQQIEwJaSjELMAkG
A1UEBxMCWUQxFTATBgNVBAoTDEZvcnQtRnVuc3RvbjEdMBsGA1UECxMUTXlPcmdh
bml6YXRpb25hbFVuaXQxCzAJBgNVBAMTAmNhMRAwDgYDVQQpEwdFYXN5UlNBMSEw
HwYJKoZIhvcNAQkBFhJtZUBteWhvc3QubXlkb21haW6CCQDDD6YC0zzwAjAMBgNV
HRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4GBAFIVIotU7ClrZLLxuLmC9N5JE0OQ
wGNj6G0DmzU0GOyM5SLCgTenbtFL+eIEkw1/Wbic8IGRG9t3K3V0GAE/KAAtwApE
F2+S6L8A3ienrvwjRzdlKMv9h3QuEp/XJD21T9kZKosPR4E2QBWgVCwO4Vba7fd/
FKUvAiakVNWFWSiY
-----END CERTIFICATE-----
</ca>
key-direction 1
<tls-auth>
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
a340b1145aba5c5c1513fbd3ebc50a12
0b0a10f8f4250d4cba67db9275e1a3fb
f081af8e0f8ae8e512237428eb491fb8
d36b05cb4b41eb22eecd4f7577c6f280
2e3debd3676865cbaacf3d40b60ee28b
3b0302096aafc075f215488f0c4d4a27
7e9d5af5d4c4085b559d790f1a78ded7
f2c0488026bf6a15695b89c04119a86f
481025d521e70f5755f8b2708699d751
3f53b92555e782b0335b4ce58aca2c48
a43b3a798b19736ca3d57ef84b6d6768
0a13dc9cca1562e344570e30d4c93ca1
eacb2a4a52d8292dbe99146d4ae60872
8a78e2340c49da76e1894951c7e9c616
70aa3decd9961c5cdc8ca11d3cc3e6aa
4c50c7cf2743e858d6de1a03a9f23c31
-----END OpenVPN Static key V1-----
</tls-auth>">/var/www/html/test.ovpn
	chmod -R 775 /sbin
	clear
	echo -e "\033[43;34m 请稍等... \033[0m"
	echo -e ""
	echo -e "\033[41;30m 正在做最后的配置... \033[0m"
	vpn restart  >/dev/null 2>&1
	echo -e "\033[1;32m"
	echo "=========================================================================="
	echo "                          博雅-DALO 安装完成                              "
	echo "																			"
	echo "                                                                          "
	echo "                            博雅-DALO服务器信息                           "
	echo "                                                                          "
	echo "                   后台管理地址：( "$IP":"$web_port"/"$web_file" )		"
	echo "                   线路模板地址：( "$IP":"$web_port"/test.ovpn )			"
	echo "                   后台管理账号: "$web_username" 密码: "$web_password"	"
	echo "                   数据库  账号: root  密码: "$mysql_password"			"
	if [[ -f "/var/www/html/config.php" ]]; then
		echo "               口令：${kouling}			"
	fi
	echo "                           重启VPN命令：vpn                               "
	echo "																			"
	echo "                   若需要更改服务器数据库请对应下方文件修改"
	if [[ -d "/var/www/html/${web_file}/library/" ]]; then
		echo "          /var/www/html/${web_file}/library/daloradius.conf.php"
	else
		echo "          /var/www/html/config.php"
	fi
	echo "          /etc/raddb/sql.conf"
	echo "=========================================================================="
	echo -e "\033[0m"
	exit;
	
	
}
 
#环境安装
function environment_install()
{
	#配置repos
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
	mv CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base-163.repo
    sed -i "s/\$releasever/6/g" /etc/yum.repos.d/CentOS-Base-163.repo
    sed -i "s/RPM-GPG-KEY-CentOS-6/RPM-GPG-KEY-CentOS-6/g" /etc/yum.repos.d/CentOS-Base-163.repo
    yum clean all
    yum makecache
 
 
    yum -y install epel-release
    #安装所需环境
	yum install gcc gcc-c++ freetype-devel glib2-devel cairo-devel libjpeg* -y
	yum install -y gcc-c++ libgcrypt libgpg-error libgcrypt-devel wget unzip zip libodbc libodbc++ t1lib libmcrypt libc-client libXpm libexslt libxslt*
 
 
    #安装数据库与apache
    if [[ ${selections} == 0 ]]; then
    	yum install -y httpd httpd-tool mysql mysql-server mysql-devdel
    fi
 
    yum install -y openvpn haproxy dnsmasq
 
    #如果出现openvpn安装不成功者循环安装
	rpm -qa|grep -i openvpn
	if [ $? -eq 0 ];then
		echo "";
	else
		clear
		echo -e "\033[41;30m 检测到您的openvpn没有安装成功 \033[0m"
		echo -e "\033[43;34m 如果出现多次请结束脚本重装系统 \033[0m"
		echo -e "\033[43;34m 输入n结束脚本 \033[0m"
		echo -e "\033[43;34m 输入y重新执行脚本 \033[0m"
		read install_fail
		case "${install_fail}" in
			y )
				environment_install
				;;
			n )
				exit 1;
				;;
		esac
	fi
    #安装freeradius
    yum install -y freeradius freeradius-mysql freeradius-utils
 
 
 
    if [[ ${selections} == 0 ]]; then
		yum remove -y php*
 
		rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
		rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
		yum install --enablerepo=remi --enablerepo=remi-php56 php-cli php-odbc php-pear-DB php-mbstring php-pear php-mcrypt php php-common php-imap php-mysql php-pdo php-gd php-xml php-xmlrpc  --skip-broken -y
    else
    	pear install DB -y
    fi
    #配置 mproxy
    cd /sbin
    wget ${http}/${host}/${wenjiann}/udp.zip
    unzip -o udp.zip
    gcc -o mproxy udp.c
    rm -rf udp.zip udp.c
 
    cd
 
    #配置haproxy
    echo "global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon
    stats socket /var/lib/haproxy/stats
defaults
    mode                    tcp
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    #option forwardfor       except 127.0.0.0/8
    option                  redispatch
    option splice-auto
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 60000
listen vpn
        bind 0.0.0.0:3389
		bind 0.0.0.0:443
        mode tcp
	option tcplog
        option splice-auto
	balance roundrobin
        maxconn 60000
        server s1 127.0.0.1:3311 maxconn 10000 maxqueue 60000
        server s2 127.0.0.1:3322 maxconn 10000 maxqueue 60000
        server s3 127.0.0.1:3333 maxconn 10000 maxqueue 60000
        server s4 127.0.0.1:3344 maxconn 10000 maxqueue 60000">/etc/haproxy/haproxy.cfg
	service haproxy restart
 
	#dnsmasq
	yum install dnsmasq -y
	echo "port=5353
server=114.114.114.114
address=/rd.go.10086.cn/10.8.0.1
listen-address=127.0.0.1
conf-dir=/etc/dnsmasq.d">/etc/dnsmasq.conf
	service dnsmasq restart
 
	#freeradius
	cd /etc/raddb
	wget ${http}/${host}/${wenjiann}/raddb.zip
	unzip -o raddb.zip
	rm -rf raddb.zip
 
	#setradius
	cd /etc/raddb/sql
	service mysqld restart
	sed -i "s/'administrator','radius'/'${web_username}','${web_password}'/g" freeradius.sql
	if [[ ${selections} == 0 ]]; then
		mysqladmin -u root password "${mysql_password}"
	fi
	mysql -uroot -p${mysql_password} -e "create database radius;"
	mysql -uroot -p${mysql_password} radius < /etc/raddb/sql/mysql/admin.sql
	mysql -uroot -p${mysql_password} radius < /etc/raddb/sql/mysql/schema.sql
	mysql -uroot -p${mysql_password} radius  < /etc/raddb/sql/mysql/nas.sql
	mysql -uroot -p${mysql_password} radius  < /etc/raddb/sql/mysql/ippool.sql
	mysql -uroot -p${mysql_password} radius  < freeradius.sql
    service mysqld restart
    service radiusd restart
 
    #apache
	sed -i "s/#ServerName www.example.com:80/ServerName localhost:${web_port}/g" /etc/httpd/conf/httpd.conf
	sed -i "s/ServerTokens OS/ServerTokens Prod/g" /etc/httpd/conf/httpd.conf
	sed -i "s/ServerSignature On/ServerSignature Off/g" /etc/httpd/conf/httpd.conf
	sed -i "s/Options Indexes MultiViews FollowSymLinks/Options MultiViews FollowSymLinks/g" /etc/httpd/conf/httpd.conf
	sed -i "s/#ServerName www.example.com:80/ServerName localhost:${web_port}/g" /etc/httpd/conf/httpd.conf
	sed -i "s/80/${web_port}/g" /etc/httpd/conf/httpd.conf
	sed -i "s/magic_quotes_gpc = Off/magic_quotes_gpc = On/g" /etc/php.ini
	setsebool httpd_can_network_connect 1
	setenforce 0
	service httpd restart
 
	#openvpn
	cd /etc/openvpn
	rm -rf /etc/openvpn/*
	wget ${http}/${host}/${wenjiann}/openvpn.zip
	unzip -o openvpn.zip
	rm -rf openvpn.zip
	sed -i "s/port 3311/port 440/g" /etc/openvpn/server1.conf
	service openvpn restart
 
	case "${1}" in
		old_dalo )
 
			#判断是否为宝塔安装
			if [[ ${selections} == 'baota' ]]; then
				#判断文件夹是否存在
				if [[ ! -d "/www/wwwroot/${web_domain}" ]]; then
					returns "没有发现宝塔站点(如不会填写请联系群主)"
					New_install
				fi
				mv /www/wwwroot/${web_domain}/admin /www/wwwroot/${web_domain}/${web_file}
				wget ${http}/${host}/${wenjiann}/old_dalo.zip
				unzip -o old_dalo.zip -d /www/wwwroot/${web_domain}
				clear
			else
				#普通安装
				wget ${http}/${host}/${wenjiann}/old_dalo.zip
				unzip -o old_dalo.zip -d /var/www/html
				clear
			fi
			;;
		llws )
			if [[ ${selections} == 'baota' ]]; then
				#判断文件夹是否存在
				if [[ ! -d "/www/wwwroot/${web_domain}" ]]; then
					returns "没有发现宝塔站点(如不会填写请联系群主)"
					New_install
				fi
					wget ${http}/${host}/${wenjiann}/new_llws.zip
					unzip -o new_llws.zip -d /www/wwwroot/${web_domain}
					sed -i "s/111.231.54.94/${IP}/g" /www/wwwroot/${web_domain}/vpndata.sql;
					# 配置后台密码
					sed -i "s/INSERT INTO \`app_admin\` VALUES (1,'0','admin','admin');/INSERT INTO \`app_admin\` VALUES (1,'0','${web_username}','${web_password}');/g" /www/wwwroot/${web_domain}/vpndata.sql;
					mysql -uroot -p${mysql_password} radius < /www/wwwroot/${web_domain}/vpndata.sql
					
					mysql -uroot -p${mysql_password} 'use radius;alter table radcheck add note_id int(11) NOT NULL;alter table line add `order` int(11) NOT NULL DEFAULT '0';alter table line modify `order` int(11) after label;'
					echo "#!/bin/sh
for((;;))
do
		        echo `curl -s http://${web_domain}:${dingd_dk}/app_api/api.php?act=user_test`;
sleep 7200
done">/sbin/bydaloll.sh
 
 
				echo "${RANDOM}" > /www/wwwroot/auth_key.access
 
				chmod -R 775 /sbin/bydaloll.sh
				nohup /sbin/bydaloll.sh &
				nohup /sbin/time.sh &
				kouling=`cat /www/wwwroot/auth_key.access`
				vpn
			else
				wget ${http}/${host}/${wenjiann}/new_llws.zip
				unzip -o new_llws.zip -d /var/www/html
				sed -i "s/111.231.54.94/${IP}/g" /var/www/html/vpndata.sql;
				sed -i "s/INSERT INTO \`app_admin\` VALUES (1,'0','admin','admin');/INSERT INTO \`app_admin\` VALUES (1,'0','${web_username}','${web_password}');/g" /www/wwwroot/${web_domain}/vpndata.sql;
				mysql -uroot -p${mysql_password} radius < /var/www/html/vpndata.sql
				
				mysql -uroot -p${mysql_password} 'use radius;alter table radcheck add note_id int(11) NOT NULL;alter table line add `order` int(11) NOT NULL DEFAULT '0';alter table line modify `order` int(11) after label;'
				echo "#!/bin/sh
	for((;;))
	do
	        echo `curl -s http://localhost:${dingd_dk}/app_api/api.php?act=user_test`;
	        sleep 7200
	done">/sbin/bydaloll.sh
 
 
			echo "${RANDOM}" > /var/www/auth_key.access
 
			chmod -R 775 /sbin/bydaloll.sh
			nohup /sbin/bydaloll.sh &
			nohup /sbin/time.sh &
			kouling=`cat /var/www/auth_key.access`
			vpn
		fi
		;;
	esac
	mv /var/www/html/admin /var/www/html/${web_file}
	clear
 
	if [[ ${selections} == 0 ]]; then
		#配置数据库参数
		sed -i "s/$configValues['CONFIG_DB_USER'] = 'radius';/$configValues['CONFIG_DB_USER'] = 'root';/g" /var/www/html/${web_file}/library/daloradius.conf.php
		sed -i "s/$configValues['CONFIG_DB_PASS'] = 'hehe123';/$configValues['CONFIG_DB_PASS'] = '${mysql_password}';/g" /var/www/html/${web_file}/library/daloradius.conf.php
		sed -i 's/login = "radius"/login = "root"/g' /etc/raddb/sql.conf
		sed -i "s/password = \"hehe123\"/password = \"${mysql_password}\"/g" /etc/raddb/sql.conf
		sed -i 's/define("_user_","radius");/define("_user_","root");/g' /var/www/html/config.php
		sed -i "s/define(\"_pass_\",\"hehe123\");/define(\"_pass_\",\"${mysql_password}\");/g" /var/www/html/config.php
	fi
	end_install
}
 
# 全新安装模块
function New_install()
{
	#填写信息
	clear
 
	if [[ ${selections} == 'baota' ]]; then
		read -p " 请输入您所绑定的域名： " web_domain
		if [[ -z "${web_domain}" ]]; then
			web_domain=0
		fi
		#不允许为空
		if [[ ${web_domain} == 0 ]]; then
			returns "域名不允许为空,若不会操作请选择全新安装"
			New_install
		fi
		if [[ ! -d "/www/wwwroot/${web_domain}" ]]; then
					returns "没有发现宝塔站点(如不会填写请联系群主)"
					New_install
		fi
	fi
 
	read -p " 请输入web后台访问端口(默认8888->若不是全新安装则不允许默认)： " web_port
	if [[ -z "${web_port}" ]]; then
		web_port=8888
	fi
 
	if [[ `netstat -anp | grep :${web_port}` ]]; then
		returns "此端口已被占用请更换端口(下方有占用情况)\n `netstat -anp | grep :${web_port}`"
		New_install
	fi 
	
	#判断是否有重复端口
	repeat_prot "${web_port}"
 
	read -p "请输入后台访问文件夹(默认admin)：" web_file
	if [[ -z "${web_file}" ]]; then
		web_file=admin
	fi
 
	read -p "请设置后台管理员账户(默认admin)：" web_username
	if [[ -z "${web_username}" ]]; then
		web_username=admin
	fi
 
	read -p "请设置后台管理员密码(默认admin123)：" web_password
	if [[ -z "${web_password}" ]]; then
		web_password=admin
	fi
 
	read -p "请设置数据库密码(默认newpass->若不是全新安装则不允许默认)：" mysql_password
	if [[ -z "${mysql_password}" ]]; then
		mysql_password=newpass
		if [[ ${selections} != 0 ]]; then
			mysql_password=0
		fi
	fi
 
	#数据库密码不能为空
	if [[ ${selections} != 0 ]]; then
		if [[ ${mysql_password} == 0 ]]; then
			returns "数据库不允许为空,若不会操作请选择全新安装"
			New_install
		fi
	fi
 
	#判断数据库长度是否正确
   if [[ ! `expr length ${mysql_password}` < 5 ]]; then
		returns "数据库密码请输入六位数以上"
		New_install
	fi
 
	if [[ ${selections} == 'baota' ]]; then
		DB_PASSWORD_LEN=${#mysql_password}
		if [[ ${DB_PASSWORD_LEN} -eq 0 ]];then  
			SQL_RESULT=$(mysql -u root -e quit 2>&1)
		else  
			SQL_RESULT=$(mysql -u root -p${mysql_password} -e quit 2>&1)
		fi
		SQL_RESULT_LEN=${#SQL_RESULT}
		if [[ ! ${SQL_RESULT_LEN} -eq 0 ]];then
			returns "数据库密码错误请重新输入"
			New_install
		fi
	fi
	clear
	echo -e "\033[31m ——————————————————————  \033[0m"
	echo -e "\033[31m  请确认下方信息是否正确   \033[0m"
	echo -e ""
	echo -e "\033[31m  注意：下方地址暂时不能访问\033[0m"
	echo -e "\033[31m ——————————————————————  \033[0m"
	echo -e ""
	echo -e ""
	if [[ ${selections} != 0 ]]; then
		echo -e "\033[41;30m 后台地址：http://${web_domain}:${web_port}/${web_file} \033[0m"
		echo -e ""
		echo -e "\033[44;37m 注意：宝塔与其他的,数据库库名必须是'radius' \033[0m"
	else
		echo -e "\033[41;30m 后台地址：http://${IP}:${web_port}/${web_file} \033[0m"
	fi
	echo -e ""
	echo -e "\033[42;34m 后台账户：${web_username} \033[0m"
	echo -e ""
	echo -e "\033[43;34m 后台密码：${web_password} \033[0m"
	echo -e ""
	echo -e "\033[44;37m 数据库密码：${mysql_password} \033[0m"
	echo -e ""
	echo -e "\033[45;30m 确认信息没有问题请回车继续 \033[0m"
	echo -e "\033[46;30m 若需要重新填写请输入 y \033[0m"
	echo -e "\033[43;34m 若需要重新回上一步请输入 n \033[0m"
	read New_install_confirm
 
	case "${New_install_confirm}" in
		y )
			returns "填写信息有误,准备重新填写"
			New_install
			;;
		n )
			Home_Welcome
			;;
	esac
 
	#判断系统是否之前搭建过
	is_file "/etc/haproxy"
	is_file "/etc/squid"
	is_file "/etc/openvpn"
 
 
	#装逼作用
	clear
	echo -e "\033[5;34m 正在做搭建前的准备... \033[0m"
	sleep 3
	clear
	echo -e "\033[45;30m 开始搭建... \033[0m"
	sleep 1
	echo -e "\033[31m 1 \033[0m" 
	sleep 1
	echo -e "\033[31m 2 \033[0m"
	sleep 1 
	echo -e "\033[31m 3 \033[0m" 
	sleep 1
 
	#开始搭建
	cd
	yum install -y wget unzip zip vim
	sysctl -w net.ipv4.ip_forward=1
	sysctl -p
 
	#开始配置防火墙
	clear
	echo -e "\033[5;34m 配置防火墙中... \033[0m"
	sleep 2
	service iptables restart >/dev/null 2>&1
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -t nat -P PREROUTING ACCEPT
	iptables -t nat -P POSTROUTING ACCEPT
	iptables -t nat -P OUTPUT ACCEPT
	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X
	/etc/rc.d/init.d/iptables save
	/etc/rc.d/init.d/iptables restart
	iptables -t nat -A PREROUTING -d 10.0.0.0/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A POSTROUTING -s 10.7.0.0/16 ! -d 10.7.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.8.0.0/16 ! -d 10.8.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.9.0.0/16 ! -d 10.9.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.10.0.0/16 ! -d 10.10.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.11.0.0/16 ! -d 10.11.0.0/16 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.12.0.0/16 ! -d 10.12.0.0/16 -j MASQUERADE
	iptables -t nat -A OUTPUT -d 10.7.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.8.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.9.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.10.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.11.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	iptables -t nat -A OUTPUT -d 10.12.0.1/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3389
	/sbin/iptables -I INPUT -p tcp --dport ${web_port} -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 443 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3389 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 137 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 138 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 135 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 53 -j ACCEPT
	iptables -t nat -A OUTPUT -d 192.168.255.1/32 -p tcp -j REDIRECT --to-ports 3389
	/etc/rc.d/init.d/iptables save
	/etc/rc.d/init.d/iptables restart
 
	#开始校准时间
	clear
	echo -e "\033[5;34m 开始校准时间... \033[0m"
	sleep 2
	echo "正在同步时间..."
	echo 
	echo "如果提示ERROR请无视..."
	yum install ntp -y >/dev/null 2>&1
	service ntp stop >/dev/null 2>&1
	\cp -rf /usr/share/zoneinfos/Asia/Shanghai /etc/localtime >/dev/null 2>&1
	ntpServer=(
		[0]=cn.ntp.org.cn
		[1]=210.72.145.44
		[2]=news.neu.edu.cn
		[3]=dns.sjtu.edu.cn
		[4]=dns2.synet.edu.cn
		[5]=ntp.glnet.edu.cn
		[6]=ntp-sz.chl.la
		[7]=202.118.1.130
		[8]=ntp.gwadar.cn
		[9]=dns1.synet.edu.cn
		[10]=sim.ntp.org.cn
	)
	serverNum=`echo ${#ntpServer[*]}`
	NUM=0
	for (( i=0; i<=$serverNum; i++ )); do
		echo
		echo -en "正在和NTP服务器 \033[34m${ntpServer[$NUM]} \033[0m 同步中..."
		ntpdate ${ntpServer[$NUM]} >> /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo -e "\t\t\t[  \e[1;32mOK\e[0m  ]"
			echo -e "当前时间：\033[34m$(date -d "2 second" +"%Y-%m-%d %H:%M.%S")\033[0m"
		else
			echo -e "\t\t\t[  \e[1;31mERROR\e[0m  ]"
				let NUM++
		fi
		sleep 2
	done
	hwclock --systohc
	service ntp restart
 
	environment_install ${1}
}
 
# 欢迎界面
function Home_Welcome()
{
	echo -e "\033[31m —————————————————————— \033[0m"
	echo -e "\033[31m      欢  迎  使  用    \033[0m"
	echo -e "\033[31m        博雅DALO        \033[0m"
	echo -e ""
	echo -e "\033[31m      作者QQ:2223139086 \033[0m"
	echo -e "\033[31m —————————————————————— \033[0m"
	echo -e ""
	#选项栏
	echo -e "\033[47;34m        使用说明      \033[0m"
	echo -e ""
	echo -e "\033[46;30m 以下所有的选项都可以重新回来选择 \033[0m"
	echo -e ""
	echo -e "\033[45;30m 此步骤不会对服务器进行任何的操作 \033[0m"
	echo -e ""
	echo -e "\033[5;34m 请放心选择！ \033[0m"
	echo -e ""
	echo -e "\033[31m —————————————————————— \033[0m"
 
	echo -e "\033[41;30m 1、全新搭建(全部使用脚本安装) \033[0m"
	echo -e ""
	echo -e "\033[42;34m 2、宝塔安装(宝塔+daloradius) \033[0m"
	echo -e ""
	echo -e "\033[43;34m 3、其他安装(lnmp or lamp daloradius) \033[0m"
	echo -e ""
	echo -e "\033[44;37m 4、其他功能脚本 \033[0m"
	echo -e ""
	echo -e "\033[45;30m 5、退出脚本 \033[0m"
 
	read Home_selection
 
	case "${Home_selection}" in
		1)
			New_install_selection
			;;
 
		2)
			selections='baota'
			New_install_selection
			;;
 
		3)
			returns "建议使用宝塔安装"
			Home_Welcome
			;;
 
		4)
			returns "暂未开通,请重新选择！"
			Home_Welcome
			;;
 
		5)
			exit 1
			;;
		*)
			returns "请输入正确的数字"
			Home_Welcome
			;;
	esac
}
Home_Welcome
