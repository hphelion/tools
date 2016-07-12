/*

Oxygen Webhelp plugin
Copyright (c) 1998-2014 Syncro Soft SRL, Romania.  All rights reserved.
Licensed under the terms stated in the license file EULA_Webhelp.txt 
available in the base directory of this Oxygen Webhelp plugin.

*/

function feedback(){
if (window.location.href.indexOf("/helion/")  > -1  || window.location.href.indexOf("devplatform/2.0/") > -1 || window.location.href.indexOf("CarrierGrade2.0") > -1 ) {
var topic=document.getElementsByTagName("title")[0].innerHTML ;
var tmp=topic.replace(/<[^>]*>/, "");
var topic=tmp.replace(/<\/[^>]*>/, "");

document.getElementById("feedback").innerHTML = "<a href=\"mailto:heliondocs@hpe.com?subject=Feedback on '"+topic+"'&body=Thank you for providing the Helion Documentation Team with feedback about this topic!  Please replace this text with your feedback.%0D%0A %0D%0ALeave the title unchanged, because this will make it clear to us what topic you are providing feedback about.  If you need support, please contact your HPE Support representative.%0D%0A %0D%0AThanks for helping us improve the documentation!\">Feedback to the Helion Docs Team</a>  ";
}else {document.getElementById("feedback").style.display = "none";}
}


/**
 * @description Get location used for "Link to this page"
 * @param currentUrl URL of current loaded page (frame)
 * @returns {string|*}
 */
 
 /*Nancy's sorter code*/
 
