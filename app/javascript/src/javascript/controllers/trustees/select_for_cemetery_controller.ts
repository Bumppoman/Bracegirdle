import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';
import { BracegirdleSelect } from '../../types';

export default class extends ApplicationController {
  static targets = [
    'addTrusteeButton',
    'cemetery',
    'selectedTrustee',
    'trusteeFormModal',
    'trusteeSelectElement'
  ];
  
  declare readonly addTrusteeButtonTarget: HTMLButtonElement;
  declare readonly cemeteryTarget: HTMLSelectElement;
  declare readonly hasSelectedTrusteeTarget: boolean;
  declare readonly selectedTrusteeTarget: HTMLInputElement;
  declare trusteeForm: HTMLFormElement;
  declare readonly trusteeFormModalTarget: HTMLElement;
  declare readonly trusteeSelectElementTarget: BracegirdleSelect;
  
  connect() {
    super.connect();
    
    this.createTrusteeForm();
  }
  
  createTrusteeForm() {
    // Create the trustee form
    this.trusteeForm = document.createElement('form');
    this.trusteeForm.method = 'post';
    this.trusteeForm.dataset.remote = 'true';
    
    // Create the hidden field
    const hiddenIndicator = document.createElement('input');
    hiddenIndicator.type = 'hidden';
    hiddenIndicator.name = 'trustee[added_at_need]';
    hiddenIndicator.value = 'true';
    this.trusteeForm.appendChild(hiddenIndicator);
    
    // Move the modal
    this.trusteeForm.appendChild(this.trusteeFormModalTarget);
    document.body.appendChild(this.trusteeForm);
    
    // Add event listener to body for new trustees
    document.body.addEventListener('bracegirdle:trustees:trusteeAdded', this.trusteeAdded.bind(this));
  }
  
  loadTrustees(event) {
    const selectedCemetery = (event as CustomEvent).detail.value;
    
    if (selectedCemetery) {
      // Get selected trustee
      let selectedTrusteeId = '';
      if (this.hasSelectedTrusteeTarget) {
        selectedTrusteeId = this.selectedTrusteeTarget.value;
      }
      
      // Load trustees
      Rails.ajax(
        {
          dataType: 'json',
          type: 'GET',
          url: `/cemeteries/${selectedCemetery}/trustees/?selected_value=${selectedTrusteeId}`,
          success: (response) => {
            // Set the trustee options
            this.trusteeSelectElementTarget.choicesInstance.removeActiveItems(0).enable()
              .setChoices(response.trustees, 'value', 'label', true);
            
            // Set the add trustee path
            this.trusteeForm.action = response.add_path;
          }
        }
      );
      
      if (selectedTrusteeId === '') {
        this.trusteeSelectElementTarget.choicesInstance.setChoiceByValue('');
      }
      
      // Enable add trustee button
      this.addTrusteeButtonTarget.disabled = false;
    }
  }
  
  openTrusteeForm() {
    this.openModal(this.trusteeForm.children[1] as HTMLElement);
  }
  
  trusteeAdded(event: CustomEvent) {
    // Clear the form and close the modal
    this.trusteeForm.reset();
    this.closeModal(this.trusteeForm.children[1] as HTMLElement);
    
    // Add the new trustee and select
    this.trusteeSelectElementTarget.choicesInstance.removeActiveItems(0).enable()
      .setChoices([event.detail], 'value', 'label', false);
    this.trusteeSelectElementTarget.choicesInstance.setChoiceByValue(event.detail.value);
    this.trusteeSelectElementTarget.dispatchEvent(new Event('change'));
  }
}