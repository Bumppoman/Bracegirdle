import ApplicationController from 'src/javascript/controllers/application_controller';
import DataTableController from 'src/javascript/controllers/datatable_controller';
import FormController from 'src/javascript/controllers/retorts/form_controller';

export default class extends ApplicationController {
  static targets = [
    'retortForm',
    'retortsDataTable',
    'successMessage'
  ];
  
  declare readonly retortsDataTableTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly retortFormTarget: HTMLElement & { stimulusController: FormController };
  declare readonly successMessageTarget: HTMLElement;
  
  addRetort() {
    this.retortFormTarget.stimulusController.openToAddRetort();
  }
  
  editRetort(event: Event) {
    this.retortFormTarget.stimulusController.openToEditRetort(event);
  }
  
  handleRetortEvent(event: CustomEvent) {
    
    // Close modal
    this.retortFormTarget.stimulusController.close();
    
    // Add or replace operator row
    let successText: string;
    
    if (event.type == 'bracegirdle:retorts:retortAdded') {
      const template = document.createElement('template');
      template.innerHTML = event.detail.retort;
      this.retortsDataTableTarget.stimulusController.appendRow(template.content.firstChild as HTMLTableRowElement);
      successText = 'You have successfully added this retort.';
      
    } else if (event.type == 'bracegirdle:retorts:retortUpdated') {
      const retortRow = Array.from(this.retortsDataTableTarget.stimulusController.table.rows).find(
        row => row.dataset.retortId === event.detail.retortId.toString());
      retortRow.outerHTML = event.detail.retort;
      this.retortsDataTableTarget.stimulusController.refresh();
      successText = 'You have successfully updated this retort.';
    }
    
    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, successText);
  }
}