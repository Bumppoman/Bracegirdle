import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'list',
    'noNotesMessage',
    'note',
    'noteBodyInput'
  ];
  
  declare readonly listTarget: HTMLElement;
  declare readonly hasNoNotesMessageTarget: boolean;
  declare readonly noNotesMessageTarget: HTMLElement;
  declare readonly noteBodyInputTarget: HTMLTextAreaElement;
  declare readonly noteTargets: HTMLElement[];
  
  create(event) {
    
    // Display new note
    this.listTarget.innerHTML = event.detail.body + this.listTarget.innerHTML;
    
    // Scroll new note into view
    this.noteTargets.find(note => note.dataset.id === event.detail.id).scrollIntoView();
    
    // Clear the notes input
    this.noteBodyInputTarget.value = '';
    
    // Hide the no notes message (if displayed)
    if (this.hasNoNotesMessageTarget) {
      this.noNotesMessageTarget.classList.add('d-none');
    }
  }
}