public class JqmRecordDmlController {

    private final static String JQM_RECORD_DML_JS = 'JqmRecordDmlComponentJS';
    public JqmRecordDmlConfig config {get; set;}

    // Parameter object to pass between JS controller and server controller.
    public virtual class JqmRecordDmlConfig {

        public String operation {get; set;}
        public String sobjectType {get; set;}
        public String jsCtlrName {get; set;}
        public Boolean debug {get; set;}
    }

    public JqmRecordDmlController() {
        this.config = new JqmRecordDmlConfig();
    }
    
    public virtual String getConfigAsJson() {
        String configStr = JSON.serialize(this.config);
        System.debug(configStr);
        return configStr;
    }
    
    public String getJqmRecordDmlComponentJS() {
        return this.config.debug ? JQM_RECORD_DML_JS : (JQM_RECORD_DML_JS + 'Min');
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