(function($){$.extend({tablesorter:new
function(){var parsers=[],widgets=[];this.defaults={cssHeader:"header",cssAsc:"headerSortUp",cssDesc:"headerSortDown",cssChildRow:"expand-child",sortInitialOrder:"asc",sortMultiSortKey:"shiftKey",sortForce:null,sortAppend:null,sortLocaleCompare:true,textExtraction:"simple",parsers:{},widgets:[],widgetZebra:{css:["even","odd"]},headers:{},widthFixed:false,cancelSelection:true,sortList:[],headerList:[],dateFormat:"us",decimal:'/\.|\,/g',onRenderHeader:null,selectorHeaders:'thead th',debug:false};function benchmark(s,d){log(s+","+(new Date().getTime()-d.getTime())+"ms");}this.benchmark=benchmark;function log(s){if(typeof console!="undefined"&&typeof console.debug!="undefined"){console.log(s);}else{alert(s);}}function buildParserCache(table,$headers){if(table.config.debug){var parsersDebug="";}if(table.tBodies.length==0)return;var rows=table.tBodies[0].rows;if(rows[0]){var list=[],cells=rows[0].cells,l=cells.length;for(var i=0;i<l;i++){var p=false;if($.metadata&&($($headers[i]).metadata()&&$($headers[i]).metadata().sorter)){p=getParserById($($headers[i]).metadata().sorter);}else if((table.config.headers[i]&&table.config.headers[i].sorter)){p=getParserById(table.config.headers[i].sorter);}if(!p){p=detectParserForColumn(table,rows,-1,i);}if(table.config.debug){parsersDebug+="column:"+i+" parser:"+p.id+"\n";}list.push(p);}}if(table.config.debug){log(parsersDebug);}return list;};function detectParserForColumn(table,rows,rowIndex,cellIndex){var l=parsers.length,node=false,nodeValue=false,keepLooking=true;while(nodeValue==''&&keepLooking){rowIndex++;if(rows[rowIndex]){node=getNodeFromRowAndCellIndex(rows,rowIndex,cellIndex);nodeValue=trimAndGetNodeText(table.config,node);if(table.config.debug){log('Checking if value was empty on row:'+rowIndex);}}else{keepLooking=false;}}for(var i=1;i<l;i++){if(parsers[i].is(nodeValue,table,node)){return parsers[i];}}return parsers[0];}function getNodeFromRowAndCellIndex(rows,rowIndex,cellIndex){return rows[rowIndex].cells[cellIndex];}function trimAndGetNodeText(config,node){return $.trim(getElementText(config,node));}function getParserById(name){var l=parsers.length;for(var i=0;i<l;i++){if(parsers[i].id.toLowerCase()==name.toLowerCase()){return parsers[i];}}return false;}function buildCache(table){if(table.config.debug){var cacheTime=new Date();}var totalRows=(table.tBodies[0]&&table.tBodies[0].rows.length)||0,totalCells=(table.tBodies[0].rows[0]&&table.tBodies[0].rows[0].cells.length)||0,parsers=table.config.parsers,cache={row:[],normalized:[]};for(var i=0;i<totalRows;++i){var c=$(table.tBodies[0].rows[i]),cols=[];if(c.hasClass(table.config.cssChildRow)){cache.row[cache.row.length-1]=cache.row[cache.row.length-1].add(c);continue;}cache.row.push(c);for(var j=0;j<totalCells;++j){cols.push(parsers[j].format(getElementText(table.config,c[0].cells[j]),table,c[0].cells[j]));}cols.push(cache.normalized.length);cache.normalized.push(cols);cols=null;};if(table.config.debug){benchmark("Building cache for "+totalRows+" rows:",cacheTime);}return cache;};function getElementText(config,node){var text="";if(!node)return"";if(!config.supportsTextContent)config.supportsTextContent=node.textContent||false;if(config.textExtraction=="simple"){if(config.supportsTextContent){text=node.textContent;}else{if(node.childNodes[0]&&node.childNodes[0].hasChildNodes()){text=node.childNodes[0].innerHTML;}else{text=node.innerHTML;}}}else{if(typeof(config.textExtraction)=="function"){text=config.textExtraction(node);}else{text=$(node).text();}}return text;}function appendToTable(table,cache){if(table.config.debug){var appendTime=new Date()}var c=cache,r=c.row,n=c.normalized,totalRows=n.length,checkCell=(n[0].length-1),tableBody=$(table.tBodies[0]),rows=[];for(var i=0;i<totalRows;i++){var pos=n[i][checkCell];rows.push(r[pos]);if(!table.config.appender){var l=r[pos].length;for(var j=0;j<l;j++){tableBody[0].appendChild(r[pos][j]);}}}if(table.config.appender){table.config.appender(table,rows);}rows=null;if(table.config.debug){benchmark("Rebuilt table:",appendTime);}applyWidget(table);setTimeout(function(){$(table).trigger("sortEnd");},0);};function buildHeaders(table){if(table.config.debug){var time=new Date();}var meta=($.metadata)?true:false;var header_index=computeTableHeaderCellIndexes(table);$tableHeaders=$(table.config.selectorHeaders,table).each(function(index){this.column=header_index[this.parentNode.rowIndex+"-"+this.cellIndex];this.order=formatSortingOrder(table.config.sortInitialOrder);this.count=this.order;if(checkHeaderMetadata(this)||checkHeaderOptions(table,index))this.sortDisabled=true;if(checkHeaderOptionsSortingLocked(table,index))this.order=this.lockedOrder=checkHeaderOptionsSortingLocked(table,index);if(!this.sortDisabled){var $th=$(this).addClass(table.config.cssHeader);if(table.config.onRenderHeader)table.config.onRenderHeader.apply($th);}table.config.headerList[index]=this;});if(table.config.debug){benchmark("Built headers:",time);log($tableHeaders);}return $tableHeaders;};function computeTableHeaderCellIndexes(t){var matrix=[];var lookup={};var thead=t.getElementsByTagName('THEAD')[0];var trs=thead.getElementsByTagName('TR');for(var i=0;i<trs.length;i++){var cells=trs[i].cells;for(var j=0;j<cells.length;j++){var c=cells[j];var rowIndex=c.parentNode.rowIndex;var cellId=rowIndex+"-"+c.cellIndex;var rowSpan=c.rowSpan||1;var colSpan=c.colSpan||1
var firstAvailCol;if(typeof(matrix[rowIndex])=="undefined"){matrix[rowIndex]=[];}for(var k=0;k<matrix[rowIndex].length+1;k++){if(typeof(matrix[rowIndex][k])=="undefined"){firstAvailCol=k;break;}}lookup[cellId]=firstAvailCol;for(var k=rowIndex;k<rowIndex+rowSpan;k++){if(typeof(matrix[k])=="undefined"){matrix[k]=[];}var matrixrow=matrix[k];for(var l=firstAvailCol;l<firstAvailCol+colSpan;l++){matrixrow[l]="x";}}}}return lookup;}function checkCellColSpan(table,rows,row){var arr=[],r=table.tHead.rows,c=r[row].cells;for(var i=0;i<c.length;i++){var cell=c[i];if(cell.colSpan>1){arr=arr.concat(checkCellColSpan(table,headerArr,row++));}else{if(table.tHead.length==1||(cell.rowSpan>1||!r[row+1])){arr.push(cell);}}}return arr;};function checkHeaderMetadata(cell){if(($.metadata)&&($(cell).metadata().sorter===false)){return true;};return false;}function checkHeaderOptions(table,i){if((table.config.headers[i])&&(table.config.headers[i].sorter===false)){return true;};return false;}function checkHeaderOptionsSortingLocked(table,i){if((table.config.headers[i])&&(table.config.headers[i].lockedOrder))return table.config.headers[i].lockedOrder;return false;}function applyWidget(table){var c=table.config.widgets;var l=c.length;for(var i=0;i<l;i++){getWidgetById(c[i]).format(table);}}function getWidgetById(name){var l=widgets.length;for(var i=0;i<l;i++){if(widgets[i].id.toLowerCase()==name.toLowerCase()){return widgets[i];}}};function formatSortingOrder(v){if(typeof(v)!="Number"){return(v.toLowerCase()=="desc")?1:0;}else{return(v==1)?1:0;}}function isValueInArray(v,a){var l=a.length;for(var i=0;i<l;i++){if(a[i][0]==v){return true;}}return false;}function setHeadersCss(table,$headers,list,css){$headers.removeClass(css[0]).removeClass(css[1]);var h=[];$headers.each(function(offset){if(!this.sortDisabled){h[this.column]=$(this);}});var l=list.length;for(var i=0;i<l;i++){h[list[i][0]].addClass(css[list[i][1]]);}}function fixColumnWidth(table,$headers){var c=table.config;if(c.widthFixed){var colgroup=$('<colgroup>');$("tr:first td",table.tBodies[0]).each(function(){colgroup.append($('<col>').css('width',$(this).width()));});$(table).prepend(colgroup);};}function updateHeaderSortCount(table,sortList){var c=table.config,l=sortList.length;for(var i=0;i<l;i++){var s=sortList[i],o=c.headerList[s[0]];o.count=s[1];o.count++;}}function multisort(table,sortList,cache){if(table.config.debug){var sortTime=new Date();}var dynamicExp="var sortWrapper = function(a,b) {",l=sortList.length;for(var i=0;i<l;i++){var c=sortList[i][0];var order=sortList[i][1];var s=(table.config.parsers[c].type=="text")?((order==0)?makeSortFunction("text","asc",c):makeSortFunction("text","desc",c)):((order==0)?makeSortFunction("numeric","asc",c):makeSortFunction("numeric","desc",c));var e="e"+i;dynamicExp+="var "+e+" = "+s;dynamicExp+="if("+e+") { return "+e+"; } ";dynamicExp+="else { ";}var orgOrderCol=cache.normalized[0].length-1;dynamicExp+="return a["+orgOrderCol+"]-b["+orgOrderCol+"];";for(var i=0;i<l;i++){dynamicExp+="}; ";}dynamicExp+="return 0; ";dynamicExp+="}; ";if(table.config.debug){benchmark("Evaling expression:"+dynamicExp,new Date());}eval(dynamicExp);cache.normalized.sort(sortWrapper);if(table.config.debug){benchmark("Sorting on "+sortList.toString()+" and dir "+order+" time:",sortTime);}return cache;};function makeSortFunction(type,direction,index){var a="a["+index+"]",b="b["+index+"]";if(type=='text'&&direction=='asc'){return"("+a+" == "+b+" ? 0 : ("+a+" === null ? Number.POSITIVE_INFINITY : ("+b+" === null ? Number.NEGATIVE_INFINITY : ("+a+" < "+b+") ? -1 : 1 )));";}else if(type=='text'&&direction=='desc'){return"("+a+" == "+b+" ? 0 : ("+a+" === null ? Number.POSITIVE_INFINITY : ("+b+" === null ? Number.NEGATIVE_INFINITY : ("+b+" < "+a+") ? -1 : 1 )));";}else if(type=='numeric'&&direction=='asc'){return"("+a+" === null && "+b+" === null) ? 0 :("+a+" === null ? Number.POSITIVE_INFINITY : ("+b+" === null ? Number.NEGATIVE_INFINITY : "+a+" - "+b+"));";}else if(type=='numeric'&&direction=='desc'){return"("+a+" === null && "+b+" === null) ? 0 :("+a+" === null ? Number.POSITIVE_INFINITY : ("+b+" === null ? Number.NEGATIVE_INFINITY : "+b+" - "+a+"));";}};function makeSortText(i){return"((a["+i+"] < b["+i+"]) ? -1 : ((a["+i+"] > b["+i+"]) ? 1 : 0));";};function makeSortTextDesc(i){return"((b["+i+"] < a["+i+"]) ? -1 : ((b["+i+"] > a["+i+"]) ? 1 : 0));";};function makeSortNumeric(i){return"a["+i+"]-b["+i+"];";};function makeSortNumericDesc(i){return"b["+i+"]-a["+i+"];";};function sortText(a,b){if(table.config.sortLocaleCompare)return a.localeCompare(b);return((a<b)?-1:((a>b)?1:0));};function sortTextDesc(a,b){if(table.config.sortLocaleCompare)return b.localeCompare(a);return((b<a)?-1:((b>a)?1:0));};function sortNumeric(a,b){return a-b;};function sortNumericDesc(a,b){return b-a;};function getCachedSortType(parsers,i){return parsers[i].type;};this.construct=function(settings){return this.each(function(){if(!this.tHead||!this.tBodies)return;var $this,$document,$headers,cache,config,shiftDown=0,sortOrder;this.config={};config=$.extend(this.config,$.tablesorter.defaults,settings);$this=$(this);$.data(this,"tablesorter",config);$headers=buildHeaders(this);this.config.parsers=buildParserCache(this,$headers);cache=buildCache(this);var sortCSS=[config.cssDesc,config.cssAsc];fixColumnWidth(this);$headers.click(function(e){var totalRows=($this[0].tBodies[0]&&$this[0].tBodies[0].rows.length)||0;if(!this.sortDisabled&&totalRows>0){$this.trigger("sortStart");var $cell=$(this);var i=this.column;this.order=this.count++%2;if(this.lockedOrder)this.order=this.lockedOrder;if(!e[config.sortMultiSortKey]){config.sortList=[];if(config.sortForce!=null){var a=config.sortForce;for(var j=0;j<a.length;j++){if(a[j][0]!=i){config.sortList.push(a[j]);}}}config.sortList.push([i,this.order]);}else{if(isValueInArray(i,config.sortList)){for(var j=0;j<config.sortList.length;j++){var s=config.sortList[j],o=config.headerList[s[0]];if(s[0]==i){o.count=s[1];o.count++;s[1]=o.count%2;}}}else{config.sortList.push([i,this.order]);}};setTimeout(function(){setHeadersCss($this[0],$headers,config.sortList,sortCSS);appendToTable($this[0],multisort($this[0],config.sortList,cache));},1);return false;}}).mousedown(function(){if(config.cancelSelection){this.onselectstart=function(){return false};return false;}});$this.bind("update",function(){var me=this;setTimeout(function(){me.config.parsers=buildParserCache(me,$headers);cache=buildCache(me);},1);}).bind("updateCell",function(e,cell){var config=this.config;var pos=[(cell.parentNode.rowIndex-1),cell.cellIndex];cache.normalized[pos[0]][pos[1]]=config.parsers[pos[1]].format(getElementText(config,cell),cell);}).bind("sorton",function(e,list){$(this).trigger("sortStart");config.sortList=list;var sortList=config.sortList;updateHeaderSortCount(this,sortList);setHeadersCss(this,$headers,sortList,sortCSS);appendToTable(this,multisort(this,sortList,cache));}).bind("appendCache",function(){appendToTable(this,cache);}).bind("applyWidgetId",function(e,id){getWidgetById(id).format(this);}).bind("applyWidgets",function(){applyWidget(this);});if($.metadata&&($(this).metadata()&&$(this).metadata().sortlist)){config.sortList=$(this).metadata().sortlist;}if(config.sortList.length>0){$this.trigger("sorton",[config.sortList]);}applyWidget(this);});};this.addParser=function(parser){var l=parsers.length,a=true;for(var i=0;i<l;i++){if(parsers[i].id.toLowerCase()==parser.id.toLowerCase()){a=false;}}if(a){parsers.push(parser);};};this.addWidget=function(widget){widgets.push(widget);};this.formatFloat=function(s){var i=parseFloat(s);return(isNaN(i))?0:i;};this.formatInt=function(s){var i=parseInt(s);return(isNaN(i))?0:i;};this.isDigit=function(s,config){return/^[-+]?\d*$/.test($.trim(s.replace(/[,.']/g,'')));};this.clearTableBody=function(table){if($.browser.msie){function empty(){while(this.firstChild)this.removeChild(this.firstChild);}empty.apply(table.tBodies[0]);}else{table.tBodies[0].innerHTML="";}};}});$.fn.extend({tablesorter:$.tablesorter.construct});var ts=$.tablesorter;ts.addParser({id:"text",is:function(s){return true;},format:function(s){return $.trim(s.toLocaleLowerCase());},type:"text"});ts.addParser({id:"digit",is:function(s,table){var c=table.config;return $.tablesorter.isDigit(s,c);},format:function(s){return $.tablesorter.formatFloat(s);},type:"numeric"});ts.addParser({id:"currency",is:function(s){return/^[£$€?.]/.test(s);},format:function(s){return $.tablesorter.formatFloat(s.replace(new RegExp(/[£$€]/g),""));},type:"numeric"});ts.addParser({id:"ipAddress",is:function(s){return/^\d{2,3}[\.]\d{2,3}[\.]\d{2,3}[\.]\d{2,3}$/.test(s);},format:function(s){var a=s.split("."),r="",l=a.length;for(var i=0;i<l;i++){var item=a[i];if(item.length==2){r+="0"+item;}else{r+=item;}}return $.tablesorter.formatFloat(r);},type:"numeric"});ts.addParser({id:"url",is:function(s){return/^(https?|ftp|file):\/\/$/.test(s);},format:function(s){return jQuery.trim(s.replace(new RegExp(/(https?|ftp|file):\/\//),''));},type:"text"});ts.addParser({id:"isoDate",is:function(s){return/^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$/.test(s);},format:function(s){return $.tablesorter.formatFloat((s!="")?new Date(s.replace(new RegExp(/-/g),"/")).getTime():"0");},type:"numeric"});ts.addParser({id:"percent",is:function(s){return/\%$/.test($.trim(s));},format:function(s){return $.tablesorter.formatFloat(s.replace(new RegExp(/%/g),""));},type:"numeric"});ts.addParser({id:"usLongDate",is:function(s){return s.match(new RegExp(/^[A-Za-z]{3,10}\.? [0-9]{1,2}, ([0-9]{4}|'?[0-9]{2}) (([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(AM|PM)))$/));},format:function(s){return $.tablesorter.formatFloat(new Date(s).getTime());},type:"numeric"});ts.addParser({id:"shortDate",is:function(s){return/\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}/.test(s);},format:function(s,table){var c=table.config;s=s.replace(/\-/g,"/");if(c.dateFormat=="us"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/,"$3/$1/$2");}else if(c.dateFormat=="uk"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/,"$3/$2/$1");}else if(c.dateFormat=="dd/mm/yy"||c.dateFormat=="dd-mm-yy"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2})/,"$1/$2/$3");}return $.tablesorter.formatFloat(new Date(s).getTime());},type:"numeric"});ts.addParser({id:"time",is:function(s){return/^(([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(am|pm)))$/.test(s);},format:function(s){return $.tablesorter.formatFloat(new Date("2000/01/01 "+s).getTime());},type:"numeric"});ts.addParser({id:"metadata",is:function(s){return false;},format:function(s,table,cell){var c=table.config,p=(!c.parserMetadataName)?'sortValue':c.parserMetadataName;return $(cell).metadata()[p];},type:"numeric"});ts.addWidget({id:"zebra",format:function(table){if(table.config.debug){var time=new Date();}var $tr,row=-1,odd;$("tr:visible",table.tBodies[0]).each(function(i){$tr=$(this);if(!$tr.hasClass(table.config.cssChildRow))row++;odd=(row%2==0);$tr.removeClass(table.config.widgetZebra.css[odd?0:1]).addClass(table.config.widgetZebra.css[odd?1:0])});if(table.config.debug){$.tablesorter.benchmark("Applying Zebra widget",time);}}});})(jQuery);
 
 
 
 
function getPath(currentUrl) {
    //With Frames
    if (/MSIE (\d+\.\d+);/.test(navigator.userAgent) && location.hostname == '' && currentUrl.search("/") == '0') {
        currentUrl = currentUrl.substr(1);
    }
    path = prefix + "?q=" + currentUrl;
    return path;
}

