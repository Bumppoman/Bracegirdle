import { Modal } from 'bootstrap';
import Choices from 'choices.js';
import { Controller } from 'stimulus';

import MainController from './main_controller';

export default class extends Controller {
  declare environment: string;
  declare mainController: MainController;
  
  connect() {
    this.element['stimulusController'] = this;
    this.mainController = 
      (document.querySelector('body') as HTMLBodyElement & { stimulusController: MainController}).stimulusController;
    this.environment = process.env.RAILS_ENV;
  }
  
  closeConfirmationModal() {
    this.mainController.closeBracegirdleConfirmationModal();
  }
  
  closeModal(modal: HTMLElement) {
    
    // Get modal instance
    const existingModal = Modal.getInstance(modal);

    // Override transitioning status
    existingModal._isTransitioning = false;
    
    // Hide the modal
    existingModal.hide();    
  }
  
  createChoices(select: HTMLSelectElement) {
    select['choicesInstance'] = new Choices(select, 
      {
        shouldSort: false
      }
    );
    
    return select['choicesInstance'];
  }
  
  disappearingSuccessMessage(messageElement: HTMLElement, text?: string) {
    if (text) {
      messageElement.querySelector('div').textContent = text;
    }
    
    messageElement.classList.remove('hidden');
    messageElement.scrollIntoView();
    setTimeout(() => messageElement.classList.add('hidden'), 5000);
  }
  
  dispatch(event: CustomEvent) {
    this[event.detail.method](event);
  }
  
  openModal(modal: HTMLElement) {
    new Modal(modal).show();
  }
  
  toggleChoices(choices: Choices, force = null): void {
    const currentlyDisabled = (choices as Choices & { containerOuter: Object & { isDisabled: boolean } }).containerOuter.isDisabled;
  
    if (force || (force === null && currentlyDisabled)) {
      choices.enable();
    } else {
      choices.disable();
    }
  }
  
  updateDates(dateElements: HTMLElement[], date: string) {
    for (const element of dateElements) {
      element.innerHTML = date;
      element.parentElement.classList.remove('d-none');
    }
  }
}