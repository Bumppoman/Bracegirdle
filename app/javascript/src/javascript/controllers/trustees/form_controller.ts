import Choices from 'choices.js';
import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'positionSelectElement',
    'stateSelectElement',
    'submit',
    'title'
  ];
  
  declare readonly element: HTMLElement;
  declare originalAction: string;
  declare positionChoices: Choices;
  declare readonly positionSelectElementTarget: HTMLSelectElement;
  declare stateChoices: Choices;
  declare readonly stateSelectElementTarget: HTMLSelectElement;
  declare readonly submitTarget: HTMLElement;
  declare readonly titleTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    this.originalAction = (this.element.parentElement as HTMLFormElement).action;
    this.positionChoices = this.createChoices(this.positionSelectElementTarget);
    this.stateChoices = this.createChoices(this.stateSelectElementTarget);
  }
  
  close() {
    this.closeModal(this.element);
  }
  
  openToAddTrustee() {
    // Change the text
    this.titleTarget.textContent = 'Add New Trustee';
    this.submitTarget.textContent = 'Add New Trustee';
    
    // Change the form action and reset
    (this.element.parentElement as HTMLFormElement).action = this.originalAction;
    (this.element.parentElement as HTMLFormElement).reset();
    const methodIndicator = (this.element.parentElement as HTMLFormElement).querySelector(
      'input[name="_method"]') as HTMLInputElement;
    if (methodIndicator) {
      methodIndicator.value = 'post';
    }
    
    // Open the form
    this.openModal(this.element);
  }
  
  openToEditTrustee(event: Event) {
    event.preventDefault();
    const clickedTrusteeData = (event.currentTarget as HTMLElement).dataset;
    
    // Change the text
    this.titleTarget.textContent = 'Edit Trustee';
    this.submitTarget.textContent = 'Edit Trustee';
    
    // Change the form action and reset
    (this.element.parentElement as HTMLFormElement).action = clickedTrusteeData.formAction;
    (this.element.parentElement as HTMLFormElement).reset();
    const methodIndicator = (this.element.parentElement as HTMLFormElement).querySelector(
      'input[name="_method"]') as HTMLInputElement;
    if (methodIndicator) {
      methodIndicator.value = 'patch';
    } else {
      const newMethodIndicator = document.createElement('input');
      newMethodIndicator.type = 'hidden';
      newMethodIndicator.name = '_method';
      newMethodIndicator.value = 'patch';
      (this.element.parentElement as HTMLFormElement).appendChild(newMethodIndicator);
    }
    
    // Load the trustee
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: clickedTrusteeData.formAction,
        success: response => {
          for (const trusteeAttributeName of Object.keys(response)) {
            const trusteeAttribute = document.getElementById(`trustee_${trusteeAttributeName}`) as HTMLInputElement;
            if (trusteeAttribute && response[trusteeAttributeName]) {
              if (trusteeAttributeName == 'position') {
                this.positionChoices.setChoiceByValue(response['position'].toString());
              } else if (trusteeAttributeName == 'state') {
                this.stateChoices.setChoiceByValue(response['state'].toString());
              } else {
                trusteeAttribute.value = response[trusteeAttributeName];
                trusteeAttribute.dispatchEvent(new Event('change'));
              }
            }
          }
        }
      }
    )
    
    // Open the form
    this.openModal(this.element);
  }
}