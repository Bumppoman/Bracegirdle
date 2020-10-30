import Choices from 'choices.js';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'cemeteryAlternateName', 
    'cemeteryRegulatedTrue', 
    'cemeterySelectArea',
    'dispositionArea',
    'disposition',
    'investigationRequiredTrue', 
    'investigatorSelect',
    'type'
  ];
  
  declare readonly cemeteryAlternateNameTarget: HTMLInputElement;
  declare readonly cemeteryRegulatedTrueTarget: HTMLInputElement;
  declare readonly cemeterySelectAreaTarget: HTMLElement;
  declare readonly dispositionAreaTarget: HTMLElement;
  declare readonly investigationRequiredTrueTarget: HTMLInputElement;
  declare investigatorChoices: Choices;
  declare readonly investigatorSelectTarget: HTMLSelectElement;
  declare typeChoices: Choices;
  declare readonly typeTarget: HTMLSelectElement;
  
  connect() {
    
    super.connect();
    
    // Update whether cemetery is regulated
    this.setCemeteryType();
    
    // Update whether an investigation is required
    this.investigatorChoices = this.createChoices(this.investigatorSelectTarget);
    this.setInvestigation();
    
    // Initialize complaint type
    this.typeChoices = new Choices(this.typeTarget, { removeItemButton: true, shouldSort: false });
  }
  
  setCemeteryType() {
    const cemeteryRegulated = this.cemeteryRegulatedTrueTarget.checked;
    
    this.cemeteryAlternateNameTarget.classList.toggle('d-none', cemeteryRegulated);
    this.cemeterySelectAreaTarget.classList.toggle('d-none', !cemeteryRegulated);
  }
  
  setInvestigation() {
    const investigationRequired = this.investigationRequiredTrueTarget.checked;
    
    this.dispositionAreaTarget.classList.toggle('d-none', investigationRequired);
    this.dispositionAreaTarget.querySelector('textarea').required = !investigationRequired;
    this.dispositionAreaTarget.querySelector('.form-group').classList.toggle('required', !investigationRequired);
    this.toggleChoices(this.investigatorChoices, investigationRequired);
  }
}