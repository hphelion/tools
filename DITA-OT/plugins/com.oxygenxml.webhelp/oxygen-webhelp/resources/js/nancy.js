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
    for (var i=1; i<listofnodes.length; i++){   //note 1. start with child 1. skip first child as it is title
        //listofnodes=boxes[i].childNodes;
		if (listofnodes[i].style.display=="none"){
            listofnodes[i].style.display="block";
        }
        else {
            listofnodes[i].style.display="none";
        }
    }
}