/**
 * @description Highlight searched words
 * @param words {array} words to be highlighted
 */
function highlightSearchTerm(words) {
    if (top==self) {
        if (words != null) {
            // highlight each term in the content view
            $('#frm').contents().find('body').removeHighlight();
            for (i = 0; i < words.length; i++) {
                debug('highlight(' + words[i] + ');');
                $('#frm').contents().find('body').highlight(words[i]);
            }
        }
    } else {
        // For index with frames
        if (parent.termsToHighlight != null) {
            // highlight each term in the content view
            for (i = 0; i < parent.termsToHighlight.length; i++) {
                $('*', window.parent.contentwin.document).highlight(parent.termsToHighlight[i]);
            }
        }
    }
}

$(document).ready(function () {
    $('#permalink').show();
    if ($('#permalink').length > 0) {
        if (window.top !== window.self) {
            if (window.parent.location.protocol != 'file:' && typeof window.parent.location.protocol != 'undefined') {
                $('#permalink>a').attr('href', window.parent.location.pathname + '?q=' + window.location.pathname);
                $('#permalink>a').attr('target', '_blank');
            } else {
                $('#permalink').hide();
            }
        } else {
            $("<div class='frames'><div class='wFrames'><a href=" + getPath(location.pathname) + ">See the Table of Contents</a></div></div>").prependTo('.navheader');							        
            $('#permalink').hide();
        }
    }
    
    // Expand toc in case there are frames.
    if (top !== self && window.parent.tocwin) {
        if (typeof window.parent.tocwin.markSelectItem === 'function') {
            window.parent.tocwin.markSelectItem(window.location.href);
        }
    }
});
/*added 12-2-15 NM add event listeners to all sections of class headerH */
  $(document).ready(function()
    { 
  if (document.getElementsByClassName("svcOverview").length) {
    descripts=
{swift: "Swift Object Storage provides for redundant, scalable data storage using clusters of standardized servers to store petabytes of accessible data. It is a long-term storage system for large amounts of static data which can be retrieved and updated. " + "<p/>" + "Object Storage uses a distributed architecture with no central point of control, providing greater scalability, redundancy, and permanence. Objects are written to multiple hardware devices, with the OpenStack software responsible for ensuring data replication and integrity across the cluster." + "<p/>" + "Storage clusters scale horizontally by adding new nodes. Should a node fail, OpenStack works to replicate its content from other active nodes. " + "<p/>" + "Object Storage is ideal for cost effective, scale-out storage. It provides a fully distributed, API-accessible storage platform that can be integrated directly into applications or used for backup, archiving, and data retention. " + "<p/>" + "Swift is highly available, distributed, and eventually consistent. Organizations can use Swift to store large amounts of data efficiently, safely, and inexpensively.", 
nova: "Nova provides virtual severs upon demand. Nova is the compute component underlying OpenStack clouds. Nova is  designed to provide powerful, massively scalable, on demand, self-service access to compute resources. Core Nova components include nova-api, the nova-scheduler, and nova-compute",
ceilometer: "Ceilometer provides telemetry/metering of the various aspects of OpenStack deployments to allow you to reliably collect data on the utilization of the physical and virtual resources comprising deployed clouds, persist these data for subsequent retrieval and analysis, and trigger actions when defined criteria are met. " + "<p/>" + "The telemetry requirements of an OpenStack environment include use cases such as metering, monitoring, and alarming. " + "<p/>" + "Currently, the telemetry project provides a set of functionality split across multiple projects; each project designed to provide a discrete service in the telemetry space.",
heat: "Heat is a template-based orchestration solution for provisioning the resources required to deploy a cloud. It implements an orchestration engine to launch multiple composite cloud applications based on templates in the form of text files that can be treated like code." + "<p/>" + "A Heat template describes the infrastructure for a cloud application in a text file that is readable and writable by humans, and can be checked into version control, diffed, and so forth.  " + "<p/>" + "Infrastructure resources that can be described include servers, floating IPs, volumes, security groups, users. Heat also provides an autoscaling service that integrates with Telemetry, so you can include a scaling group as a resource in a template. " + "<p/>" + "Templates can also specify the relationships between resources. This enables Heat to call out to the OpenStack APIs to create all of your infrastructure in the correct order to completely launch your application. " + "<p/>" + "Heat manages the whole lifecycle of the application - when you need to change your infrastructure, simply modify the template and use it to update your existing stack.",
keystone: "The Keystone Identity service provides authentication and authorization for all the OpenStack services. It also provides a sertvice catalog of services within an OpenStack cloud. Based on Openstack Keystone, the HPE Helion Openstack Identity service provides one-stop authentication.The Identity service enables you to create and configure users, specify user roles and credentials, and issue security tokens. The Identity service validates that incoming requests are being made by the user or service that claims to be making the call. " + "<p/>" + "Users have a login and may be assigned tokens to access resources. Users can scope their authentication to a project (or, tenant) which then limits where and how their tokens can be used to interact with services. User roles can be assigned to control access to projects." + "<p/>" + "The Identity service issues tokens that the user can provide to demonstrate that their identity has been authenticated when making subsequent requests.The following topics describe several key features." + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/understanding_identity.html'>Overview</a></li><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/configuring/identity/identity_ldap.html'>LDAP Integration</a></li><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/configuring/identity/keystone_federation.html'>Keystone Federation</a></li><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/configuring/identity/websso.html'>Web Single Sign-on</a></li></ul>", 
cinder: "Cinder is a Block Storage service for OpenStack. It's designed to present storage resources to end users that can be consumed by the OpenStack Compute (Nova). This is done through the use of either a reference implementation (LVM) or plugin drivers for other storage. " + "<p/>" + "Cinder virtualizes pools of block storage devices and provides users with a self-service API to request and consume those resources without requiring any knowledge of where their storage is actually deployed or on what type of device.",
glance: "Glance provides a service where users can upload and discover data assets that are meant to be used with other services. This currently includes images and metadata definitions. Glance image services include discovering, registering, and retrieving virtual machine images. " + "<p/>" + "Glance has a RESTful API that allows querying of VM image metadata as well as retrieval of the actual image. VM images made available through Glance can be stored in a variety of locations from simple filesystems to object-storage systems like the OpenStack Swift project. " + "<p/>" + "Glance provides a catalog and repository for virtual disk images. These images are used by Nova compute and allow you to quickly provision pre-configured VMs.",
ironic: "Ironic provisions physical hardware as opposed to virtual machines. It provides several reference drivers that leverage common technologies such as PXE and IPMI, to cover a wide range of hardware. Ironic's pluggable driver architecture also allows vendor-specific drivers to be added for improved performance or functionality not provided by reference drivers." + "<p/>" + "If typical hypervisor functionality includes creating a VM, enumerating virtual devices, managing the power state, and so on, then Ironic can be considered a hypervisor API gluing together multiple drivers, each of which implement some portion of that functionality with respect to physical hardware." + "<p/>" + "Ironic makes physical servers as easy to provision as virtual machines in cloud, which in turn will open up new avenues for enterprises and service providers.",
monasca: "HPE Helion OpenStack provides a monitoring solution based on OpenStack's Monasca service. This service provides monitoring and metrics for all OpenStack components, as well as much of the underlying system. By default, Helion OpenStack comes with a set of alarms that provide coverage of the primary systems. In addition, you can define alarms based on threshold values for any metrics defined in the system." + "<p/>" + "You can view alarm information in the Operations Console. You can also receive or deliver this information to others by configuring email or other mechanisms. Alarms provide information about whether a component failed and is affecting the system, and also what condition triggered the alarm. " + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/monitoring_service.html'>Overview</a></li></ul>",
freezer: "Freezer is the technology underlying the HPE Helion OpenStack backup and restore functionality. Backup jobs are configured by default upon installation of HPE Helion OpenStack. The service also allows you to create your own backup jobs using the scheduler, and allows you to set various locations to store your backups." + "<p/>" + " Freezer is a Backup and Restore as a Service platform that helps you automate the backup and restore process for your data. Freezer executes backups and restores as jobs, and executes these jobs independently and/or as managed sessions (multiple jobs in multiple machines sharing a state). " + "<p/>" + "Freezer is automatically installed on compute nodes during initial cloud installation and when you add a compute node." + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/bura/bura_overview.html'>Overview</a></li></ul>",
neutron: "Neutron provides networking as a service between interface devices managed by other OpenStack services. Neutron allows users to create their own networks and attach interfaces to them." + "<p/>" + "Neutron has a pluggable architecture to support many popular technologies." + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/networking/networking_overview.html'>Overview</a></li><li><a href='http://docs.hpcloud.com/#3.x/helion/networking/rbac.html'>Role-based Access Control</a></li><li><a href='http://docs.hpcloud.com/#3.x/helion/networking/using_ipam.html'>Using IPAM Drivers</a></li></ul>",
barbican: "Barbican is an OpenStack key management service offering secure storage, provisioning, and management of key data. The Barbican service provides management of secrets, keys and certificates via multiple storage back ends. The support for various back ends is provided via a plug-in mechanism, a Key Management Interoperability Protocol (KMIP) plug-in for a KMIP-compliant HSM device. " + "<p/>" + "Barbican supports symmetric and asymmetric key generation using various algorithms. Barbican is new in this release. Cinder, neutron-lbaas v2 and Nova will integrate with Barbican for their encryption key generation and storage." + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/security/barbican.html'>Overview</a></li></ul>",
horizon: "Horizon is the OpenStack service that serves as the basis for the HPE Helion OpenStack dashboards.The dashboards provide a web-based user interface to HPE Helion OpenStack services including Compute, Volume Operations, Networking, and Identity. Horizon allows users to launch instances, assign IP addresses, set access control, view network topologies, and more, in a convenient UI." + "<p/>" + "<img src='AZ.png'>" + "<p/>" + "<ul><li><a href='http://docs.hpcloud.com/#3.x/helion/operations/configuring/configure_dashboard.html'>Start Here</a></li></ul>"};
       
           overviewDiv=document.getElementsByClassName("svcOverview");
           overviewDiv[0].innerHTML='<img id="overview" class="overview" src="http://docs.hpcloud.com/3.x/media/intro/HelionOpenStack30Services.png" border="0" width="1000" height="600" orgWidth="1000" orgHeight="600" usemap="#overview" alt="" /><map name="overview" id="over"><area id="hor" alt="" title="Horizon Dashboard" href="#" shape="rect" coords="32,123,863,177" style="outline:none;" onclick="showdesc(descripts.horizon);"  /><area id="swift" alt="" title="Swift" href="#" shape="rect" coords="34,198,122,336" style="outline:none;" onclick="showdesc(descripts.swift);"      /><area  alt="" title="Cinder" href="#" shape="rect" coords="143,194,231,332" style="outline:none;" onclick="showdesc(descripts.cinder);"      /><area id="glancs" alt="" title="Glance" href="#" shape="rect" coords="244,197,332,335" style="outline:none;" onclick="showdesc(descripts.glance);"      /><area id="nova" alt="" title="Nova" href="#" shape="rect" coords="353,194,441,332" style="outline:none;" onclick="showdesc(descripts.nova);"      /><area id="ironic" alt="" title="Ironic" href="#" shape="rect" coords="455,193,543,331" style="outline:none;" onclick="showdesc(descripts.ironic);"      /><area id="neutron" alt="" title="Neutron" href="#" shape="rect" coords="567,194,655,332" style="outline:none;" onclick="showdesc(descripts.neutron);"      /><area id="heat" alt="" title="Heat" href="#" shape="rect" coords="673,193,761,331" style="outline:none;" onclick="showdesc(descripts.heat);"      /><area id="barbican" alt="" title="Barbican" href="#" shape="rect" coords="773,196,861,334" style="outline:none;" onclick="showdesc(descripts.barbican);"      /><area id="keystone" alt="" title="Keystone" href="#" shape="rect" coords="879,123,967,398" style="outline:none;" onclick="showdesc(descripts.keystone);"      /><area id="monasca" alt="" title="Monasca" href="#" shape="rect" coords="32,349,435,398" style="outline:none;" onclick="showdesc(descripts.monasca);"      /><area id="ceilometer" alt="" title="Ceilometer" href="#" shape="rect" coords="452,350,855,399" style="outline:none;" onclick="showdesc(descripts.ceilometer);"      /><area id="freezer" alt="" title="Freezer" href="#" shape="rect" coords="36,414,968,463" style="outline:none;" onclick="showdesc(descripts.freezer);"      /></map>';
            		
    	}
    	if (document.getElementsByClassName("keystoneVideo").length) {
            vidDiv=document.getElementsByClassName("keystoneVideo");

            vidDiv[0].innerHTML='<video width="1040" height="585" controls><source src="https://docs.hpcloud.com/3.x/media/video/KeystoneTokenValidationExample.mp4" type="video/mp4">Your browser does not support the video tag.</video>';
        }
    	if (document.getElementsByClassName('midScaleAllNetworks').length) {
    	   $.getScript("https://docs.hpcloud.com/oxygen-webhelp/resources/js/networkimages.js");
    	}
    	else if (document.getElementsByClassName('entryScaleDedicated').length) {
    	    $.getScript("https://docs.hpcloud.com/oxygen-webhelp/resources/js/entryScaleDedicated.js");		
    	}
    	
    	else if (document.getElementsByClassName('entryScale').length) {
    	    $.getScript("https://docs.hpcloud.com/oxygen-webhelp/resources/js/entryScale.js");		
    	}
    	
    	else if (document.getElementsByClassName('entryScaleCeph').length) {
    	    $.getScript("https://docs.hpcloud.com/oxygen-webhelp/resources/js/entryScaleCeph.js");		
    	}
    	

    	/*------------------network diagrams-------------------------------*/
  	
      /*------------------end network diagrams-------------------------------*/	
    	
      /*------------------ copy button ------------------------------------*/      
     /* if (document.queryCommandSupported("copy")) {
         var pres=document.getElementsByClassName('copybutton');
         if (pres.length) {
           for (var y=0; y<pres.length; y++) {
             pres[y].setAttribute('id', 'a' + y);
             var btn = document.createElement("BUTTON");        
             btn.addEventListener('click', copycode, false);
             btn.setAttribute('id', 'a' + y + 'b');
             btn.setAttribute('class', 'codebutton');
             var t = document.createTextNode("Copy Code");       
             btn.appendChild(t);                               
             var nextsib=pres[y].nextSibling;
             pres[y].parentNode.insertBefore(btn, nextsib); 

           }
         } 
      }   /// comment out copy button for now
      */
 /*------------------ end copy button ------------------------------------*/      
/*------------------ prettyprint ------------------------------------*/      	
       // $.getScript("https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js");
      	//$.getScript("http://docs-staging.hpcloud.com/z_test_hos.docs+hos-30+nancy/media/run_prettify.js");
      	/*var pretags=document.getElementsByTagName("PRE");
      	for (var q=0; q<pretags.length; q++) {
      		var currclass=pretags[q].className;
      		var newclass=currclass + " prettyprint";
      		pretags[q].setAttribute('class', newclass);
      	}*/
 //no need to load on every page     	
/*------------------ single accordion ------------------------------------*/
      	   if (document.getElementsByClassName('expandcode').length) {
      	        var lonecodeblocks=document.getElementsByClassName('expandcode');
      	      	for (var k=0; k<lonecodeblocks.length; k++) {
      		    lonecodeblocks[k].addEventListener('click', expcode, false);
      	        }
      	    }
/* ------------------------begin HA-----------------------------------------------------------------*/
      	 if (document.getElementsByClassName('wrapper1').length) {
      	     var concontain=document.getElementsByClassName('oldcontentContainer');
      	     concontain[0].setAttribute('id', 'HP20HA__contentContainer');
             var descr=document.getElementsByClassName('desc');
             descr[0].setAttribute('id', 'HP20HA__desc');
      	     //document.getElementById('HP2.0HA__contentContainer').setAttribute('id', 'HP20HA__contentContainer');
             var allids=document.getElementsByClassName('HAcontent');
             var bgimages=document.getElementsByClassName('HAimgs');
             var allbgs=bgimages[0].innerHTML;
             var haimgs=allbgs.toString();
             var allimgs=haimgs.split('%');
           
                 
             for (var j=0; j<allids.length; j++) {
                  allids[j].setAttribute('id', 'item' + parseInt(j+1));
                  allids[j].style.backgroundImage = "url('" + allimgs[j] + "')";
             }
             var allliitems=document.getElementsByClassName('itemLinks');
             var m=0;
             for (var k=0; k<allliitems.length; k++) {
                  allliitems[k].setAttribute('data-pos', m+'px');
                  m-=1000;
             }
             var rappers=document.getElementsByClassName('wrapper1');
             rappers[0].setAttribute('id', 'wrapper');
             var mainlinks=document.getElementsByClassName('navLinks1');
             mainlinks[0].setAttribute('id', 'navLinks');
             var links = document.getElementsByClassName("itemLinks");
             var wrapper = document.getElementById("wrapper");

             // Build array of slide information.
             var arraytext=document.getElementsByClassName('HAsliderText');
             var arrayoftext=arraytext[0].innerHTML;
             var info=arrayoftext.toString();
             HAinfo=info.split('%');
                 
          
           // Set initial text.
           document.getElementById("HP20HA__desc").innerHTML = HAinfo[0];

          // the activeLink provides a pointer to the currently displayed item
           var activeLink = 0;
 
          // setup the event listeners
          for (var i = 0; i < links.length; i++) {
              var link = links[i];
          link.addEventListener('click', setClickedItem, false);
 
           // identify the item for the activeLink
          link.itemID = i;
         }
        // set first item as active
        links[activeLink].classList.add("active");
  
        var transforms = ["transform",
            "msTransform",
            "webkitTransform",
            "mozTransform",
            "oTransform"];
 
       transformPropertyHAHAHA = getSupportedPropertyName(transforms);

}
/* ------------------------end HA-----------------------------------------------------------------*/	

/* ------------------------begin accordions-----------------------------------------------------------------*/		
          
      /* bind the event listeners for the headline itself   */    
        if (document.getElementsByClassName("headerH")){

           var headers=document.getElementsByClassName("headerH");  //h1

          for(var i=0;i<headers.length;i++){
              var headline=headers[i].innerHTML;
              headers[i].innerHTML="&#x25b8;"+headline;
              headers[i].addEventListener('click', accord, false);
          }
       }
/* ---   whole page   --- */
        if (document.getElementsByClassName("expandpage").length && document.getElementsByClassName("collapsepage").length) {       
          var expandpage=document.getElementsByClassName("expandpage");
          expandpage[0].addEventListener('click', expandall, false);
          var collapsepage=document.getElementsByClassName("collapsepage");
          collapsepage[0].addEventListener('click', collapseall, false);

        }
/* ---   whole page   --- */

      /* bind the event listeners for the expand collapse links- one kind for many subsections one kind for old single instances  */  
        if (document.getElementsByClassName("expandall").length && document.getElementsByClassName("collapseall").length) {  
            if (document.getElementsByClassName("accordionWrapper").length) {
               var expands=document.getElementsByClassName('expandall');
               var collapse=document.getElementsByClassName('collapseall');

               for (var j=0; j<expands.length; j++) {
                   collapse[j].addEventListener('click', hide, false);
                   expands[j].addEventListener('click', show, false);
                }
            }
            else {
                var expanding=document.getElementsByClassName("expandall");
                for (var k=0; k < expanding.length; k++) {
                    expanding[k].addEventListener('click', expandall, false);
                    var collapsing=document.getElementsByClassName("collapseall");
                    collapsing[k].addEventListener('click', collapseall, false);
                }
            }
        }
/* ------------------------end accordions-----------------------------------------------------------------*/  

/* ------------------------begin anchors-----------------------------------------------------------------*/
        
// anchors code can be deleted if we use only drupal   
/*
 $.browser.chrome = $.browser.webkit && !!window.chrome;
    if ($.browser.chrome) {
       var allAnchors=document.getElementsByTagName('A');
       for (var i=0; i<allAnchors.length; i++) {
           var hrf=allAnchors[i].href;
           if (allAnchors[i].target!="_blank") {
              allAnchors[i].setAttribute('target', '_self');
     	   }
       }
    }
*/    
    
}); 

