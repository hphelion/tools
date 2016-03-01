#!/bin/bash

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
 
mkdir ./media

repo="devplat.docs"
	echo "clone $repo"
	rm -r $repo
	if ! git clone -b ${devplat_docs_BRANCH} --single-branch  --depth 1 git@github.com:hphelion/${repo}.git ${repo}
	then
		echo >&2 Cloning git@github.com:hphelion/${repo}.git faild.  Stopping the build.
		exit 1
	fi
	
    
    adjust_date_to_last_commit
    
	cp -rp ${repo}/devplatform/ ./
   # cp -rp ${repo}/media/${repo} ./
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
    cp -rp ${repo}/hdp-html/ ./
 
    rm -r $repo
 
  
#repo="public.cloud.docs"
#	echo "clone $repo"
#	rm -r $repo
#	git clone -b ${public_cloud_docs_BRANCH} --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
#
#	adjust_date_to_last_commit
#
#	cp -rp ${repo}/file/ ./
#	cp -rp ${repo}/publiccloud/ ./
#   cp -rp ${repo}/*.ditamap ./
#
#	rm -r ${repo}


repo="carrier.grade.docs"
	echo "clone $repo"
	rm -r $repo
	if ! git clone -b ${carrier_grade_docs_BRANCH} --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
	then
		echo >&2 Cloning git@github.com:hphelion/${repo}.git faild.  Stopping the build.
		exit 1
	fi

	
	
	
    adjust_date_to_last_commit

	cp -rp ${repo}/media/${repo} ./media/${repo}
	cp -rp ${repo}/CarrierGrade/ ./
        cp -rp ${repo}/CarrierGrade2.0/ ./
        cp -rp ${repo}/CarrierGrade2.1/ ./
        cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


repo="hcf.docs"
	echo "clone $repo"
	rm -r $repo
	if ! git clone -b ${hcf_docs_BRANCH} --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
	then
		echo >&2 Cloning git@github.com:hphelion/${repo}.git faild.  Stopping the build.
		exit 1
	fi


	adjust_date_to_last_commit

	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
	cp -rp ${repo}/hcf/ ./
    
	rm -r ${repo}

	
	
repo="hos.docs"
	echo "clone $repo"
 	rm -r $repo
	if ! git clone -b ${hos_docs_BRANCH} --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
	then
		echo >&2 Cloning git@github.com:hphelion/${repo}.git faild.  Stopping the build.
		exit 1
	fi
    
    adjust_date_to_last_commit

	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./
    cp -rp ${repo}/hos-html/ ./
	cp -rp ${repo}/media/ ./
    cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
 
	rm -r ${repo}

 
 repo="wrapper.docs"
	echo "clone $repo"
	rm -r $repo
	if ! git clone -b bundle-2015-may --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
	then
		echo >&2 Cloning git@github.com:hphelion/${repo}.git faild.  Stopping the build.
		exit 1
	fi
    
    adjust_date_to_last_commit

	cp -r ${repo}/* ./
   
    rm -r $repo

 
 
