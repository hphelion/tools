#!/bin/bash

#Set some variables and functions
source <(curl -s https://raw.githubusercontent.com/hphelion/tools/master/jenkins/functionLibrary.sh)

#Set the variable to whatever was passed to this script.
HIPCHAT_ROOM="$1"

#Set the variables that define the publish branch for all repos
source ./tools/jenkins/publish-config.sh
 
#write publish branch variables to stdout so we know what is going on 
echo "

#################################################################

      devplat_docs_BRANCH = $devplat_docs_BRANCH
          hos_docs_BRANCH = $hos_docs_BRANCH
          hos_docs_LEGACYBRANCH = $hos_docs_LEGACYBRANCH
carrier_grade_docs_BRANCH = $carrier_grade_docs_BRANCH
 public_cloud_docs_BRANCH = $public_cloud_docs_BRANCH
          hcf_docs_BRANCH = $hcf_docs_BRANCH

#################################################################
"


 
#find . -name docs.hpcloud.com.HDP.ditamap
################################################################################

 
# For each repo, clone it and checkout publish branch, adjust the modification
# date of the ditafiles to the date of the last commit copy files into place
# for the final build.
 
    repo="hos.docs"
	branch="$hos_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	mkdir media
    cp -rp ${repo}/community/ ./3.x/
    cp -rp ${repo}/commercial/ ./3.x/
    cp -rp ${repo}/helion/ ./3.x/
    cp -rp ${repo}/hos-html/ ./3.x/
	cp -rp ${repo}/media/ ./3.x/media/
    cp -rp ${repo}/media/${repo} ./3.x/media/${repo}
    cp -rp ${repo}/*.ditamap ./3.x/
	rm -r ${repo}

	


	repo="devplat.docs"
	branch="$devplat_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/devplatform/ ./
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
    cp -rp ${repo}/hdp-html/ ./
 
    rm -r $repo
 


	repo="carrier.grade.docs"
	branch="$carrier_grade_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/media/${repo} ./media/${repo}
	cp -rp ${repo}/CarrierGrade/ ./
    cp -rp ${repo}/CarrierGrade2.0/ ./
    cp -rp ${repo}/CarrierGrade2.1/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


	repo="hcf.docs"
	branch="$hcf_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
	cp -rp ${repo}/hcf/ ./
    
	rm -r ${repo}


	
	repo="hos.docs"
	branch="$hos_docs_LEGACYBRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./
    cp -rp ${repo}/hos-html/ ./
	cp -rp ${repo}/media/* ./media/
    cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
 
	rm -r ${repo}
	

	repo="wrapper.docs"
	branch="bundle-2015-may"
	clone_repo $repo $branch
    adjust_date_to_last_commit

	cp -r ${repo}/* ./
   
    rm -r ${repo}



 
