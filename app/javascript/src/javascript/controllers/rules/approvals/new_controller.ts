import Choices from 'choices.js';

import ApplicationController from '../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'requestByEmailArea',
    'requestByEmailTrue',
    'requestByPostalMailArea',
    'trusteesSelectForCemetery'
  ];
  
  declare readonly requestByEmailAreaTarget: HTMLElement;
  declare readonly requestByEmailTrueTarget: HTMLInputElement;
  declare readonly requestByPostalMailAreaTarget: HTMLElement;
  declare readonly trusteeTarget: HTMLSelectElement;
  declare readonly trusteesSelectForCemeteryTarget: HTMLElement & { 
    stimulusController: ApplicationController &  {
      trusteeSelect: Choices
    }
  };
  
  connect() {
    super.connect();
    this.setSubmissionType();
  }
  
  loadSenderInformation() {
    const trusteeSelect = this.trusteesSelectForCemeteryTarget.stimulusController.trusteeSelect;
    const selectedTrustee = (trusteeSelect.getValue() as any).customProperties.trustee;
    
    for (const attribute of ['street_address', 'city', 'state', 'zip', 'email']) {
      const rulesApprovalInput = document.getElementById(`rules_approval_sender_${attribute}`) as HTMLInputElement;

      // Only set required inputs
      if (rulesApprovalInput.required) {
        rulesApprovalInput.value = selectedTrustee[attribute];
        rulesApprovalInput.dispatchEvent(new Event('change'));
      }
    }
  }
  
  setSubmissionType() {
    const rulesByEmail = this.requestByEmailTrueTarget.checked;
    
    this.requestByEmailAreaTarget.classList.toggle('d-none', !rulesByEmail);
    this.requestByPostalMailAreaTarget.classList.toggle('d-none', rulesByEmail);
    
    (document.getElementById('rules_approval_sender_email') as HTMLInputElement).required = rulesByEmail;
    for (const input of ['street_address', 'city', 'state', 'zip']) {
      (document.getElementById(`rules_approval_sender_${input}`) as HTMLInputElement).required = !rulesByEmail;
    }
  }
}