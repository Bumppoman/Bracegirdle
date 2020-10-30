import ApplicationController from '../../application_controller';

export default class extends ApplicationController {
  static targets = [
    'revision',
    'revisionRequestArea',
    'revisionRequestFormElement',
    'revisionsArea',
    'revisionsTable',
    'revisionSuccessMessage',
    'revisionToggleIcon',
    'revisionUploadArea',
    'revisionUploadFormElement',
    'successMessage'
  ];
  
  declare readonly revisionRequestAreaTarget: HTMLElement;
  declare readonly revisionRequestFormElementTarget: HTMLFormElement;
  declare readonly revisionSuccessMessageTarget: HTMLElement;
  declare readonly revisionsAreaTarget: HTMLElement;
  declare readonly revisionsTableTarget: HTMLTableElement;
  declare readonly revisionTargets: HTMLElement[];
  declare readonly revisionToggleIconTargets: HTMLElement[];
  declare readonly revisionUploadAreaTarget: HTMLElement;
  declare readonly revisionUploadFormElementTarget: HTMLFormElement;
  declare readonly successMessageTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    if (!this.successMessageTarget.classList.contains('hidden')) {
      setTimeout(() => this.successMessageTarget.classList.add('hidden'), 5000);
    }
  }
  
  hideAllRevisions() {
    for (const revision of this.revisionTargets) {
      revision.classList.add('d-none');
    }
  }
  
  revisionCreated(event: CustomEvent) {
    // Clear form and hide request section
    this.revisionRequestFormElementTarget.reset();
    this.revisionRequestAreaTarget.classList.add('d-none');
    
    // Display upload revision section
    this.revisionUploadAreaTarget.classList.remove('d-none');

    // Add requested revision to the table
    const revisionsTableBody = this.revisionsTableTarget.tBodies[0];
    revisionsTableBody.innerHTML = event.detail.revision + revisionsTableBody.innerHTML;

    // Display success message
    this.disappearingSuccessMessage(this.revisionSuccessMessageTarget, 'You have successfully requested this revision!');
  }
  
  revisionReceived(event: CustomEvent) {
    // Clear form and hide upload revision section
    this.revisionUploadFormElementTarget.reset();
    this.revisionUploadAreaTarget.classList.add('d-none');

    // Display request section
    this.revisionRequestAreaTarget.classList.remove('d-none');

    // Add revision
    this.revisionsAreaTarget.innerHTML = event.detail.revision + this.revisionsAreaTarget.innerHTML;

    // Change revision received date
    const revisionRow = this.revisionsTableTarget.querySelector(`tr[data-revision="${event.detail.revisionID}"]`);
    revisionRow.querySelector('.rules-approvals-revision-date-received').innerHTML = event.detail.date;

    // Collapse all revisions except the new one
    this.hideAllRevisions();
    this.showRevision(event.detail.revisionID);

    // Display success message
    this.disappearingSuccessMessage(this.revisionSuccessMessageTarget, 'You have successfully uploaded this revision!');
  }
  
  showRevision(revisionID: string) {
    this.revisionTargets.find(element => element.dataset.revisionId === revisionID).classList.remove('d-none');
  }
  
  toggleRevision(event: Event) {
    event.preventDefault();
    
    const revisionID = (event.target as HTMLElement).dataset.revisionId;
    const revision = this.revisionTargets.find(element => element.dataset.revisionId === revisionID);
    
    if (revision.classList.contains('d-none')) {
      revision.classList.remove('d-none');
      this.revisionToggleIconTargets.find(element => element.dataset.revisionId === revisionID).textContent = 'expand_less';
    } else {
      revision.classList.add('d-none');
      this.revisionToggleIconTargets.find(element => element.dataset.revisionId === revisionID).textContent = 'expand_more';
    }
  }
}