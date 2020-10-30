import Choices from 'choices.js';
import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'cemetery',
    'county',
    'selectedID'
  ];
  
  declare cemeteryChoices: Choices;
  declare readonly cemeteryTarget: HTMLSelectElement;
  declare readonly countyTarget: HTMLSelectElement;
  declare readonly selectedIDTarget: HTMLInputElement;
  
  connect() {
    super.connect();
    
    // Initialize Choices on cemetery
    this.cemeteryChoices = new Choices(this.cemeteryTarget);
    
    // Enable the cemetery select if a county is already chosen
    if (this.countyTarget.options[this.countyTarget.selectedIndex].value !== '') {
      this.loadCemeteries();
    }
  }
  
  loadCemeteries() {
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: `/cemeteries/county/${this.countyTarget.options[this.countyTarget.selectedIndex].value}/options?selected_value=${this.selectedID}`,
        success: (response) => {
          this.cemeteryChoices.removeActiveItems(-1).enable().setChoices(response, 'value', 'label', true);
          
          if (!this.selectedID) {
            this.cemeteryChoices.setChoiceByValue('');
          }
        }
      }
    )
  }
  
  get selectedID() {
    return this.selectedIDTarget.value;
  }
}