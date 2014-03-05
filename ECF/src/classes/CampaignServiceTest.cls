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

	/*

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
	
	*/
	/*
	@isTest static void testIsProgrammeEvent() {
		// Test a with a regular Campaign record - expect false
		System.assert(!CampaignService.isProgrammeEvent(new Campaign()));
		
		// Test with a Programme Event - expect true
		Campaign pe = new Campaign();
		pe.RecordTypeId = CampaignService.CAMPAIGN_FILTER_ID;
		System.assert(CampaignService.isProgrammeEvent(pe));
	}

	*/
	
	// Test exsisting member of a Programme is added to a new event
	@isTest static void testAddMembersToProgramEvent() {
		Campaign[] programmes = CampaignTestDataFactory.createProgrammeWithEvents(2, 3, 3);
		
		
		// get programme
		Campaign program = programmes[0];
		
		// get contact we'll be adding to our test programme
		Contact c = CampaignTestDataFactory.getContact('testcase1', 'B002', true);
		
		Test.startTest();
		
		// add contact to top-level programme
		
		CampaignMember cm = CampaignTestDataFactory.getCampaignMember(c.Id, program.Id);
		insert cm;		
		
		// check that contact exists in all sub-events
		
		for (Campaign cmp : program.ChildCampaigns) {
			System.assert(CampaignTestsCommon.checkCampaignMemberOnCampaign(cmp.Id, c.Id),'Member/contact ' + c.id + ' does not exist on campaign ' + cmp.id);
		}
		
		
		Test.stopTest();
		
	} 
	

	
}