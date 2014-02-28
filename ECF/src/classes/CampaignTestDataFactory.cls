/**
 * This class contains utilities for testing the Campaign object.
 */
public class CampaignTestDataFactory {
	
	private static Map<String,Schema.RecordTypeInfo> typesByName = null;
	
	/**
	 * Creates a Programme type Campaign record with the specified number of events.
	 */
	public static List<Campaign> createProgrammeWithEvents(Integer numOfProgrammes, Integer eventsPerProgramme, Integer contactsPerEvent) {
		list<Campaign> allProgrammes = new list<Campaign>();
		list<Campaign> allEvents = new list<Campaign>();
		list<CampaignMember> allMembers = new list<CampaignMember>();
		list<Contact> allContacts = new list<Contact>();
		
		// 1. generate all the contacts needed
		
		for (Integer c = 0; c < contactsPerEvent * numOfProgrammes; c++) {
			allContacts.add(getContact(null, 'B001', false));
		}
		
		if (allContacts.size() > 0 )
			insert allContacts;
		
		// 2. generate top-level programmes
		
		for (Integer p = 0; p < numOfProgrammes; p++) {

			// create programme
			allProgrammes.add(createProgramme(null, null, null, false,'Programme', null));
			
		}
		
		if (allProgrammes.size() > 0 )
			insert allProgrammes;
			
		// 3. generate programme sub-events
		
		for (Campaign p : allProgrammes) {

			// create sub-events
			for (Integer e = 0; e < eventsPerProgramme; e++) {
				allEvents.add(createProgramme(null, null, null, false,'Programme Event', p.Id));
			}
			
		}
		
		if (allEvents.size() > 0 )
			insert allEvents;
		
		
		
		// 4. add campaignmembers to events
		
		// refresh campaign list first to get all the children
		
		allProgrammes = [SELECT Id, Name, (SELECT ID, Name FROM Campaign.ChildCampaigns) 
						FROM Campaign WHERE parentid = null and RecordTypeId IN (SELECT Id FROM RecordType WHERE SObjectType ='Campaign' AND Name='Programme')];
						
		Set<Id> programmeIds = new Set<Id>();
		for (Campaign c : allProgrammes) 
			programmeIds.add(c.Id); 						
						
		allEvents = [SELECT Id, Name, (SELECT ID, Name FROM Campaign.ChildCampaigns) 
					FROM Campaign WHERE parentid IN :programmeIds and RecordTypeId IN (SELECT Id FROM RecordType WHERE SObjectType ='Campaign' AND Name='Programme Event')];						
		
		for (Campaign p : allProgrammes) {
 
			// add members to child campaigns
			for (Campaign child : p.ChildCampaigns) {
				for (Integer c = 0; c < contactsPerEvent; c++) {
					allMembers.add(getCampaignMember(allContacts[c].Id, child.Id));
				}
			}
			
			// add members to parent campaign
			for (Integer c = 0; c < contactsPerEvent; c++) {
					allMembers.add(getCampaignMember(allContacts[c].Id, p.Id));
			}
			
			// now get rid of the contacts we just used from the list
			for (Integer c = 0; c < contactsPerEvent; c++) {
					allContacts.remove(0);
			}
		}		
		
		if (allMembers.size() > 0 )
			insert allMembers;
		
		return allProgrammes;
	}
	
	private static CampaignMember getCampaignMember(Id contactId, Id campaignId) {
		CampaignMember cm = new CampaignMember();
		cm.ContactId = contactId;
		cm.CampaignId = campaignId;
		return cm;
	}
	
	/**
	 * Creates a Programme type Campaign.
	 */
	public static Campaign createProgramme(String baseName, Date startDate, Date endDate, boolean doInsert, String programmeType, Id parent) {
		if (baseName == null)
			baseName = 'Dummy Campaign';
		if (startDate == null)
			startDate = System.now().date();
		if (endDate == null || endDate < startDate)
			endDate = startDate + 100;
		if (doInsert == null)
			doInsert = false;
		Campaign programme = new Campaign();
		programme.Name = baseName + String.valueOf(System.now());
		programme.StartDate = startDate;
		programme.EndDate = endDate;
		if (programmeType == 'Programme') {
			programme.RecordTypeId = getRecordTypeInfoForProgramme().getRecordTypeId();
		} else if (programmeType == 'Programme Event') {
			programme.RecordTypeId = getRecordTypeInfoForProgrammeEvent().getRecordTypeId();
		}
		if (parent != null) {
			programme.ParentId = parent;
		}
		
		if (doInsert)
			insert programme;
		return programme;
	}
	
	/**
	 * Creates a new Program Event with no members as a child of the parent Programme.
	 */
	public static Campaign createProgramEvent(Campaign programme) {
		Campaign programEvent = new Campaign();
		programEvent.ParentId = programme.Id;
		programEvent.RecordTypeId = CampaignService.CAMPAIGN_FILTER_ID;
		return programEvent;
	}

	/*
	public static List<CampaignMember> getMembers(Campaign campaign) {
		List<CampaignMember> members = [SELECT ContactId FROM CampaignMember WHERE CampaignId = :campaign.Id];
		return members;
	}
	*/
	
	/*
	private static List<CampaignMember> createMembers(Campaign campaign, Integer amount) {
		List<CampaignMember> members = new List<CampaignMember>();
		for (Integer i = 0; i < amount; i++) {
			CampaignMember m = new CampaignMember();
			Contact c = getContact(null, 'B001', true);
			m.ContactId = c.Id;
			m.CampaignId = campaign.Id;
			members.add(m);
		}
		return members;
	}
	*/
	
	private static Schema.RecordTypeInfo getRecordTypeInfoForProgrammeEvent() {
		return getRecordTypeInfo('Programme Event');
	}
	
	private static Schema.RecordTypeInfo getRecordTypeInfoForProgramme() {
		return getRecordTypeInfo('Programme');
	}
	
	private static Schema.RecordTypeInfo getRecordTypeInfo(String type) {
		if (typesByName == null) {
			Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
			typesByName = r.getRecordTypeInfosByName();
		}
		return typesByName.get(type);
	}
	
	private static Contact getContact(String lastName, String branch, boolean doInsert) {
		if (doInsert == null) 
			doInsert = false;
		if (branch == null) 
			branch = 'B002';
		if (lastName == null)
			lastName = 'Dummy';
		
		Contact c = new Contact();
		c.LastName = lastname + ' ' + String.valueOf(System.now());
		c.Branch__c = branch;
		
		if (doInsert) {
			insert c;
		}
		return c;		
	}
	
}