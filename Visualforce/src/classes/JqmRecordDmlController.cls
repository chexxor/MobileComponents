public class JqmRecordDmlController {

    public JqmRecordDmlConfig config {get; set;}

    // Parameter object to pass between JS controller and server controller.
    public virtual class JqmRecordDmlConfig {

        public String operation {get; set;}
        public String sobjectType {get; set;}
    }

    public JqmRecordDmlController() {
        this.config = new JqmRecordDmlConfig();
    }
    
    @RemoteAction
    public static Sobject performOperation(Map<String, String> fieldNameToValueMap) {
    	
    	System.debug('fieldNameToValueMap: ' + fieldNameToValueMap);
	    
	    Lead newSobject = new Lead();
	    for (String fieldName : fieldNameToValueMap.keySet()) {
	        String fieldValue = fieldNameToValueMap.get(fieldName);
	        if (fieldName != 'sobjectType' && fieldName != 'operation') {
	            newSobject.put(fieldName, fieldValue);
	        }
	    }
	    
	    System.debug('newSobject: ' + newSobject);
	    Database.insert(newSobject);
    	
        return newSobject;
    }
}
