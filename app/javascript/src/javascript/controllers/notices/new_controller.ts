import Choices from 'choices.js';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'trustee',
    'trusteesSelectForCemetery'
  ];
  
  declare readonly trusteeTarget: HTMLSelectElement;
  declare readonly trusteesSelectForCemeteryTarget: HTMLElement & { 
    stimulusController: ApplicationController &  {
      trusteeSelect: Choices
    }
  };
  
  loadServedOnInformation() {
    const trusteeSelect = this.trusteesSelectForCemeteryTarget.stimulusController.trusteeSelect;
    const selectedTrustee = (trusteeSelect.getValue() as any).customProperties.trustee;
    
    for (const attribute of ['street_address', 'city', 'state', 'zip']) {
      const noticeInput = document.getElementById(`notice_served_on_${attribute}`) as HTMLInputElement;
      noticeInput.value = selectedTrustee[attribute];
      noticeInput.dispatchEvent(new Event('change'));
    }
  }
}