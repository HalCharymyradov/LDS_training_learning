import { LightningElement, api, track } from 'lwc';

import contact_object from '@salesforce/schema/Contact';
import firstName_field from '@salesforce/schema/Contact.FirstName';
import lastName_field from '@salesforce/schema/Contact.LastName';
import email_field from '@salesforce/schema/Contact.Email';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class ContactCreator extends LightningElement {
    objectApiName = contact_object;
    FIELDS = [firstName_field, lastName_field, email_field];

    @track contact = {
        FirstName: '',
        LastName: '',
        Email: ''
    }

    handleSuccess(event) {
        console.log('halTrial: handleSuccess CALLED: event.detail: ' + JSON.stringify(event.detail));
        console.log('halTrial: handleSuccess CALLED: event.detail.values: ' + JSON.stringify(event.detail.values));
        console.log('halTrial: handleSuccess CALLED: event.detail.id: ' + JSON.stringify(event.detail.id));
        console.log('halTrial: handleSuccess CALLED: event.detail.FIELDS: ' + JSON.stringify(event.detail.FIELDS));

        const toastEvent = new ShowToastEvent ({
            title: 'Contact Created',
            message: 'Record Id: ' + event.detail.id,
            variant: 'success'
        })
        this.dispatchEvent(toastEvent);
    }
}