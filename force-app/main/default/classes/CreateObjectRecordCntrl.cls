/**
 * Class Name           :   CreateObjectRecordCntrl
 * Related Artifacts    :   Below is the list of related artifacts:
 *                          - Custom Metadata   :   RecordCreateFromLWC(RecordCreateFromLWC__mdt)
 * Description          :   Apex Class that are used in createAccountrecord LWC component.
 */
public with sharing class CreateObjectRecordCntrl {
    
    /**
    * 2nd Approach
    * Get Required Fields of the object from Field-Set, 
    * Here, we have used the metadata to store the mapping for Sobject API Name and corresponding field-set name.
    */
    // @AuraEnabled
    // public static List<Object> getSobjRequiredFieldsFromFieldSet() {
    @AuraEnabled
    public static List<Object> getDataOnCmpLoad() {
        List<Object> lstFinalResult = new List<Object>();

        Map<String, String> mapSobjectToFieldset = getFieldSetNames();
        for(String strSobjeName : mapSobjectToFieldset.keySet()) {
            List<Map<String, Object>> lstFields = new List<Map<String, Object>>();
            // List<String> lstFields = new List<String>();
            for(Schema.FieldSetMember f : getFields(strSobjeName, mapSobjectToFieldset.get(strSobjeName))) {
                lstFields.add(new Map<String, String>{'api' => f.getFieldPath(), 'label' => f.getLabel()});
                // lstFields.add(f.getFieldPath());
            }
            lstFinalResult.add(new Map<String, Object>{'SobjectAPIName' => strSobjeName, 'fieldsList' => lstFields});
        }
        
        System.debug('===INIT MAP RESULT===>'+ lstFinalResult);
        return lstFinalResult;
    }

    // Map object to field-set name from the custom metadata
    private static Map<String, String> getFieldSetNames() {
        Map<String, String> mapSobjectToFieldset = new Map<String, String>();
        List<RecordCreateFromLWC__mdt> sObjectFieldSets = [SELECT Sobject_API_Name__c, FieldSet_Name__c FROM RecordCreateFromLWC__mdt];
    
        for (RecordCreateFromLWC__mdt fieldSet : sObjectFieldSets) {
            mapSobjectToFieldset.put(fieldSet.Sobject_API_Name__c, fieldSet.FieldSet_Name__c);
        }
        return mapSobjectToFieldset;
    }

    // Gets the fields to display from the field set. Fields within the Fieldsetname
    private static List<Schema.FieldSetMember> getFields(String APIName, String fieldSetName) {
        // All sObject names
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        // Object that we are iterested in
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(APIName);
        // Description for object that we are interested in
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        // FieldSetNames associated with this object 
        Map<String,Schema.FieldSet> fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap();
        // Populate fieldset class with the fields from fieldsetname that we are intersted in
        Schema.FieldSet aFieldSet = fieldSetObj.get(fieldSetName);
    
        return aFieldSet.getFields();
    }

    /**
    * 1st Approach
    * Return Required Fields of the object based on the Sobject Api Name passed
    */
    // @AuraEnabled(cacheable=true)
    // public static List<String> getSobjRequiredFields(String strObjName){
    //     List<String> lstRequiredFields = new List<String>();

    //     if(String.isNotBlank(strObjName)) {
    //         SObjectType sObjType = Schema.getGlobalDescribe().get(strObjName);
    //         Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();

    //         for(String strFieldName : fieldMap.keySet()) {
    //             Schema.DescribeFieldResult f = fieldMap.get(strFieldName).getDescribe();
    //             if(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) lstRequiredFields.add(f.getName());
    //         }
    //     }
    //     return lstRequiredFields;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<FieldDefinition> getFieldList(id recordId, String objectApiName) {
    //     /*
    //     Queries object based on the fields listed in their fieldsetname.  Using LWC record Id and ObjectApiName, we can determine what object we are looking at and populate data accordingly.

    //     INPUT
    //         recordId        : ID passed from current record
    //         objectAPIName   : ObectAPIName of record
    //     OUTPUT
    //         Field Name and Field value
    //     */
    //     // query string to build
    //     String query = 'SELECT ';

    //     // List of field set names associated with object
    //     List<String> fieldSetNames = getFieldSetNames(objectApiName);
    //     // Fields in each field set name
    //     List<String> FieldDescriptions = new List<String>(); 

    //     // Get the field set name
    //     for (String fieldSetName : fieldSetNames) {
    //         // If we have fields, add them to the list
    //         for(Schema.FieldSetMember f : getFields(objectApiName, fieldSetName)) {
    //             query += f.getFieldPath() + ', ';
    //             FieldDescriptions.Add(f.getFieldPath());
    //         } 

    //     }

    //     // Query for the fields that we have in our list
    //     query += 'Id FROM '+ objectApiName +' WHERE ID=\''+recordId+'\'';

    //     // Instantiate object 
    //     SObject Obj = recordId.getSObjectType().newSObject(recordId);

    //     Obj = database.query(query);

    //     // Add values to a generic object tha can be used to display on any page
    //     List<FieldDefinition> Field = new List<FieldDefinition>();
    //     for (String F : FieldDescriptions) {
    //         if ((Obj.get(F) != null) || (Obj.get(F) != '')){
    //             FieldDefinition fieldDef = new FieldDefinition();
    //             fieldDef.APIfieldName = F;
    //             fieldDef.fieldValue   = String.valueOf(Obj.get(F));
    //             if ((fieldDef.FieldValue != null) && (fieldDef.fieldValue != ''))
    //                 Field.Add(fieldDef);
    //         }
    //     }
    //     return Field;
    // }

    // public class FieldDefinition {
    //     @AuraEnabled
    //     public String APIfieldName {get;set;}
    //     @AuraEnabled
    //     public String FieldValue {get;set;}
    // }
}