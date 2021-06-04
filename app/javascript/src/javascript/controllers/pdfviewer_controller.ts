import { PDFDocumentProxy, PDFPageProxy } from 'pdfjs-dist/types/display/api';

import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'currentPage',
    'document',
    'loading',
    'nextPageButton',
    'previousPageButton',
    'totalPages',
    'viewer',
    'zoomInButton',
    'zoomOutButton',
    'zoomPercentage'
  ];
  
  declare readonly currentPageTarget: HTMLInputElement;
  declare readonly documentTarget: HTMLElement;
  declare readonly loadingTarget: HTMLElement;
  declare readonly nextPageButtonTarget: HTMLButtonElement;
  declare pdf: PDFDocumentProxy;
  declare readonly previousPageButtonTarget: HTMLButtonElement;
  declare totalPages: number;
  declare readonly totalPagesTarget: HTMLElement;
  declare readonly viewerTarget: HTMLElement;
  declare readonly zoomInButtonTarget: HTMLButtonElement;
  declare readonly zoomOutButtonTarget: HTMLButtonElement;
  declare readonly zoomPercentageTarget: HTMLInputElement;
  declare _drawingPage: number;
  declare _currentPage: number;
  declare _pageObserver: IntersectionObserver;
  declare _scale: number;
  declare _zoom: number;
  
  connect(): void {
    super.connect();
        
    // Set initial state
    this.page = 1;
    this._drawingPage = 1;
    this._scale = 3;
    
    // Update the current page and the scale display
    this.currentPageTarget.value = this.page.toString();
    this.updateZoomPercentage();
    
    // Create scroll observer
    this._pageObserver = new IntersectionObserver(this.updateCurrentPageByScrolling.bind(this), 
      {
        rootMargin: '0px',
        threshold: 0.2
      }
    );
    
    // Load PDF
    const pdfJS = require('pdfjs-dist/webpack');
    pdfJS.getDocument(this.documentTarget.dataset.documentUrl)
      .promise
      .then(document => {
        this.pdf = document;
        this.totalPages = this.pdf.numPages;
        
        // Update the total page display
        this.totalPagesTarget.innerHTML = this.totalPages.toString();
        
        // Display pages
        this.draw();
        
        // Remove the loading status
        this.viewerTarget.classList.remove('bracegirdle-pdf-loading');
      }
    );
  }
  
  disconnect(): void {
    this._pageObserver.disconnect();
  }
  
  draw(): void {
    this.pdf.getPage(1).then(this.handlePages.bind(this));
  }
  
  goToPage (selectedPage: number): void {
    
    // Update the current page
    this.page = selectedPage;
    
    // Locate page and scroll to it
    const targetPage = document.querySelector(`.bracegirdle-pdf-page[data-page="${selectedPage}"]`) as HTMLElement;
    this.viewerTarget.scroll(0, targetPage.offsetTop - 50);
  }
  
  handlePages(page: PDFPageProxy): void {

    // Get the full size viewport
    const viewport = page.getViewport({scale: this._scale});
    
    // Create a canvas to draw each page
    const canvas = document.createElement('canvas');
    canvas.classList.add('bracegirdle-pdf-page');
    canvas.dataset.page = this._drawingPage.toString();
    const context = canvas.getContext('2d');
    canvas.height = viewport.height;
    canvas.width = viewport.width;
    
    // Draw the page on the canvas
    page.render({
      canvasContext: context, 
      viewport: viewport
    });
    
    // Add the canvas to the document
    canvas.style.width = this.zoomPercentage;
    this.documentTarget.appendChild(canvas);
    
    // Begin observing for page scrolling
    this._pageObserver.observe(canvas);
    
    // Move to next page
    this._drawingPage++;
    if (this.pdf !== null && this._drawingPage <= this.totalPages) {
      this.pdf.getPage(this._drawingPage).then(this.handlePages.bind(this));
    }
  }
    
  redraw(): void {
    if(this.pdf !== undefined) {
      
      // Clear pages
      this.documentTarget.innerHTML = '';
      this._pageObserver.disconnect();
      
      // Reset drawing page
      this._drawingPage = 1;
      
      // Draw the document
      this.draw();
    }
  }
  
  scrollAhead (): void {
    this.goToPage(this.page + 1);
  }

  scrollBack (): void {
    this.goToPage(this.page - 1);
  }
  
  updateCurrentPageByScrolling(entries, observer): void {
    for (const entry of entries) {
      const pageNumber = Number(entry.target.dataset.page);
      if(entry.isIntersecting && pageNumber !== this.page) {
        this.page = pageNumber;
      }
    }
  }
  
  updateZoomPercentage(): void {
    this.zoomPercentageTarget.value = this.zoomPercentage;
  }
  
  zoomTo (scaleFactor: number): void {
    // Set the scale and update the display
    this._scale = scaleFactor;
    this.redraw();
    this.updateZoomPercentage();
    
    // Disable or enable zoom in button
    if (scaleFactor === 6) {
      this.zoomInButtonTarget.disabled = true;
    } else {
      this.zoomInButtonTarget.disabled = false;
    }
    
    // Disable or enable zoom out button
    if (scaleFactor === 0.75) {
      this.zoomOutButtonTarget.disabled = true;
    } else {
      this.zoomOutButtonTarget.disabled = false;
    }
  }

  zoomIn (): void {
    this.zoomTo(this._scale + 0.75);
  }

  zoomOut (): void {
    this.zoomTo(this._scale - 0.75);
  }

  get page() {
    return this._currentPage;
  }
  
  set page(page: number) {
    
    // Update the internal page number
    this._currentPage = page;
    
    // Update the current page indicator
    this.currentPageTarget.value = this._currentPage.toString();
    
    // Enable/disable next page link
    if(page === this.totalPages) {
      this.nextPageButtonTarget.disabled = true;
    } else {
      this.nextPageButtonTarget.disabled = false;
    }
    
    // Enable/disable previous page link
    if(page === 1) {
      this.previousPageButtonTarget.disabled = true;
    } else {
      this.previousPageButtonTarget.disabled = false;
    }
  }
  
  get zoomPercentage() {
    return `${(this._scale / 3) * 100}%`;
  }
}