$(document).ready(function() {
  //$("#introduction_content").typed({
    //strings: ["David is…", "Heidi is…", "Alyssa is…", "Pierre is…", "Alex is…"],
    ////attr: "placeholder",
    //cursorChar: "",
    //backDelay: 2000,
    //loop: true
  //});

  $("#form-introname").keypress(function (e) {
    if (e.which == 13) {  //enter key
      e.stopPropagation();
      e.preventDefault();

      if ($(this).val() != "") {
        var name = $(this).val();

        //$(this).attr("disabled", true);
        $(this).hide();
        $("#box-text").text($("#box-text").text() + " " + name + ".");

        //$("#introductions")
          //.transition({display: "block", height: "auto", easing: "snap"});

        $("#form-intro")
          .css("display", "inline")
          .focus();
          //.focus(function () { $(this).select(); } )
          //.mouseup(function (e) {e.preventDefault(); });

        $("#examples")
          .show();
          //.transition({display: "block", easing: "snap"});
      }
    }
  })

  $(".tip")
    .css({opacity: 0});

  $(".prompt").hoverIntent(function() {
    $(".tip").transition({opacity: 1});
  }, function() {
    $(".tip").transition({opacity: 0});
  }).click(function() {
    $("#introduction_content", this).select();
  });

  $("#introduction_sender_name").on("click", function(e) {
    e.stopPropagation();
  });


  var intros = ["one of the most genuine and thoughtful people I know.",
    //"I'm inspired by David's deep ability to rally others around his vision.",
    "passionate and fearless: he inspires me to be ambitious.",
    "one of the most brilliant and creative people I've met."]
    //"David exudes a sense of urgency that inspires me to push harder."];

  //$('#form-intro').autocomplete({
      //lookup: intros,
      //minChars: 0,
  //});

  var input = document.getElementById("introduction_content");
  new Awesomplete(input, {
    list: intros,
    filter: function (text, input) {
      return true;
    },
    item: function(text, input){
      var newText = input + " is " + text;

      return Awesomplete.$.create("li", {
          innerHTML: newText.replace(RegExp(input.trim(), "gi"), "<mark>$&</mark>"),
          "aria-selected": "false"
      });
    },
  });


  if ($("#google-autocomplete").length) {
    var autocomplete = new google.maps.places.Autocomplete(document.getElementById('google-autocomplete'),
        { types: ['establishment'] });

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();

      var address = find_component(place, "street_number", "long_name") + " " + find_component(place, "route", "short_name");
      var subpremise = find_component(place, "subpremise", "long_name");

      if (subpremise !== "") {
        address += "# " + subpremise;
      }

      if ("name" in place) {
        $("#address-line1").val(place["name"]);
        $("#address-line2").val(address);
      } else {
        $("#address-line1").val(address);
      }

      $("#address-city").val(find_component(place, "locality", "long_name"));
      $("#address-state").val(find_component(place, "administrative_area_level_1", "short_name"));
      $("#address-postalcode").val(find_component(place, "postal_code", "long_name"));
      $("#address-country").val(find_component(place, "country", "long_name"));
    });
  }

  //function showIntroduction(e) {
    //var next = getNext(e);

    //e
      //.transition({opacity: 0, y: 50, delay: 200, easing: "snap"});

    //next
        //.css({opacity: 0, y: -100})
        //.transition({opacity: 1, y: 0, easing: "snap"});

    //setTimeout(showIntroduction, 5000, next);
  //}

  //function getNext(e) {
    //// loops around
    //return e.next().length ? e.next() : e.parent().children().first()
  //}

  //setTimeout(showIntroduction, 10000, $('#introductions span:first-child'));
});


function find_component(place, component, property) {
  var value = place.address_components.filter(function(d) { return d["types"][0] === component; });

  return (value.length == 0) ? "" : value[0][property];
};
