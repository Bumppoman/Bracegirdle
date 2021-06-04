import ApplicationController from '../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'submit'
  ];
  
  declare readonly submitTarget: HTMLButtonElement;
  
  close() {

    // Close this modal
    this.closeModal(this.element as HTMLElement);
    
    // Reopen the estimate modal if appropriate
    if (document.querySelector('input[name="retort_model\[retort_form\]"]')) {
      this.openModal(document.getElementById('retorts-form-modal'));
    }
  }
  
  get patchIndicator() {
    return (this.element.parentElement as HTMLFormElement).elements.namedItem('_method') as HTMLInputElement;
  }
}