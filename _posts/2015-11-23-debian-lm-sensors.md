---
layout: blog
title: Debianでlm_sensorsを使用してCPUの温度やファンの回転数などを取得する
tag: ['linux', 'debian']
---



# はじめに

lm\_sensorsは、LinuxでCPUやマザーボードの温度などを監視するユーティリティです。
実際にセンサから温度等を取得するには、ハードウェアに対応したカーネルモジュールをロードする必要があります。
lm\_sensorsでは、`sensers-detect`コマンドでセンサの検出を行い、ロードするモジュールを決定します。
センサから温度等を取得して表示するには、`sensors`コマンドを使用します。

このエントリでは、Debian Wheezyで、lm\_sensorsをインストールして、CPUの温度やファンの回転数を取得して表示する方法を紹介します。なおハードウェアは、CPUがAMD FX-8350、マザーボードがGA-990FXA-UD3(チップセットはAMD SB950)を使用しています。

OSは、Debian Wheezyとしていますが、パッケージの構造は同じため、基本的にはJessie以降のより新しいバージョンのDebianや、Ubuntuでも同様の手順となるはずです。

# インストール

`lm-sensors`パッケージをインストールします。

~~~~
apt-get install lm-sensors
~~~~

# センサの検出

root権限を持ったユーザで`sensors-detect`コマンドを実行して対話的に検出できます。
いくつか質問されますので、回答は内容を見て判断して下さい。
基本的にはデフォルトで(特に入力せずにEnterを押していけば)良いです。

以下の例では、`Do you want to add these lines automatically to /etc/modules?`の箇所だけ`yes`にしています。
この項目を`yes`にすると`/etc/modules`にセンサからデータを取得するためのカーネルモジュールが追加され、起動時にロードされるようになります。

~~~~
sensors-detect
~~~~

~~~~
# sensors-detect revision 6031 (2012-03-07 17:14:01 +0100)
# System: Gigabyte Technology Co., Ltd. GA-990FXA-UD3

This program will help you determine which kernel modules you need
to load to use lm_sensors most effectively. It is generally safe
and recommended to accept the default answers to all questions,
unless you know what you're doing.

