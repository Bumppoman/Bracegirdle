import ApplicationController from '../application_controller';
import DataTableController from '../datatable_controller';
import FormController from './form_controller';

export default class extends ApplicationController {
  static targets = [
    'successMessage',
    'trusteeForm',
    'trusteesDataTable'
  ];
  
  declare successMessageTarget: HTMLElement;
  declare readonly trusteesDataTableTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly trusteeFormTarget: HTMLElement & { stimulusController: FormController };
  
  addTrustee() {
    this.trusteeFormTarget.stimulusController.openToAddTrustee();
  }
  
  editTrustee(event: Event) {
    this.trusteeFormTarget.stimulusController.openToEditTrustee(event);
  }
  
  handleTrusteeEvent(event: CustomEvent) {
    // Close modal
    this.trusteeFormTarget.stimulusController.close();
    
    // Add or replace trustee row
    let successText: string;
    
    if (event.type == 'bracegirdle:trustees:trusteeAdded') {
      const template = document.createElement('template');
      template.innerHTML = event.detail.trustee;
      this.trusteesDataTableTarget.stimulusController.appendRow(template.content.firstChild as HTMLTableRowElement);
      successText = 'You have successfully added this trustee.';
      
    } else if (event.type == 'bracegirdle:trustees:trusteeEdited') {
      const trusteeRow = [...this.trusteesDataTableTarget.stimulusController.table.rows].find(
        row => row.dataset.trusteeId === event.detail.trusteeId.toString());
      trusteeRow.outerHTML = event.detail.trustee;
      this.trusteesDataTableTarget.stimulusController.refresh();
      successText = 'You have successfully updated this trustee.';
    }
    
    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, successText);
  }
}