/* ------------------------end anchors-----------------------------------------------------------------*/

/* ------------------------begin HA functions-----------------------------------------------------------------*/
  function setClickedItem(e) {
    removeActiveLinks();
 
    var clickedLink = e.target;
    activeLink = clickedLink.itemID;
 
    changePosition(clickedLink);
	document.getElementById("HP20HA__desc").innerHTML = HAinfo[clickedLink.itemID];
}
 
function removeActiveLinks() {
var links = document.getElementsByClassName("itemLinks");
    for (var i = 0; i < links.length; i++) {
        links[i].classList.remove("active");
    }
}
 
// Handle changing the slider position as well as ensure
// the correct link is highlighted as being active
function changePosition(link) {
    var position = link.getAttribute("data-pos");
 
    var translateValue = "translate3d(" + position + ", 0px, 0)";
    wrapper.style[transformPropertyHAHAHA] = translateValue;
 
    link.classList.add("active");
}
function getSupportedPropertyName(properties) {
    for (var i = 0; i < properties.length; i++) {
        if (typeof document.body.style[properties[i]] != "undefined") {
            return properties[i];
        }
    }
    return null;
}
/* ------------------------end HA functions-----------------------------------------------------------------*/
  


/*added 12-2-15 NM shows hides sectiondivs */
/* used in both old accordions and new accordions with subsections */
/* ------------------------begin accordion functions-----------------------------------------------------------------*/
function accord(){
var listofnodes=this.parentNode.children;
    for (var i=0; i<listofnodes.length; i++){
         var headline=listofnodes[0].innerHTML;

          if ((i+1)<listofnodes.length) {
		if (listofnodes[i+1].style.display=="block") {
                     listofnodes[i+1].style.display="none";
                     listofnodes[0].innerHTML="&#x25b8;"+headline.substring(1);
                }
                else {
                    listofnodes[i+1].style.display="block";
                    listofnodes[0].innerHTML="&#x25be;"+headline.substring(1);
                }
          }
    }
}

