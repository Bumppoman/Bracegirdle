import Rails from '@rails/ujs';
import { Controller } from 'stimulus';

export default class extends Controller {
  cemeteryInspectionSteps = {
    1: 'begun',
    2: 'cemetery_information_gathered',
    3: 'physical_characteristics_surveyed',
    4: 'record_keeping_reviewed'
  }
  
  static targets = [
    'form',
    'receivingVaultCharacteristic',
    'receivingVaultExists',
    'receivingVaultInspected',
    'status',
    'tracker'
  ];
  
  declare readonly formTarget: HTMLFormElement;
  declare readonly receivingVaultCharacteristicTargets: HTMLInputElement[];
  declare readonly receivingVaultExistsTargets: HTMLInputElement[];
  declare readonly receivingVaultInspectedTargets: HTMLInputElement[];
  declare readonly statusTarget: HTMLInputElement;
  declare readonly trackerTarget: HTMLElement;
  
  connect() {
    // Save input automatically when changed
    const saveFunction = this.save.bind(this);
    for (const input of this.formTarget.querySelectorAll('input:not([name^="attachment"]), textarea')) {
      input.addEventListener('blur', saveFunction);
    }
    
    // Enable receiving vault questions
    this.receivingVaultExistence();
    this.receivingVaultInspection();
  }
  
  receivingVaultExistence() {
    for (const question of this.receivingVaultInspectedTargets) {
      (question as HTMLInputElement).disabled = !this.receivingVaultExists;
      question.dispatchEvent(new Event('change'));
    }
  }
  
  receivingVaultInspection() {
    for (const question of this.receivingVaultCharacteristicTargets) {
      if (!this.receivingVaultExists || !this.receivingVaultInspected) {
        (question as HTMLInputElement).disabled = true;
        
        if ((question as HTMLInputElement).type === 'text') {
          (question as HTMLInputElement).value = '';
        } else if ((question as HTMLInputElement).type === 'checkbox') {
          (question as HTMLInputElement).checked = false;
        }
      } else {
        (question as HTMLInputElement).disabled = false;
      }
    }
  }
  
  save(event: CustomEvent) {
    // Make sure status matches current step
    this.statusTarget.value = this.cemeteryInspectionSteps[parseInt(this.trackerTarget.dataset.trackerCurrentStep)];
    
    // Save form data
    Rails.ajax(
      {
        data: new FormData(this.formTarget),
        type: 'patch',
        url: this.formTarget.action
      }
    )
  }
  
  get receivingVaultExists() {
    return this.receivingVaultExistsTargets.find(element => element.value === 'true').checked;
  }
  
  get receivingVaultInspected() {
    return this.receivingVaultInspectedTargets.find(element => element.value === 'true').checked;
  }
}