import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

import NameField from '@salesforce/schema/Account.Name';
import PhoneField from '@salesforce/schema/Account.Phone';
import WebsiteField from '@salesforce/schema/Account.Website';

const FIELDS = [NameField, PhoneField, WebsiteField];

export default class RealTimeAccountrecordDisplayLDS extends LightningElement {
    @api recordId;
    @api objectApiName;

    isEditable = false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        } else if (data) {
            this.record = data;
        }
    }

    handleSuccess() {
        this.isEditable = false;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated successfully',
                variant: 'success'
            })
        );
    }

    handleEdit() {
        this.isEditable = true;
    }
}