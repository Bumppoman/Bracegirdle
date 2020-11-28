import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'appointment',
    'confirmBeginModal',
    'confirmCancelModal',
    'rescheduleDate',
    'rescheduleModal',
    'rescheduleTime',
    'successMessage'
  ];
  
  declare readonly appointmentTargets: HTMLElement[];
  declare readonly confirmBeginModalTarget: HTMLElement;
  declare readonly confirmCancelModalTarget: HTMLElement;
  declare readonly rescheduleDateTarget: HTMLInputElement;
  declare readonly rescheduleModalTarget: HTMLElement;
  declare readonly rescheduleTimeTarget: HTMLInputElement;
  declare readonly successMessageTarget: HTMLElement;
  
  appointmentCancelled(event: CustomEvent) {
    // Show success message
    this.disappearingSuccessMessage(this.successMessageTarget, event.detail.message);
    
    // Close modal
    this.closeConfirmationModal();
    
    // Remove appointment
    const appointment = this.appointmentTargets.find(
      appointment => appointment.dataset.appointmentId === event.detail.appointmentId);
    appointment.parentElement.removeChild(appointment);
  }
  
  appointmentRescheduled(event: CustomEvent) {
    // Show success message
    this.disappearingSuccessMessage(this.successMessageTarget, event.detail.message);
    
    // Close modal
    this.closeModal(this.rescheduleModalTarget);
    
    // Update date
    this.appointmentTargets.find(appointment => appointment.dataset.appointmentId === event.detail.appointmentId)
      .querySelector('.appointment-date').textContent = event.detail.date;
  }
  
  reschedule(event: Event) {
    const dataset = (event.target as HTMLElement).dataset;
    
    this.openModal(this.rescheduleModalTarget);
    (this.rescheduleModalTarget.parentElement as HTMLFormElement).action = dataset.formAction;
    
    this.rescheduleDateTarget.value = dataset.date;
    this.rescheduleTimeTarget.value = dataset.time;
  }
}