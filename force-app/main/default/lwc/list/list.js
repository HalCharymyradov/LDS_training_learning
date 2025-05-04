import { LightningElement } from 'lwc';

export default class List extends LightningElement {
    selectBike() {
        const bikeId = '001XXXXXXXXXXXX'; // Sample Id
        this.dispatchEvent(new CustomEvent('productselected', {
            detail: bikeId
        }));
    }
}