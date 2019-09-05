# トレーニングコース用VirtualBoxイメージ作成メモ

Scientific Linux 7.7イメージを作成する。CentOS 7.7でも同様。

## VirtualBox側設定

- メモリー量は2GBにする。デフォルトの1GBだとSL GuestをGNOMEで起動したときswapが発生する。
- ディスク容量は16GBにする。デフォルトの8GBだとDAQ-Middleware, ROOTなどセットしたあと、
残り800MBになって心許ない。

## SL 7.7インストール

- 日本語環境でセットアップする。英語キーボード対応もあとから可能。
- General Purpose用を選択する。開発環境などはあとから追加する。
- General Purposeでインストールに15分かかる。

## リブート後の設定

- /etc/yum.repos.d/でリポジトリの向き先をftp.riken.jpに切りかえる。
- yum clean all; yum update
- yum groupinstall 'Development Tools'
- yum install kernel-devel (VirtualBox Guest Addtion用)
- reboot (新規kernelになっているかもしれないのでリブートしておく)
- VirtualBox Guest Addtionsをセット(VirtualBoxデバイスからGuest Addtions用ISOイメージを挿入。
CDROMアイコンをクリックしてRunを選ぶ
- /etc/defaul/grubでGRUB_CMDLINE_LINUXからrhgbを削除(ブート時にテキストでブート進捗具合を
表示させるため)。cd /boot/grub2; grub2-mkconfig -o grub.cfg
- reboot
- GNOMEメニュー右側電源ボタンをクリックして設定アイコン(ドライバとスパナのアイコン)をクリック。
「地域と言語」をえらび、「入力ソース」から「日本語(かな漢字)」を追加する。これでGNOMEメニュー
右側にjaと表示されるところで「日本語(かな漢字)が選べるようになり、漢字変換が可能になる。
切替えはSuper - Space (SuperはWindowsキー)でも切替え可能。さらに英語(US)を追加しておくと
英語キーボードを使ったときに記号の入力で困らなくなる。
- 画面左上隅にマウスがあたったとき、ウインドウ一覧になる機能を停止するには、
yum install gnome-tweak-tool gnome-shell-extension-no-hot-cornerして、
アプリケーション -> アクセサリ -> Tweaks -> 拡張機能 -> No topleft hot cornerをONにする。
- ウインドウ上枠がメニューバーについたときにそのウインドウを最大化するのを止めるには以下のコマンド
を実行する:

    gsettings set org.gnome.mutter auto-maximize false
    gsettings set org.gnome.shell.overrides edge-tiling false
    gsettings set org.gnome.shell.extensions.classic-overrides edge-tiling false

- その他の開発ツール

    yum -y install zsh mercurial screen redhat-lsb-core nmap-ncat telnet tcpdump wireshark-gnome
    yum -y install lsof bind-utils strace ltrace man-pages wget vim
    yum -y insatll emacs

## DAQ-Middleware関連パッケージ、設定

- vimrcサンプル。DAQ-Middlewareのソースコードはインデントが4個のスペースに
なっているので、そのようになるようなvimrcサンプルを入れておく。使うには
cd; ln -s vimrc .vimrcしてもらう。

- yum install boost-devel libuuid-devel mod_wsgi
- ROOTの設定。http://daqmw.kek.jp/src/root-5.34.24.sl7-x86_64.bin.tar.xz をダウンロードし
tar xf root-5.34.24.sl7-x86_64.bin.tar.xz -C /usr/local。/etc/ld.so.conf.d/root.confを
作り、/usr/local/root/libと書く。書いたあとldconfigを実行。
/home/daq/.bashrcあたりにROOTSYSの定義、パスの追加を書く。

    if [ -f /usr/local/root/bin/root ]; then
        export ROOTSYS=/usr/local/root
        PATH=$PATH:${ROOTSYS}/bin
    fi
- ROOT用フォントの追加。xorg-x11-fonts-75dpi xorg-x11-fonts-100dpi xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-1-100dpi
- SELinuxをpermissiveに: /etc/selinux/configでSELINUX=permissiveに変更(リブートが必要)
- httpdの自動起動: systemctl enable httpd
- firewalldの停止: systemctl disable firewalld

## DAQ-Middlewareのセット

daqmw-rpmをダウンロードしてDAQ-Middlewareをセットする:

    wget http://daqmw.kek.jp/src/daqmw-rpm
    sudo sh daqmw-rpm install

コンソールモードのテスト:

    cd; mkdir MyDaq
    cp -r /usr/share/daqmw/example/SampleReader
    cp -r /usr/share/daqmw/example/SampleLogger
    cp -r /usr/share/daqmw/example/SampleMonitor
    cd SampleReader
    make
    cd ../SampleLogger
    make
    cd ..
    cp /usr/share/daqmw/conf/reader-logger.xml .
    (別ターミナルエミュレータを開いて)
    daqmw-emulator
    (元のターミナルエミュレータに戻って)
    run.py -cl
    cd SampleMonitor
    make
    cd ..
    cp /usr/share/daqmw/conf/sample.xml .
    run.py -cl sample.xml

Webモードも同様にテストする。

## VirtualBoxイメージをzipでまとめる作業

動作確認などに使ったファイルは全て消しておく:

    cd
    rm -fr daqmw-tc-virtualbox
    rm -fr MyDaq
    rm -f .ssh/*

zipにまとめてWebサイトに転送。