/* expandal and collapseall functions are used in old accordions where you have no subsections */
function expandall(){
  var listofnodes=document.getElementsByClassName("headerH");
  var allnodes=document.getElementsByClassName("insideSection");
    for (var i=0; i<allnodes.length; i++){
      var headline=listofnodes[i].parentNode.children[0].innerHTML;
      allnodes[i].style.display="block";
      listofnodes[i].parentNode.children[0].innerHTML="&#x25be;"+headline.substring(1);
    }
}


function collapseall(){
  var listofnodes=document.getElementsByClassName("headerH");
  var allnodes=document.getElementsByClassName("insideSection");
    for (var i=0; i<allnodes.length; i++){
      var headline=listofnodes[i].parentNode.children[0].innerHTML;
      allnodes[i].style.display="none";
      listofnodes[i].parentNode.children[0].innerHTML="&#x25b8;"+headline.substring(1);
    }
}

/* show hide functions are used in new accordions where you have subsections */

function hide() {

     $(this).parent().parent().children().children('.headerH').each(function() {
         var head=$(this).html();
         $(this).html("&#x25b8;"+head.substring(1));
     });
     $(this).parent().parent().children().children('.insideSection').hide();
}

function show() {

    $(this).parent().parent().children().children('.headerH').each(function() {
         var head=$(this).html();
         $(this).html("&#x25be;"+head.substring(1));
     });
     $(this).parent().parent().children().children('.insideSection').show();
}

