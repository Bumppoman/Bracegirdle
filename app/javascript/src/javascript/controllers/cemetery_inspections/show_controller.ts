import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'downloadModal',
    'finalizeButton',
    'reprintButton',
    'reviseButton',
    'status'
  ];
  
  declare readonly downloadModalTarget: HTMLElement;
  declare readonly finalizeButtonTarget: HTMLButtonElement;
  declare readonly reprintButtonTarget: HTMLButtonElement;
  declare readonly reviseButtonTarget: HTMLButtonElement;
  declare readonly statusTarget: HTMLElement;
  
  finalize(event: CustomEvent) {
    // Hide action buttons
    this.finalizeButtonTarget.classList.add('d-none');
    this.reviseButtonTarget.classList.add('d-none');
    this.reprintButtonTarget.classList.remove('d-none');

    // Update the inspection date
    this.statusTarget.textContent = `Completed (mailed ${event.detail.date})`

    // Display the download modal
    this.openModal(this.downloadModalTarget);
  }
  
  openReprintModal() {
    this.openModal(this.downloadModalTarget);
  }
}