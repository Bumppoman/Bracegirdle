import Rails from '@rails/ujs';
import { Data } from 'popper.js';

import ApplicationController from '../../../application_controller';
import DataTableController from '../../../datatable_controller';
import FormController from './form_controller';

export default class extends ApplicationController {
  static targets = [
    'contractorsDataTable',
    'formModal',
    'formModalTitle',
    'successMessage'
  ];
  
  declare readonly contractorsDataTableTarget: HTMLElement & { stimulusController: DataTableController };
  declare readonly formModalTarget: HTMLElement & { stimulusController: FormController };
  declare readonly formModalTitleTargets: HTMLElement[];
  declare readonly successMessageTarget: HTMLElement;
  
  contractorCreated(event: CustomEvent) {
    // Close the modal
    this.closeModal(this.formModalTarget);
    
    // Add the contractor to the table
    const row = document.createElement('template');
    row.innerHTML = event.detail.contractor;
    this.contractorsDataTableTarget.stimulusController.appendRow(row.content.firstChild as HTMLTableRowElement);

    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, 'You have successfully added this contractor.');
  }
  
  contractorUpdated(event: CustomEvent) {
    // Close the modal
    this.closeModal(this.formModalTarget);

    // Update the trustee
    const replacementRow = document.createElement('template');
    replacementRow.innerHTML = event.detail.contractor;
    this.contractorsDataTableTarget.stimulusController.replaceRow(
      [...this.contractorsDataTableTarget.stimulusController.table.rows].find(
        row => row.dataset.contractorId === event.detail.contractorId),
      replacementRow.content.firstChild as HTMLTableRowElement
    );

    // Display the success message
    this.disappearingSuccessMessage(this.successMessageTarget, 'You have successfully added this contractor.');
  }
  
  openEditContractorForm(event: Event) {
    (this.formModalTarget.parentElement as HTMLFormElement).reset();
    event.preventDefault();
      
    const contractor = (event.currentTarget as HTMLElement).dataset.contractor;
    
    // Update text
    for (const title of this.formModalTitleTargets) {
      title.innerHTML = 'Edit Contractor';
    }
    
    // Update form method and action
    (this.formModalTarget.parentElement as HTMLFormElement).action = (event.currentTarget as HTMLAnchorElement).href;
    
    if (!this.formModalTarget.stimulusController.patchIndicator) {
      const patch = document.createElement('input');
      patch.type = 'hidden';
      patch.name = '_method';
      patch.value = 'patch';
      this.formModalTarget.parentElement.appendChild(patch);
    }
    
    Rails.ajax(
      {
        dataType: 'json',
        type: 'GET',
        url: (event.currentTarget as HTMLAnchorElement).href,
        success: (response) => {
          for (const contractorAttributeName of Object.keys(response)) {
            const contractorAttribute = ((this.formModalTarget.parentElement as HTMLFormElement).elements
              .namedItem(`contractor_${contractorAttributeName}`) as HTMLInputElement);
            
            if (contractorAttribute && response[contractorAttributeName]) {
              if (contractorAttributeName == 'county') {
                this.formModalTarget.stimulusController.countyChoices.setChoiceByValue(response['county'].toString());
              } else if (contractorAttributeName == 'state') {
                this.formModalTarget.stimulusController.stateChoices.setChoiceByValue(response['state'].toString());
              } else {
                contractorAttribute.value = response[contractorAttributeName];
              }
            }
          }
        }
      }
    )
    
    this.openModal(this.formModalTarget);
  }
  
  openNewContractorForm(event: Event) {
    (this.formModalTarget.parentElement as HTMLFormElement).reset();

    // Update text
    for (const title of this.formModalTitleTargets) {
      title.innerHTML = 'Add New Contractor';
    }
      
    // Update form method and action
    (this.formModalTarget.parentElement as HTMLFormElement).action = '/board_applications/restorations/contractors';
    if (this.formModalTarget.stimulusController.patchIndicator) {
      this.formModalTarget.parentElement.removeChild(this.formModalTarget.stimulusController.patchIndicator);
    }
    
    this.openModal(this.formModalTarget);
  }
}