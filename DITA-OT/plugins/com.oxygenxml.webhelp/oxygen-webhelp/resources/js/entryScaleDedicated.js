
         netcounter=0;
         netimages = [

    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedExternalVM.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedExternalAPI.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedGuest.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedProviderVLANS.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedOctavia.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedManagement.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedAllNetworks.png'];

var getnetworks=document.getElementsByClassName('entryScaleDedicated');

getnetworks[0].innerHTML='<div id="allmaps" oncontextmenu="noclick(); return false;"><img id="solid" src="http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedAllNetworks.png"><img id="all" src="http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicated-2pxBorder.png"  border="0"<img id="entryScaleDedicated" src="http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicated-2pxBorder.png" border="0" width="1000" height="900" orgWidth="1000" orgHeight="900" usemap="#entryScaleDedicated" alt="" /><map name="entryScaleDedicated"><area  alt="" title="EXTERNAL-VM" href="#" shape="rect" coords="14,73,150,87" style="outline:none;"  onclick="changeimg(0);"      /><area  alt="" title="EXTERNAL-API" href="#" shape="rect" coords="10,94,146,108" style="outline:none;"  onclick="changeimg(1);"      /><area  alt="" title="GUEST" href="#" shape="rect" coords="11,149,140,167" style="outline:none;"  onclick="changeimg(2);"      /><area  alt="" title="Provider VALNS" href="#" shape="rect" coords="0,170,140,188" style="outline:none;"  onclick="changeimg(3);"      /><area  alt="" title="OCTAVIA-MGMT" href="#" shape="rect" coords="0,190,133,206" style="outline:none;"  onclick="changeimg(4);"      /><area  alt="" title="MANAGEMENT" href="#" shape="rect" coords="4,211,140,229" style="outline:none;"  onclick="changeimg(5);"      /><area  alt="" title="All Networks" href="#" shape="rect" coords="3,232,140,254" style="outline:none;"  onclick="changeimg(6);"      /></map>';
