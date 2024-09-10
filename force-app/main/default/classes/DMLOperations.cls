/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount= new Account(Name='Apex Test Account',Type='Prospect');
        // Set some fields on the Account

        // Insert the Account into the database
        insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {// Create a new Account and set the fields inline

        Account newAccount= new Account (Name=name, Industry=industry);         // Insert the Account

    Insert newAccount;    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        Contact newContact = new Contact (FirstName='Aaron', LastName='Greenberg', AccountId=accountId); // Create a new Contact instance &  Set some fields on the Contact // Set the AccountId field to the given accountId
        insert newContact;    // Insert the Contact into the database

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        Contact existingContact = [SELECT Id FROM Contact WHERE Id = :contactId]; //create a Contact instance and populate the Id.
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        existingContact.LastName= newLastName; // Update the Contact's last name
        update existingContact;
        // Update the Contact in the database
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity varOpportunity = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        varOpportunity.StageName=newStage;         // Update the Opportunity's stage
        Upsert varOpportunity;    // Update the Opportunity in the database
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        
        Account varAccount=[SELECT Id FROM Account WHERE Id = :accountId]; // Query the account
            // [SELECT Id FROM Account WHERE Id = :accountId]

        varAccount.Name=newName;
        varAccount.Industry=newIndustry;    // Update the Account with the given Id with the new name and industry
        update varAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        for(Opportunity currentIteminLoop:opportunities){
        currentIteminLoop.StageName='Qualification';
        currentIteminLoop.CloseDate=Date.today().AddMonths(3);
        currentIteminLoop.Amount=50000;    
        }
        upsert opportunities;
            // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        // Upsert the opportunities List so that records are either updated or created
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There needs to be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        List <Account> Accounts = [SELECT Id FROM Account WHERE Name = :accountName]; // Query the account
        Account varAccount = new Account(Name=accountName);
        if(Accounts.isempty()){
        insert varAccount;}
        else {varAccount=[SELECT Id FROM Account WHERE Name = :accountName];}    
        Map<String,Opportunity> opportunityNametoRecordMap = new Map<String,Opportunity>();
        List <Opportunity> existingOpportunities = [SELECT Id, Name FROM Opportunity WHERE Name IN :oppNames];
        for (Opportunity OppinList: existingOpportunities){
            opportunityNametoRecordMap.put(OppinList.Name,OppinList); // Populate the map with the Name, Record
        }
        List <Opportunity> OppstoUpsert= new List <Opportunity>();
        for (String oppName:OppNames){
            Opportunity varOpp = new Opportunity();
            if(OpportunityNametoRecordMap.keySet().contains(oppName)){//if the key set contains OppName
                varOpp.AccountId=varAccount.Id;
                varOpp.Id=opportunityNametoRecordMap.get(oppName).Id; // Define the Opportunity instance as the result of the Map's value, which is an Opp record, and provide the Id
                varOpp.Name=oppName;
                OppstoUpsert.add(varOpp);
            }
            else{
                varOpp.AccountId=varAccount.Id;
                varOpp.Name=oppName;
                OppstoUpsert.add(varOpp);
            }
        }
            upsert OppstoUpsert;
    }
                 
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account varAccount= new Account();   
		// if the Account exists, update the description
        If(!accounts.isempty()){
            varAccount=accounts[0];
            varAccount.Description='Updated Account';
            }
            else {
                    varAccount.Description='New Account';
                    varAccount.Name=accountName;
                    }
		// otherwise, create a new Account and set the description
		// Upsert the Account
		upsert varAccount;
        return varAccount;
	}
//for(Account currentAccountinLoop: accounts){
        //    currentAccountinLoop.Description='Updated'
       // }
    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        for(Contact contactIteminLoop: ContactsToUpsert){ // Loop through each Contact
            Account varAccount = upsertAccount(contactIteminLoop.LastName); // Call the method from 9 to upsert on the basis of Account Name.
            contactIteminLoop.AccountId=varAccount.Id;}
            Upsert contactstoUpsert;

		// Get the account based on the name or create one if it doesn't exist

		// Link the Contact to its Account using the Account Id

	// Upsert the Contacts
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List <Lead> newLeads = new List <Lead>();
        // Loop through each Lead name
        for(String currentIteminLoop:LeadNames){
        Lead varLead= new Lead();
            // Insert the Leads
        varLead.FirstName=currentIteminLoop;
        varLead.LastName='Last Name';
        varLead.Company='Test Company';
        newLeads.add(varLead);
        }
        insert newLeads;
        // Delete the Leads
        delete newLeads;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List <Case> newCases = new List <Case>();
     for(Integer i=0; i<numOfCases; i++){
        Case newCase= new Case(AccountId=accountId);
        newCases.add(newCase);
    }
    insert newCases;

        // Delete the cases
    delete newCases;
    }
}