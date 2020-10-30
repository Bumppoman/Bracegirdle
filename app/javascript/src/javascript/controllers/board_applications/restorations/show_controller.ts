import ApplicationController from '../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'successMessage'
  ];
  
  declare readonly successMessageTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    if (!this.successMessageTarget.classList.contains('hidden')) {
      setTimeout(() => this.successMessageTarget.classList.add('hidden'), 5000);
    }
  }
}