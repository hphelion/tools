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
 




rm -r *


git clone -b master --single-branch git@github.com:hphelion/tools.git
 

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
 
    rm -r $repo
 
 
repo="hos.docs"
	echo "clone $repo"
 	rm -r $repo
	git clone -b ${hos_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit

	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./
	cp -rp ${repo}/media/ ./
    cp -rp ${repo}/media/${repo} ./
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


repo="public.cloud.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${public_cloud_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}

	adjust_date_to_last_commit

	cp -rp ${repo}/file/ ./
	cp -rp ${repo}/publiccloud/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}



repo="hcf.docs"
	echo "clone $repo"
	rm -r $repo
	git clone -b ${hcf_docs_BRANCH} --single-branch git@github.com:hphelion/${repo}.git ${repo}

	adjust_date_to_last_commit

	cp -rp ${repo}/media/${repo} ./
    cp -rp ${repo}/*.ditamap ./
    
	rm -r ${repo}