/* ------------------------end accordion functions-----------------------------------------------------------------*/

function expcode() {
	//this.next().css( "display", "block" );
	var theblock=this.nextElementSibling;
	if (theblock.style.display=="block") {
		theblock.style.display="none";
	}
	else {
		theblock.style.display="block";
	}
}
/*------------------ copy function ------------------------------------*/      
function copycode(){  ///copy button is currently commented out

	var length=this.id.length;
	var preid = this.id.substring(0,length-1);
        var textnode=document.getElementById(preid);
	textnode.setAttribute('contenteditable', 'true');
	window.getSelection().removeAllRanges();
        var range = document.createRange();  
        range.selectNode(textnode);
        window.getSelection().addRange(range);
        var succeed;
        try {
    	  succeed = document.execCommand("copy");
        } 
        catch(e) {
          succeed = false;
        }
        textnode.setAttribute('contenteditable', 'false');
}



/*-----------------network images function------------------*/
function changeimg(x) {

	var solid=document.getElementById('solid');

	solid.src=netimages[x];
}
function noclick() {
  return false;
}
function showdesc(x) {
	//alert('hi');
	var pop=document.getElementsByClassName('popup');
	pop[0].style.opacity="1.0";
	pop[0].style.WebkitTransition="opacity 0.60s ease-in";
        pop[0].style.MozTransition="opacity 0.60s ease-in";
        pop[0].style.transition="opacity 0.60s ease-in";
	var inner=pop[0].innerHTML;
	pop[0].style.visibility='visible';
	pop[0].innerHTML=x + "<p>";
	pop[0].style.top="-545px";
        pop[0].style.left="48px";
    pop[0].style.padding="30px";
    pop[0].style.width="500px";
    var btn = document.createElement("BUTTON");        
    btn.addEventListener('click', close, false);
    var t = document.createTextNode("Close");       
    btn.appendChild(t); 
    pop[0].appendChild(btn); 
}

function close() {
	var pop1=document.getElementsByClassName('popup');
	pop1[0].style.visibility='hidden';
}
