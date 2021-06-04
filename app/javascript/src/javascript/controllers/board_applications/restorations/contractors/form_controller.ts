import Choices from 'choices.js';

import ApplicationController from '../../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'county',
    'state'
  ];
  
  declare countyChoices: Choices;
  declare readonly countyTarget: HTMLSelectElement;
  declare stateChoices: Choices;
  declare readonly stateTarget: HTMLSelectElement;
  
  connect() {
    super.connect();
    
    this.countyChoices = this.createChoices(this.countyTarget);
    this.stateChoices = this.createChoices(this.stateTarget);
  }
  
  close() {
    // Close this modal
    this.closeModal(this.element as HTMLElement);
    
    // Reopen the estimate modal if appropriate
    if (document.querySelector('input[name="contractor\[estimate_form\]"]')) {
      this.openModal(document.getElementById('board_applications-restorations-estimates-new-modal'));
    }
  }
  
  get patchIndicator() {
    return (this.element.parentElement as HTMLFormElement).elements.namedItem('_method') as HTMLInputElement;
  }
}