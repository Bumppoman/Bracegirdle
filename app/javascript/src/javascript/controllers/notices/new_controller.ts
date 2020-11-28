import ApplicationController from '../application_controller';
import { BracegirdleSelect } from '../../types';

export default class extends ApplicationController {
  static targets = [
    'stateSelectElement',
    'trustee',
    'trusteesSelectForCemetery'
  ];
  
  declare readonly stateSelectElementTarget: BracegirdleSelect;
  declare readonly trusteeTarget: HTMLSelectElement;
  declare readonly trusteesSelectForCemeteryTarget: HTMLElement & { 
    stimulusController: ApplicationController &  {
      trusteeSelectElementTarget: BracegirdleSelect
    }
  };
  
  loadServedOnInformation() {
    const trusteeSelect = this.trusteesSelectForCemeteryTarget.stimulusController.trusteeSelectElementTarget.choicesInstance;
    const selectedTrustee = (trusteeSelect.getValue() as any).customProperties.trustee;
    
    for (const attribute of ['street_address', 'city', 'zip']) {
      const noticeInput = document.getElementById(`notice_served_on_${attribute}`) as HTMLInputElement;
      noticeInput.value = selectedTrustee[attribute];
      noticeInput.dispatchEvent(new Event('change'));
    }
    
    this.stateSelectElementTarget.choicesInstance.setChoiceByValue(selectedTrustee['state']);
  }
}