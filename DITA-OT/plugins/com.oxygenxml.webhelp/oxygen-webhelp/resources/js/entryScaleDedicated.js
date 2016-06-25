
         netcounter=0;
         netimages = [

    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedExternalVM.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedExternalAPI.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedGuest.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedProviderVLANS.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedOctavia.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedManagement.png',
    'http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicatedAllNetworks.png',

var getnetworks=document.getElementsByClassName('entryScaleDedicated');

getnetworks[0].innerHTML='<div id="allmaps" oncontextmenu="noclick(); return false;"><img id="solid" src="http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicated-2pxBorder.png" border="0" width="1000" height="900" orgWidth="1000" orgHeight="900" usemap="#entryScaleDedicated" alt="" /><img id="all" src="http://docs.hpcloud.com/3.x/media/entryScaleDed/Entry-ScaleDedicated-2pxBorder.png" border="0" width="1000" height="900" orgWidth="1000" orgHeight="900" usemap="#networks" alt="" /><map name="networks" id="allnets"><area  alt="" title="" href="#" hape="rect" coords="16,66,121,87" style="outline:none;"  onclick="changeimg(0);"     /><area  alt="" title="" href="#" shape="rect" coords="16,94,131,114" style="outline:none;"  onclick="changeimg(1);"     /><area  alt="" title="" href="#" shape="rect" coords="9,141,131,165" style="outline:none;"  onclick="changeimg(2);"     /><area  alt="" title="" href="#" shape="rect" coords="12,169,128,190" style="outline:none;"  onclick="changeimg(3);"     />
<area  alt="" title="" href="#" shape="rect" coords="2,192,131,209" style="outline:none;"  onclick="changeimg(4);"     /><area  alt="" title="" href="#" shape="rect" coords="2,213,128,234" style="outline:none;"  onclick="changeimg(5);"     /><area  alt="" title="All Networks" href="#" shape="rect" coords="5,227,174,260" style="outline:none;"  onclick="changeimg(6);"     /></map></div>';
