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
