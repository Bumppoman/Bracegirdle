import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'attachment',
    'attachmentFormElement',
    'attachmentsList',
    'confirmDeleteModal',
    'deleteButton',
    'noAttachmentsMessage'
  ];
  
  declare readonly attachmentFormElementTarget: HTMLFormElement;
  declare readonly attachmentsListTarget: HTMLElement;
  declare readonly attachmentTargets: HTMLElement[];
  declare readonly confirmDeleteModalTarget: HTMLElement;
  declare readonly deleteButtonTarget: HTMLAnchorElement;
  declare readonly noAttachmentsMessageTarget: HTMLElement;
  
  attachmentCreated(event: CustomEvent) {
    // Hide the no attachments message
    this.noAttachmentsMessageTarget.classList.add('d-none');

    // Display new attachment
    this.attachmentsListTarget.innerHTML = event.detail.attachment + this.attachmentsListTarget.innerHTML;

    // Scroll new attachment into view
    this.attachmentTargets.find(element => element.dataset.attachmentId === event.detail.attachmentId).scrollIntoView();

    // Clear the attachment form
    this.attachmentFormElementTarget.reset();
    document.querySelector('.bracegirdle-file-input').nextElementSibling.textContent = 'Choose file';
  }
  
  attachmentDestroyed(event: CustomEvent) {
    // Remove attachment
    const attachment = this.attachmentTargets.find(element => element.dataset.attachmentId === event.detail.attachmentId);
    attachment.parentNode.removeChild(attachment);

    // Close confirmation modal
    this.closeModal(this.confirmDeleteModalTarget);

    // If no attachments are remaining, display the no attachments message
    this.noAttachmentsMessageTarget.classList.toggle('d-none', this.attachmentTargets.length !== 0);
  }
  
  confirmDelete(event: Event) {
    event.preventDefault();
    
    // Open the modal
    this.openModal(this.confirmDeleteModalTarget);
    
    // Change the path of the delete
    this.deleteButtonTarget.href = (event.currentTarget as HTMLElement).dataset.path + 
      `/${(event.currentTarget as HTMLElement).dataset.attachmentId}`;
  }
}