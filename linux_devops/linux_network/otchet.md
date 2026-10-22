## Part 1. Инструмент ipcalc

#### 1.1. Сети и маски

                                    Определил адрес сети
![адрес сети](screen/1.1.png "адрес сети")

**Перевод маски 255.255.255.0 в префиксную и двоичную запись, /15 в обычную и двоичную, 11111111.11111111.11111111.11110000 в обычную и префиксную**

                                    Перевод маски 255.255.255.0
![](screen/1.2.1.png "255.255.255.0")

                                    Перевод /15
![](screen/1.2.2.png "/15")

Ручной расчет так как ipcalc не умеет читать:

Префикс: считаем единицы

11111111.11111111.11111111.11110000

8 + 8 + 8 + 4 = 28

"Префикс: /28"
Десятичная: рассчитываем последний октет

11110000 = 128+64+32+16 = 240

Десятичная: 255.255.255.240

**Минимальный и максимальный хост в сети 12.167.38.4 при масках: /8, 11111111.11111111.00000000.00000000, 255.255.254.0 и /4**

                            Min/Max /8
![](screen/1.3.1.png "/8")

                            Min/Max 11111111.11111111.00000000.00000000
![](screen/1.3.2.png "11111111.11111111.00000000.00000000")

                            Min/Max 255.255.254.0
![](screen/1.3.3.png "255.255.254.0")

                            Min/Max /4
![](screen/1.3.4.png "/4")

#### 1.2 localhost

**Определи и запиши в отчёт, можно ли обратиться к приложению, работающему на localhost, со следующими IP: 194.34.23.100, 127.0.0.2, 127.1.0.1, 128.0.0.1**


C помощью пинга определял доступность серверов

                            194.34.23.100
![](screen/1.4.1.png "194.34.23.100")

                            127.0.0.2
![](screen/1.4.2.png "127.0.0.2")

                            127.1.0.1
![](screen/1.4.3.png "127.1.0.1")

                            128.0.0.1
![](screen/1.4.4.png "128.0.0.1")

Работают: 127.0.0.2, 127.1.0.1

Не работают: 194.34.23.100, 128.0.0.1 (внешние адреса)

#### 1.3. Диапазоны и сегменты сетей

**Какие из перечисленных IP можно использовать в качестве публичного, а какие только в качестве частных: 10.0.0.45, 134.43.0.2, 192.168.4.2, 172.20.250.4, 172.0.2.1, 192.172.0.1, 172.68.0.2, 172.16.255.255, 10.10.10.10, 192.169.168.1**

                             Определение частный или публичный айпи
![](screen/1.5.png "public\private")

**Какие из перечисленных IP-адресов шлюза возможны у сети 10.10.0.0/18: 10.0.0.1, 10.10.0.2, 10.10.10.10, 10.10.100.1, 10.10.1.255**

                            Определяю минимальный и максимальный хост
![](screen/1.6.png "шлюзы")

С помощью ipcalc определяю минимальный и максимальный хост, и по данному диапазону определяю какие шлюзы находятся в данной сети:

Диапазон 10.10.0.1 - 10.10.63.254

Может быть шлюзом: 10.10.0.2, 10.10.10.10, 10.10.1.255

Не может: 10.0.0.1, 10.10.100.1

## Part 2. Статическая маршрутизация между двумя машинами

**С помощью команды ip a посмотри существующие сетевые интерфейсы.**

                            Интерфейс ws1
![](screen/2.1ws1.png "ws1")

                            Интерфейс ws1
![](screen/2.1ws2.png "ws2")

**Опиши сетевой интерфейс, соответствующий внутренней сети, на обеих машинах и задай следующие адреса и маски: ws1 — 192.168.100.10, маска /16, ws2 — 172.24.116.8, маска /12**

Описание сетевого интерфейса.

ws1:

* Интерфейс: enp0s3

* Тип: Ethernet

* MAC-адрес: 08:00:27:cf:3b:28

* адрес: 192.168.100.10/16

* Маска подсети: 255.255.0.0

* Диапазон адресов: 192.168.0.1 — 192.168.255.254

ws2:

* Интерфейс: enp0s3

* Тип: Ethernet

* MAC-адрес: 08:00:27:d1:81:a6

* адрес: 172.24.116.8/12

* Маска подсети: 255.240.0.0

* Диапазон адресов: 172.16.0.1 — 172.31.255.254

***
                            ws1 netplan

![](screen/2.2ws1.png "ws1 netplan")

                            ws2 netplan
![](screen/2.2ws2.png "ws2 netplan")

**Выполни команду netplan apply для перезапуска сервиса сети.**

                            netplan apply ws1
