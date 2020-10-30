import Rails from '@rails/ujs';

import ApplicationController from '../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'applicationForm',
    'applicationFormElement',
    'applicationFormNextButton',
    'applicationSummary',
    'estimateFormModal',
    'estimatesList',
    'estimatesNextButton',
    'legalNoticeForm',
    'legalNoticeFormElement',
    'legalNoticeFormNextButton',
    'legalNoticeSummary',
    'noEstimatesMessage',
    'previousDetailsArea',
    'previousExistsTrue',
    'previousForm',
    'previousFormElement',
    'previousFormNextButton',
    'previousSummary',
    'tracker'
  ];
  
  declare readonly applicationFormElementTarget: HTMLFormElement;
  declare readonly applicationFormNextButtonTarget: HTMLButtonElement;
  declare readonly applicationFormTarget: HTMLElement;
  declare readonly applicationSummaryTarget: HTMLElement;
  declare readonly estimateFormModalTarget: HTMLElement;
  declare readonly estimatesListTarget: HTMLElement;
  declare readonly estimatesNextButtonTarget: HTMLButtonElement;
  declare readonly hasNoEstimatesMessageTarget: boolean;
  declare readonly legalNoticeFormElementTarget: HTMLFormElement;
  declare readonly legalNoticeFormNextButtonTarget: HTMLButtonElement;
  declare readonly legalNoticeFormTarget: HTMLElement;
  declare readonly legalNoticeSummaryTarget: HTMLElement;
  declare readonly noEstimatesMessageTarget: HTMLElement;
  declare readonly previousDetailsAreaTarget: HTMLElement;
  declare readonly previousExistsTrueTarget: HTMLInputElement;
  declare readonly previousFormElementTarget: HTMLFormElement;
  declare readonly previousFormNextButtonTarget: HTMLButtonElement;
  declare readonly previousFormTarget: HTMLElement;
  declare readonly previousSummaryTarget: HTMLElement;
  declare readonly trackerTarget: HTMLElement;
  
  applicationFormChanged() {
    for (const element of this.applicationFormElementTarget.elements) {
      if ((element as HTMLInputElement).required && (element as HTMLInputElement).value === '') {
        return;
      }
    }
    
    // Enable button if form is complete
    this.applicationFormNextButtonTarget.disabled = false;
  }
  
  changePreviousExists(event: Event) {
    event.preventDefault();
    
    this.previousFormTarget.classList.remove('d-none');
    this.previousSummaryTarget.classList.add('d-none');
  }
  
  estimateCreated(event: CustomEvent) {
    this.closeModal(this.estimateFormModalTarget);
    
    if (this.hasNoEstimatesMessageTarget) {
      this.noEstimatesMessageTarget.classList.add('d-none');
    }
    
    this.estimatesListTarget.innerHTML = this.estimatesListTarget.innerHTML + event.detail.estimate;
    
    this.estimatesNextButtonTarget.disabled = false;
  }
  
  legalNoticeFormChanged() {
    for (const element of this.legalNoticeFormElementTarget.elements) {
      if ((element as HTMLInputElement).required && (element as HTMLInputElement).value === '') {
        return;
      }
    }
    
    // Enable button if form is complete
    this.legalNoticeFormNextButtonTarget.disabled = false;
  }
  
  openEstimateForm() {
    (this.estimateFormModalTarget.parentElement as HTMLFormElement).reset();
    this.openModal(this.estimateFormModalTarget);
  }
  
  previousFormChanged() {
    for (const element of this.previousFormElementTarget.elements) {
      if ((element as HTMLInputElement).required && 
        !(element.classList.contains('choices__input')) && 
        (element as HTMLInputElement).value === '') 
      {
        return;
      }
    }
        
    // Enable button if form is complete
    this.previousFormNextButtonTarget.disabled = false;
  }
  
  saveApplication() {
    if (!this.applicationFormTarget.classList.contains('d-none')) {
      // Submit form
      this.applicationFormElementTarget.submit();
      
      // Hide the form and show the summary
      this.applicationFormTarget.classList.add('d-none');
      this.applicationSummaryTarget.classList.remove('d-none');
    }
    
    // Advance the tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  saveLegalNotice() {
    if (!this.legalNoticeFormTarget.classList.contains('d-none')) {
      // Submit form
      this.legalNoticeFormElementTarget.submit();
      
      // Hide the form and show the summary
      this.legalNoticeFormTarget.classList.add('d-none');
      this.legalNoticeSummaryTarget.classList.remove('d-none');
    }
    
    // Advance the tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  savePrevious() {
    if (!this.previousFormTarget.classList.contains('d-none')) {
      // Submit form
      this.previousFormElementTarget.submit();
      
      // Hide the form and show the summary
      this.previousFormTarget.classList.add('d-none');
      this.previousSummaryTarget.classList.remove('d-none');
    }
    
    // Advance the tracker
    this.trackerTarget.dispatchEvent(new Event('bracegirdle:tracker:nextStep'));
  }
  
  setPreviousDetails() {
    const previousExists = this.previousExistsTrueTarget.checked;
    
    this.previousDetailsAreaTarget.classList.toggle('d-none', !previousExists);
    for (const formGroup of this.previousDetailsAreaTarget.querySelectorAll('.form-group')) {
      formGroup.classList.toggle('required', previousExists);
    }
    
    for (const input of this.previousDetailsAreaTarget.querySelectorAll('input, select')) {
      (input as HTMLInputElement | HTMLSelectElement).required = previousExists;
    }
  }
}