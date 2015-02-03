# $ ->  replaces $(function)  as document.ready()

#	a = 1
#	b=5 if a>10

#	sayHello = -> 
#		alert "Hello"
	# sayHello()

#	capitalize = (word) ->
#		word.charAt(0).toUpperCase() + word.slice(1)
	# alert(capitalize("tam"))

#	$("a").click -> 
#		$(@).html("Hahahahaha")
#		false

# coffee script exercises:  http://jquery-drills.herokuapp.com/coffee/
# exercise One:  to implement a toggle color button
$ ->
#append button here or add a button to the ERB page:	<%= link_to "Click me", "javascript:void(0);", class: "btn btn-primary" %>

# add buttons to the About.html page directly
#	$('body').append("<button class='btn btn-primary btn1'>Ex 1</button>")
#	$('body').append("<button class='btn btn-primary btn2'>Ex 2</button>")

	$('.btn1').click ->
			$(@).toggleClass("btn-danger")

  $(".btn2").click ->
      $(@).animate({
          height: "+=10",
          width: "+=50",
          fontSize: "+=5"
        })

  # Exercise 3:
  capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice(1)


  $("#ex3-entry").keyup ->
    word_array = $(@).val().split(" ")

    console.log word_array
    # map (word) <-- spacing does matter!
    result = word_array.map (word) -> capitalize(word)
    #result = capitalize for word in word_array
    $("#ex3-output").text( result.join(" ") )


