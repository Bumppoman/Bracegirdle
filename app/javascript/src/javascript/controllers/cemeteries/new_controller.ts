import Choices from 'choices.js';
import Rails from '@rails/ujs';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'county',
    'selectedId',
    'towns'
  ];
  
  declare readonly countyTarget: HTMLSelectElement;
  declare readonly selectedIdTarget: HTMLInputElement;
  declare townsChoices: Choices;
  declare readonly townsTarget: HTMLSelectElement;
  
  connect() {
    super.connect();
    
    this.townsChoices = new Choices(this.townsTarget, { removeItemButton: true, shouldSort: false });
  }
  
  loadTowns() {
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: `/towns/county/${this.countyTarget.options[this.countyTarget.selectedIndex].value}?selected_value=${this.selectedId}`,
        success: (response) => {
          this.townsChoices.removeActiveItems(-1).enable().setChoices(response, 'value', 'label', true);
        }
      }
    )
  }
  
  get selectedId() {
    return this.selectedIdTarget.value;
  }
}