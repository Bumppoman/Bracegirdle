import Choices from 'choices.js';

import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'footer',
    'header',
    'info',
    'paginationList',
    'perPageSelect',
    'search'
  ];
  
  declare readonly element: HTMLElement;
  declare firstRecord: number;
  declare readonly footerTarget: HTMLElement;
  declare readonly headerTarget: HTMLElement;
  declare readonly infoTarget: HTMLElement;
  declare lastRecord: number;
  declare readonly paginationListTarget: HTMLUListElement;
  declare perPageChoices: Choices;
  declare readonly perPageSelectTarget: HTMLSelectElement;
  declare readonly searchTarget: HTMLInputElement;
  declare totalPages: number;
  declare table: HTMLTableElement;
  declare _page: number;
  declare _perPage: number;
  declare _rowCount: number;
  declare _search: string;
  declare _sortParameters: {
    direction: string;
    index: number;
  }

  
  connect() {
    super.connect();
    
    // Load table
    this.element.classList.add('bracegirdle-data-table');
    this.table = this.element.getElementsByTagName('table')[0];
    
    // Initialize table
    this.initializeTable();
  }
  
  disconnect() {    
    // Remove all additions
    this.element.removeChild(this.headerTarget);
    this.element.removeChild(this.footerTarget);
  }
  
  appendRow(row: HTMLTableRowElement) {
    this.table.tBodies[0].appendChild(row);
    this.draw();
  }
  
  checkForEmpty() {
    
    // Display empty message
    if (this.rowCount === 0) {      

      // Create the empty cell
      const emptyCell = document.createElement('td');
      emptyCell.classList.add('empty-message');
      emptyCell.colSpan = this.table.tHead.rows[0].cells.length;
      emptyCell.textContent = this.table.dataset.emptyMessage || 'There are no rows to display.';
      
      // Create the empty row
      const emptyRow = document.createElement('tr');
      emptyRow.appendChild(emptyCell);
      this.table.tBodies[0].appendChild(emptyRow);
      
      // Hide the footer
      this.footerTarget.classList.add('d-none');
    }
  }
  
  createFooter() {
    // Create footer element
    const footer = document.createElement('div');
    footer.classList.add('footer');
    footer.dataset.target = 'datatable.footer';
    
    // Create count area
    const info = document.createElement('div');
    info.classList.add('info');
    info.dataset.target = 'datatable.info';
    footer.appendChild(info);
    
    // Create pagination area
    const pagination = document.createElement('div');
    pagination.classList.add('pagination');
    
    // Create pagination list
    const paginationList = document.createElement('ul');
    paginationList.dataset.target = 'datatable.paginationList';
    pagination.appendChild(paginationList);
    footer.appendChild(pagination);
    
    // Append footer to table
    this.element.appendChild(footer);
  }
  
  createHeader() {
    // Create header element
    const header = document.createElement('div');
    header.classList.add('header');
    header.dataset.target = 'datatable.header';
    
    // Create per page area
    const perPage = document.createElement('div');
    perPage.classList.add('per-page');
    
    // Create per page select
    const perPageSelect = document.createElement('select');
    perPageSelect.dataset.action = 'datatable#perPageChanged';
    perPageSelect.dataset.target = 'datatable.perPageSelect';
    for (const option of ['5', '10', '15', '20', '25']) {
      const optionElement = document.createElement('option');
      optionElement.value = option;
      optionElement.text = option;
      perPageSelect.add(optionElement);
    }
    
    // Append select to per page area
    const perPageLabel = document.createElement('label');
    perPageLabel.appendChild(perPageSelect);
    perPageLabel.innerHTML = perPageLabel.innerHTML + ' items/page';
    perPage.appendChild(perPageLabel);
    
    // Create search area
    const search = document.createElement('div');
    search.classList.add('search');
    
    // Create search input
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.classList.add('form-control');
    searchInput.placeholder = 'Search...';
    searchInput.dataset.action = 'input->datatable#performSearch';
    searchInput.dataset.target = 'datatable.search';
    search.appendChild(searchInput);
    
    // Prepend header
    header.appendChild(perPage);
    header.appendChild(search);
    this.table.before(header);
    
    // Create choices for per page select
    this.perPageChoices = new Choices(this.perPageSelectTarget, { itemSelectText: '' });
    this.perPageChoices.setChoiceByValue(this.perPage.toString());
  }
  
  draw() {
    // Sort the records
    this.sort();
    
    // Create the page links
    this.paginate(this.totalPages);
    
    // Change footer text
    this.infoTarget.textContent = `Showing ${this.firstRecord} to ${Math.min(this.lastRecord, this.rowCount)} of ${this.rowCount} entries`;
  }
  
  goToPage(event: Event) {
    event.preventDefault();
    
    this.page = parseInt((event.currentTarget as HTMLElement).dataset.page);
  }
  
  initializeTable() {

    // Set initial per page
    this._page = 1;
    this._perPage = 10;
    this._search = '';
    this._sortParameters = {
      direction: null,
      index: null
    };
        
    // Set the sort index and direction
    if ('order' in this.table.dataset) {
      this._sortParameters.index = parseInt(this.table.dataset.order);
    } else {
      this._sortParameters.index = 0;
    }
    
    if ('direction' in this.table.dataset) {
      this._sortParameters.direction = this.table.dataset.direction;
    } else {
      this._sortParameters.direction = 'asc';
    }
    
    // Create the header
    this.createHeader();
    
    // Create the footer
    this.createFooter();
    this.rowCount = this.table.tBodies[0].rows.length;
    
    // Draw the table
    this.draw();
  }
  
  paginate(totalPages) {
    
    // Create list
    const list = document.createElement('ul');
    list.dataset.target = 'datatable.paginationList';
          
    if (totalPages > 1) {
      
      // Create previous button
      let previousDisabled = true;
      let previousLinkPage = 0;
      if (this.page > 1) {
        previousDisabled = false;
        previousLinkPage = this.page - 1;
      }
      list.appendChild(this.linkToPage(previousLinkPage, 'Previous', previousDisabled));
      
      // Add links
      if (totalPages <= 8) {
        for (let i = 1; i <= totalPages; i++) {
          list.appendChild(this.linkToPage(i));
        }
      } else if (this.page - 4 > 1 && this.page + 4 < totalPages) {
        list.appendChild(this.linkToPage(1));
        list.appendChild(this.linkToPage(0, '...', true));
        for (let i = this.page - 2; i <= this.page + 2; i++) {
          list.appendChild(this.linkToPage(i));
        }
        list.appendChild(this.linkToPage(0, '...', true));
        list.appendChild(this.linkToPage(totalPages));
      } else if (this.page + 4 < totalPages) {
        for (let i = 1; i <= 7; i++) {
          list.appendChild(this.linkToPage(i));
        }
        list.appendChild(this.linkToPage(0, '...', true));
        list.appendChild(this.linkToPage(totalPages));
      } else {
        list.appendChild(this.linkToPage(1));
        list.appendChild(this.linkToPage(0, '...', true));
        for (let i = totalPages - 6; i <= totalPages; i++) {
          list.appendChild(this.linkToPage(i))
        }
      }
      
      // Create next button
      let nextDisabled = true;
      let nextLinkPage = 0;
      if (this.page < totalPages) {
        nextDisabled = false;
        nextLinkPage = this.page + 1;
      }
      list.appendChild(this.linkToPage(nextLinkPage, 'Next', nextDisabled));
    }
    
    this.paginationListTarget.replaceWith(list);
  }
  
  performSearch() {
    this.search = this.searchTarget.value;
  }
  
  performSort(event: Event) {
    event.preventDefault();
    
    const selectedIndex = parseInt((event.target as HTMLElement).dataset.index);
    this.sortParameters = {
      direction: (this.sortParameters.direction === 'asc' && this.sortParameters.index === selectedIndex) ? 
        'desc' : 'asc',
      index: selectedIndex
    }
  }
  
  perPageChanged() {
    this.perPage = parseInt(this.perPageChoices.getValue(true) as string);
  }
  
  refresh() {
    this.draw();
  }
  
  removeRow(row: HTMLTableRowElement) {
    this.table.tBodies[0].removeChild(row);
    this.draw();
  }
  
  replaceRow(targetRow: HTMLTableRowElement, replacementRow: HTMLTableRowElement) {
    targetRow.replaceWith(replacementRow);
  }
  
  sort() {
    
    // Apply sort headers    
    for (const [index, header] of [...this.table.tHead.rows[0].cells].entries()) {
      
      // Turn header into link
      const link = document.createElement('a');
      link.href = '#';
      link.dataset.action = 'datatable#performSort';
      link.dataset.index = index.toString();
      link.innerHTML = header.textContent || '&nbsp;';
      header.innerHTML = '';
      header.appendChild(link);
      
      // Add class if currently sorted
      if (index === this.sortParameters.index) {
        header.classList.remove('asc', 'desc');
        header.classList.add('sorting', this.sortParameters.direction);
      } else {
        header.classList.remove('sorting', 'asc', 'desc');
      }
    }
    
    let tableRows = [...this.table.tBodies[0].rows];
    
    // Filter if necessary
    if (this.search !== '') {
      tableRows = tableRows.filter(row => 
        {
          for (const cell of row.cells) {
            if (cell.textContent.toLowerCase().includes(this.search)) {
              return true;
            }
          }
          
          row.classList.add('d-none');
          return false;
        }
      );
    }
    
    // Sort function
    let comparison;
    
    if (this.sortParameters.direction === 'asc') {
      comparison = (a: HTMLTableRowElement, b: HTMLTableRowElement) => {
        return a.cells[this.sortParameters.index].textContent.toLowerCase().localeCompare(
          b.cells[this.sortParameters.index].textContent.toLowerCase());
      }
    } else {
      comparison = (a: HTMLTableRowElement, b: HTMLTableRowElement) => {
        return b.cells[this.sortParameters.index].textContent.toLowerCase().localeCompare(
          a.cells[this.sortParameters.index].textContent.toLowerCase());
      }
    }
    
    // Sort rows
    const sortedRows = tableRows.sort(comparison);
    
    // Determine first record to show
    this.rowCount = sortedRows.length;
    this.totalPages = Math.ceil(this.rowCount / this.perPage);
    this.lastRecord = this.page * this.perPage;
    this.firstRecord = (this.lastRecord - this.perPage) + 1;
    
    // Apply cell styles
    for (const [rowIndex, row] of sortedRows.entries()) {
  
      if (rowIndex >= this.firstRecord - 1 && rowIndex < this.lastRecord) {
        
        // Make sure row is displayed
        row.classList.remove('d-none');

        // Mark even and odd rows
        row.classList.remove('even', 'odd');
        if (rowIndex % 2 == 0) {
          row.classList.add('even');
        } else {
          row.classList.add('odd');
        }

        // Mark sort column
        for (const [cellIndex, cell] of [...row.cells].entries()) {
          const heading = this.table.tHead.rows[0].cells[cellIndex].classList;
          if (heading.contains('asc') || heading.contains('desc')) {
            cell.classList.add('sorting');
          } else {
            cell.classList.remove('sorting');
          }
        }
      } else {
        row.classList.add('d-none');
      }
      
      // Reappend row to table
      this.table.tBodies[0].appendChild(row);
    }
  }
  
  // #linkToPage(page: number)
  linkToPage(page: number, title?: string, disabled: boolean = false): HTMLLIElement {
    
    // Create link
    const link = document.createElement('a');
    link.href = '#';
    link.textContent = title || page.toString();
    link.dataset.action = 'datatable#goToPage';
    link.dataset.page = page.toString();
    link.classList.toggle('active', this.page === page);
    link.classList.toggle('disabled', disabled);
    
    // Create list element
    const listElement = document.createElement('li');
    listElement.appendChild(link);
    
    return listElement;
  }
  
  get page() {
    return this._page;
  }
  
  set page(page: number) {
    this._page = page;
    this.draw();
  }
  
  get perPage() {
    return this._perPage;
  }
  
  set perPage(perPage: number) {
    this._perPage = perPage;
    this.draw();
  }
  
  get rowCount() {
    return this._rowCount;
  }
  
  set rowCount(rowCount: number) {
    this._rowCount = rowCount;
    this.checkForEmpty();
  }
  
  get search() {
    return this._search;
  }
  
  set search(search: string) {
    this._search = search;
    this.draw();
  }
  
  get sortParameters() {
    return this._sortParameters;
  }
  
  set sortParameters(sortParameters) {
    this._sortParameters = sortParameters;
    this.draw();
  }
}