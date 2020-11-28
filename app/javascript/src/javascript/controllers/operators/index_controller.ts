import ApplicationController from '../application_controller';
import DataTableController from '../datatable_controller';
import FormController from './form_controller';

export default class extends ApplicationController {
  static targets = [
    'operatorForm',
    'operatorsDataTable',
    'successMessage'
  ];
  
  declare readonly operatorsDataTableTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly operatorFormTarget: HTMLElement & { stimulusController: FormController };
  declare readonly successMessageTarget: HTMLElement;
  
  addOperator() {
    this.operatorFormTarget.stimulusController.openToAddOperator();
  }
  
  editOperator(event: Event) {
    this.operatorFormTarget.stimulusController.openToEditOperator(event);
  }
  
  handleOperatorEvent(event: CustomEvent) {
    // Close modal
    this.operatorFormTarget.stimulusController.close();
    
    // Add or replace operator row
    let successText: string;
    
    if (event.type == 'bracegirdle:operators:operatorAdded') {
      const template = document.createElement('template');
      template.innerHTML = event.detail.operator;
      this.operatorsDataTableTarget.stimulusController.appendRow(template.content.firstChild as HTMLTableRowElement);
      successText = 'You have successfully added this operator.';
      
    } else if (event.type == 'bracegirdle:operators:operatorUpdated') {
      const operatorRow = [...this.operatorsDataTableTarget.stimulusController.table.rows].find(
        row => row.dataset.operatorId === event.detail.operatorId.toString());
      operatorRow.outerHTML = event.detail.operator;
      this.operatorsDataTableTarget.stimulusController.refresh();
      successText = 'You have successfully updated this operator.';
    }
    
    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, successText);
  }
}