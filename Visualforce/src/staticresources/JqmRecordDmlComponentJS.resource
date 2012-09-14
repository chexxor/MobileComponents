
(function($) {

	/**
	* Class representing a RecordDml component, which uses form and inputs to 
	    perform DML operations on a record.
	*/
	$V.JqmRecordDmlComponent = $V.Component.extend({

	    // Override Component.init
	    init: function(config) {
	        var that = this;
	        that._super(config);
	        that.applyEvents();
	        
	        $(document).on('listitemselect', function(e, context) {
                if (context.config.sObjectType == that.config.sObjectType) that.render(context.data);
            });
	    },

	    // Override Component.prepare
	    prepare: function() {
	        this._super();
	        //Get the selected item Id from the App.
	        
	    },

	    // Override Component.render
	    render: function(selectedRecord) {
	        this._super();
	        console.log('RecordDml selectedRecord: ', selectedRecord);
	        //Get all the fields from the selected record, and push them into the form.
	        JqmRecordDmlComponentUtil.setFormFieldValues(selectedRecord);
	    },

        applyEvents: function() {
            /*
            $V.App.log.debug('RecordDml this.config.elemId: ', this.config.elemId);
            this.$me = $('[id="'+ this.config.elemId + '"]');
            this.$me.on('submit', this.onJqmFormSubmit);
            */
            
            $(document).ready(function($){
                $('#jqmForm').live('submit', function(e){
                    e.preventDefault();
                    console.log('onClick: ', this);//this = the form element
                    console.log('onClick e: ', e);//e = jQuery.Event
                    //TODO: Find a way to call the method on this Component, not the window.
                    JqmRecordDmlComponentUtil.onJqmFormSubmit(this);
                    //var onJqmFormSubmitFn = $V.App.getFn('onJqmFormSubmit', '$V.JqmRecordDmlComponent');
                    //onJqmFormSubmitFn(this);
                });
            });
        },
        
        //TODO: Add update functionality.
        //Find which fields are shown, then ask for the record's value.
        //The current page's record Id is stored globally, in $V.App

    });

})(jQuery);


var JqmRecordDmlComponentUtil = {};

//TODO: Define this on $V to keep clutter out of global namespace.
JqmRecordDmlComponentUtil.onJqmFormSubmit = function(that) {
    $.mobile.showPageLoadingMsg("b", "Calculating...", false);
    
    //Gather all form inputs into a form values map.
    //'that' should be the form.
    var formFieldNameToValueMap = {};
    $V.App.log.debug("this.getFormFieldValues: ", JqmRecordDmlComponentUtil.getFormFieldValues);
    //$V.App.log.debug("this.config.sobjectType: ", JqmRecordDmlComponentUtil.config.sobjectType);
    formFieldNameToValueMap = JqmRecordDmlComponentUtil.getFormFieldValues(that);
    //formFieldNameToValueMap['sobjectType'] = this.config.sobjectType;
    
    $V.App.log.debug("Sending these fields to server handler: ", formFieldNameToValueMap);
    //$.mobile.hidePageLoadingMsg();
    
    //Send the form values map to the server handler.
    //TODO: Turn this specific method call a generic method call.
    //$V.App.getFn(this.config.serverCtlrName).performOperation(
    JqmRecordDmlController.performOperation(
        formFieldNameToValueMap,
        function(result, event) {
            $V.App.log.debug("Event: ", event);
            $V.App.log.debug("Result: ", result);
            if (event.status === false) {//Failure
                $("#formResults").html(event.message);
            }
            else {//Success
                //TODO: Do success stuff here.
                $("#formResults").html('Record created: ' + result.Id);
            }
            
            $.mobile.hidePageLoadingMsg();
            return false;
        }
    );
}

//Helper methods, for updating the form.
JqmRecordDmlComponentUtil.setFormFieldValues = function(pFieldValueMap, that) {
    var lFieldValueMap = pFieldValueMap;
    
    $(that).find('input').each(function() {
        var fieldName = $(this).attr('name');
        var fieldValue = $(this).attr('value');
    if (fieldName !== 'submit') {
        $(this).attr('value', lFieldValueMap[fieldName]);
    }
    });
    
    return true;
}
    
JqmRecordDmlComponentUtil.getFormFieldValues = function(that) {
    var fieldNameToValueMapToReturn = {};
    $(that).find('input').each(function() {
        var fieldName = $(this).attr('name');
        var fieldValue = $(this).attr('value');
        if (fieldName !== 'submit') {
            fieldNameToValueMapToReturn[fieldName] = fieldValue;
        }
    });
    return fieldNameToValueMapToReturn;
}

