         netcounter=0;
         netimages = [

    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleExternalVM.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleExternalAPI.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleGuest.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleProviderVLANS.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleOctavia.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleManagement.png',
    'http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleAllNetworks.png'];

var getnetworks=document.getElementsByClassName('entryScale');

getnetworks[0].innerHTML='<div id="allmaps" oncontextmenu="noclick(); return false;"><img id="solid" src="http://docs.hpcloud.com/3.x/media/entryScale/Entry-ScaleAllNetworks.png"><img id="all2" src="http://docs.hpcloud.com/3.x/media/entryScale/Entry-Scale-2pxBorder.png"  border="0"<img id="entryScale" src="http://docs.hpcloud.com/3.x/media/entryScale/Entry-Scale-2pxBorder.png" border="0" width="1000" height="900" orgWidth="1000" orgHeight="900" usemap="#entryScale" alt="" /><map name="entryScale"><area  alt="" title="EXTERNAL-VM" href="#" shape="rect" coords="13,63,130,86" style="outline:none;" onclick="changeimg(0);"     /><area  alt="" title="EXTERNAL-API" href="#" shape="rect" coords="13,91,137,114" style="outline:none;" onclick="changeimg(1);"     /><area  alt="" title="GUEST" href="#" shape="rect" coords="5,141,129,164" style="outline:none;" onclick="changeimg(2);"     /><area  alt="" title="Provider VLANs" href="#" shape="rect" coords="5,167,129,190" style="outline:none;" onclick="changeimg(3);"     /><area  alt="" title="OCTAVIA-MGMT" href="#" shape="rect" coords="7,191,131,210" style="outline:none;" onclick="changeimg(4);"     /><area  alt="" title="MANAGEMENT" href="#" shape="rect" coords="8,211,132,233" style="outline:none;" onclick="changeimg(5);"     /><area  alt="" title="All Networks" href="#" shape="rect" coords="5,234,130,256" style="outline:none;" onclick="changeimg(6);"     /></map>';
