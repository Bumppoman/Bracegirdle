import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'indicator',
    'step'
  ];
  
  declare readonly indicatorTargets: HTMLElement[];
  declare readonly stepTargets: HTMLElement[];
  
  connect() {
    super.connect();
    
    this.disableTransitions();
    this.goToStep(this.currentStep, 0);
    this.enableTransitions();
  }
  
  disableTransitions() {
    (this.element as HTMLElement).classList.add('no-transitions');
  }
  
  enableTransitions() {
    if (this.environment !== 'test') {
      (this.element as HTMLElement).offsetHeight;
      (this.element as HTMLElement).classList.remove('no-transitions');
    }
  }
  
  goToStep(step: number, previousStep: number) {
    
    // Set transitioning status
    (this.element as HTMLElement).classList.add('bracegirdle-tracker-transitioning');

    // Display correct indicators
    for (const indicator of this.indicatorTargets) {
      const indicatorStep = parseInt(indicator.dataset.step);
      
      if (step < previousStep && indicatorStep > step) {
        indicator.classList.remove('active');
      } else if (step > previousStep && indicatorStep <= step) {
        indicator.classList.add('active');
      }
    }
    
    // Display correct step
    for (const stepElement of this.stepTargets) {
      stepElement.classList.toggle('active', parseInt(stepElement.dataset.step) === step);
    }
    
    // Emit event
    this.element.dispatchEvent(
      new CustomEvent('bracegirdleTracker:stepChanged', {
        detail: {
          step: step
        }
      })
    );
    
    // Remove transitioning status
    (this.element as HTMLElement).classList.remove('bracegirdle-tracker-transitioning');
  }
  
  goToStepByLink(event: Event) {
    event.preventDefault();
    
    const step = parseInt((event.target as HTMLElement).dataset.step);
    this.currentStep = step;
  }
  
  nextStep() {
    this.currentStep++;
  }
  
  previousStep() {
    this.currentStep--;
  }
  
  get currentStep() {
    return parseInt(this.data.get('currentStep'));
  }
  
  set currentStep(step) {
    const previousStep = this.currentStep;
    this.data.set('currentStep', step.toString());
    this.goToStep(step, previousStep);
  }
}