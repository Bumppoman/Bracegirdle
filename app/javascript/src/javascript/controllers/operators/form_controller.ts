import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'submit',
    'title'
  ];
  
  declare readonly element: HTMLElement;
  declare originalAction: string;
  declare readonly submitTarget: HTMLElement;
  declare readonly titleTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    this.originalAction = (this.element.parentElement as HTMLFormElement).action;
  }
  
  close() {
    this.closeModal(this.element);
  }
  
  openToAddOperator() {
    // Change the text
    this.titleTarget.textContent = 'Add New Operator';
    this.submitTarget.textContent = 'Add New Operator';
    
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
  
  openToEditOperator(event: Event) {
    event.preventDefault();
    const clickedOperatorData = (event.currentTarget as HTMLElement).dataset;
    
    // Change the text
    this.titleTarget.textContent = 'Edit Operator';
    this.submitTarget.textContent = 'Edit Operator';
    
    // Change the form action and reset
    (this.element.parentElement as HTMLFormElement).action = clickedOperatorData.formAction;
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
    
    // Load the operator
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: clickedOperatorData.formAction,
        success: response => {
          for (const operatorAttributeName of Object.keys(response)) {
            const operatorAttribute = document.getElementById(`operator_${operatorAttributeName}`) as HTMLInputElement;
            if (operatorAttribute && response[operatorAttributeName]) {
              operatorAttribute.value = response[operatorAttributeName];
              operatorAttribute.dispatchEvent(new Event('change'));
            }
          }
        }
      }
    )
    
    // Open the form
    this.openModal(this.element);
  }
}