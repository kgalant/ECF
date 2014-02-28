/**
 * Unit test class for the CampaignService.
 */
@isTest
class CampaignServiceTest {

	// Test exsisting member of a Programme is added to a new event
	@isTest static void testAddMembersToProgramEventsNull() {
		List<CampaignMember> newMembers = CampaignService.addMembersToProgramEvents(null);
		System.assert(newMembers != null && newMembers.size() == 0);
	}

	// Test exsisting member of a Programme is added to a new event
	@isTest static void testAddMembersToProgramEvents() {
		// Setup test data
		List<Campaign> progs = CampaignTestDataFactory.createProgrammeWithEvents(2, 2, 10);
		
		// Run through the programmes, extract the events and pass them to the test method
		for (Campaign p : progs) {
			CampaignTestDataFactory.createProgramEvent(p);
			List<CampaignMember> newMembers = CampaignService.addMembersToProgramEvents(p.ChildCampaigns);
			// expect each programme to have 10 members on each event - including the new one
			System.assert(newMembers != null && newMembers.size() == 10);	 
		}
	}
	
	@isTest static void testIsProgrammeEvent() {
		// Test a with a regular Campaign record - expect false
		System.assert(!CampaignService.isProgrammeEvent(new Campaign()));
		
		// Test with a Programme Event - expect true
		Campaign pe = new Campaign();
		pe.RecordTypeId = CampaignService.CAMPAIGN_FILTER_ID;
		System.assert(CampaignService.isProgrammeEvent(pe));
	}
	
}