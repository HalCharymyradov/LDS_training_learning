import { LightningElement, api, track, wire} from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactList extends LightningElement {
    contacts;
    @track error;
    columns = [
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
    ];

    @wire(getContacts)
    contacts({ error, data }) {
        console.log('halTrial: contacts CALLED: ' + JSON.stringify(data));
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contacts',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        }
    }
    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }

}