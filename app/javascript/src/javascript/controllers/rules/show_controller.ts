import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'downloadApprovalLetterModal',
    'successMessage'
  ];
  
  declare readonly downloadApprovalLetterModalTarget: HTMLElement;
  declare readonly successMessageTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    if (!this.successMessageTarget.classList.contains('hidden')) {
      setTimeout(() => this.successMessageTarget.classList.add('hidden'), 5000);
    }
    
    if (this.downloadApprovalLetterModalTarget.dataset.show === 'true') {
      this.openModal(this.downloadApprovalLetterModalTarget);
    }
  }
}