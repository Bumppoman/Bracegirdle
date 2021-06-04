import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';
import { BracegirdleSelect } from '../../types';

export default class extends ApplicationController {
  static targets = [
    'retortModelSelectElement',
    'submit',
    'title'
  ];
  
  declare readonly element: HTMLElement;
  declare originalAction: string;
  declare readonly retortModelSelectElementTarget: BracegirdleSelect;
  declare readonly submitTarget: HTMLElement;
  declare readonly titleTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    this.originalAction = (this.element.parentElement as HTMLFormElement).action;
  }
  
  close() {
    this.closeModal(this.element);
  }
  
  openNewRetortModelForm() {
    const newRetortModelFormModal = document.getElementById('crematories-retort_models-form-modal');
    newRetortModelFormModal.classList.remove('fade');
    this.element.classList.remove('fade');
    
    // Add hidden input to associate retort model creation through retort form
    const hidden = document.createElement('input');
    hidden.type = 'hidden';
    hidden.name = 'retort_model[retort_form]';
    hidden.value = 'true';
    newRetortModelFormModal.parentElement.appendChild(hidden);
    
    // Open modal
    this.closeModal(this.element);
    this.openModal(newRetortModelFormModal);
  }
  
  openToAddRetort() {
    // Change the text
    this.titleTarget.textContent = 'Add New Retort';
    this.submitTarget.textContent = 'Add New Retort';
    
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
  
  openToEditRetort(event: Event) {
    event.preventDefault();
    const clickedRetortData = (event.currentTarget as HTMLElement).dataset;
    
    // Change the text
    this.titleTarget.textContent = 'Edit Retort';
    this.submitTarget.textContent = 'Edit Retort';
    
    // Change the form action and reset
    (this.element.parentElement as HTMLFormElement).action = clickedRetortData.formAction;
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
        url: clickedRetortData.formAction,
        success: response => {
          for (const retortAttributeName of Object.keys(response)) {
            if (retortAttributeName === 'retort_model_id') {
              this.retortModelSelectElementTarget.choicesInstance.setChoiceByValue(response['retort_model_id'].toString());
            } else {
              const retortAttribute = document.getElementById(`retort_${retortAttributeName}`) as HTMLInputElement;
              if (retortAttribute && response[retortAttributeName]) {
                retortAttribute.value = response[retortAttributeName];
                retortAttribute.dispatchEvent(new Event('change'));
              }
            }
          }
        }
      }
    )
    
    // Open the form
    this.openModal(this.element);
  }
  
  retortModelCreated(event: CustomEvent) {
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: `/crematories/retort_models?as_options&selected=${event.detail.retortModelId}`,
        success: (response) => {
          this.retortModelSelectElementTarget.choicesInstance.destroy();
          this.retortModelSelectElementTarget.innerHTML = response.options;
          this.createChoices(this.retortModelSelectElementTarget);
        }
      }
    );
    
    // Reopen retort modal
    this.closeModal(document.getElementById('crematories-retort_models-form-modal'));
    this.openModal(this.element);
  }
}