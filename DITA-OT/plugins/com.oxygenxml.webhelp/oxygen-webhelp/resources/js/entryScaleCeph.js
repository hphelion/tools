
         netcounter=0;
         netimages = [

    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-ExternalVM.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-ExternalAPI.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-Guest.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-ProviderVLANS.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-Octavia.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-Management.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-AllNetworks.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-OSDClient.png', 
    'http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-OSDInternal.png'
    ];

var getnetworks=document.getElementsByClassName('entryScaleCeph');
getnetworks[0].innerHTML='<div id="allmaps" oncontextmenu="noclick(); return false;"><img id="solid" src="http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-AllNetworks.png"><img id="all3" src="http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph--2pxBorder.png"  border="0"<img id="entryScaleCeph" src="http://docs.hpcloud.com/3.x/media/entryScaleCeph/Entry-Scale-Ceph-2pxBorder.png" border="0" width="1000" height="1000" orgWidth="1000" orgHeight="1000" usemap="#entryScaleCeph" alt="" /><map name="entryScaleCeph"><area  alt="" title="EXTERNAL-VM" href="#" shape="rect" coords="12,64,140,87" style="outline:none;" onclick="changeimg(0);"      /><area  alt="" title="EXTERNAL-API" href="#" shape="rect" coords="12,92,140,115" style="outline:none;" onclick="changeimg(1);"      /><area  alt="" title="OSD Client" href="#" shape="rect" coords="4,143,132,166" style="outline:none;" onclick="changeimg(2);"      /><area  alt="" title="OSD Internal" href="#" shape="rect" coords="0,168,128,189" style="outline:none;" onclick="changeimg(3);"      /><area  alt="" title="GUEST" href="#" shape="rect" coords="4,190,133,210" style="outline:none;" onclick="changeimg(4);"      /><area  alt="" title="Provider VLANs" href="#" shape="rect" coords="4,212,133,227" style="outline:none;" onclick="changeimg(5);"      /><area  alt="" title="OCTAVIA-MGMT" href="#" shape="rect" coords="0,231,132,247" style="outline:none;" onclick="changeimg(6);"      /><area  alt="" title="MANAGEMENT" href="#" shape="rect" coords="4,251,133,266" style="outline:none;" onclick="changeimg(7);"      /><area  alt="" title="All Networks" href="#" shape="rect" coords="0,274,128,299" style="outline:none;" onclick="changeimg(8);"      /></map>';
