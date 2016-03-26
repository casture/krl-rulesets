ruleset track_trips {

  meta {
    name "Track Trips"
    description <<
2nd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
  }
  
  global {
    long_trip = 1000;
  }

  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage")
    }
    noop();
    fired {
      raise explicit event 'trip_processed'
        attributes event:attrs()
    }
  }
  
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").defaultsTo(15, "dumbzzzzzz").klog("Mileage: ");
    }
    { 
      send_directive("find_trip") with
        long_trip_length = mileage
    }
    fired {
      log "Long trip limit: "+long_trip;
      raise explicit event 'found_long_trip' 
        attributes event:attrs()
        if (mileage > long_trip);
    }
  }
  
  rule child_to_parent {
    select when wrangler init_events
    pre {
       // find parant 
       // place  "use module  b507199x5 alias wrangler_api" in meta block!!
       parent_results = wrangler_api:parent();
       parent = parent_results{'parent'};
       parent_eci = parent[0]; // eci is the first element in tuple 
       attrs = {}.put(["name"],"Sub_Name")
          .put(["name_space"],"Fleet_Subscriptions")
          .put(["my_role"],"Vehicle")
          .put(["your_role"],"Fleet")
          .put(["target_eci"],parent_eci.klog("target Eci: "))
          .put(["channel_type"],"Pico_Tutorial")
          .put(["attrs"],"success")
          ;
    }
    {
     noop();
    }
    always {
      raise wrangler event "subscription"
        attributes attrs;
    }
  }

}