![](screen/2.3ws1.png "ws1 netplan apply")

                            netplan apply ws2
![](screen/2.3ws2.png "ws2 netplan apply")

#### 2.1. Добавление статического маршрута вручную

                            ip add r ws1
![](screen/2.4ws1.png "ws1 route add")

                            ip add r ws2
![](screen/2.4ws2.png "ws2 route add")

#### 2.2. Добавление статического маршрута с сохранением

                            netplan ws1 route
![](screen/2.5ws1.png "netplan ws1 route")

                            ping ws1 to ws2
![](screen/2.5.1ws1.png "ping ws1 to ws2")

                            netplan ws2 route
![](screen/2.5ws2.png "netplan ws2 route")

                            ping ws2 to ws1
![](screen/2.5.1ws2.png "ping ws2 to ws1")                            

## Part 3. Утилита iperf3

#### 3.1. Скорость соединения

**Переведи и запиши в отчёт: 8 Mbps в MB/s, 100 MB/s в Kbps, 1 Gbps в Mbps.**

* 8 мегабит будет 1 мегабайт

* 100 мегабайт будет 800000 килобит

* 1 гигабит будет 100000 мегабит

***

#### 3.2. Утилита iperf3

**Измерь скорость соединения между ws1 и ws2.**

                            iperf3 ws1 server
![](screen/iperf3ws1.png "iperf3 ws1 server")

                            iperf3 ws2 client
![](screen/iperf3ws2.png "iperf3 ws1 server")

## Part 4. Сетевой экран

#### 4.1. Утилита iptables

                            firewall ws1
![](screen/iptablesws1.png "firewall ws1")

                            firewall ws2
![](screen/iptablesws2.png "firewall ws2")

**Запусти файлы на обеих машинах командами chmod +x /etc/firewall.sh и /etc/firewall.sh.**

                            запуск firewall ws1
![](screen/ws1firewall.png "запуск firewall ws1")

                            запуск firewall ws2
![](screen/ws2firewall.png "запуск firewall ws2")

Так как iptables применяет правила по цепочке с верху вниз, и если при первое совпадение с правилом произошло, то остальные правила в этой цепочке не применяются. То есть на первой машине сначала идет запрещающее правило, и при пинге оно применяется то следующее разрешающее правило не трегерится вовсе. Так и наоборот для второй машине, сначала разрешает пинг, и следующее правило запрещающее не применяется.

#### 4.2. Утилита nmap

                            Проверка пингом и отображение nmap
![](screen/nmap.png "ping and nmap")


## Part 5. Статическая маршрутизация сети

#### 5.1. Настройка адресов машин

                            ws11 netplan
![](screen/ws11netplan.png "ws11 netplan")

                            r1 netplan
![](screen/r1netplan.png "r1 netplan")

                            r2 netplan
![](screen/r2netplan.png "r2 netplan")

                            ws21 netplan ПОМЕНЯЙ СКРИН
![](screen/ws21netplan.png "ws21 netplan")

                            ws22 netplan
![](screen/ws22netplan.png "ws22 netplan")

                            ip -4 a ws11
![](screen/ipaws11.png "ip -4 a ws11")

                            ip -4 a r1 + ping ws11
![](screen/ipapingr1.png "ip -4 a r1 + ping ws11")

                            ip -4 a r2
![](screen/ipar2.png "ip -4 a r2")

                            ip -4 a ws21
![](screen/ipaws21.png "ip -4 a ws21")

                            ip -4 a ws22 + ping ws21
![](screen/ipapingws22.png "ip -4 a ws22 + ping ws21")

#### 5.2. Включение переадресации IP-адресов

                            r1 forward
![](screen/iprestrictr1.png "r1 forward")

                            r2 forward
![](screen/iprestrictr2.png "r2 forward")

                            sysctl.conf
![](screen/susctl.png "sysctl.conf")

#### 5.3. Установка маршрута по умолчанию

                            default route ws11
![](screen/defws11.png "default route ws11")

                            default route ws21
![](screen/defws21.png "default route ws21")

                            default route ws22
![](screen/defws22.png "default route ws22")

                            ip r default ws11
![](screen/iprws11.png "default route ws11")

                            ip r default ws21
![](screen/iprws21.png "default route ws21")

                            ip r default ws22
![](screen/iprws22.png "default route ws22")

                            tcpdump r2
![](screen/tcpdumpr2.png "default route ws22")

#### 5.4. Добавление статических маршрутов

                            netplan r1
![](screen/newnetplanr1.png "netplan r1")

                            netplan r2
