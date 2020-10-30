import BSN from 'bootstrap.native';
import Choices from 'choices.js';
import { Controller } from 'stimulus';

import MainController from './main_controller';

export default class extends Controller {
  declare mainController: MainController;
  
  connect() {
    this.element['stimulusController'] = this;
    this.mainController = 
      (document.querySelector('body') as HTMLBodyElement & { stimulusController: MainController}).stimulusController;
  }
  
  closeConfirmationModal() {
    this.mainController.closeBracegirdleConfirmationModal();
  }
  
  closeModal(modal: HTMLElement) {
    new BSN.Modal(modal).hide();
  }
  
  createChoices(select: HTMLSelectElement) {
    return new Choices(select, 
      {
        shouldSort: false
      }
    );
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
    new BSN.Modal(modal).show();
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