#!/usr/bin/php
<?php

////////////////////////////////////////////////////////////////////
// Docs Build Script
//
// Created: Carter A. Thompson - December 9, 2016
//
// Modified:
//
//
////////////////////////////////////////////////////////////////////


// WORK IN PROGRESS


// Include class files.
include("lib/build.class.php");
include("lib/pdf.class.php");


// Create the build object
//
$build = new Build();

// Read cmd line options and conf.  Add contents from the conf to the
// object.
//
$build->getCmdLine();

// Initiate the build by printing info and setting up the environment.
//
$build->init();

// Get the source from Github.  The repos and branch which is cloned is
// located in the conf file.
//
$build->getSource();

// Run the build.
//
$build->runBuild();

// Post build actions.  Once html help is build, we need to modify some
// of the content.
//
$build->postActions();

//Push to staging server.  This moves the build to the staging server.
//
$build->pushToStaging();
	

?>


