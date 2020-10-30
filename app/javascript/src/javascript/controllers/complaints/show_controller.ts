import BSN from 'bootstrap.native';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'currentInvestigatorArea',
    'disposition',
    'dispositionDate',
    'investigationBegunArea',
    'investigationBegunDate',
    'investigationCompletedDate',
    'openReassignButton',
    'reassignArea',
    'tracker'
  ];
  
  declare readonly confirmBeginInvestigationModalTarget: HTMLElement;
  declare readonly currentInvestigatorAreaTarget: HTMLElement;
  declare readonly dispositionTarget: HTMLElement;
  declare readonly dispositionDateTarget: HTMLElement;
  declare readonly investigationBegunAreaTarget: HTMLElement;
  declare readonly investigationBegunDateTargets: HTMLElement[];
  declare readonly investigationCompletedDateTargets: HTMLElement[];
  declare readonly openReassignButtonTarget: HTMLElement;
  declare readonly reassignAreaTarget: HTMLElement;
  declare readonly trackerTarget: HTMLElement;
  
  closureRecommended(event: CustomEvent) {
    // Close confirmation modal
    this.mainController.closeConfirmationModal();
    
    // Update disposition and disposition date
    this.dispositionTarget.textContent = event.detail.disposition;
    this.dispositionDateTarget.textContent = event.detail.date;
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }

  investigationBegun(event: CustomEvent) {
    // Replace investigation begun area
    this.investigationBegunAreaTarget.outerHTML = event.detail.tracker;
    
    // Close confirmation modal
    this.mainController.closeConfirmationModal();
    
    // Update dates
    this.updateDates(this.investigationBegunDateTargets, event.detail.date);
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  investigationCompleted(event: CustomEvent) {
    // Close confirmation modal
    this.mainController.closeConfirmationModal();

    // Update dates
    this.updateDates(this.investigationCompletedDateTargets, event.detail.date);
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  toggleReassign(event: Event) {
    event.preventDefault();
    
    this.reassignAreaTarget.classList.toggle('d-none');
    this.currentInvestigatorAreaTarget.classList.toggle('d-none');
    this.openReassignButtonTarget.classList.toggle('d-none');
  }
}