import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'assignModal',
    'currentInvestigatorArea',
    'disposition',
    'dispositionDate',
    'investigationBegunActionsArea',
    'investigationBegunArea',
    'investigationBegunDate',
    'investigationCompletedDate',
    'openReassignButton',
    'reassignArea',
    'tracker'
  ];
  
  declare readonly assignModalTarget: HTMLElement;
  declare readonly confirmBeginInvestigationModalTarget: HTMLElement;
  declare readonly currentInvestigatorAreaTarget: HTMLElement;
  declare readonly dispositionTarget: HTMLElement;
  declare readonly dispositionDateTarget: HTMLElement;
  declare readonly investigationBegunActionsAreaTarget: HTMLElement;
  declare readonly investigationBegunAreaTarget: HTMLElement;
  declare readonly investigationBegunDateTargets: HTMLElement[];
  declare readonly investigationCompletedDateTargets: HTMLElement[];
  declare readonly openReassignButtonTarget: HTMLElement;
  declare readonly reassignAreaTarget: HTMLElement;
  declare readonly trackerTarget: HTMLElement;
  
  assigned(event: CustomEvent) {
    // Close modal
    this.closeModal(this.assignModalTarget);
    
    // Update the investigator name
    this.currentInvestigatorAreaTarget.textContent = event.detail.investigatorName;
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
    
    // Hide actions if assigned to another investigator
    if (!event.detail.assignedToSelf) {
      this.investigationBegunActionsAreaTarget.classList.add('d-none');
    }
  }
  
  closureRecommended(event: CustomEvent) {
    // Close confirmation modal
    this.closeConfirmationModal();
    
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
    this.closeConfirmationModal();
    
    // Update dates
    this.updateDates(this.investigationBegunDateTargets, event.detail.date);
    
    // Advance tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  investigationCompleted(event: CustomEvent) {
    // Close confirmation modal
    this.closeConfirmationModal();

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