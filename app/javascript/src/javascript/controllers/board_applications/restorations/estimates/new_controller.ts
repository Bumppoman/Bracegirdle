import Rails from '@rails/ujs';

import ApplicationController from 'src/javascript/controllers/application_controller';
import { BracegirdleSelect } from 'src/javascript/types';

export default class extends ApplicationController {
  static targets = [
    'contractorSelectElement'
  ];
  
  declare readonly contractorSelectElementTarget: BracegirdleSelect;
  
  contractorCreated(event: CustomEvent) {
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: '/board_applications/restorations/contractors',
        success: (response) => {
          this.contractorSelectElementTarget.choicesInstance.removeActiveItems(-1).enable()
            .setChoices(response, 'value', 'label', true);
        }
      }
    )
    
    // Reopen estimate modal
    this.openModal(this.element as HTMLElement);
  }
  
  openNewContractorFormFromEstimate() {
    const contractorFormModal = document.getElementById('board_applications-restorations-contractors-form-modal');
    this.element.classList.remove('fade');
    contractorFormModal.classList.remove('fade');
    
    // Add hidden input to associate contractor creation through estimate form
    const hidden = document.createElement('input');
    hidden.type = 'hidden';
    hidden.name = 'contractor[estimate_form]';
    hidden.value = 'true';
    contractorFormModal.parentElement.appendChild(hidden);
    
    // Hide estimate modal and open contractor modal
    this.closeModal(this.element as HTMLElement);
    this.openModal(contractorFormModal);
  }
}