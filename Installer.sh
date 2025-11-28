GOINFRE="/home/$USER/goinfre"
FILES="$GOINFRE/tmp_install_files"
TSHELL="/home/$USER/.zshrc"
LCURL="https://master.dl.sourceforge.net/project/curl.mirror/curl-8_17_0/curl-8.17.0.tar.bz2?viasf=1"
LZIP="https://sf-eu-introserv-1.dl.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz?viasf=1"
LUNZIP="https://sf-eu-introserv-1.dl.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz?viasf=1"

vcpkg --version

if [ $? -ne 0 ] ; then
	rm -rf "$FILES"; mkdir -p "$FILES"
	rm -rf $GOINFRE/zip $GOINFRE/unzip

	curl --version

	if [ $? -ne 0 ] ; then
		echo -e "\n[*] Install Curl before running the script !"; exit 1
	fi 

	tar --version 

	if [ $? -ne 0 ] ; then
		echo -e "\n[*] Install tar before running the script !"; exit 1
	fi 

	zip --version 

	if [ $? -ne 0 ] ; then
		rm -rf $GOINFRE/zip 
		mkdir $GOINFRE/zip

		curl -L $LZIP -o $FILES/zip.tar

		if [ $? -ne 0 ] ; then
			echo -e "\n[*] Error Downloading the zip.tar !"; exit 1
		fi 

		tar xf $FILES/zip.tar -C $GOINFRE/zip --strip-components=1

		if [ $? -ne 0 ] ; then
			echo -e "\n[*] Error Extracting the zip.tar !"; exit 1
		fi 
		cd $GOINFRE/zip
		make -f unix/Makefile generic  >> /dev/null

		if [ $? -eq 0 ] ; then
			echo -e "\n[*] Success Installing the zip !"

		else 
			echo -e "\n[*] Error Compiling the zip !"; exit 1
		fi 
		
	fi 

	unzip --version

	if [ $? -ne 0 ] ; then
		rm -rf $GOINFRE/unzip 
		mkdir $GOINFRE/unzip
	
		curl -L $LUNZIP -o $FILES/unzip.tar

		if [ $? -ne 0 ] ; then
			echo -e "\n[*] Error Downloading the unzip.tar !"; exit 1
		fi 
			
		tar xf $FILES/unzip.tar -C $GOINFRE/unzip --strip-components=1

		if [ $? -ne 0 ] ; then
			echo -e "\n[*] Error Extracting the zip.tar !"; exit 1
		fi 

		cd $GOINFRE/unzip
		make -f unix/Makefile generic >> /dev/null

		if [ $? -eq 0 ] ; then
			echo -e "\n[*] Success Installing the unzip !"

		else 
			echo -e \"\n[*] Error Compiling the unzip !\"; exit 1
		fi 
		#rm -rf /home/$USER/.local/bin/unzip /home/$USER/.local/bin/unzip /home/$USER/.local/bin/vcpkg
		#ln -s $GOINFRE/unzip /home/$USER/.local/bin/unzip ; ln -s $GOINFRE/zip /home/$USER/.local/bin/zip
		echo "export PATH=$GOINFRE/zip:$GOINFRE/unzip:$GOINFRE/vcpkg:\$PATH" >> $TSHELL
		. $TSHELL

	fi


	cd $GOINFRE
	rm -rf $GOINFRE/vcpkg

	git clone https://github.com/microsoft/vcpkg.git vcpkg

	if [ $? -ne 0 ] ; then
		echo -e "\n[*] Error While Cloning vcpkg.git"; exit 1
	fi 

    cd vcpkg
    ./bootstrap-vcpkg.sh

	if [ $? -ne 0 ] ; then
		echo -e "\n[*] Failure Running bootstrap-vcpkg.sh"; exit 1
	
	else
		echo -e "\n[*] Success Installing vcpkg !"
		echo "export CPLUS_INCLUDE_PATH=$GOINFRE/vcpkg/installed/x64-linux/include:$CPLUS_INCLUDE_PATH" >> $TSHELL
		echo "export LIBRARY_PATH=$GOINFRE/vcpkg/installed/x64-linux/lib:$LIBRARY_PATH" >> $TSHELL
		echo "export LD_LIBRARY_PATH=$GOINFRE/vcpkg/installed/x64-linux/lib:$LD_LIBRARY_PATH" >> $TSHELL
		. $TSHELL
	fi
fi 
