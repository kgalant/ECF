trigger Campaign_After_Insert on Campaign (after insert) {
	System.debug(loggingLevel.INFO, 'Entering Trigger: Campaign_After_Insert');

	// Extract Record Type definitions for filtering
	Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
	Map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
	
	Id rt = typesByName.get('Programme Event').getRecordTypeId();
	
	List<Campaign> events = new List<Campaign>();
	
	// Iterate over each Campaign object 
	for (Campaign c : Trigger.new) {
		System.debug('Examining Campaign: ' + c.Name);
		// Filter on Record Type Programme only
		System.debug('Record Type Id = ' + c.RecordTypeId);
		if (c.RecordTypeId != null && c.RecordTypeId == rt) {
			// Record is an event
			System.debug('Campaign is of type Event');
			events.add(c);
		}
	}
	
	if(events.size() > 0) {
		System.debug(events.size() + ' Programme records sent to service');
		CampaignService.addMembersToProgramEvents(events);
	}
	System.debug(loggingLevel.INFO, 'Exiting Trigger: Campaign_After_Insert');

}