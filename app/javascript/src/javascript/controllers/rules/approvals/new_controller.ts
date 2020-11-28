import Choices from 'choices.js';

import ApplicationController from '../../application_controller';
import SelectForCemeteryController from '../../trustees/select_for_cemetery_controller';
import { BracegirdleSelect } from '../../../types';

export default class extends ApplicationController {
  static targets = [
    'requestByEmailArea',
    'requestByEmailTrue',
    'requestByPostalMailArea',
    'senderState',
    'trusteesSelectForCemetery'
  ];
  
  declare readonly requestByEmailAreaTarget: HTMLElement;
  declare readonly requestByEmailTrueTarget: HTMLInputElement;
  declare readonly requestByPostalMailAreaTarget: HTMLElement;
  declare readonly senderStateTarget: BracegirdleSelect;
  declare readonly trusteeTarget: HTMLSelectElement;
  declare readonly trusteesSelectForCemeteryTarget: HTMLElement & { stimulusController: SelectForCemeteryController };
  
  connect() {
    super.connect();
    
    this.setSubmissionType();
  }
  
  loadSenderInformation() {
    const trusteeSelect = this.trusteesSelectForCemeteryTarget.stimulusController.trusteeSelectElementTarget.choicesInstance;
    const selectedTrustee = (trusteeSelect.getValue() as any).customProperties.trustee;
    
    for (const attribute of ['street_address', 'city', 'zip', 'email']) {
      const rulesApprovalInput = document.getElementById(`rules_approval_sender_${attribute}`) as HTMLInputElement;

      // Only set required inputs
      if (rulesApprovalInput.required) {
        rulesApprovalInput.value = selectedTrustee[attribute];
        rulesApprovalInput.dispatchEvent(new Event('change'));
      }
    }
    
    // Set state element if required
    if (this.senderStateTarget.required) {
      this.senderStateTarget.choicesInstance.setChoiceByValue(selectedTrustee['state']);
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