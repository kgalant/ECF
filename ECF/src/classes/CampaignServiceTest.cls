/**
 * Unit test class for the CampaignService.
 */
@isTest
class CampaignServiceTest {

	// Test exsisting member of a Programme is added to a new event
	@isTest static void testAddMembersToProgramEvents() {
	//	Campaign programme = CampaignTestDataFactory.createProgramme();
	//	Campaign event = CampaignTestDataFactory.createProgramEvent(programme);
		CampaignService.addMembersToProgramEvents(null);
		
		System.assert(false);
	}
	
	@isTest static void testIsProgrammeEvent() {
		// Expect false
		System.assert(!CampaignService.isProgrammeEvent(new Campaign()));
		// Expect true
		Campaign pe = new Campaign();
		pe.RecordTypeId = CampaignService.CAMPAIGN_FILTER_ID;
		System.assert(CampaignService.isProgrammeEvent(pe));
	}
	
}