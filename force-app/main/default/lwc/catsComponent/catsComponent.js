import { LightningElement } from 'lwc';
import getCats from '@salesforce/apex/CatsComponentController.getCats';

export default class CatsComponent extends LightningElement {
    breed = {};
    familyFriendliness = '';
    gotCats = false;
    cats = {};
    queryReturnedZeroResults = false;
    loading = false;
    isError = false;
    errorMessage = '';
    timer;

    breeds = [
        { label: 'Abyssinian', value: 'abyssinian' },
        { label: 'American Bobtail', value: 'american bobtail' },
        { label: 'American Curl', value: 'american curl' },
        { label: 'American Shorthair', value: 'american shorthair' },
        { label: 'British Longhair', value: 'british longhair' },
        { label: 'British Shorthair', value: 'british shorthair' },
        { label: 'Balinese', value: 'balinese' },
        { label: 'Burmese', value: 'burmese' },
        { label: 'Devon Rex', value: 'devon rex' },
        { label: 'Maine Coon', value: 'maine coon' },
        { label: 'Persian', value: 'persian' },
        { label: 'Ragdoll', value: 'ragdoll' },
        { label: 'Siamese', value: 'siamese' }
    ];

    familyFriendlinessScores = [
        { label: '1', value: 1 },
        { label: '2', value: 2 },
        { label: '3', value: 3 },
        { label: '4', value: 4 },
        { label: '5', value: 5 }
    ];

    handleCustomBreedInput(event) {
        clearTimeout(this.timer);
        this.timer = setTimeout(() => {
            this.handleBreedChange(event);
        }, 500);
    }

    handleBreedChange(event) {
        this.breed = event.detail;
        this.getCatsData('name', this.breed.value);
    }

    handleFamilyFriendlinessChange(event) {
        this.familyFriendliness = event.detail;
        this.getCatsData('family_friendly', this.familyFriendliness.value);
    }

    getCatsData(_param, _value) {
        this.loading = true;
        this.gotCats = false;
        this.cats = {};
        getCats({ param: _param, value : _value })
            .then(results => {
                this.isError = false;
                this.errorMessage = '';
                this.cats = results;
                if (results.length === 0) {
                    this.gotCats = false;
                    this.queryReturnedZeroResults = true;
                } else {
                    this.gotCats = true;
                    this.queryReturnedZeroResults = false;
                }
                this.loading = false;
            })
            .catch(err => {
                this.isError = true;
                this.errorMessage = err;
                this.loading = false;
            })
    }
}