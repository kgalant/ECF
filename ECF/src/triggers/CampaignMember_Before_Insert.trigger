trigger CampaignMember_Before_Insert on CampaignMember (before insert) {
	// check whether this campaign is a parent campaign with events that would need members updated
	
	CampaignMember[] toDo = new list<CampaignMember>();
	
	for (CampaignMember cm : Trigger.new) {
		if (CampaignCommon.isCampaignProgramme(cm.CampaignId) && CampaignCommon.hasChildEvents(cm.CampaignId)) {
			toDo.add(cm);
		}	
	}
	
	
	
	// call service with list of all CampaignMembers which may require a child event update
	System.debug(LoggingLevel.INFO, '@@ Calling CampaignMemberService class from CampaignMember_before_insert trigger with ' + toDo.size() + 'items of work.');
	if (toDo.size() > 0) {
		CampaignMemberService.doAdd(toDo);
	}
}