ruleset echo {

  meta {
    name "Echo"
    description <<
1st Ruleset for Reactive Single Pico lab
>>
    author "Micah Weatherhead"
    logging on
  }
  
  rule hello {
    select when echo hello {
      send_directive("say") with
        something = "Hello World"
    }
  }
}
