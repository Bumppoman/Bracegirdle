import Choices from 'choices.js';
import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'cemetery',
    'selectedTrustee',
    'trustee'
  ];
  
  declare readonly cemeteryTarget: HTMLSelectElement;
  declare readonly hasSelectedTrusteeTarget: boolean;
  declare readonly selectedTrusteeTarget: HTMLInputElement;
  declare trusteeSelect: Choices;
  declare readonly trusteeTarget: HTMLSelectElement;
  
  connect() {
    super.connect();
    
    this.trusteeSelect = this.createChoices(this.trusteeTarget);
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
            this.trusteeSelect.removeActiveItems(0).enable().setChoices(response, 'value', 'label', true);
          }
        }
      );
      
      if (selectedTrusteeId === '') {
        this.trusteeSelect.setChoiceByValue('');
      }
    }
  }
}