---
layout: blog
title: Linuxでも動くようになったPowerShellを試しに使ってみた(Docker/Debian)
tag: powershell
---

# はじめに

噂はありましたが、とうとう昨日、LinuxやMacOS Xでも、PowerShellが使えるようになりました。

このエントリでは、DockerとDebian StretchでPowerShellをインストールして、使ってみます。

## 対象ソフトウェア

|ソフトウェア  |バージョン    |備考                                                   |
|:-            |:-            |:-                                                     |
|PowerShell    |v6.0.0-alpha.9|[https://github.com/PowerShell/PowerShell](https://github.com/PowerShell/PowerShell)|
|Debian        |Stretch       |-                                                      |
|Docker        |1.11.0        |-                                                      |
{: .table .table-striped}

# インストール

## Docker

GitHubには[Dockerで動かせる記載](https://github.com/PowerShell/PowerShell/blob/master/docs/installation/docker.md)がありますが、このエントリ執筆時点では、DockerHubに`powershell`イメージが登録されていないようで、記載どおり`docker run -it powershell`しても動きません。

GitHubのソースコードに`Dockerfile`が含まれていますので、自分でPowerShellの入ったDockerイメージをビルドします。

~~~~
$ git clone git@github.com:PowerShell/PowerShell.git
$ cd PowerShell
$ docker build -t powershell .
~~~~

`Dockerfile`を見ればわかりますが、このイメージは`ubuntu:16.04`イメージをベースに、`curl`, `libunwind8`, `libicu55`パッケージを入れて、Ubuntu 16.04向けにビルドされたPowerShellのDebパッケージをインストールしているだけです。

Dockerイメージがビルドできたら、以下のように起動すると、PowerShellが立ち上がります。

~~~~
$ docker run -it --rm powershell
PowerShell 
Copyright (C) 2016 Microsoft Corporation. All rights reserved.
PS /> 
~~~~

## Debian Stretch

PowerShellの公式のビルド済みバイナリは、Windows、Ubuntu、CentOS、Mac OSX向けのみ提供されており、Debian向けのビルド済みバイナリはありません。
とはいえ、UbuntuとDebianはほぼパッケージの構成が同じですので、DebianでもUbuntu向けのビルド済みバイナリを使うことができます。

私は、手元のDebian Stretch環境で、Ubuntu 16.04向けのdebパッケージをインストールしてみました。
インストール手順はUbuntu 16.04と同じです。

~~~~
# apt-get install libunwind8 libicu55
$ wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/powershell_6.0.0-alpha.9-1ubuntu1.16.04.1_amd64.deb
# dpkg -i powershell_6.0.0-alpha.9-1ubuntu1.16.04.1_amd64.deb
~~~~

起動は`powershell`コマンドです。

~~~~
xmisao:/$ powershell
PowerShell 
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS /> 
~~~~

# PowerShellの動作を確認する

Microsoftの[Windows PowerShell コマンドレットのタスク別ガイド](https://technet.microsoft.com/ja-jp/scriptcenter/dd772285.aspx)を参考に、Linux版Powershellの動作を確認してみます。

WindowsでもPowerShellを使い慣れていないため、つまらない例なのはご容赦下さい。

## コマンドレット一覧の表示

とりあえず使えるコマンドレットの一覧を見てみます。
PowerShellでは、`Get-Command`コマンドレットで取得できます。
エイリアスなど余計なものも出力されますので`-CommandType Cmdlet`オプションでコマンドレットのみ出力しています。

~~~~
PS />Get-Command -CommandType Cmdlet

CommandType     Name                                               Version    Source                                                                          
-----------     ----                                               -------    ------                                                                          
Cmdlet          Add-Content                                        3.1.0.0    Microsoft.PowerShell.Management                                                 
Cmdlet          Add-History                                        3.0.0.0    Microsoft.PowerShell.Core                                                       
Cmdlet          Add-Member                                         3.1.0.0    Microsoft.PowerShell.Utility
# 以下省略
~~~~

今のところコマンドレットは213個あるようです。
サービスを表示する`Get-Service`など、Windowsのシステムに固有のコマンドレットは入っていないことがわかります。

完全な出力結果はgistに上げたので、興味のある方はご覧ください。

* [xmisao/powershell-for-every-system-commandlets.txt](https://gist.github.com/xmisao/b21ce53cd25e20db31652145f283037f)

## 日付の表示と計算

`Get-Date`コマンドレットで日付と時刻を表示してみます。

~~~~
PS /> Get-Date

Sunday, 21 August 2016 04:53:57
~~~~

`Get-Date`コマンドレットの出力する型を調べてみます。
`System.DateTime`型だとわかります。

~~~~
PS /> (Get-Date).GetType().FullName
System.DateTime
~~~~

サンプルに倣って現在時刻の137分後の日付と時刻を表示してみます。
PowerShellらしく`Get-Date`コマンドレットが出力が、オブジェクトだからできることです。

~~~~
PS /> (Get-date).AddMinutes(137)

Sunday, 21 August 2016 07:12:32
~~~~

## ドライブ一覧の表示

`Get-PSDrive`コマンドレットでドライブ一覧を確認してみます。 
この程度ならLinuxでも使えるようです。

Windowsであれば`Root`にはドライブレター付きのパスが出力されますが、Linuxにドライブレターはありませんので`/`から始まるパスが出力されているのが新鮮です。

~~~~
PS /> Get-PSDrive

Name           Used (GB)     Free (GB) Provider      Root                                                                           CurrentLocation
----           ---------     --------- --------      ----                                                                           ---------------
/                   0.89          8.83 FileSystem    /                                                                                             
Alias                                  Alias                                                                                                       
Cert                                   Certificate   \                                                                                             
Env                                    Environment                                                                                                 
Function                               Function                                                                                                    
Variable                               Variable                                                                                                    
~~~~


## プロセス一覧の表示

`Get-Process`コマンドレットでプロセス一覧を確認してみます。
この例ではDockerコンテナで動かしているので、プロセスIDが1でpowershellプロセスが起動しています。

~~~~
PS /> Get-Process

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName                                                                              
-------  ------    -----      -----     ------     --  -- -----------                                                                              
      0       0        0         21       5.39      1   1 powershell                                                                               
~~~~

## コマンドレットの実行結果をCSVやXMLで出力

先ほどのプロセス一覧を`Export-Csv`コマンドレットでCSVに出力して、`Get-Content`コマンドレットで表示してみます。

~~~~
PS /> Get-Process | Export-Csv process.csv
PS /> Get-Content process.csv                                                                                                                       
#TYPE System.Diagnostics.Process#HandleCount
"HandleCount","Name","SI","Handles","VM","WS","PM","NPM","Path","Company","CPU","FileVersion","ProductVersion","Description","Product","__NounName","SafeHandle","BasePriority","ExitCode","HasExited","ExitTime","Id","MachineName","MaxWorkingSet","MinWorkingSet","Modules","NonpagedSystemMemorySize64","PagedMemorySize64","PagedSystemMemorySize64","PeakPagedMemorySize64","PeakWorkingSet64","PeakVirtualMemorySize64","PriorityBoostEnabled","PriorityClass","PrivateMemorySize64","ProcessName","ProcessorAffinity","SessionId","StartInfo","Threads","VirtualMemorySize64","EnableRaisingEvents","StandardInput","StandardOutput","StandardError","WorkingSet64","MainModule","PrivilegedProcessorTime","StartTime","TotalProcessorTime","UserProcessorTime"
"0","powershell","1","0","3407556608","22524","0","0","/opt/microsoft/powershell/6.0.0-alpha.9/powershell",,"7.54",,,,,"Process","Microsoft.Win32.SafeHandles.SafeProcessHandle","0",,"False",,"1",".","9223372036854775807","0","System.Diagnostics.ProcessModuleCollection","0","0","0","0","0","0","False","Normal","0","powershell","3","1",,"System.Diagnostics.ProcessThreadCollection","3407556608","False",,,,"22524","System.Diagnostics.ProcessModule (powershell)","00:00:01.5000000","08/21/2016 04:01:38","00:00:07.5400000","00:00:06.0400000"
~~~~

`Export-Clixml`コマンドレットを使うとXMLに出力することもできます。

~~~~
PS /> Get-Process | Export-Clixml process.xml
PS /> Get-Content process.xml
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>System.Diagnostics.Process#HandleCount</T>
      <T>System.Diagnostics.Process</T>
      <T>System.Object</T>
    </TN>
    <ToString>System.Diagnostics.Process (powershell)</ToString>
# 以下省略
~~~~

なお、PowerShellにはHTMLで出力する`ConvertTo-Html`というコマンドレットもあるのですが、LinuxのPowerShellでは省かれているようです。

## ヘルプの表示

ヘルプの表示は`Get-Help`コマンドレットです。
ためしに`Get-Member`のヘルプを表示してみます。

~~~~
PS /> Get-Help Get-Member

NAME
    Get-Member
    
SYNOPSIS
    Gets the properties and methods of objects.

# 以下省略
~~~~

## PowerShellスクリプトの実行

ファイルに保存したPowerShellスクリプトを実行します。

`one.ps1`として以下の内容のファイルを作成します。
大変つまらない例ですが、正しく実行できれば`$x is 1.`と表示されるはずです。

~~~~
$x = 1
if($x -eq 1){
  Write-Output '$x is 1.'
}else{
  Write-Output '$x is not 1.'
}
~~~~

以下のように実行できます。

~~~~
PS /> ./one.ps1
$x is 1.
~~~~

なお`ls`で見たパーミッションは以下です。
実行権限は必要ないようです。

~~~~
PS /> ls -l one.ps1
-rw-r--r-- 1 root root 86 Aug 21 05:19 one.ps1
~~~~

## ループでも回してみる

1から10までループでも回してみます。
評価した結果がそのまま出力されるのがPowerShellらしいですね。

~~~~
PS /> for ($a = 1; $a -le 10; $a++) {$a}                                                                                                            
1
2
3
4
5
6
7
8
9
10
~~~~

## .NET Frameworkのクラスを呼び出す

最後に`String`クラスの`Format`メソッドを呼び出して、`255`という数値を、16進数に整形して表示してみます。

~~~~
PS /> [String]::Format("Hex: {0:x}", 255)
Hex: ff
~~~~

# おわりに

簡単ではありますが、PowerShellがLinuxでも動くことがわかりました。
本当はコマンドレットを作成したり、いろいろ踏み込んだ実験がしてみたかったのですが、このエントリはここまでです。

WindowsのPowerShellは、使いやすさに賛否両論ありそうですが、.NET Frameworkとの強力な連携や、パイプでオブジェクトを受け渡せる柔軟性など、従来のシェルにはなかった面白さのあるシェルだと思います。

Linuxで動いても、現状では具体的な活用シーン思い浮かびません。
しかし、Windowsの特徴的な機能の1つが、Windows以外のシステム上でも使えるようになったのは、喜ばしいことです。
