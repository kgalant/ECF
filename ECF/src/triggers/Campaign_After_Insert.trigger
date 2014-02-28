trigger Campaign_After_Insert on Campaign (after insert) {
	// Extract Record Type definitions for filtering
	Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
	Map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
	
	// Get the Id of the Record Type used for filtering
	Id rt = typesByName.get('Programme Event').getRecordTypeId();
	
	// Container for the new Programme Events 
	List<Campaign> events = new List<Campaign>();
	
	// Iterate over each Campaign object 
	for (Campaign c : Trigger.new) {
		System.debug('Examining Campaign: ' + c.Name);
		// Filter on Record Type Programme only
		System.debug('Record Type Id = ' + c.RecordTypeId);
		if (CampaignService.isProgrammeEvent(c)) {
			// Record is an event
			System.debug('Campaign is of type Event');
			events.add(c);
		}
	}
	
	// If any Programme Event records are stored, pass them on to the service
	if(events.size() > 0) {
		System.debug(events.size() + ' Programme Event records sent to service');
		CampaignService.addMembersToProgramEvents(events);
	}
}