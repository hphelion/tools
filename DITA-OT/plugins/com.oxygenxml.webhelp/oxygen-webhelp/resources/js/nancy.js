      $(document).ready(function()
      { 
          headers=document.getElementsByClassName("headerH");
          for(var i=0;i<headers.length;i++){
              var headline=headers[i].firstChild.innerText;
              headers[i].firstChild.innerText="+"+headline;
              headers[i].addEventListener('click', accord, false);
          }
      
      } 
      ); 


function accord(){
listofnodes=this.children;
    for (var i=1; i<listofnodes.length; i++){
            var headline=listofnodes[0].innerText;
	if (listofnodes[i].style.display=="block"){
            listofnodes[i].style.display="none";
            listofnodes[0].innerText="+"+headline.substring(1);
        }
        else {
            listofnodes[i].style.display="block";
            listofnodes[0].innerText="-"+headline.substring(1);
        }
    }
}