![](screen/newnetplanr2.png "netplan r2")

                            ip r r1
![](screen/iprr1.png "ip r r1")

                            ip r r2
![](screen/iprr2.png "ip r r2")

                            ip r list ws11
![](screen/iprlistws11.png "ip r list ws11")

В данном случае поведение  ip маршрутизации связано с тем, что 10.10.0.0/18 это локальный маршрут, к которой подключен ws11. И он всегда предпочтительнее дефолтного, так как система ищет самую длинную маску. Длина составляет 18 бит и является более точной, поэтому система выбирает именно такой маршрут. А 0.0.0.0/0 по сути может подрузумевать любой адрес, поэтому маршрутизация идет через дефолтный маршрут.

#### 5.5. Построение списка маршрутизаторов

                            traceroute ws11 to ws21
![](screen/traceroutews11.png "traceroute ws11 to ws21")

                            tcpdump r1
![](screen/tcpdumpr1.png "traceroute ws11 to ws21")

Построение маршрута с помощью утилиты traceroute происходит следующим образом:

* Отправляются пакеты с TTL равным 1, когда первый пакет достигает r1 то ttl становится равным 1

* Затем отправляются пакеты с TTL равным 2 и так далее пока не достигнет ws21

#### 5.6. Использование протокола ICMP при маршрутизации

                            ping 10.30.0.111
![](screen/pingws11not.png "ping 10.30.0.111")

                            dump icmp
![](screen/dumpicmpr1.png "dump icmp")

## Part 6. Динамическая настройка IP с помощью DHCP

                            r2 dhcpd resolv
![](screen/dhcpr2.png "r2 dhcpd")

![](screen/resolr2.png "r2 resolv")


**Перезагрузи службу DHCP командой systemctl restart isc-dhcp-server. Машину ws21 перезагрузи при помощи reboot и через ip a покажи, что она получила адрес. Также пропингуй ws22 с ws21.**

                            dhcp restart
![](screen/restartdhcpr2.png "dhcp restart")

                            ip ws21 new
![](screen/dhcpws21.png "ip ws21 new")

                            ping ws22 to ws21
![](screen/newpingws22tows21.png "ping ws22 to ws21")

**Укажи MAC-адрес у ws11, для этого в etc/netplan/00-installer-config.yaml надо добавить строки: macaddress: 10:10:10:10:10:BA, dhcp4: true.**

                            ws11 new netplan
![](screen/macws11.png "ws11 new netplan")

**Для r1 настрой аналогично r2, но сделай выдачу адресов с жесткой привязкой к MAC-адресу (ws11). Проведи аналогичные тесты.**

                            r1 dhcp file
![](screen/r1dhcp.png "r1 dhcp file")

                            r1 resolv file
![](screen/resolvr1.png "r1 resolv file")

                            new ip ws11
![](screen/newipws11.png "new ip ws11")

                            ping ws22 to ws11
![](screen/pingws22tows11.png "ping ws22 to ws11")

**Запроси с ws21 обновление IP-адреса.**

                            old and new ip ws21
![](screen/oldnewipws21.png "old and new ip ws21")

В данном заднии использовал две опции:

* sudo dhclient -r enp0s3 (освободил адрес)

* sudo dhclient enp0s3 (запросил новый адрес)

## Part 7. NAT

**В файле /etc/apache2/ports.conf на ws22 и r1 измени строку Listen 80 на Listen 0.0.0.0:80, то есть сделай сервер Apache2 общедоступным.**

                            ports r1
![](screen/portsr1.png "ports r1")

                            ports ws22
![](screen/portsws22.png "ports ws22")

**Запусти веб-сервер Apache командой service apache2 start на ws22 и r1.**

                            apache r1
![](screen/apacher1.png "apache r1")

                            apache ws22
![](screen/apachews22.png "apache ws22")

**Добавь в фаервол, созданный по аналогии с фаерволом из Части 4, на r2 правила**

**Проверь соединение между ws22 и r1 командой ping.**

                            ping ws22
![](screen/pingws22tor1.png "ping ws22")

**Разрешить маршрутизацию всех пакетов протокола ICMP.**

                            ping ws22
![](screen/pingws22tor1icmp.png "ping ws22")


Добавил SNAT DNAT правила

                            dnat/snat
![](screen/snatdnat.png "dnat/snat")

**Проверь соединение по TCP для SNAT: для этого с ws22 подключиться к серверу Apache на r1**

                            telnet ws22 to r1
![](screen/telnetws22.png "telnet ws22 to r1")

                            telnet r1 to ws22
![](screen/telnetr1.png "telnet r1 to ws22")