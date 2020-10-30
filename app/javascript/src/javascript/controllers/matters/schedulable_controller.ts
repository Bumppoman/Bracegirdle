import ApplicationController from '../application_controller';
import DataTableController from '../datatable_controller';

export default class extends ApplicationController {
  static targets = [
    'mattersDataTableElement',
    'scheduleModal',
    'successMessage'
  ];
  
  declare readonly mattersDataTableElementTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly scheduleModalTarget: HTMLElement;
  declare readonly successMessageTarget: HTMLElement;
  
  openScheduleModal(event: Event) {
    // Set the form action
    (this.scheduleModalTarget.parentElement as HTMLFormElement).action =
      (event.currentTarget as HTMLElement).dataset.formAction;

    // Open the modal
    this.openModal(this.scheduleModalTarget);
  }
  
  scheduled(event: CustomEvent) {
    // Close the modal
    this.closeModal(this.scheduleModalTarget);
    
    // Remove the matter from the list
    const matterRow = [...this.mattersDataTableElementTarget.stimulusController.table.rows].find(
      row => row.dataset.matterId === event.detail.matterId);
    this.mattersDataTableElementTarget.stimulusController.removeRow(matterRow);
    
    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, 'You have successfully scheduled this matter.');
  }
}