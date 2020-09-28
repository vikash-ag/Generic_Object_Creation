/**
 * @track   :   this annotation will track the changes of the declared variable
 * @api     :   this annotation is used to let the values passed in this components
 * 
 */
import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDataOnCmpLoad from '@salesforce/apex/CreateObjectRecordCntrl.getDataOnCmpLoad';

// Used to get the required fields mapping by passing the Object API Name
// import getSobjRequiredFields from '@salesforce/apex/CreateObjectRecordCntrl.getSobjRequiredFields';


export default class CreateAccountRecord extends LightningElement {
    
    // Object Attibutes
    @track selectedObject = null;
    @track isShowNewObjDiv = false;
    
    @track fields = [];
    @track lstObjects = [];
    SobjectAPINameToLstFieldsMapping = [];

    // Error Message Attributes
    // @track isError = false;
    // @track errorMsg = null;

    // Called on component initialization
    connectedCallback() {
        // Call Apex class method to get the list of fields dynamically
        getDataOnCmpLoad({
            // Add params to pass to apex class
        })
        .then(result => {
            console.log('===CONNECTED CALLBACK RESULT===>', result);
            this.SobjectAPINameToLstFieldsMapping = result;

            let lstSobjectNames = [];
            result.forEach(ele => {
                lstSobjectNames.push({
                    label : ele.SobjectAPIName, 
                    value : ele.SobjectAPIName
                });
            });
            this.lstObjects = lstSobjectNames;

            this.showToastMessage('success', 'Success', 'Data successfully loaded.', 'pester', null);
        })
        .catch(error => {
            console.log('===Error INIT===>', error.detail);
            this.showToastMessage('error', 'Error', 'Error occured while fetch data on load.', 'pester', null);
        });
    }

    // Update Selected Object API Name on radio selection change
    handleObjSelectionChange(event) {
        this.selectedObject = event.detail.value;
        this.isShowNewObjDiv = false;
    }

    // Get the name of Object on button click
    handleObjSelection() {
        console.log('===handle click called===>', this.selectedObject);

        let objectNameToFieldsMapping = this.SobjectAPINameToLstFieldsMapping;
        // console.log('===objectNameToFieldsMapping===>', objectNameToFieldsMapping);

        objectNameToFieldsMapping.forEach(ele => {
            // console.log('===INSIDE FOR EACH 111===>', ele);
            // console.log('===INSIDE FOR EACH 222===>', (ele.SobjectAPIName == this.selectedObject));
            if(ele.SobjectAPIName == this.selectedObject) {
                this.fields = ele.fieldsList;
            }
        });
        // console.log('===this.fields 222===>', JSON.parse(JSON.stringify(this.fields)));

        // Display Input fields division
        this.isShowNewObjDiv = true;


        // Call apex to get the required fields for the selected object
        // getSobjRequiredFields( {strObjName : this.selectedObject} )
        // .then(result => {
        //     this.fields = result;
        // })
        // .catch(error => {
        //     console.log('===Error Occured:===>');
        // });
        // this.isShowNewObjDiv = true;
    }

    @api
    get getNewObjCardHeader() {
        return 'Create New ' + this.selectedObject;
    }

    /** 
     * Event on New Contact Submit 
     * In this method we can default any field values before saving
     * */
    handleNewRecSubmit(event) {
        event.preventDefault();
        // const fields = event.detail.fields;
        // fields.LastName = 'My Custom Last Name';
        this.template.querySelector('lightning-record-form').submit(fields);
    }

    /** Event on New Contact Success submission*/
    handleNewRecSuccess(event) {
        // Show Success Toast message
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'New ' + event.detail.apiName + ' created.',
                variant: 'success',
            }),
        );
    }

    /** Event on New Contact error submission */
    handleNewRecError() {
        // Show Success Toast message
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error occured while saving the record, please check field values.',
                variant: 'error',
            }),
        );
    }

    showToastMessage(strVariant, strTitle, strMessage, strMode, strMessageData) {
        const event = new ShowToastEvent({
            variant     :   strVariant,
            title       :   strTitle,
            message     :   strMessage,
            mode        :   strMode,
            messageData :   strMessageData
        });
        this.dispatchEvent(event);
    }




    // getCmpInitialData() {
    //     getSobjRequiredFieldsFromFieldSet({})
    //     .then(result => {
    //         console.log('===RESULT===>', result);
    //         return result;
    //     })
    //     .catch(error => {
    //         console.log('===Error Occured in getSobjRequiredFieldsFromFieldSet===>');
    //     });
    // }

    // @wire(getSobjRequiredFields, { strObjName : this.selectedObject })
    // lstObjFields({ error, data }) {
    //     if (data) {
    //         console.log('===SObject Fields===>'+ data);
    //     } else if (error) {
    //         console.log('===Error occured while fetching fields===>'+ error);
    //     }
    // }
}