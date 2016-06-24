netcounter=0;
netimages = [

    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-External-VM.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-External-API.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Internal-API.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Swift.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-ISCSI.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Guest.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Provider.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Octavia.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Management.png',
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-Conf.png', 
    'http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-AllNetworks.png'];

var getnetworks=document.getElementsByClassName('midScaleAllNetworks');
getnetworks[0].innerHTML='<div id="allmaps" oncontextmenu="noclick(); return false;"><img id="solid" src="http://docs.hpcloud.com/3.x/media/networkImages/Mid-Scale-AllNetworks.png"><img id="all" src="http://docs.hpcloud.com/3.x/media/networkImages/clear.png" border="0" width="1000" height="800" orgWidth="1000" orgHeight="800" usemap="#networks" alt="" /><map name="networks" id="allnets"><area  alt="" title="All Networks" href="#" shape="rect" coords="2,323,135,365" style="outline:none;"  onclick="changeimg(10);"      /><area class="spot"  id="n0" alt="" title="EXTERNAL-VM" href="#" shape="rect" coords="16,67,128,88" style="outline:none;"  onclick="changeimg(0);"      /><area class="spot"   id="n1" alt="" title="EXTERNAL-API" href="#" shape="rect" coords="12,93,128,117" style="outline:none;"  onclick="changeimg(1);"      /><area class="spot" id="n2"  alt="" title="INTERNAL-API" href="#" shape="rect" coords="16,143,132,167" style="outline:none;"  onclick="changeimg(2);"      /><area class="spot" id="n3"  alt="" title="SWIFT" href="#" shape="rect" coords="12,170,128,188" style="outline:none;"  onclick="changeimg(3);"      /><area class="spot" id="n4"  alt="" title="ISCSI" href="#" shape="rect" coords="11,190,140,211" style="outline:none;"  onclick="changeimg(4);"      /><area class="spot"  id="n5" alt="" title="GUEST (vxlan)" href="#" shape="rect" coords="11,213,140,230" style="outline:none;"  onclick="changeimg(5);"      /><area class="spot"  id="n6" alt="" title="Provider VLANs" href="#" shape="rect" coords="12,231,141,249" style="outline:none;"  onclick="changeimg(6);"      /><area class="spot" id="n7"  alt="" title="OCTAVIA-MGMT" href="#" shape="rect" coords="9,250,134,271" style="outline:none;"  onclick="changeimg(7);"      /><area class="spot" id="n8"  alt="" title="MANAGEMENT" href="#" shape="rect" coords="5,273,138,291" style="outline:none;"  onclick="changeimg(8);"      /><area class="spot" id="n9"  alt="" title="CONF" href="#" shape="rect" coords="4,292,132,313" style="outline:none;"  onclick="changeimg(9);"      /></map></div>';
