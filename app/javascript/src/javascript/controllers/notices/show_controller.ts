import BSN from 'bootstrap.native';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'actionsArea',
    'confirmReceiveResponseModal',
    'confirmResolveModal',
    'downloadModal',
    'followUpCompletedDate',
    'followUpModal',
    'resolvedDate',
    'responseReceivedDate',
    'tracker'
  ];
  
  declare readonly actionsAreaTarget: HTMLElement;
  declare readonly downloadModalTarget: HTMLElement;
  declare readonly confirmReceiveResponseModalTarget: HTMLElement;
  declare readonly confirmResolveModalTarget: HTMLElement;
  declare readonly followUpCompletedDateTargets: HTMLElement[];
  declare readonly followUpModalTarget: HTMLElement;
  declare readonly resolvedDateTarget: HTMLElement;
  declare readonly responseReceivedDateTargets: HTMLElement[];
  declare readonly trackerTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('download_notice')) {
      new BSN.Modal(this.downloadModalTarget).show();
    }
  }
  
  followUpCompleted(event: CustomEvent) {
    // Close modal
    new BSN.Modal(this.followUpModalTarget).hide();
    
    // Update dates
    this.updateDates(this.followUpCompletedDateTargets, event.detail.date);
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  resolved(event: CustomEvent) {
    // Close confirmation modal
    this.mainController.closeConfirmationModal();
    
    // Update dates
    this.updateDates([this.resolvedDateTarget], event.detail.date);
    
    // Hide the tracker
    this.actionsAreaTarget.classList.add('d-none');
  }
  
  responseReceived(event: CustomEvent) {
    // Close confirmation modal
    this.mainController.closeConfirmationModal();
    
    // Update dates
    this.updateDates(this.responseReceivedDateTargets, event.detail.date);
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
}