Some south bridges, CPUs or memory controllers contain embedded sensors.
Do you want to scan for them? This is totally safe. (YES/no): 
Module cpuid loaded successfully.
Silicon Integrated Systems SIS5595...                       No
VIA VT82C686 Integrated Sensors...                          No
VIA VT8231 Integrated Sensors...                            No
AMD K8 thermal sensors...                                   No
AMD Family 10h thermal sensors...                           No
AMD Family 11h thermal sensors...                           No
AMD Family 12h and 14h thermal sensors...                   No
AMD Family 15h thermal sensors...                           Success!
    (driver `k10temp')
AMD Family 15h power sensors...                             Success!
    (driver `fam15h_power')
Intel digital thermal sensor...                             No
Intel AMB FB-DIMM thermal sensor...                         No
VIA C7 thermal sensor...                                    No
VIA Nano thermal sensor...                                  No

Some Super I/O chips contain embedded sensors. We have to write to
standard I/O ports to probe them. This is usually safe.
Do you want to scan for Super I/O sensors? (YES/no): 
Probing for Super-I/O at 0x2e/0x2f
Trying family `National Semiconductor/ITE'...               No
Trying family `SMSC'...                                     No
Trying family `VIA/Winbond/Nuvoton/Fintek'...               No
Trying family `ITE'...                                      Yes
Found `ITE IT8720F Super IO Sensors'                        Success!
    (address 0x228, driver `it87')
Probing for Super-I/O at 0x4e/0x4f
Trying family `National Semiconductor/ITE'...               No
Trying family `SMSC'...                                     No
Trying family `VIA/Winbond/Nuvoton/Fintek'...               No
Trying family `ITE'...                                      No

Some systems (mainly servers) implement IPMI, a set of common interfaces
through which system health data may be retrieved, amongst other things.
We first try to get the information from SMBIOS. If we don't find it
there, we have to read from arbitrary I/O ports to probe for such
interfaces. This is normally safe. Do you want to scan for IPMI
interfaces? (YES/no): 
Probing for `IPMI BMC KCS' at 0xca0...                      No
Probing for `IPMI BMC SMIC' at 0xca8...                     No

Some hardware monitoring chips are accessible through the ISA I/O ports.
We have to write to arbitrary I/O ports to probe them. This is usually
safe though. Yes, you do have ISA I/O ports even if you do not have any
ISA slots! Do you want to scan the ISA I/O ports? (yes/NO): 

Lastly, we can probe the I2C/SMBus adapters for connected hardware
monitoring devices. This is the most risky part, and while it works
reasonably well on most systems, it has been reported to cause trouble
on some systems.
Do you want to probe the I2C/SMBus adapters now? (YES/no): 
Using driver `i2c-piix4' for device 0000:00:14.0: ATI Technologies Inc SB600/SB700/SB800 SMBus
Module i2c-dev loaded successfully.

Now follows a summary of the probes I have just done.
Just press ENTER to continue: 

Driver `it87':
  * ISA bus, address 0x228
    Chip `ITE IT8720F Super IO Sensors' (confidence: 9)

Driver `fam15h_power' (autoloaded):
  * Chip `AMD Family 15h power sensors' (confidence: 9)

Driver `k10temp' (autoloaded):
  * Chip `AMD Family 15h thermal sensors' (confidence: 9)

To load everything that is needed, add this to /etc/modules:
#----cut here----
# Chip drivers
it87
#----cut here----
If you have some drivers built into your kernel, the list above will
contain too many modules. Skip the appropriate ones!

Do you want to add these lines automatically to /etc/modules? (yes/NO)yes
Successful!

Monitoring programs won't work until the needed modules are
loaded. You may want to run '/etc/init.d/kmod start'
to load them.

Unloading i2c-dev... OK
Unloading cpuid... OK
~~~~

# モジュールのロードと確認

`sensors-detect`の結果を見ると、カーネルモジュールのドライバ`it87`, `fam15h_power`, `k10temp`を使えということのようです。
メッセージにも表示されていますが、モジュールをロードするまでモニタリングプログラム(`sensors`コマンド)は動作しません。
指示に従ってkmodをstartさせて、モジュールをロードします。

~~~~
/etc/init.d/kmod start
~~~~

試しに`lsmod`してみると、モジュールがロードされていることが確認できます。
以下の出力は抜粋です。

~~~~
lsmod
~~~~

~~~~
it87                   30712  0
fam15h_power           12677  0
k10temp                12611  0
~~~~

# センサからのデータ取得

モジュールをロードした状態で、`sensors`コマンドを実行すると、センサからデータを取得して、表示することができます。
`sensors`コマンドの実行には、root権限は必要ありません。

~~~~
sensors
~~~~

~~~~
fam15h_power-pci-00c4
Adapter: PCI adapter
power1:       27.54 W  (crit = 125.19 W)

k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +19.4°C  (high = +70.0°C)
                       (crit = +90.0°C, hyst = +87.0°C)

it8720-isa-0228
Adapter: ISA adapter
in0:          +0.93 V  (min =  +0.00 V, max =  +4.08 V)
in1:          +1.47 V  (min =  +0.00 V, max =  +4.08 V)
in2:          +3.41 V  (min =  +0.00 V, max =  +4.08 V)
+5V:          +3.02 V  (min =  +0.00 V, max =  +4.08 V)
in4:          +3.09 V  (min =  +0.00 V, max =  +4.08 V)
in5:          +1.10 V  (min =  +0.00 V, max =  +4.08 V)
in6:          +4.08 V  (min =  +0.00 V, max =  +4.08 V)  ALARM
5VSB:         +3.01 V  (min =  +0.00 V, max =  +4.08 V)
Vbat:         +3.33 V  
fan1:        2070 RPM  (min =    0 RPM)
fan2:           0 RPM  (min =    0 RPM)
fan3:           0 RPM  (min =    0 RPM)
fan4:           0 RPM  (min =    0 RPM)
temp1:        +40.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = thermistor
temp2:        +36.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = thermal diode
temp3:        +33.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = thermal diode
cpu0_vid:    +0.000 V
intrusion0:  OK
~~~~

だいたい意味はわかりますが、意味が不明瞭な項目、きちんと取得できていないように見える項目もあります。
lm\_sensorsのバージョンや、ハードウェアの構成によって、どのように値が取得できるのかは異なるのでしょう。
