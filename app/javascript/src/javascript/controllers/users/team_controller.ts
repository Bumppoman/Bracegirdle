import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [
    'tab',
    'tabLink'
  ];
  
  declare readonly tabLinkTargets: HTMLAnchorElement[];
  declare readonly tabTargets: HTMLElement[];
  
  changeTab(event: Event) {
    event.preventDefault();
    
    const activeTab = (event.currentTarget as HTMLElement).dataset.tab;
    
    // Activate/deactivate tab links
    for (const tabLink of this.tabLinkTargets) {
      tabLink.classList.toggle('active', tabLink.dataset.tab === activeTab);
    }
    
    // Show correct tab
    for (const tab of this.tabTargets) {
      tab.classList.toggle('d-none', tab.dataset.tab !== activeTab);
    }
  }
}