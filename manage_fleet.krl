ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<
2nd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
    
    use module  b507199x5 alias wranglerOS
  }

  global {
    trips = function() {
      report = {};
      results = wranglerOS:subscriptions();
      subscriptions = results{"subscriptions"};
      subscriptions.forEach(function(sub) {
        trips = sub.trips();
        report{sub.name} = trips;
      })
    }
  }
  
  rule create_vehicle {
    select when car new_vehicle
    pre {
      attributes = {}
        .put(["Prototype_rids"],"b507729x2.prod") // semicolon separated rulesets the child needs installed at creation
        .put(["name"],"Vehicle1") // name for child
        
    }
    {
      event:send({"cid":meta:eci()}, "wrangler", "child_creation")  // wrangler os event.
      with attrs = attributes.klog("attributes: "); // needs a name attribute for child
    }
    always {
      log "ehllo"
    }
  }
  
  rule auto_accept {
    select when wrangler inbound_pending_subscription_added 
    pre {
      attributes = event:attrs().klog("subcription :");
    }
    noop();
    always {
      raise wrangler event 'pending_subscription_approval'
        attributes attributes;        
      log("auto accepted subcription.");
    }
  }
}
