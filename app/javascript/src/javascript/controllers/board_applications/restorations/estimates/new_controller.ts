import Choices from 'choices.js';
import Rails from '@rails/ujs';

import ApplicationController from '../../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'contractorSelect'
  ];
  
  declare contractorChoices: Choices;
  declare readonly contractorSelectTarget: HTMLSelectElement;
  
  connect() {
    super.connect();
    
    this.contractorChoices = this.createChoices(this.contractorSelectTarget);
  }
  
  contractorCreated(event: CustomEvent) {
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: '/board_applications/restorations/contractors',
        success: (response) => {
          this.contractorChoices.removeActiveItems(-1).enable().setChoices(response, 'value', 'label', true);
        }
      }
    )
    
    // Reopen estimate modal
    this.openModal(this.element as HTMLElement);
  }
  
  openNewContractorFormFromEstimate() {
    const contractorFormModal = document.getElementById('board_applications-restorations-contractors-form-modal');
    
    // Add hidden input to associate contractor creation through estimate form
    const hidden = document.createElement('input');
    hidden.type = 'hidden';
    hidden.name = 'contractor[estimate_form]';
    hidden.value = 'true';
    contractorFormModal.parentElement.appendChild(hidden);
    
    // Open modal
    this.openModal(contractorFormModal);
  }
}