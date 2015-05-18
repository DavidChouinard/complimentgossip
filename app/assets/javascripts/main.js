var TEMPLATE_COUNT = 12;

$.fx.speeds._default = 200;

$(document).ready(function() {
  var typed = $("#introduction_content").typed({
    strings: ["David", "Olivia", "Nick", "Lei", "Chris",
      "Alex", "Liz", "James", "Heidi", "Matt"].map(function(d) { return d + " is…"; }),
    cursorChar: "",
    backDelay: 2000,
    loop: true
  });

  $('button, input[type="submit"]').on("click", function(e) {
    $(this).addClass("loading").val("");
  });

  $(".tip")
    .css({opacity: 0});

  if ($(".bigcard").length) {
    $(".prompt").height(4/6 * $(".prompt").width());
    fit($(".bigcard")[0], $(".prompt")[0]);
  }

  $(".prompt").hoverIntent(function() {
    $(".tip").transition({opacity: 1});
  }, function() {
    $(".tip").transition({opacity: 0});
  }).one("click", function() {
    if ($("#introduction_content").length) {
      $("#introduction_content", this).select();
      $("#introduction_content").data('typed').destroy();

      $(this).click(function() {
        $("#introduction_content", this).focus();
      });
    }
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
    //var intros = [
      //"is <mark>bold</mark>, <mark>wondrous</mark> and an incredible friend.",
      //"one of the most <mark>genuine</mark> and <mark>thoughtful</mark> people I know.",
      //"always takes common courtesy to uncommon levels.",
      //"is <mark>passionate</mark> and <mark>fearless</mark>: he inspires me to be ambitious.",
      //"is the most <mark>brilliantly creative</mark> person I’ve met."]

    //var input = document.getElementById("introduction_content");
    //new Awesomplete(input, {
      //minChars: 0,
      //list: intros,
      //sort: function() {
        //return 0;  // keep original sort
      //},
      //filter: function (text, input) {
        //return (input.trim().split(" ").length - 1) <= 3
      //},
      //item: function(text, input){
        //var html = input.trim().split(" ")[0].capitalizeFirstCharacter() + " " + text
          //.replace(RegExp(input, "gi"), "$&")
          //.replace(/\{/, "");

        //return Awesomplete.$.create("li", {
            //innerHTML: html, "aria-selected": "false"
        //});
      //}
    //});

    var LINE_HEIGHT = 34;
    var PADDING = 4;

    $('#introduction_content').on('input propertychange', function(e) {
      if (($(this)[0].scrollHeight + 2 * PADDING) / LINE_HEIGHT >= 3) {

        // delete last entered char
        $(input).val(function(index,value) {
          return value.substr(0,value.length-1);
        })

        // Handle copy paste case recursively
        $(this).trigger("input");
      }
    });
  }

  if ($(".template-picker").length) {
    var current_template = 0;  // 0 = no template
    update_template_state(current_template);

    // TODO: prefetch images
    //for(var i = 1; i <= TEMPLATE_COUNT; i++) {
      //(new Image()).src = "assets/templates/" + i + ".png";
    //}

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
      $(".card-overlaid").css({"border-color": "#2ecc71"});

      $(".card-overlay > div")
        .css({opacity: 0, scale: 3, "padding-top": 2})
        .transition({opacity: 1, scale: 1, easing: "snap"});
    }, 700);

    setTimeout(function() {
      $(".card-overlay")
        .transition({opacity: 0}, function () {
          $(this).remove();
        })

      $(".card-overlaid").transition({"border-color": "#D3D3D3"});
    }, 4000);
  }

  if ($(".card-stack").length) {
    $(".card-stack").each(function() {
      var key = $(".card:first-child", this).data("key")
      show_card_stack_key($(this).parent(), key);
    });

    $(".cards .card-stack").each(function(i) {
      update_card_stack_state($(this));
    });

    $(".cards:has(.card-stack)").hover(function() {
      var width = $(this).find(".card").width() + 15;

      $(this).children(".card-text").transition({"opacity": 0 })
      $(this).find(".card-stack *:not(:first-child)").each(function(i) {
        $(this).transition({"left": width * (i + 1) })
      });
    }, function() {
      $(this).children(".card-text").transition({"opacity": 1 })
      update_card_stack_state($(this).find(".card-stack"));
    });

    $(".card-stack .card").click(function() {
      show_card_stack_key($(this).parent().parent(), $(this).data("key"));

      $(this).insertBefore($(this).parent().children().first());
      $(this).parent().parent().children(".card-text").transition({"opacity": 1 })

      update_card_stack_state($(this).parent().parent().find(".card-stack"));
    });
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
        $("#introduction_recipient_street_line1").val(place["name"]);
        $("#introduction_recipient_street_line2").val(address);
      } else {
        $("#introduction_recipient_street_line1").val(address);
      }

      var city = find_component(place, "locality", "long_name")
      if (city == "") {
        city = find_component(place, "postal_town", "long_name")
      }

      var state = find_component(place, "administrative_area_level_1", "short_name")
      if (state == "") {
        state = find_component(place, "administrative_area_level_2", "short_name")
      }

      $("#introduction_recipient_city").val(city);
      $("#introduction_recipient_state").val(state);
      $("#introduction_recipient_postal_code").val(find_component(place, "postal_code", "long_name"));
      $("#introduction_recipient_country").val(find_component(place, "country", "short_name"));
    });

    // prevent form submission
    $("#google-autocomplete").keypress(function (e) {
      if (e.which == 13) {  //enter key
        e.preventDefault();
      }
    });
  }
});


function find_component(place, component, property) {
  var value = place.address_components.filter(function(d) { return d["types"].indexOf(component) != -1; });

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
    $(".bigcard").attr("id", null);
    $("#introduction_template").val(null);
  } else {
    $(".bigcard").attr("id", "template-" + template);
    $("#introduction_template").val(template);
  }
};

function update_card_stack_state($parent) {
  $parent.children().each(function(i) {
    $(this).transition({"left": 4 * i, "z-index": 100 - i })
  });
}

function show_card_stack_key($parent, key) {
  $parent.children(".card-text").each(function() {
    if ($(this).data("key") === key) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
}

String.prototype.capitalizeFirstCharacter = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}
