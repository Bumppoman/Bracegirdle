import ApplicationController from '../application_controller';
import DataTableController from '../datatable_controller';

export default class extends ApplicationController {
  static targets = [
    'boardApplicationsDataTableElement',
    'restorationsDataTableElement',
    'boardApplicationsSuccessMessage',
    'restorationsSuccessMessage',
    'successMessage'
  ];
  
  declare readonly boardApplicationsDataTableElementTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly boardApplicationsSuccessMessageTarget: HTMLElement;
  declare readonly restorationsDataTableElementTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly restorationsSuccessMessageTarget: HTMLElement;
  declare readonly successMessageTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    if (!this.successMessageTarget.classList.contains('hidden')) {
      setTimeout(() => this.successMessageTarget.classList.add('hidden'), 5000);
    }
  }
  
  unschedule(event: CustomEvent) {
    // Close the confirmation modal
    this.closeConfirmationModal();
    
    // Determine the correct table
    let dataTable, successMessage;
    if (event.detail.type === 'Restoration') {
      dataTable = this.restorationsDataTableElementTarget.stimulusController;
      successMessage = this.restorationsSuccessMessageTarget;
    } else {
      dataTable = this.boardApplicationsDataTableElementTarget.stimulusController;
      successMessage = this.boardApplicationsSuccessMessageTarget;
    }
    
    // Remove the matter and redraw the table
    const matter = [...dataTable.table.rows].find(element => element.dataset.matterId === event.detail.matterId);
    dataTable.removeRow(matter);
    
    // Show success message
    this.disappearingSuccessMessage(successMessage, 'You have successfully unscheduled this application.');
  }
}