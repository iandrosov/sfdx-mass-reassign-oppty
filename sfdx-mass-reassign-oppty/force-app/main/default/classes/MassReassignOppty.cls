/**
 * Name     : MassReassignOppty
 * Usage    : Class controller for Opportunity batch owner assignmnet.
 *  
 * Created By      : A.I.
 * Modified By     : A.I.
 * Modified Date   : Aug 11, 2016
 */
public without sharing class MassReassignOppty {	
   public List<OpptyObject> optyList {get; set;}
   // Use dummy Opportunity object for User lookup purpose to select/assign owner Id
   public Opportunity opportunity {get; set;}
   public Opportunity opptyFilter {get;set;}
   
   private integer list_size = 10; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   
   private Map<String,OpptyObject> selectedRecordMap;
      
    public MassReassignOppty() {
    	total_size = [select count() from Opportunity]; //set the total size in the constructor
    	optyList = new List<OpptyObject>();
    	// Dummy Opportunity
    	opportunity = new Opportunity();
    	opptyFilter = new Opportunity();
    	selectedRecordMap = new Map<String,OpptyObject>();
    }
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
            	con = queryOpportunity();
            }
            return con;
        }
        set;
    }
    
    public PageReference filterOpportunity() {
    	if(opptyFilter.OwnerId != null){
        	con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, CreatedDate, 
    						            LastModifiedDate, StageName, Type, 
    	                      OwnerId, Owner.FirstName, Owner.LastName, Owner.Username 
    	                      FROM Opportunity WHERE OwnerId =:opptyFilter.OwnerId ORDER BY Owner.Username LIMIT 1000]));
			con.setPageSize(list_size);
    	}else{
    		con = queryOpportunity();
    	}
    	return null;
    }
    
    private ApexPages.StandardSetController queryOpportunity(){
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, CreatedDate, 
    						            LastModifiedDate, StageName, Type, 
    	                      OwnerId, Owner.FirstName, Owner.LastName, Owner.Username 
    	                      FROM Opportunity WHERE OwnerId =:opportunity.OwnerId ORDER BY Owner.Username LIMIT 1000]));
                // sets the number of records in each page set
                std.setPageSize(list_size);
            
        
		return std;    	
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<OpptyObject> getOpportunityList() {
    	flagSelected();
        optyList = new List<OpptyObject>();
        if(con != null){
        	for (Opportunity o : (List<Opportunity>)con.getRecords()){
    			OpptyObject opt = new OpptyObject();
    			opt.name = o.Name;
    			opt.oid = o.Id;
    			opt.checked = getSelected(o.Id);
    			opt.oppty = o;
    			optyList.add(opt); 
        	}
        }
        return optyList;
    }
    
    public Boolean getSelected(String oid){
    	if (selectedRecordMap.containsKey(oid)){
    		return true;
    	}else{
    		return false;
    	}		
    }
    
    // Track what records been selected in the map select/deselect when list changes, pages change etc
    public void flagSelected() {
    	for (OpptyObject o : optyList){
    		// ADD selected Oppty
    		if (o.checked == true){
    			selectedRecordMap.put(o.oid, o);
    		}else{
    			// Check is any been deselected and remove fomr selectio list
    			if (selectedRecordMap.containsKey(o.oid)){
    				selectedRecordMap.remove(o.oid);
    			}
    		}
    	}
    }

    public Integer getSelectCount() {
    	Integer cnt = 0;
    	if (selectedRecordMap != null && selectedRecordMap.size() > 0){
    		cnt = selectedRecordMap.size();
    	}
   		return cnt;
    }

    public PageReference assignOpportunity() {
      try {	
      	System.debug('###  assignOpportunity Start');
      	// Refresh assignments in map
      	flagSelected();
    	List<Opportunity> lst = new List<Opportunity>();
    	List<OpptyObject> reassignList = (List<OpptyObject>)selectedRecordMap.values();
    	for (OpptyObject o : reassignList) {
    		System.debug('### Reassign Start Loop');
    		if (o.checked && opportunity.OwnerId != null) {
    		   System.debug('### Reassign OPTY:'+o.oid);	
    		   Opportunity upd = new Opportunity();
    		   upd.Id = o.oppty.Id;
    		   upd.OwnerId = opportunity.OwnerId; 
    		   	
    		   lst.add(upd);
    		}
    	}
    	if (lst.size() > 0){
    		
    		update lst;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Opportunities assigned');
            ApexPages.addMessage(myMsg);
            
			// Clear selected objects
			clearSelection();
    	}
      }	catch (Exception e) {
       	ApexPages.addMessages(e);   
        return null;    		
      }
      return null;
    }
       
    private void clearSelection(){
    	// Clear selected objects
		selectedRecordMap.clear();
		opportunity = new Opportunity();
		for (OpptyObject o : optyList){
			o.checked = false;
		}    		
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

     // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
     	 clearSelection();
         con.cancel();
     }
    
    // Wrapper class handle UI selections
    public class OpptyObject {
    	public String oid {get; set;}
    	public String name {get; set;}
    	public Boolean checked {get; set;}
    	public Opportunity oppty {get; set;}
    }
   
}