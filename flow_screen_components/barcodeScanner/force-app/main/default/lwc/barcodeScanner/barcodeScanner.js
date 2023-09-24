/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 02-23-2023
 * @last modified by  : Josh Dayment
**/
// barcodeScanner.js
import { LightningElement,api } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';


export default class BarcodeScanner extends LightningElement {
    myScanner;
    sessionScanner;
    scanButtonDisabled = false;
    scannedBarcodes;
    @api scannedBarcode = '';
    @api label;
    @api autoNavigate;
    @api buttonLabel = 'Scan';
    @api buttonIcon = 'utility:scan';
    @api scannerInstructions;
    @api availableActions = [];
    @api scanContinuously;
    @api allscannedBarcodes = [];
    // When component is initialized, detect whether to enable Scan button and if it is single or continuous scan
    connectedCallback() {
        if(this.scanContinuously){
            this.sessionScanner = getBarcodeScanner();
        }
        else{
        this.myScanner = getBarcodeScanner();
        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }}
    }

    beginScanning() {
        // Reset scannedBarcodes before starting new scanning session
        this.scannedBarcodes = [];

        // Make sure BarcodeScanner is available before trying to use it
        if (this.sessionScanner != null && this.sessionScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [],
                instructionText: 'Scan barcodes — Click ✖︎ when done',
                successText: 'Successful scan.'
            };
            this.sessionScanner.beginCapture(scanningOptions)
            .then((scannedBarcode) => {
                this.processScannedBarcode(scannedBarcode);
                this.continueScanning();
            })
            .catch((error) => {
                this.processError(error);
                this.sessionScanner.endCapture();
            })
        }
        else {
            console.log("BarcodeScanner unavailable. Non-mobile device?");
        }
    }
    async continueScanning() {
        // Pretend to do some work; see timing note below.
        await new Promise((resolve) => setTimeout(resolve, 1000));
        
        this.sessionScanner.resumeCapture()
        .then((scannedBarcode) => {
            this.processScannedBarcode(scannedBarcode);
            this.continueScanning();
        })
        .catch((error) => {
            this.processError(error);
            this.sessionScanner.endCapture();
        })
    }

    processScannedBarcode(barcode) {
        // Do something with the barcode scan value:
        // - look up a record
        // - create or update a record
        // - parse data and put values into a form
        // - and so on; this is YOUR code
        console.log(JSON.stringify(barcode));
        this.scannedBarcodes.push(barcode);
        this.allscannedBarcodes.push(decodeURIComponent(barcode.value))
    }

    processError(error) {
        // Check to see if user ended scanning
        if (error.code == 'userDismissedScanner') {
            console.log('User terminated scanning session via Cancel.');
        }
        else {
            console.error(error);
        }
    }

    get scannedBarcodesAsString() {
        return this.scannedBarcodes.map(barcodeResult => {
            return barcodeResult.value;
        }).join('\n\n');
    }

    handleBeginScanClick(event) {
        // Reset scannedBarcode to empty string before starting new scan
        this.scannedBarcode = '';

        // Make sure BarcodeScanner is available before trying to use it
        // Note: We _also_ disable the Scan button if there's no BarcodeScanner
        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: []
            };
            this.myScanner
                .beginCapture(scanningOptions)
                .then((result) => {
                    console.log(result);

                    // Do something with the barcode scan value:
                    // - look up a record
                    // - create or update a record
                    // - parse data and put values into a form
                    // - and so on; this is YOUR code
                    // Here, we just display the scanned value in the UI
                    this.scannedBarcode = decodeURIComponent(result.value);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Successful Scan',
                            message: 'Barcode scanned successfully.',
                            variant: 'success'
                        })
                    );
                    // Instead of making the user click next why not just keep the flow going?
                    if(this.autoNavigate === true && this.availableActions.find(action => action ==='NEXT')){
                        // navigate to the next screen
                        const navigateNextEvent = new FlowNavigationNextEvent();
                        this.dispatchEvent(navigateNextEvent);
                    }; 
                })
               
                .catch((error) => {
                    console.error(error);

                    // Handle unexpected errors here
                    // Inform the user we ran into something unexpected
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Barcode Scanner Error',
                            message:
                                'There was a problem scanning the barcode: ' +
                                JSON.stringify(error) +
                                ' Please try again.',
                            variant: 'error',
                            mode: 'sticky'
                        })
                    );
                })
                .finally(() => {
                    console.log('#finally');

                    // Clean up by ending capture,
                    // whether we completed successfully or had an error
                    this.myScanner.endCapture();
                });

                                               
        } else {
            // BarcodeScanner is not available
            // Not running on hardware with a camera, or some other context issue
            console.log(
                'Scan Barcode button should be disabled and unclickable.'
            );
            console.log('Somehow it got clicked: ');
            console.log(event);

            // Let user know they need to use a mobile phone with a camera
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Barcode Scanner Is Not Available',
                    message:
                        'Try again from a supported app on a mobile device.',
                    variant: 'error'
                })
            );
           
        }       
    }      
}
