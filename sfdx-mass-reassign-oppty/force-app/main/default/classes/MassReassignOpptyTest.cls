/**
 * Name     : MassReassignOpptyTest
 * Usage    : Class controller for Opportunity batch owner assignmnet.
 *  
 * Created By      : A.I.
 * Modified By     : A.I.
 * Modified Date   : Sep 14, 2016
 */
@isTest
private class MassReassignOpptyTest {

	@testSetup static void setup() {
        Date cdt = Date.today();
        cdt.addDays(5);
        Opportunity opp = new Opportunity(Name='Test Oppty', StageName='Prospecting',CloseDate=cdt);
        
		insert opp;        
    }
    static testMethod void OpptyObjectTest(){
        MassReassignOppty.OpptyObject obj = new MassReassignOppty.OpptyObject();
        obj.checked = true;
        obj.oid = '00a12432gu31167AAA';
        obj.name = 'Test Oppty';
        obj.oppty = null;
    }
    static testMethod void massReassignOpptyTest(){
        List<User> testUsrLst = [SELECT Id, UserName FROM User];
        // === Start Test ===
        Test.startTest();
        MassReassignOppty ctrl = new MassReassignOppty();
        List<MassReassignOppty.OpptyObject> inputLst = new List<MassReassignOppty.OpptyObject>();
        if(testUsrLst != null && testUsrLst.size()>0){
            Opportunity opp = new Opportunity();
            opp.OwnerId = testUsrLst[0].Id;
            ctrl.opptyFilter = opp;
            
            List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity];
            MassReassignOppty.OpptyObject oo = new MassReassignOppty.OpptyObject();
            oo.checked = true;
            oo.name = 'Test';
            oo.oid = oppList[0].Id;
            oo.oppty = oppList[0];
            inputLst.add(oo);
            ctrl.optyList = inputLst;
          
        }                
        List<MassReassignOppty.OpptyObject> lst = ctrl.getOpportunityList();
        PageReference pr = ctrl.assignOpportunity();
		Test.StopTest();         
        system.assertEquals(0,lst.size());
    }
    
    static testMethod void filterOpportunityTest(){
        List<User> testUsrLst = [SELECT Id, UserName FROM User];
        // === Start Test ===
        Test.startTest();
        MassReassignOppty ctrl = new MassReassignOppty();
        if(testUsrLst != null && testUsrLst.size()>0){
            Opportunity opp = new Opportunity();
            opp.OwnerId = testUsrLst[0].Id;
            ctrl.opptyFilter = opp;
        }                
        PageReference pr = ctrl.filterOpportunity();
		Test.StopTest();                 
    }
    static testMethod void flagSelectedTest(){
        List<User> testUsrLst = [SELECT Id, UserName FROM User];
        List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity];
        // === Start Test ===
        Test.startTest();
        MassReassignOppty ctrl = new MassReassignOppty();
        List<MassReassignOppty.OpptyObject> lst = new List<MassReassignOppty.OpptyObject>();
        if(testUsrLst != null && testUsrLst.size()>0){
            Opportunity opp = oppList[0];
            opp.OwnerId = testUsrLst[0].Id;
            ctrl.opptyFilter = opp;
            MassReassignOppty.OpptyObject oo = new MassReassignOppty.OpptyObject();
            oo.checked = true;
            oo.name = 'Test';
            oo.oid = opp.Id;
            oo.oppty = opp;
            lst.add(oo);
            ctrl.optyList = lst;
        }                
        ctrl.flagSelected();
        Integer cnt = ctrl.getSelectCount();
        ctrl.cancel();
        Boolean isnext = ctrl.hasNext;
        Boolean isprior = ctrl.hasPrevious;
        Integer nbr = ctrl.pageNumber;
        ctrl.first();
        ctrl.next();
        ctrl.previous();
        ctrl.last();
        ctrl.previous();
        Boolean sel = ctrl.getSelected(oppList[0].Id);
		Test.StopTest();   
        system.assertEquals(1, cnt);
        system.assertEquals(1, nbr);
        system.assertEquals(false, isnext);
        system.assertEquals(false, isprior);
    }
}