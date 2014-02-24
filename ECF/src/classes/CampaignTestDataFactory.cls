/**
 * This class contains utilities for testing the Campaign object.
 */
public class CampaignTestDataFactory {
	
	/**
	 * Creates a Programme type Campaign record with the specified number of events.
	 */
	public static Campaign createProgrammeWithEvents(Integer events) {
		Campaign programme = createProgramme();
		for (Integer i = 0; i < events; i++) {
			createProgramEvent(programme);
		}
		return programme;
	}
	
	/**
	 * Creates a Programme type Campaign.
	 */
	public static Campaign createProgramme() {
		Campaign programme = new Campaign();
		programme.RecordTypeId = getRecordTypeInfoForProgramme().getRecordTypeId();
		return programme;
	}
	
	/**
	 * Create a Program Event for the parent Programme.
	 */
	public static Campaign createProgramEvent(Campaign parent) {
		Campaign programEvent = new Campaign();
		// Set the parent Programme for this instance
		programEvent.ParentId = parent.Id;
		// Set the RecordTypeId
		programEvent.RecordTypeId = getRecordTypeInfoForProgramEvent().getRecordTypeId();
		return programEvent;
	}
	
	public static List<CampaignMember> getMembers(Campaign campaign) {
		List<CampaignMember> members = [SELECT ContactId FROM CampaignMember WHERE CampaignId = :campaign.Id];
		return members;
	}
	
	private static List<CampaignMember> createMembers(Campaign campaign, Integer amount) {
		List<CampaignMember> members = new List<CampaignMember>();
		for (Integer i = 0; i < amount; i++) {
			CampaignMember m = new CampaignMember();
			Contact c = new Contact();
			m.ContactId = c.Id;
			m.CampaignId = campaign.Id;
			members.add(m);
		}
		return members;
	}
	
	private static Schema.RecordTypeInfo getRecordTypeInfoForProgramEvent() {
		return getRecordTypeInfo('Program Event');
	}
	
	private static Schema.RecordTypeInfo getRecordTypeInfoForProgramme() {
		return getRecordTypeInfo('Programme');
	}
	
	private static Schema.RecordTypeInfo getRecordTypeInfo(String type) {
		Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
		return typesByName.get(type);
	}
}