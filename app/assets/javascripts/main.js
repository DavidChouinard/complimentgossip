var TEMPLATE_COUNT = 13;

$(document).ready(function() {
  $("#introduction_content").typed({
    strings: ["David is…", "Heidi is…", "Alyssa is…", "Pierre is…", "Alex is…"],
    //attr: "placeholder",
    cursorChar: "",
    backDelay: 2000,
    loop: true
  });

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

  if ($(".cards").length) {
    $(".cards > .card:not(.card-fadded)").hover(function() {
      $(".card-preview > img").attr("src", $(this).attr("src"));
      $(".card-preview").show()
    }, function() {
      $(".card-preview").hide()
    });
  }

  if ($("#introduction_content").length) {
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
  }

  if ($(".template-picker").length) {
    var current_template = 0;  // 0 = no template
    update_template_state(current_template);

    // TODO: prefetch images

    $(".template-picker > div:first-child").on("click", function() {
      if (current_template > 0) {
        current_template--;
        update_template_state(current_template);
      }
    });

    $(".template-picker > div:last-child").on("click", function() {
      if (current_template < TEMPLATE_COUNT) {
        current_template++
        update_template_state(current_template);
      }
    });
  }

  if ($(".card-overlay").length) {
    setTimeout(function() {
      $(".card-overlay > div")
        .css({opacity: 0, scale: 3, "padding-top": 2})
        .text("Sent!")
        .transition({opacity: 1, scale: 1, easing: "snap"});
    }, 4000);

    setTimeout(function() {
      $(".card-overlay")
        .transition({opacity: 0}, function () { $(this).remove(); })
        //.hide();
    }, 6000);
  }

  if ($("#google-autocomplete").length) {
    var autocomplete = new google.maps.places.Autocomplete(document.getElementById('google-autocomplete'),
        { types: ['establishment'] });

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();

      var address = find_component(place, "street_number", "long_name") + " " + find_component(place, "route", "short_name");
      var subpremise = find_component(place, "subpremise", "long_name");

      if (subpremise !== "") {
        address += " # " + subpremise;
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

function update_template_state(template) {
  if (template == 0) {
    $(".template-picker > div:first-child").attr("class", "disabled");
  } else if (template == TEMPLATE_COUNT) {
    $(".template-picker > div:last-child").attr("class", "disabled");
  } else {
    $(".template-picker > div").attr("class", null);
  }

  if (template == 0) {
    $(".prompt").attr("id", null);
    $("#introduction_template").val(null);
  } else {
    $(".prompt").attr("id", "template-" + template);
    $("#introduction_template_id").val(template);
  }
};
