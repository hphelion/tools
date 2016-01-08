#!/bin/bash

#START="testBuild $BUILD_NUMBER on <b>$GIT_BRANCH</b>: $CHANGES_OR_CAUSE (View the <a href=\"${BUILD_URL}console\">build log</a>.) "



#rm -r ./docs.hpcloud.com.ditamap


function adjust_date_to_last_commit {
pwd
    cd $repo
pwd    
    for t in $(find . -name "*.dita");
    do
    	echo $repo : $t
        stat --format=%y $t
    	git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'
        echo""
    	touch -d "`git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'` " $t
        stat --format=%y $t
        echo""
	done
    cd -    
}
 





 

pwd
source ./tools/jenkins/publish-config.sh
cat    ./tools/jenkins/publish-config.sh
echo "

#################################################################

      devplat_docs_BRANCH = $devplat_docs_BRANCH
          hos_docs_BRANCH = $hos_docs_BRANCH
carrier_grade_docs_BRANCH = $carrier_grade_docs_BRANCH
 public_cloud_docs_BRANCH = $public_cloud_docs_BRANCH
          hcf_docs_BRANCH = $hcf_docs_BRANCH

#################################################################
"
 


repo="devplat.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${devplat_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit
    
	cp -rp ${repo}/devplatform/ ./
    cp -rp ${repo}/media/${repo} ./
    cp -rp ${repo}/*.ditamap ./
    cp -rp ${repo}/hdp-html/ ./
 
    rm -r $repo
 
 



repo="public.cloud.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${public_cloud_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}

	adjust_date_to_last_commit

	cp -rp ${repo}/file/ ./
	cp -rp ${repo}/publiccloud/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


repo="carrier.grade.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${carrier_grade_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit

	cp -rp ${repo}/media/${repo} ./
	cp -rp ${repo}/CarrierGrade/ ./
    cp -rp ${repo}/CarrierGrade2.0/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


repo="hcf.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${hcf_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}

	adjust_date_to_last_commit

	cp -rp ${repo}/media/${repo} ./
        cp -rp ${repo}/*.ditamap ./
	cp -rp ${repo}/hcf/ ./
    
	rm -r ${repo}

	
	
repo="hos.docs"
	echo "clone $repo"
 	rm -r $repo
	git clone -b ${hos_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit

	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./

    cp -rp ${repo}/hos-html/ ./
	cp -rp ${repo}/media/ ./
    cp -rp ${repo}/media/${repo} ./
    cp -rp ${repo}/*.ditamap ./
 
	rm -r ${repo}

#repo="cloud.system.docs"
#	echo "clone $repo"
#	rm -r $repo
#	git clone -b bundle-2015-may --single-branch git@github.com:hphelion/${repo}.git ${repo}
#good to here
#	adjust_date_to_last_commit
#exit 0;
#	cp -rp ${repo}/media/${repo} ./
#	cp -rp ${repo}/cloudsystem/ ./
 #   cp -rp ${repo}/*.ditamap ./

#	rm -r ${repo}
 #Bad here

#
#repo="mpc.docs"
#	echo "clone $repo"
#	rm -r $repo
#	git clone -b mpc --single-branch git@github.com:hphelion/${repo}.git ${repo}
#
#	adjust_date_to_last_commit
#
#	cp -rp ${repo}/media/${repo} ./
#    cp -rp ${repo}/*.ditamap ./
#
#	rm -rp ${repo}
#


 repo="wrapper.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b bundle-2015-may --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit

	cp -r ${repo}/* ./
   
    rm -r $repo

 

echo "Building HTML docs:"
 
if [ -z "$BRANCH_TO_BUILD" ]
then
	PUSHED_BY=`git log -1 | grep Author | sed 's|.*: \([^<]*\)<.*|\1|' | sed 's| .*||'`
    BRANCH=`echo $GIT_BRANCH | sed 's|.*\/||'`
    
else
    GIT_BRANCH=$BRANCH_TO_BUILD
    BRANCH=`echo $GIT_BRANCH | sed 's|.*\/||'`
    git checkout $BRANCH
    git pull
    PUSHED_BY=$BUILD_USER_FIRST_NAME
    
fi


 


echo "###"
 
echo $GIT_BRANCH
echo $BRANCH


#Don't build these branches:
if [ "$BRANCH" = "hos2.0ga" ] || [ "$BRANCH" = "ditaval-test" ]|| [ "$BRANCH" = "pdf_test" ]|| [ "$BRANCH" = "doc-split-test" ]
then
	exit 0
fi

echo "###"


#remove old output files
rm -r ./out/ || true

 
chmod -R 777 ./tools/jenkins/

./tools/jenkins/license.sh






./tools/jenkins/oxygen-webhelp-build.sh docs.hpcloud.com.ditamap	
#./tools/jenkins/inject_tableau_code.sh
#./tools/jenkins/inject_google_analytics.sh
#./tools/jenkins/insert_disclaimer.sh
./tools/jenkins/inject_redirects.sh





./tools/jenkins/inject_date.sh -file


 
 
#echo "copy start"
#sudo rm -r /var/www/html/dita-test-build/*
#sudo cp -r /var/lib/jenkins/workspace/helion-dita-build/out/webhelp/* /var/www/html/dita-test-build/
#sudo chmod -R 755 /var/www/html/dita-test-build/


cp -r ./commercial/GA1/RollYourOwn11/  out/webhelp/commercial/GA1/RollYourOwn11/
cp -r ./commercial/GA1/RollYourOwn10/  out/webhelp/commercial/GA1/RollYourOwn10/
cp -r ./media/ ./out/webhelp/
cp -r ./hcf/media ./out/webhelp/hcf/media
cp -r ./file/  out/webhelp/file/
cp -r ./ServerArtifacts/404.html  out/webhelp/404.html
cp -r ./ServerArtifacts/htaccess.with.rewrite.rules  out/webhelp/.htaccess
