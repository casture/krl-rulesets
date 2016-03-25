ruleset manage_fleet {

  meta {
  
  }

  global {
  
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
    
    }
  }
}
