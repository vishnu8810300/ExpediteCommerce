public class AccountController {
    
    @AuraEnabled(cacheable=true)
    public static String getAccounts() {
        // Fetch open Opportunities related to the Account
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, CloseDate, Amount
                                            FROM Opportunity 
                                            WHERE AccountId = '0015g00000Mu6T0AAJ'];
        
        // Prepare JSON-like structure for opportunities and associated Quotes/Quote Line Items
        List<Map<String, Object>> opportunityList = new List<Map<String, Object>>();
        
        for (Opportunity opp : opportunities) {
            Map<String, Object> opportunityMap = new Map<String, Object>();
            opportunityMap.put('Opportunity', opp);
            
            // Fetch Quotes related to the Opportunity
            List<Quote> quotes = [SELECT Id, Name, TotalPrice 
                                  FROM Quote 
                                  WHERE OpportunityId = :opp.Id];
            
            List<Map<String, Object>> quoteList = new List<Map<String, Object>>();
            
            for (Quote quote : quotes) {
                Map<String, Object> quoteMap = new Map<String, Object>();
                quoteMap.put('Quote', quote);
                
                // Fetch Quote Line Items related to the Quote
                List<QuoteLineItem> quoteLineItems = [SELECT Id, Quantity, UnitPrice, TotalPrice
                                                      FROM QuoteLineItem
                                                      WHERE QuoteId = :quote.Id];
                
                quoteMap.put('QuoteLineItems', quoteLineItems);
                quoteList.add(quoteMap);
            }
            
            opportunityMap.put('Quotes', quoteList);
            opportunityList.add(opportunityMap);
        }
        
        // Return the data as a JSON string
        return JSON.serializePretty(opportunityList);
    }
}
